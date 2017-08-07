
SELECT bam_signpost_id,bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE';
SELECT gdc_src_id, gdc_id FROM wgs;

--SELECT wgs.gdc_src_id,bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id;

SELECT DISTINCT(wgs.gdc_src_id),bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id  WHERE bqsr.status = 'COMPLETE' ORDER BY wgs.gdc_src_id;

\copy (SELECT DISTINCT(wgs.gdc_src_id),bqsr.bam_signpost_id,bqsr.bam_uuid,bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs wgs ON uuid(bqsr.bam_signpost_id) = wgs.gdc_id  WHERE bqsr.status = 'COMPLETE' ORDER BY wgs.gdc_src_id) to 'wgs.csv' With CSV

--
SELECT input_signpost_id, s3_url, uuid FROM wgs_753_status WHERE status = 'COMPLETE' ORDER BY input_signpost_id;
SELECT input_signpost_id, s3_url, uuid FROM wgs_753_status WHERE status = 'COMPLETE';
SELECT bam_signpost_id,bam_uuid,s3_bam_url FROM run_status_bqsr_wgs_jan2017 WHERE status = 'COMPLETE' ORDER BY bam_signpost_id;

SELECT DISTINCT(wgs.input_signpost_id), bqsr.bam_signpost_id, bqsr.bam_uuid, bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE' ORDER BY wgs.input_signpost_id;

\copy (SELECT DISTINCT(wgs.input_signpost_id), bqsr.bam_signpost_id, bqsr.bam_uuid, bqsr.s3_bam_url FROM run_status_bqsr_wgs_jan2017 bqsr JOIN wgs_753_status wgs ON bqsr.bam_signpost_id = wgs.uuid  WHERE bqsr.status = 'COMPLETE' AND wgs.status = 'COMPLETE' ORDER BY wgs.input_signpost_id) To '753.csv' With CSV
