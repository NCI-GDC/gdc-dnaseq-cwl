#TARGET
cgquery --all-states -a "study=phs000218" -o phs000218_all_states.xml > phs000218_all_states.out
cgquery --all-states -a "study=phs000463" -o phs000463_all_states.xml > phs000463_all_states.out
cgquery --all-states -a "study=phs000464" -o phs000464_all_states.xml > phs000464_all_states.out
cgquery --all-states -a "study=phs000465" -o phs000465_all_states.xml > phs000465_all_states.out
cgquery --all-states -a "study=phs000466" -o phs000466_all_states.xml > phs000466_all_states.out
cgquery --all-states -a "study=phs000467" -o phs000467_all_states.xml > phs000467_all_states.out
cgquery --all-states -a "study=phs000468" -o phs000468_all_states.xml > phs000468_all_states.out
cgquery --all-states -a "study=phs000469" -o phs000469_all_states.xml > phs000469_all_states.out
cgquery --all-states -a "study=phs000470" -o phs000470_all_states.xml > phs000470_all_states.out
cgquery --all-states -a "study=phs000471" -o phs000471_all_states.xml > phs000471_all_states.out
cgquery --all-states -a "study=phs000515" -o phs000515_all_states.xml > phs000515_all_states.out
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)" -o "phs000218_phs0004*_phs000515_all_states.xml" > "phs000218_phs0004*_phs000515_all_states.out"

##WXS
cgquery --all-states -a "study=phs000218&library_strategy=WXS&platform=ILLUMINA" -o phs000218_wxs_illumina_all_states.xml > phs000218_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000463&library_strategy=WXS&platform=ILLUMINA" -o phs000463_wxs_illumina_all_states.xml > phs000463_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000464&library_strategy=WXS&platform=ILLUMINA" -o phs000464_wxs_illumina_all_states.xml > phs000464_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000465&library_strategy=WXS&platform=ILLUMINA" -o phs000465_wxs_illumina_all_states.xml > phs000465_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000466&library_strategy=WXS&platform=ILLUMINA" -o phs000466_wxs_illumina_all_states.xml > phs000466_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000467&library_strategy=WXS&platform=ILLUMINA" -o phs000467_wxs_illumina_all_states.xml > phs000467_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000468&library_strategy=WXS&platform=ILLUMINA" -o phs000468_wxs_illumina_all_states.xml > phs000468_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000469&library_strategy=WXS&platform=ILLUMINA" -o phs000469_wxs_illumina_all_states.xml > phs000469_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000470&library_strategy=WXS&platform=ILLUMINA" -o phs000470_wxs_illumina_all_states.xml > phs000470_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000471&library_strategy=WXS&platform=ILLUMINA" -o phs000471_wxs_illumina_all_states.xml > phs000471_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000515&library_strategy=WXS&platform=ILLUMINA" -o phs000515_wxs_illumina_all_states.xml > phs000515_wxs_illumina_all_states.out
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WXS" -o "phs000218_phs0004*_phs000515_wxs_all_states.xml" > "phs000218_phs0004*_phs000515_wxs_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WXS&platform=ILLUMINA" -o "phs000218_phs0004*_phs000515_wxs_illumina_all_states.xml" > "phs000218_phs0004*_phs000515_wxs_illumina_all_states.out"

cgquery --all-states -a "study=phs000218&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000218_wxs_illumina_live_all_states.xml > phs000218_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000463&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000463_wxs_illumina_live_all_states.xml > phs000463_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000464&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000464_wxs_illumina_live_all_states.xml > phs000464_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000465&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000465_wxs_illumina_live_all_states.xml > phs000465_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000466&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000466_wxs_illumina_live_all_states.xml > phs000466_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000467&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000467_wxs_illumina_live_all_states.xml > phs000467_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000468&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000468_wxs_illumina_live_all_states.xml > phs000468_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000469&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000469_wxs_illumina_live_all_states.xml > phs000469_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000470&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000470_wxs_illumina_live_all_states.xml > phs000470_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000471&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000471_wxs_illumina_live_all_states.xml > phs000471_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000515&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000515_wxs_illumina_live_all_states.xml > phs000515_wxs_illumina_live_all_states.out
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WXS&state=live" -o "phs000218_phs0004*_phs000515_wxs_live_all_states.xml" > "phs000218_phs0004*_phs000515_wxs_live_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WXS&platform=ILLUMINA&state=live" -o "phs000218_phs0004*_phs000515_wxs_illumina_live_all_states.xml" > "phs000218_phs0004*_phs000515_wxs_illumina_live_all_states.out"

