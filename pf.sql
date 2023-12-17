
select 
	count(*) count, 
	from `ml_dataset.bigdata_for_ev` where str_col5='10';

select 
	count(*) count, 
	from `ml_dataset.bigdata_for_ev_nopart` where str_col5='10';

return ;
--Get information 

--Basic
------------------------
------------------------
------------------------
select 
	count(num_col1) num_col1_count, 
	min(num_col1) num_col1_min, 
	max(num_col1) num_col1_max
	from `ml_dataset.bigdata_for_ev`;

select 
	'pf not hit: between min and max' comment, 
	num_col1,
	partid, 
	clusterdid,
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` 
where num_col1 = 12091143;

select 
	'pf not hit: out of min and max' comment, 
	num_col1,
	partid, 
	clusterdid,
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` 
where num_col1 = 100000001;
-----------------------------------

select 
	count(*) count, 
	min(str_col3) str_col3_min, 
	max(str_col3) str_col3_max,
	min(str_col4) str_col4_min, 
	max(str_col4) str_col4_max
	from `ml_dataset.bigdata_for_ev`;

select 
	count(*) count, 
	min(str_col3) str_col3_min, 
	max(str_col3) str_col3_max,
	min(str_col4) str_col4_min, 
	max(str_col4) str_col4_max
	from `ml_dataset.bigdata_for_ev_nopart`;

select 
	'pf tableN high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where p.str_col3='1' 
  and n.str_col4='1' ;
--  table n high cardinality; 

select 
	'pf tableP high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where n.str_col3='1'
  and p.str_col4='1' ;
--  table p high cardinality; 
-----------------------------------

update `ml_dataset.bigdata_for_ev` set str_col5 = '10' where str_col5  > '500';
update `ml_dataset.bigdata_for_ev_nopart` set str_col5 = '10' where str_col5  > '500';

select 
	count(*) count, 
	min(str_col5) str_col5_min, 
	max(str_col5) str_col5_max
	from `ml_dataset.bigdata_for_ev`;

select 
	count(*) count, 
	min(str_col5) str_col5_min, 
	max(str_col5) str_col5_max
	from `ml_dataset.bigdata_for_ev_nopart`;

select 
	count(*) count, 
	from `ml_dataset.bigdata_for_ev` where str_col5='10';

select 
	count(*) count, 
	from `ml_dataset.bigdata_for_ev_no_part` where str_col5='10';


select 
	'pf tableP high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where n.str_col4='11'
  and p.str_col5='110' ;


select 
	'pf tableP high cardinality ', 
	p.num_col1, 
	n.num_col1, 
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
   on p.clusterdid = n.clusterdid
where n.str_col4='11'
  and p.str_col5='10' ;




