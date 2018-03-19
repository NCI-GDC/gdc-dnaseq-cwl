SELECT * FROM wgs_753_status;
SELECT * FROM wgs;
SELECT * FROM run_status_bqsr_wgs_jan2017;
--

SELECT distinct(bam_signpost_id),bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE';
SELECT distinct(cghub_id), gdc_src_id, gdc_id, filename FROM wgs order by cghub_id;

--SELECT wgs.gdc_src_id,bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id;

SELECT DISTINCT(wgs.gdc_src_id),bqsr.bam_signpost_id,bqsr.bam_uuid,wgs.cghub_id,wgs.location,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id  WHERE bqsr.status = 'COMPLETE' ORDER BY wgs.gdc_src_id;

\copy (SELECT DISTINCT(wgs.gdc_src_id),bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id  WHERE bqsr.status = 'COMPLETE' ORDER BY wgs.gdc_src_id) to 'wgs.csv' With CSV

--
SELECT input_signpost_id, s3_url, uuid FROM wgs_753_status WHERE status = 'COMPLETE' ORDER BY input_signpost_id;
SELECT input_signpost_id, s3_url, uuid FROM wgs_753_status WHERE status = 'COMPLETE';
SELECT bam_signpost_id,bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE' ORDER BY bam_signpost_id;

SELECT DISTINCT(wgs753.input_signpost_id), bqsr.bam_signpost_id, bqsr.bam_uuid, bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE' ORDER BY wgs699.input_signpost_id;

\copy (SELECT DISTINCT(wgs753.input_signpost_id), bqsr.bam_signpost_id, bqsr.bam_uuid, bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE' ORDER BY wgs753.input_signpost_id) To '699.csv' With CSV


--
SELECT * FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE' AND bam_uuid NOT IN (
SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE'
)
AND bam_uuid NOT IN (
SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE'
);




SELECT bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (
SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE'
)
AND bqsr.bam_uuid NOT IN (
SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE'
);


SELECT wgs.gdc_src_id,bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE';


\copy (SELECT bam_signpost_id,bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE' AND bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE')AND bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) To '1020.csv' With CSV
g


--****---
\copy (SELECT wgs.gdc_src_id,bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) To '3198.csv' With CSV
--****---
\copy (SELECT DISTINCT(wgs753.input_signpost_id), bqsr.bam_signpost_id, bqsr.bam_uuid, bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE' ORDER BY wgs753.input_signpost_id) To '699.csv' With CSV
--***---
\copy (SELECT wgs.gdc_src_id, bqsr.bam_signpost_id,bqsr.bam_uuid,regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '') FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON regexp_replace(wgs.filename, '^.+[/\\]', '') = regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '')WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT bqsr.bam_uuid FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) AND bqsr.bam_uuid NOT IN ( SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE') ORDER BY wgs.gdc_src_id) To '1020.csv' With CSV


SELECT bam_signpost_id,bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE' ORDER BY bam_signpost_id;


SELECT bqsr.bam_signpost_id,bqsr.bam_uuid,regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '') FROM run_status_bqsr_wgs_jan2017 bqsr WHERE status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT bqsr.bam_uuid FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) AND bqsr.bam_uuid NOT IN ( SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE') ORDER BY bqsr.bam_signpost_id;


WITH files AS (
    SELECT regexp_replace(s3_url, '^.+[/\\]', ''), s3_url AS filename
    FROM markduplicates_wgs_status;
);
SELECT s3_url FROM markduplicates_wgs_status;

CREATE OR REPLACE FUNCTION basename(text) RETURNS text AS $basename$ declare FILE_PATH alias for $1; ret text; begin ret := regexp_replace(FILE_PATH,'^.+[/\]', ''); return ret; end; $basename$ LANGUAGE plpgsql;


regexp_replace('s3://bqsr-wgs-jan2017-2/8de027f2-8da1-4458-aeca-058ef0ccdad2/b063d293e0df48fc160fc08c84c39531_gdc_realn.bam', '^.+[/\\]', '')
SELECT regexp_replace(s3_url, '^.+[/\\]', '') FROM markduplicates_wgs_status WHERE STATUS = 'COMPLETE';
SELECT regexp_replace(filename, '^.+[/\\]', '') FROM wgs;
SELECT regexp_replace(s3_bam_url, '^.+[/\\]', '') FROM run_status_bqsr_wgs_jan2017 WHERE STATUS = 'COMPLETE';

SELECT bqsr.bam_signpost_id,bqsr.bam_uuid,regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '') FROM run_status_bqsr_wgs_jan2017 bqsr WHERE status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT bqsr.bam_uuid FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) AND bqsr.bam_uuid NOT IN ( SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE') ORDER BY bqsr.bam_signpost_id;


SELECT wgs.gdc_src_id, bqsr.bam_signpost_id,bqsr.bam_uuid,regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '') FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON regexp_replace(wgs.filename, '^.+[/\\]', '') = regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '')WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT bqsr.bam_uuid FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) AND bqsr.bam_uuid NOT IN ( SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE') ORDER BY wgs.gdc_src_id;



SELECT wgs.gdc_src_id, bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON regexp_replace(wgs.filename, '^.+[/\\]', '') = regexp_replace(bqsr.s3_bam_url, '^.+[/\\]', '')WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT bqsr.bam_uuid FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id WHERE bqsr.status = 'COMPLETE' AND bqsr.bam_uuid NOT IN (SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE')) AND bqsr.bam_uuid NOT IN ( SELECT DISTINCT(bqsr.bam_uuid) FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs753 ON bqsr.bam_signpost_id = wgs753.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs753.status = 'COMPLETE') ORDER BY wgs.gdc_src_id;
