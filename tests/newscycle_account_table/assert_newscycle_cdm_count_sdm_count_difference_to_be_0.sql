#https://docs.google.com/spreadsheets/d/1ZWRNEsdkeXFz2DvRjbkvNK1agiAMwRepXFaSKqW8m-U/edit#gid=0

with assertion as (select table_name,
	dw_partition_date, 
	sum(sdmcount) sdmcount,
	sum( cdmcount) cdmcount, 
	sum(sdmcount) - sum(cdmcount) difference, 
	current_datetime('Australia/Sydney') execdatetime 
from 
	(
		select 'account' table_name,dw_partition_date,count(1) sdmcount,0 cdmcount 
			FROM ( SELECT DISTINCT * except (dgw_batch_id,dw_ingest_time,dw_publish_time) 
				from `ncau-data-newsquery-dev.sdm_newscycle.account`) 
			group by dw_partition_date
				union all
		select 'account' table_name,dw_tgt_partition_date,0 sdmcount,count(1) cdmcount
		from `ncau-data-newsquery-dev.cdm_newscycle.account`  
		group by dw_tgt_partition_date 
	)
group by table_name,dw_partition_date	
order by table_name
)

select * from assertion where difference != 0 and dw_partition_date='2020-02-16'