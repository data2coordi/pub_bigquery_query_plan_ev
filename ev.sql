
SELECT
  query,
  total_bytes_processed / 1024 / 1024  AS processed_MB,
  total_bytes_processed / 1024 / 1024 / 1024  * 1 AS Charges_yen,
  cache_hit
FROM
`region-us-central1`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE
  query like '%pf%ml_dataset%'  and query not like '%INFORMATION_SCHEMA%'
ORDER BY DATETIME(creation_time)  DESC
LIMIT 1;

