To run DNASeq harmonization workflow
------------------------------------
The current workflow will harmonize WGS and WXS BAMs, and generate picard and samtools metrics (stored in a sqlite file) on the harmonized BAM. WGS metrics (picard CollectWgsMetrics) is currently implemented, and WXS (picard CollectHsMetrics) is in development.

After completing numbered installation steps below, these 3 steps will suffice to run workflows:

        $ workon cwl
        $ cd /mnt/SCRATCH/dnaseq_example
        $ nohup cwltool --debug --tmpdir-prefix tmp/ --cachedir cache/ ~/gdc-dnaseq-cwl/workflows/dnaseq/transform.cwl ~/gdc-dnaseq-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json &

---
The following steps are tested on Ubuntu 14.04. Newer Ubuntu versions, and other Linux distributions use a different method of configuration, which is beyond the scope of this document. Running the cwl workflow (step 16), will cause the docker images to be pulled as each cwl step is executed. A description of each tool is at the bottom of this document.

0. install needed packages

        if you have a proxy, enable for apt:
        $ sudo sh -c "echo 'Acquire::http::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy"
        $ sudo sh -c "echo 'Acquire::https::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy"

        $ sudo aptitude update
        $ sudo aptitude install apt-transport-https ca-certificates docker-engine htop libffi-dev libssl-dev nodejs python-dev virtualenvwrapper

1. prep storage

        $ sudo mkfs.ext4 /dev/vdb
        $ sudo rm -rf /mnt
        $ sudo mount /dev/vdb /mnt
        $ sudo mkdir /mnt/SCRATCH
        $ sudo chmod 777 /mnt/SCRATCH

2. prep docker

        create a dir for image storage (will store ~12GiB of images):
        $ mkdir /mnt/SCRATCH/docker

        enable docker storage in scratch dir:
        $ sudo sh -c "echo "DOCKER_OPTS=\"-g /mnt/SCRATCH/docker/\"" >> /etc/default/docker"

        enable non-root user to run docker:
        $ sudo gpasswd -a ubuntu docker

        if you have a proxy, enable for docker:
        $ sudo sh -c "echo "export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128" >> /etc/default/docker"
        
        restart docker service
        $ sudo service docker restart
        $ exit (non-root only gain group access to docker when exit/login - make sure you are ENTIRELY logged out of VM before proceeding)


3. log back in. configure `virtualenvwrapper`

        $ echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
        $ exit

4. log back in. If needed, enable proxy to access pypi.org and github.com

        $ export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;

5. create a virtualenv for cwltool

        $ mkvirtualenv --python /usr/bin/python2 cwl

