

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
	'pf not hit: between min and max' comment, 
	num_col1,
	partid, 
	clusterdid,
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` 
where num_col1 = 100000001;
-----------------------------------
--select min
--select 
--	'pf not hit: out of min and max', 
--	p.partid, 
--	p.clusterdid, 
--	p.num_col1, 
--	CURRENT_TIMESTAMP() t  
--from `ml_dataset.bigdata_for_ev` p inner join `ml_dataset.bigdata_for_ev_nopart` n
--where p.num_col1=100000000 ; 


select 
	'pf part', 
	partid, 
	clusterdid,
	CURRENT_TIMESTAMP() t  
from `ml_dataset.bigdata_for_ev` 
where num_col1=12091139 
and   partid = 10 ; 


select 
	'pf part+cluster', 
	partid, 
	clusterdid,
	CURRENT_TIMESTAMP() t 
from `ml_dataset.bigdata_for_ev`
where num_col1=12091139 
and   partid = 10
and   clusterdid=9700146 ; 


--Advanced
------------------------
------------------------
------------------------
-- cluster min vs max
-- part 10 clusterdid min:9500000 max:10499999 
select 
    'pf part+cluster min', 
	partid, 
	clusterdid, 
	num_col1, 
	CURRENT_TIMESTAMP() t 
from 
`ml_dataset.bigdata_for_ev`
where partid = 10 
and   clusterdid=9500000 ; 

select 
    'pf part+cluster middle', 
	partid, 
	clusterdid, 
	num_col1, 
	CURRENT_TIMESTAMP() t 
from 
`ml_dataset.bigdata_for_ev`
where partid = 10 
and   clusterdid=10000000 ; 



select 
    'pf part+cluster max', 
	partid, 
	clusterdid, 
	num_col1, 
	CURRENT_TIMESTAMP() t 
from 
`ml_dataset.bigdata_for_ev`
where partid = 10 
and   clusterdid=10499999 ; 


------------------------

-- seq  vs randum
-- seqid:9500000 num_col1:18500113
select 
    'pf seqid only', 
	partid, 
	clusterdid, 
	seqid, 
	CURRENT_TIMESTAMP() t 
from 
`ml_dataset.bigdata_for_ev`
where seqid = 9500000; 

select 
    'pf randum colum only', 
	partid, 
	clusterdid, 
	num_col1,
	CURRENT_TIMESTAMP() t 
from 
`ml_dataset.bigdata_for_ev`
where num_col1 = 18500113;

------------------------