##WGS
cgquery --all-states -a "study=phs000218&library_strategy=WGS&platform=ILLUMINA" -o phs000218_wgs_illumina_all_states.xml > phs000218_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000463&library_strategy=WGS&platform=ILLUMINA" -o phs000463_wgs_illumina_all_states.xml > phs000463_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000464&library_strategy=WGS&platform=ILLUMINA" -o phs000464_wgs_illumina_all_states.xml > phs000464_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000465&library_strategy=WGS&platform=ILLUMINA" -o phs000465_wgs_illumina_all_states.xml > phs000465_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000466&library_strategy=WGS&platform=ILLUMINA" -o phs000466_wgs_illumina_all_states.xml > phs000466_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000467&library_strategy=WGS&platform=ILLUMINA" -o phs000467_wgs_illumina_all_states.xml > phs000467_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000468&library_strategy=WGS&platform=ILLUMINA" -o phs000468_wgs_illumina_all_states.xml > phs000468_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000469&library_strategy=WGS&platform=ILLUMINA" -o phs000469_wgs_illumina_all_states.xml > phs000469_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000470&library_strategy=WGS&platform=ILLUMINA" -o phs000470_wgs_illumina_all_states.xml > phs000470_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000471&library_strategy=WGS&platform=ILLUMINA" -o phs000471_wgs_illumina_all_states.xml > phs000471_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000515&library_strategy=WGS&platform=ILLUMINA" -o phs000515_wgs_illumina_all_states.xml > phs000515_wgs_illumina_all_states.out
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WGS" -o "phs000218_phs0004*_phs000515_wgs_all_states.xml" > "phs000218_phs0004*_phs000515_wgs_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WGS&platform=ILLUMINA" -o "phs000218_phs0004*_phs000515_wgs_illumina_all_states.xml" > "phs000218_phs0004*_phs000515_wgs_illumina_all_states.out"

cgquery --all-states -a "study=phs000218&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000218_wgs_illumina_live_all_states.xml > phs000218_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000463&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000463_wgs_illumina_live_all_states.xml > phs000463_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000464&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000464_wgs_illumina_live_all_states.xml > phs000464_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000465&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000465_wgs_illumina_live_all_states.xml > phs000465_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000466&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000466_wgs_illumina_live_all_states.xml > phs000466_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000467&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000467_wgs_illumina_live_all_states.xml > phs000467_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000468&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000468_wgs_illumina_live_all_states.xml > phs000468_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000469&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000469_wgs_illumina_live_all_states.xml > phs000469_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000470&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000470_wgs_illumina_live_all_states.xml > phs000470_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000471&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000471_wgs_illumina_live_all_states.xml > phs000471_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000515&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000515_wgs_illumina_live_all_states.xml > phs000515_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WGS&state=live" -o "phs000218_phs0004*_phs000515_wgs_live_all_states.xml" > "phs000218_phs0004*_phs000515_wgs_live_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&library_strategy=WGS&platform=ILLUMINA&state=live" -o "phs000218_phs0004*_phs000515_wgs_illumina_live_all_states.xml" > "phs000218_phs0004*_phs000515_wgs_illumina_live_all_states.out"


cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&state=live" -o "phs000218_phs0004*_phs000515_live_all_states.xml" > "phs000218_phs0004*_phs000515_live_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&state=redacted" -o "phs000218_phs0004*_phs000515_redacted_all_states.xml" > "phs000218_phs0004*_phs000515_redacted_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&state=supressed" -o "phs000218_phs0004*_phs000515_supressed_all_states.xml" > "phs000218_phs0004*_phs000515_supressed_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&state=bad_data" -o "phs000218_phs0004*_phs000515_bad_data_all_states.xml" > "phs000218_phs0004*_phs000515_bad_data_all_states.out"
cgquery --all-states -a "study=(phs000218 OR phs0004* OR phs000515)&state=submitted" -o "phs000218_phs0004*_phs000515_submitted_all_states.xml" > "phs000218_phs0004*_phs000515_submitted_all_states.out"

####
#TCGA
cgquery --all-states -a "study=phs000178" -o phs000178_all_states.xml > phs000178_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WGS" -o phs000178_wgs_all_states.xml > phs000178_wgs_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WXS" -o phs000178_wxs_all_states.xml > phs000178_wxs_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WGS&platform=ILLUMINA" -o phs000178_wgs_illumina_all_states.xml > phs000178_wgs_illumina_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WXS&platform=ILLUMINA" -o phs000178_wxs_illumina_all_states.xml > phs000178_wxs_illumina_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WGS&platform=ILLUMINA&state=live" -o phs000178_wgs_illumina_live_all_states.xml > phs000178_wgs_illumina_live_all_states.out
cgquery --all-states -a "study=phs000178&library_strategy=WXS&platform=ILLUMINA&state=live" -o phs000178_wxs_illumina_live_all_states.xml > phs000178_wxs_illumina_live_all_states.out