6. When virtualenv is first created, the vitualenv will be activated. To activate virtualenv on later login sessions:

        $ workon cwl

   To deactive a virtualenv (don't do this now, just FYI)

        $ deactivate

7. upgrade pip

        $ pip install --upgrade pip

8. enable SSL connections

        $ pip install 'requests[security]'  --no-cache-dir

9. get the CDIS tested version of cwltool

        $ wget https://github.com/NCI-GDC/cwltool/archive/1.0_gdc_f.tar.gz

10. install cwltool and its dependencies

        $ pip install 1.0_gdc_f.tar.gz --no-cache-dir

11. get the DNASeq CWL Workflow

        $ git clone https://github.com/NCI-GDC/gdc-dnaseq-cwl.git

12. The workflow to perform DNASeq BAM harmonization is

        gdc-dnaseq-cwl/workflows/dnaseq/transform.cwl

    and an example input file is

        gdc-dnaseq-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json

13. get reference files

        $ mkdir /mnt/SCRATCH/hg38_reference
        $ cd /mnt/SCRATCH/hg38_reference

    dbsnp vcf (two choices):

    (1) modified data generation:

        $ wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/hg38bundle/dbsnp_144.hg38.vcf.gz
        $ gunzip dbsnp_144.hg38.vcf.gz
        $ sed -i 's/\(^[1-9,X,Y,M]\)/chr\1/g' dbsnp_144.hg38.vcf
        $ gzip dbsnp_144.hg38.vcf

     or (2) pull modified data from gdc:

        $ wget https://gdc-api.nci.nih.gov/data/4ba1c087-ec80-47c4-a9d5-e9bb9933fef4 -O dbsnp_144.hg38.vcf.gz

    reference genome:

        $ wget https://gdc-api.nci.nih.gov/data/62f23fad-0f24-43fb-8844-990d531947cf
        tar xvf 62f23fad-0f24-43fb-8844-990d531947cf

    bwa indexed genome:

        $ wget https://gdc-api.nci.nih.gov/data/964cbdac-1043-4fae-b068-c3a65d992f6b
        tar xvf 964cbdac-1043-4fae-b068-c3a65d992f6b

14. Get example data: 1 readgroup BAM which uses `bwa mem`

        Single readgroup BAM which maps with `bwa mem`, and contains Paired-End reads (SRR622461_1.fq.gz, SRR622461_2.fq.gz), Single-End (SRR622461_s.fq.gz) reads, and Orphaned (SRR622461_o1.fq.gz) reads, all of which are mapped to the harmonized BAM
        $ cd /mnt/SCRATCH/
        $ wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam

15. Run workflow

        $ mkdir /mnt/SCRATCH/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211
        $ cd /mnt/SCRATCH/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211/
        $ mkdir tmp cache
        $ nohup cwltool --debug --tmpdir-prefix tmp/ --cachedir cache/ ~/gdc-dnaseq-cwl/workflows/dnaseq/transform.cwl ~/gdc-dnaseq-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json &

16. Other example data

        16 readgroup BAM which uses `bwa aln` (all readgroup reads < 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/NA12889/alignment/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.bam
        use gdc-dnaseq-cwl/workflows/dnaseq/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.json

        22 readgroup BAM which uses `bwa mem` (all readgroup reads > 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/NA11829/alignment/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
        use gdc-dnaseq-cwl/workflows/dnaseq/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.json

        16 readgroup BAM which uses both `bwa aln` and `bwa mem` (some readgroup reads < 70bp, some > 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/NA11829/alignment/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.bam
        use gdc-dnaseq-cwl/workflows/dnaseq/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.json

17. Resources required for successful workflow completion

        * Storage: 7-10X initial BAM size. That is, if the input BAM to be harmonized is 1GiB, then 7-10GiB of stoarge will be required, as cwltool does not remove intermediate files during workflow processing. This is in addition to storage required for reference files, and docker images.
        
        * CPU: The workflow will operate with any number of cores. It is tested with 8 cores.
        
        * RAM: Most BAM files will harmonize with less than 20GiB of RAM, but in some cases up to 50GiB of RAM is required during the MarkDuplicates step.

---
Docker tools used for DNASeq harmonization workflow (transform.cwl)

#### Used to convert each readgroup of a BAM to a json file.
* (https://quay.io/repository/ncigdc/bam_readgroup_to_json)
* (https://github.com/NCI-GDC/bam_readgroup_to_json)

#### Used to reheader a BAM file so it contains gdc reference assembly name (GRCh38.d1.vd1), Species (Homo sapiens), and M5 (MD5 of each contig).
* (https://quay.io/repository/ncigdc/bam_reheader)
* (https://github.com/NCI-GDC/bam_reheader)

        https://quay.io/repository/ncigdc/biobambam
        https://github.com/NCI-GDC/biobambam_docker
        Contains biobambam. Currently used for bamtofastq step.

        https://quay.io/repository/ncigdc/bwa
        https://github.com/NCI-GDC/bwa_docker
        Mapper used for WGS/WXS.

        https://quay.io/repository/ncigdc/fastq_remove_duplicate_qname
        https://github.com/NCI-GDC/fastq_remove_duplicate_qname
        Some BAM files from Broad contain multiple entries of the same read. This tool removes such duplicates.

        https://quay.io/repository/ncigdc/fastqc
        https://github.com/NCI-GDC/fastqc_docker
        Get basic metrics on fastq files.

        https://quay.io/repository/ncigdc/fastqc_db
        https://github.com/NCI-GDC/fastqc_db
        Converts fastqc metrics to sqlite.

        https://quay.io/repository/ncigdc/fastqc_to_json
        https://github.com/NCI-GDC/fastqc_to_json
        Converts subset of fastqc metrics to json to be used for bwa step.

        https://quay.io/repository/ncigdc/integrity_to_sqlite
        https://github.com/NCI-GDC/integrity_to_sqlite
        Converts md5, sha256 and file byte size to sqlite.

        https://quay.io/repository/ncigdc/merge_sqlite
        https://github.com/NCI-GDC/merge_sqlite
        Merges an arbitrary number of sqlite files into a single sqlite file.

        https://quay.io/repository/ncigdc/picard
        https://github.com/NCI-GDC/picard_docker
        Picard is used in the core workflow (BAM validation, sorting, merging, markduplicates), and for metrics (BAM CollectHsMetris, CollectWgsMetrics, CollectMultipleMetrics, CollectOxoGMetrics).

        https://quay.io/repository/ncigdc/picard_metrics_sqlite
        https://github.com/NCI-GDC/picard_metrics_sqlite
        Converts picard metrics to sqlite.

        https://quay.io/repository/ncigdc/queue_status
        https://github.com/NCI-GDC/queue_status
        Run at the start and end of each job. Records current time, job uuid, software version, job status, and final s3 uri.

        https://quay.io/repository/ncigdc/readgroup_json_db
        https://github.com/NCI-GDC/readgroup_json_db
        Convert readgroup json to sqlite.

        https://quay.io/repository/ncigdc/samtools
        https://github.com/NCI-GDC/samtools_docker
        Used to compress bwa SAM to BAM. Also used to collect metrics (flagstat, idxstats, stats).

        https://quay.io/repository/ncigdc/samtools_metrics_sqlite
        https://github.com/NCI-GDC/samtools_metrics_sqlite
        Converts samtools metrics to sqlite.
