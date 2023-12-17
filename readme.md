
bq query --use_legacy_sql=false <  pf.sql


exit

# ##概要
DWHのDBはマシンパワーに依存する。クエリプランはパーティションやクラスタキーに
よってのみ決まる製品もある。
一方、多くのRDBはオプティマイザが統計情報からデータ傾向を把握し、緻密なクエリプラン
を作成する。
Bigqueryはどの程度、統計情報を考慮してクエリプランを決めているのか検証してみる。




# ##環境＆手順

## テストデータ
以下のリポジトリの方法で作成した1億件のテーブルで性能を検証する。
[Bigqueryで大量データ生成](https://github.com/data2coordi/pub_bigquery_generate_data)

## 性能確認手順

```
bq query --use_legacy_sql=false <  pf.sql

```

[対象のSQL:pf.sql](./pf.sql)

上記のコマンドで対象のSQL実行を実行している。



# ##検証
## Bigqueryは項目の最大値、最小値を把握しているのか？
### 検証内容
パーティション、クラスターキー以外の通常項目で以下2パターンの条件指定の結果を
検証する。

パターン1:最小値と最大値の間にある値をwhere句に指定する。
パターン2:対象項目に含まれるデータの最小値より小さい、または最大値より大きい値をwhere句に指定する。

### 検証結果

***データ傾向***

```
select 
	count(num_col1) num_col1_count, 
	min(num_col1) num_col1_min, 
	max(num_col1) num_col1_max
	from `ml_dataset.bigdata_for_ev`; -- at [2:1]
+----------------+--------------+--------------+
| num_col1_count | num_col1_min | num_col1_max |
+----------------+--------------+--------------+
|      100003248 |            1 |     99999999 |
+----------------+--------------+--------------+
```

***パターン1:最小値と最大値の間にある値をwhere句に指定する。***

フルスキャンで全データをREADしている。この条件句はヒットしないのでSQLの結果は0件。
![クエリプラン](./img/ヒットなし中間.jpg)


***パターン2:対象項目に含まれるデータの最小値より小さい、または最大値より大きい値をwhere句に指定する。***

スキャンをしていない（0件の読み込み）。この条件句はヒットしないのでSQLの結果は0件。
![クエリプラン](./img/ヒットなし最小最大の外.jpg)

### 考察 
最小値、最大値を把握していて、クエリプランの作成に利用しているようである。


## Bigqueryは項目のカーディナリティを知っているのか？
### 検証内容
RDBのJOINではカーディナリティが高い条件を指定したテーブルが駆動表となる。
※まず高いカーディナリティで絞り込みJOIN対象を小くするため
これが可能なのは統計情報から項目のカーディナリティをオプティマイザがわかるからである。
Bigqueryでは特に統計情報を利用者が意識しない。カーディナリティは考慮されないのか
検証する。


### 検証結果

***事前にデータ傾向を確認***

下記のとおりbigdata_for_evテーブル（以降、テーブルPと呼ぶ）では、
str_col3(10種類の値）よりもstr_col4(100種類の値）の方がカーディナリティが高い
str_col3、str_col4とも通常の項目でパーティションキーでもクラスターキーでもない。

```
select 
	count(*) count, 
	min(str_col3) str_col3_min, 
	max(str_col3) str_col3_max,
	min(str_col4) str_col4_min, 
	max(str_col4) str_col4_max
	from `ml_dataset.bigdata_for_ev`; -- at [2:1]
+-----------+--------------+--------------+--------------+--------------+
|   count   | str_col3_min | str_col3_max | str_col4_min | str_col4_max |
+-----------+--------------+--------------+--------------+--------------+
| 100003248 | 0            | 9            | 0            | 99           |
+-----------+--------------+--------------+--------------+--------------+

```
下記のとおりbigdata_for_evテーブル（以降、テーブルNと呼ぶ）でも同様に、
str_col3(10種類の値）よりもstr_col4(100種類の値）の方がカーディナリティが高い
```
select 
	count(*) count, 
	min(str_col3) str_col3_min, 
	max(str_col3) str_col3_max,
	min(str_col4) str_col4_min, 
	max(str_col4) str_col4_max
	from `ml_dataset.bigdata_for_ev_nopart`; -- at [10:1]
+-----------+--------------+--------------+--------------+--------------+
|   count   | str_col3_min | str_col3_max | str_col4_min | str_col4_max |
+-----------+--------------+--------------+--------------+--------------+
| 100003248 | 0            | 9            | 0            | 99           |
+-----------+--------------+--------------+--------------+--------------+
```


<br><br>

***パターン1:テーブルPにカーディナリティが高い条件を指定した場合のクエリプラン。***

下記のとおりテーブルPが駆動表となっている。
カーディナリティが高いテーブルからアクセスする基本どおりのクエリプラン。
```

select 
	'pf tableP high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where n.str_col3='1'
  and p.str_col4='1' ;

```


![クエリプラン](./img/テーブルP_高カーディナリティ.jpg)



<br><br>
***パターン2:テーブルNにカーディナリティが高い条件を指定した場合のクエリプラン。***

下記のとおりテーブルNが駆動表に変わった。
やはり、カーディナリティが高いテーブルからアクセスする基本どおりのクエリプラン。
```
select 
	'pf tableN high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where p.str_col3='1' 
  and n.str_col4='1' ;

```


![クエリプラン](./img/テーブルN_高カーディナリティ.jpg)


### 考察
カーディナリティを知っている。
RDBでは一般的にインデックス項目で統計情報を取得することが多いが、
Bigqueryは通常項目でも統計情報を持っているようである。いつ取得しているのか。。。




## Bigqueryは項目のカーディナリティが低い(ヒット件数が多い）値を知っているのか？
### 検証内容

################################
################################
################################
################################