cgquery --all-states -a "study=phs000178&state=live" -o phs000178_live_all_states.xml > phs000178_live_all_states.out
cgquery --all-states -a "study=phs000178&state=redacted" -o phs000178_redacted_all_states.xml > phs000178_redacted_all_states.out
cgquery --all-states -a "study=phs000178&state=suppressed" -o phs000178_suppressed_all_states.xml > phs000178_supressed_all_states.out
cgquery --all-states -a "study=phs000178&state=bad_data" -o phs000178_bad_data_all_states.xml > phs000178_bad_data_all_states.out
cgquery --all-states -a "study=phs000178&state=submitted" -o phs000178_submitted_all_states.xml > phs000178_submitted_all_states.out
cgquery --all-states -a "study=phs000178&state=uploading" -o phs000178_uploading_all_states.xml > phs000178_uploading_all_states.out
cgquery --all-states -a "study=phs000178&state=validating_sample" -o phs000178_validating_sample_all_states.xml > phs000178_validating_sample_all_states.out


cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=BCM" -o wxs_illumnia_live_phs000178_BCM.xml > wxs_illumnia_live_phs000178_BCM.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=BCCAGSC" -o wxs_illumnia_live_phs000178_BCCAGSC.xml > wxs_illumnia_live_phs000178_BCCAGSC.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=BI" -o wxs_illumnia_live_phs000178_BI.xml > wxs_illumnia_live_phs000178_BI.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=EBI-EMBL" -o wxs_illumnia_live_phs000178_EBI-EMBL.xml > wxs_illumnia_live_phs000178_EBI-EMBL.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=HMS-RK" -o wxs_illumnia_live_phs000178_HMS-RK.xml > wxs_illumnia_live_phs000178_HMS-RK.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=HAIB" -o wxs_illumnia_live_phs000178_HAIB.xml > wxs_illumnia_live_phs000178_HAIB.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=MSKCC" -o wxs_illumnia_live_phs000178_MSKCC.xml > wxs_illumnia_live_phs000178_MSKCC.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=SANGER" -o wxs_illumnia_live_phs000178_SANGER.xml > wxs_illumnia_live_phs000178_SANGER.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=UCSC" -o wxs_illumnia_live_phs000178_UCSC.xml > wxs_illumnia_live_phs000178_UCSC.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=UNC-LCCC" -o wxs_illumnia_live_phs000178_UNC-LCCC.xml > wxs_illumnia_live_phs000178_UNC-LCCC.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=USC-JHU" -o wxs_illumnia_live_phs000178_USC-JHU.xml > wxs_illumnia_live_phs000178_USC-JHU.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=WUGSC" -o wxs_illumnia_live_phs000178_WUGSC.xml > wxs_illumnia_live_phs000178_WUGSC.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=STJUDE" -o wxs_illumnia_live_phs000178_STJUDE.xml > wxs_illumnia_live_phs000178_STJUDE.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=BCG-DANVERS" -o wxs_illumnia_live_phs000178_BCG-DANVERS.xml > wxs_illumnia_live_phs000178_BCG-DANVERS.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=NCI-KHAN" -o wxs_illumnia_live_phs000178_NCI-KHAN.xml > wxs_illumnia_live_phs000178_NCI-KHAN.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=NCI-MELTZER" -o wxs_illumnia_live_phs000178_NCI-MELTZER.xml > wxs_illumnia_live_phs000178_NCI-MELTZER.out
cgquery -a "library_strategy=WXS&platform=ILLUMINA&state=live&study=phs000178&center_name=OHSU" -o wxs_illumnia_live_phs000178_OHSU.xml > wxs_illumnia_live_phs000178_OHSU.out

#CGCI
cgquery --all-states -a "study=phs000235" -o phs000235_all_states.xml > phs000235_all_states.out
cgquery --all-states -a "study=phs00052*" -o "phs00052*_all_states.xml" > "phs00052*_all_states.out"
cgquery --all-states -a "study=phs00053*" -o "phs00053*_all_states.xml" > "phs00053*_all_states.out"

cgquery --all-states -a "study=phs00052*&library_strategy=WXS" -o "phs00052*_wxs_all_states.xml" > "phs00052*_wxs_all_states.out"
cgquery --all-states -a "study=phs00053*&library_strategy=WGS" -o "phs00053*_wgs_all_states.xml" > "phs00053*_wgs_all_states.out"

cgquery --all-states -a "study=phs00052*&library_strategy=WXSS&platform=ILLUMINA" -o "phs00052*_wxs_illumina_all_states.xml" > "phs00052*_wxs_illumina_all_states.out"
cgquery --all-states -a "study=phs00053*&library_strategy=WGSS&platform=ILLUMINA" -o "phs00053*_wgs_illumina_all_states.xml" > "phs00053*_wgs_illumina_all_states.out"

cgquery --all-states -a "study=phs00052*&library_strategy=WXSS&platform=ILLUMINA&state=live" -o "phs00052*_wxs_illumina_live_all_states.xml" > "phs00052*_wxs_illumina_live_all_states.out"
cgquery --all-states -a "study=phs00053*&library_strategy=WGSS&platform=ILLUMINA&state=live" -o "phs00053*_wgs_illumina_live_all_states.xml" > "phs00053*_wgs_illumina_live_all_all_states.out"
