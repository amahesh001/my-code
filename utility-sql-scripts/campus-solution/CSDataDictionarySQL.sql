---------------------------------
-- XLAT QUERIES -----------------
---------------------------------

-- XLat-Field-Names
SELECT DISTINCT fieldname
    FROM sysadm.psxlatitem
ORDER BY 1;

-- XLat-Field-Values
  SELECT a.fieldname,
         a.fieldvalue,
         a.effdt,
         a.eff_status,
         a.xlatlongname,
         a.xlatshortname
    FROM sysadm.psxlatitem a
ORDER BY 1, 2, 3;

-- Latest XLAT Values
with latest_xlats as
(
SELECT *
           FROM sysadm.psxlatitem o
          WHERE     effdt =
                    (SELECT MAX (i.effdt)
                       FROM sysadm.psxlatitem i
                      WHERE     i.fieldname = o.fieldname
                            AND i.fieldvalue = o.fieldvalue
                            AND i.effdt <= SYSDATE)
                AND o.eff_status = 'A'
)
select * from latest_xlats 
--where fieldname = 'SEX' 
ORDER BY 1,2;

-- 156 Rows





-- Check on List
-- Check which tables are in Oracle
select column_value 
from table(sys.dbms_debug_vc2coll(
'PS_RELATIONSHIPS','PS_RELATION_AFFIL','PS_ADM_APPL_RCR_CA'
))
minus
select object_name from all_objects where owner = 'SYSADM' and object_type = 'TABLE';


select column_value 
from table(sys.dbms_debug_vc2coll(
'RELATIONSHIPS','RELATION_AFFIL','ADM_APPL_RCR_CA'
))
minus
select recname from sysadm.psrecfielddb;


--SQL Statement
--CFGDataDictionarySQL.sql



-- CS-Records
WITH
    cte_rec_keys
    AS
        (  SELECT recname,
                  RTRIM (
                      XMLAGG (XMLELEMENT (e, fieldname, ', ').EXTRACT (
                                  '//text()')
                              ORDER BY fieldnum).getclobval (),
                      ', ')    key_fields
             FROM sysadm.psrecfielddb
            WHERE BITAND (useedit, 1) = 1
         GROUP BY recname)
  SELECT t.recname,
         DBMS_LOB.SUBSTR (k.key_fields, 4000, 1)     keys,
         t.parentrecname,
         t.recdescr,
         DBMS_LOB.SUBSTR (t.descrlong, 4000, 1)      descrlong,
         o.object_type
    FROM sysadm.psrecdefn t
         LEFT OUTER JOIN cte_rec_keys k ON k.recname = t.recname
         LEFT OUTER JOIN all_objects o
             ON     o.owner = 'SYSADM'
                AND o.object_name = 'PS_' || t.recname
                AND o.object_type IN ('TABLE', 'VIEW')
   WHERE t.recname IN 
   (
   
'ACAD_CAR_TBL','ACAD_DEGR','ACAD_DEGR_HONS','ACAD_DEGR_PLAN','ACAD_DEGR_SPLN','ACAD_GROUP_TBL','ACAD_HISTORY','ACAD_LEVEL_TBL','ACAD_ORG_FS_OWN','ACAD_ORG_TBL','ACAD_PLAN','ACAD_PLAN_CAF','ACAD_PLAN_TBL','ACAD_PROG','ACAD_PROG_TBL','ACAD_STACTN_TBL','ACAD_STDNG_ACTN','ACAD_STDNG_TBL','ACAD_SUBPLAN','ACAD_SUBPLN_TBL','ADDRESSES','ADDRESS_TYP_TBL','ADMIT_TYPE_TBL','ADM_APPL_DATA','ADM_APPL_DEP','ADM_APPL_DEP_PR','ADM_APPL_PLAN','ADM_APPL_PROG','ADM_APPL_RCR_CA','ADM_APPL_RCTER','ADM_APPL_SBPLAN','ADM_APP_CAR_SEQ','ADM_PRSPCT_CAR','ADM_PRSPCT_PLAN','ADM_PRSPCT_PROG','ATHL_PART_LANG','ATHL_PART_SPORT','ATHL_PART_STAT','ATHL_PART_TBL','CAMPUS_EVENT','CAMPUS_EVNT_ATT','CAMPUS_LOC_TBL','CAMPUS_MTG','CAMPUS_MTG_RSRC','CAMPUS_MTG_SEL','CAMPUS_MTG_STAF','CAMPUS_TBL','CAMP_MTG_OTRLOC','CIP_CODE_TBL','CITIZENSHIP','CITIZEN_STS_TBL','CLASS_ASSOC','CLASS_ATTENDNCE','CLASS_ATTRIBUTE','CLASS_CHRSTC','CLASS_COMPONENT','CLASS_EXAM','CLASS_INSTR','CLASS_MTG_PAT','CLASS_NOTES','CLASS_NOTES_TBL','CLASS_PRMSN','CLASS_RSRV_CAP','CLASS_RSRV_GRP','CLASS_TBL','CLASS_TBL_GL','CMPNT_CHRSTC','COUNTRY_TBL','CRSE_ATTENDANCE','CRSE_ATTRIBUTES','CRSE_ATTR_VALUE','CRSE_CATALOG','CRSE_COMPONENT','CRSE_EQUIV_TBL','CRSE_LST_DTL_SF','CRSE_LST_HDR_SF','CRSE_OFFER','CRSE_OFFER_GL','CRSE_OFFER_OWNR','CRSE_TOPICS','DEGREE_TBL','DEGR_HONORS_TBL','DIVERSITY','DIVERS_ETHNIC','EMAIL_ADDRESSES','ENRL_REQ_DETAIL','ENRL_RSN_TBL','ETHNICITY_DTL','ETHNIC_GRP_TBL','EVENT_MTG','EXAM_CODE_TBL','EXT_ACAD_DATA','EXT_ACAD_SUM','EXT_COURSE','EXT_DEGREE','EXT_ORG_TBL','EXT_ORG_TBL_ADM','EXT_ORG_VW','GLOBAL_NOTE_TBL','GRADE_BASIS_TBL','GRADE_TBL','INSTITUTION_TBL','ITEM_LINE_SF','ITEM_SF','MESSAGE_LOG','MESSAGE_LOGPARM','NAMES','NAME_TYPE_TBL','ORG_CONTACT','ORG_DEPT','ORG_LOCATION','PERSON','PERSON_SA','PERS_DATA_EFFDT','PRCSRUNCNTL','REGION_TBL','REG_REGION_TBL','RESOURCE_QUEUE','RUN_CNTL_EXSCH2','RUN_CNTL_EXSCHD','R_SRROLL_TBL','SAD_APPL_ATCH','SAD_APPL_CAF','SAD_PLAN_CAF','SAD_PROG_CAF','SAD_TESTDT','SAD_TESTDT_CAF','SCC_ENTITY_REG','SCC_ORG_EXT_KEY','SCC_ORG_EXT_SYS','SCTN_CMBND','SCTN_CMBND_TBL','SESSION_TBL','SSR_ASSOC_CAF','SSR_CLASS_SHIFT','SSR_CLASS_TXB','SSR_CLS_TBL_NZL','SSR_CLS_TXB_DTL','SSR_CRS_MILESTN','SSR_CRS_OFR_AUS','SSR_CRS_OFR_NZL','SSR_HE_CRSE','SSR_HE_CRSE_FLD','SSR_HE_CSUB_FLD','SSR_PLAN_CAF','SSR_STDNT_GRAD','STATE_TBL','STDNT_ATTR_DTL','STDNT_CAREER','STDNT_CAR_SEQ','STDNT_CAR_TERM','STDNT_ENRL','STDNT_GROUP_TBL','STDNT_GRPS','STDNT_GRPS_HIST','STDNT_RESPONSE','STDNT_SESSION','STDNT_TEST','STDNT_TEST_COMP','SUBJECT_TBL','SUBJ_COMPONENT','SUBJ_OWNER_TBL','TERM_TBL','VISA_PERMIT_TBL','VISA_PMT_DATA','RELATIONSHIPS','RELATION_AFFIL','ADM_APPL_RCR_CA'   
   )
ORDER BY 1;

-- CS-Record-Columns ($$$$)
WITH
    cte_xlat1
    AS
        (SELECT *
           FROM sysadm.psxlatitem o
          WHERE     effdt =
                    (SELECT MAX (i.effdt)
                       FROM sysadm.psxlatitem i
                      WHERE     i.fieldname = o.fieldname
                            AND i.fieldvalue = o.fieldvalue
                            AND i.effdt <= SYSDATE)
                AND o.eff_status = 'A'),
    cte_xlat2
    AS
        (  SELECT fieldname,
                  RTRIM (
                      XMLAGG (XMLELEMENT (e,
                                          fieldvalue || ':' || xlatlongname,
                                          ', ').EXTRACT ('//text()')
                              ORDER BY fieldvalue).getclobval (),
                      ', ')    xlatvalues
             FROM cte_xlat1
         GROUP BY fieldname)
  SELECT a.recname,
         a.fieldnum,
         CASE
             WHEN BITAND (useedit, 1) = 1 THEN 'Key'
             ELSE CASE WHEN BITAND (useedit, 16) = 16 THEN 'Alt' END
         END
             AS key,
         a.fieldname,
         d.longname,
         CASE
             WHEN b.fieldtype = 1 THEN 'long'
             WHEN b.fieldtype = 2 THEN 'number'
             WHEN b.fieldtype = 3 THEN 'signed number'
             WHEN b.fieldtype = 4 THEN 'date'
             WHEN b.fieldtype = 5 THEN 'time'
             WHEN b.fieldtype = 6 THEN 'datetime'
             WHEN b.fieldtype = 8 THEN 'image'
             WHEN b.fieldtype = 0 THEN 'char'
             WHEN b.fieldtype = 9 THEN 'imageref'
             ELSE TO_CHAR (b.fieldtype)
         END
             fieldtype,
         b.LENGTH,
         b.decimalpos,
         CASE WHEN BITAND (useedit, 256) = 256 THEN 'Y' ELSE '' END
             AS req,
         CASE
             WHEN BITAND (useedit, 512) = 512
             THEN
                 'Xlat'
             ELSE
                 CASE
                     WHEN BITAND (useedit, 8192) = 8192
                     THEN
                         'Y/N'
                     ELSE
                         CASE
                             WHEN BITAND (useedit, 16384) = 16384 THEN 'Prompt'
                             ELSE ''
                         END
                 END
         END
             AS edit,
         -- Show EDITTBLE Only if  BITAND (USEEDIT, 16384) = 16384
         CASE WHEN BITAND (useedit, 16384) = 16384 THEN edittable ELSE '' END
             AS edittable,
         --EDITTABLE,
         -- Show XLatValues Only if  BITAND (USEEDIT, 512) = 512
         CASE
             WHEN BITAND (useedit, 512) = 512
             THEN
                 DBMS_LOB.SUBSTR (x.xlatvalues, 4000, 1)
             ELSE
                 ''
         END
             AS xlatvalues,
         CASE WHEN BITAND (useedit, 2048) = 2048 THEN 'Y' ELSE '' END
             AS search,
         CASE WHEN BITAND (useedit, 32) = 32 THEN 'Y' ELSE '' END
             AS list,
         deffieldname,
         o.object_type
    --  C.RECDESCR,
    --  DECODE( A.FIELDNUM,1, dbms_lob.substr( C.DESCRLONG, 4000, 1 ) , ' ') RECORD_DESC
    FROM sysadm.psrecfielddb a
         INNER JOIN sysadm.psdbfield b ON a.fieldname = b.fieldname
         INNER JOIN sysadm.psrecdefn c ON a.recname = c.recname
         INNER JOIN sysadm.psdbfldlabl d ON b.fieldname = d.fieldname
         LEFT OUTER JOIN cte_xlat2 x ON a.fieldname = x.fieldname
         LEFT OUTER JOIN all_objects o
             ON     o.owner = 'SYSADM'
                AND o.object_name = 'PS_' || a.recname
                AND o.object_type IN ('TABLE', 'VIEW')
   WHERE     (   d.default_label = 1 AND a.label_id = ' '
              OR d.label_id = a.label_id)
         AND a.recname IN 
   (


'ACAD_CAR_TBL','ACAD_DEGR','ACAD_DEGR_HONS','ACAD_DEGR_PLAN','ACAD_DEGR_SPLN','ACAD_GROUP_TBL','ACAD_HISTORY','ACAD_LEVEL_TBL','ACAD_ORG_FS_OWN','ACAD_ORG_TBL','ACAD_PLAN','ACAD_PLAN_CAF','ACAD_PLAN_TBL','ACAD_PROG','ACAD_PROG_TBL','ACAD_STACTN_TBL','ACAD_STDNG_ACTN','ACAD_STDNG_TBL','ACAD_SUBPLAN','ACAD_SUBPLN_TBL','ADDRESSES','ADDRESS_TYP_TBL','ADMIT_TYPE_TBL','ADM_APPL_DATA','ADM_APPL_DEP','ADM_APPL_DEP_PR','ADM_APPL_PLAN','ADM_APPL_PROG','ADM_APPL_RCR_CA','ADM_APPL_RCTER','ADM_APPL_SBPLAN','ADM_APP_CAR_SEQ','ADM_PRSPCT_CAR','ADM_PRSPCT_PLAN','ADM_PRSPCT_PROG','ATHL_PART_LANG','ATHL_PART_SPORT','ATHL_PART_STAT','ATHL_PART_TBL','CAMPUS_EVENT','CAMPUS_EVNT_ATT','CAMPUS_LOC_TBL','CAMPUS_MTG','CAMPUS_MTG_RSRC','CAMPUS_MTG_SEL','CAMPUS_MTG_STAF','CAMPUS_TBL','CAMP_MTG_OTRLOC','CIP_CODE_TBL','CITIZENSHIP','CITIZEN_STS_TBL','CLASS_ASSOC','CLASS_ATTENDNCE','CLASS_ATTRIBUTE','CLASS_CHRSTC','CLASS_COMPONENT','CLASS_EXAM','CLASS_INSTR','CLASS_MTG_PAT','CLASS_NOTES','CLASS_NOTES_TBL','CLASS_PRMSN','CLASS_RSRV_CAP','CLASS_RSRV_GRP','CLASS_TBL','CLASS_TBL_GL','CMPNT_CHRSTC','COUNTRY_TBL','CRSE_ATTENDANCE','CRSE_ATTRIBUTES','CRSE_ATTR_VALUE','CRSE_CATALOG','CRSE_COMPONENT','CRSE_EQUIV_TBL','CRSE_LST_DTL_SF','CRSE_LST_HDR_SF','CRSE_OFFER','CRSE_OFFER_GL','CRSE_OFFER_OWNR','CRSE_TOPICS','DEGREE_TBL','DEGR_HONORS_TBL','DIVERSITY','DIVERS_ETHNIC','EMAIL_ADDRESSES','ENRL_REQ_DETAIL','ENRL_RSN_TBL','ETHNICITY_DTL','ETHNIC_GRP_TBL','EVENT_MTG','EXAM_CODE_TBL','EXT_ACAD_DATA','EXT_ACAD_SUM','EXT_COURSE','EXT_DEGREE','EXT_ORG_TBL','EXT_ORG_TBL_ADM','EXT_ORG_VW','GLOBAL_NOTE_TBL','GRADE_BASIS_TBL','GRADE_TBL','INSTITUTION_TBL','ITEM_LINE_SF','ITEM_SF','MESSAGE_LOG','MESSAGE_LOGPARM','NAMES','NAME_TYPE_TBL','ORG_CONTACT','ORG_DEPT','ORG_LOCATION','PERSON','PERSON_SA','PERS_DATA_EFFDT','PRCSRUNCNTL','REGION_TBL','REG_REGION_TBL','RESOURCE_QUEUE','RUN_CNTL_EXSCH2','RUN_CNTL_EXSCHD','R_SRROLL_TBL','SAD_APPL_ATCH','SAD_APPL_CAF','SAD_PLAN_CAF','SAD_PROG_CAF','SAD_TESTDT','SAD_TESTDT_CAF','SCC_ENTITY_REG','SCC_ORG_EXT_KEY','SCC_ORG_EXT_SYS','SCTN_CMBND','SCTN_CMBND_TBL','SESSION_TBL','SSR_ASSOC_CAF','SSR_CLASS_SHIFT','SSR_CLASS_TXB','SSR_CLS_TBL_NZL','SSR_CLS_TXB_DTL','SSR_CRS_MILESTN','SSR_CRS_OFR_AUS','SSR_CRS_OFR_NZL','SSR_HE_CRSE','SSR_HE_CRSE_FLD','SSR_HE_CSUB_FLD','SSR_PLAN_CAF','SSR_STDNT_GRAD','STATE_TBL','STDNT_ATTR_DTL','STDNT_CAREER','STDNT_CAR_SEQ','STDNT_CAR_TERM','STDNT_ENRL','STDNT_GROUP_TBL','STDNT_GRPS','STDNT_GRPS_HIST','STDNT_RESPONSE','STDNT_SESSION','STDNT_TEST','STDNT_TEST_COMP','SUBJECT_TBL','SUBJ_COMPONENT','SUBJ_OWNER_TBL','TERM_TBL','VISA_PERMIT_TBL','VISA_PMT_DATA','RELATIONSHIPS','RELATION_AFFIL','ADM_APPL_RCR_CA'
   )
ORDER BY 1, 2;

-- PKey Alter Table Statements
--PKey-Statements
WITH
    cte_rec_keys
    AS
        (  SELECT recname,
                  RTRIM (
                      XMLAGG (XMLELEMENT (e, fieldname, ', ').EXTRACT (
                                  '//text()')
                              ORDER BY fieldnum).getclobval (),
                      ', ')    key_fields
             FROM sysadm.psrecfielddb
            WHERE BITAND (useedit, 1) = 1
         GROUP BY recname)
  SELECT recname,
         DBMS_LOB.SUBSTR (key_fields, 4000, 1)    keys,
            'ALTER TABLE SYSADM.PS_'
         || recname
         || ' ADD CONSTRAINT XPKPS_'
         || recname
         || ' PRIMARY KEY ('
         || DBMS_LOB.SUBSTR (key_fields, 4000, 1)
         || ');'                                  alter_stmt
    FROM cte_rec_keys a join all_objects b on b.object_name = 'PS_'|| a.recname and 
                                              b.owner = 'SYSADM' and 
                                              b.object_type = 'TABLE' 
   WHERE recname IN 
   (
'ACAD_CAR_TBL', 'ACAD_DEGR', 'ACAD_DEGR_HONS', 'ACAD_DEGR_PLAN', 'ACAD_DEGR_SPLN', 'ACAD_GROUP_TBL', 'ACAD_HISTORY', 'ACAD_ORG_FS_OWN', 'ACAD_ORG_TBL', 'ACAD_PLAN', 'ACAD_PLAN_TBL', 'ACAD_PROG', 'ACAD_PROG_TBL', 'ACAD_STDNG_ACTN', 'ACAD_STDNG_TBL', 'ACAD_SUBPLAN', 'ACAD_SUBPLN_TBL', 'ADDRESSES', 'ADDRESS_TYP_TBL', 'ADMIT_TYPE_TBL', 'ADM_APPL_DATA', 'ADM_APPL_DEP', 'ADM_APPL_DEP_PR', 'ADM_APPL_PLAN', 'ADM_APPL_PROG', 'ADM_APPL_RCR_CA', 'ADM_APPL_RCTER', 'ADM_APPL_SBPLAN', 'ADM_APP_CAR_SEQ', 'ADM_PRSPCT_CAR', 'ADM_PRSPCT_PLAN', 'ADM_PRSPCT_PROG', 'ATHL_PART_LANG', 'ATHL_PART_SPORT', 'ATHL_PART_STAT', 'ATHL_PART_TBL', 'CAMPUS_EVENT', 'CAMPUS_EVNT_ATT', 'CAMPUS_LOC_TBL', 'CAMPUS_MTG', 'CAMPUS_MTG_RSRC', 'CAMPUS_MTG_SEL', 'CAMPUS_MTG_STAF', 'CAMPUS_TBL', 'CAMP_MTG_OTRLOC', 'CITIZENSHIP', 'CITIZEN_STS_TBL', 'CLASS_ASSOC', 'CLASS_ATTENDNCE', 'CLASS_ATTRIBUTE', 'CLASS_CHRSTC', 'CLASS_COMPONENT', 'CLASS_EXAM', 'CLASS_INSTR', 'CLASS_MTG_PAT', 'CLASS_NOTES', 'CLASS_NOTES_TBL', 'CLASS_PRMSN', 'CLASS_RSRV_CAP', 'CLASS_RSRV_GRP', 'CLASS_TBL', 'CLASS_TBL_GL', 'CMPNT_CHRSTC', 'COUNTRY_TBL', 'CRSE_ATTENDANCE', 'CRSE_ATTRIBUTES', 'CRSE_CATALOG', 'CRSE_COMPONENT', 'CRSE_EQUIV_TBL', 'CRSE_LST_DTL_SF', 'CRSE_LST_HDR_SF', 'CRSE_OFFER', 'CRSE_OFFER_GL', 'CRSE_OFFER_OWNR', 'CRSE_TOPICS', 'DEGREE_TBL', 'DEGR_HONORS_TBL', 'DEPENDENT_VW', 'DIVERS_ETHNIC', 'EMAIL_ADDRESSES', 'ETHNICITY_DTL', 'ETHNIC_GRP_TBL', 'EVENT_MTG', 'EXAM_CODE_TBL', 'EXT_ACAD_DATA', 'EXT_ACAD_SUM', 'EXT_COURSE', 'EXT_DEGREE', 'EXT_ORG_TBL', 'EXT_ORG_VW', 'GLOBAL_NOTE_TBL', 'HCR_ETHNC_GRP_I', 'HCR_REG_REGN_I', 'INSTITUTION_TBL', 'ITEM_LINE_SF', 'ITEM_SF', 'MESSAGE_LOG', 'MESSAGE_LOGPARM', 'NAMES', 'NAME_FORMAT_TBL', 'NAME_PREFIX_TBL', 'NAME_SUFFIX_TBL', 'NAME_TYPE_TBL', 'NM_ROYPREF_GBL', 'NM_ROYSUFF_GBL', 'PERSON', 'PERSON_NAME', 'PERS_DATA_EFFDT', 'PRCSRUNCNTL', 'REG_REGION_TBL', 'RESIDENCY_TBL', 'RESOURCE_QUEUE', 'RUN_CNTL_EXSCH2', 'RUN_CNTL_EXSCHD', 'R_SRROLL_TBL', 'SAD_APPL_ATCH', 'SAD_APPL_CAF', 'SAD_PROG_CAF', 'SAD_TESTDT', 'SAD_TESTDT_CAF', 'SCC_ENTITY_REG', 'SCTN_CMBND', 'SCTN_CMBND_TBL', 'SESSION_TBL', 'SET_VLD_HR_11', 'SSR_ASSOC_CAF', 'SSR_CLASS_SHIFT', 'SSR_CLASS_TXB', 'SSR_CLS_TBL_NZL', 'SSR_CLS_TXB_DTL', 'SSR_CRS_MILESTN', 'SSR_CRS_OFR_AUS', 'SSR_CRS_OFR_NZL', 'SSR_HE_CRSE', 'SSR_HE_CRSE_FLD', 'SSR_HE_CSUB_FLD', 'SSR_STDNT_GRAD', 'STATE_TBL', 'STDNT_ATTR_DTL', 'STDNT_CAREER', 'STDNT_CAR_SEQ', 'STDNT_CAR_TERM', 'STDNT_ENRL', 'STDNT_GROUP_TBL', 'STDNT_GRPS', 'STDNT_GRPS_HIST', 'STDNT_RESPONSE', 'STDNT_TEST', 'STDNT_TEST_COMP', 'SUBJECT_TBL', 'SUBJ_COMPONENT', 'SUBJ_OWNER_TBL', 'TERM_TBL', 'TITLE_TBL', 'VISA_PERMIT_TBL', 'VISA_PMT_DATA'
   )
ORDER BY 1;

-- Effective Dated Tables (with type!)
with cte1 as
(
select table_name,
    count(case when column_name = 'EMPLID' then 1 else null end) as empl_id_flag,
    count(case when column_name = 'EFFDT' then 1 else null end) as effdt_flag,
    count(case when column_name = 'EFF_STATUS' then 1 else null end) as effstatus_flag,
    count(case when column_name = 'EFFSEQ' then 1 else null end) as effseq_flag
 from all_tab_columns where owner = 'SYSADM' and table_name in
(
'PS_TERM_TBL','PS_SESSION_TBL','PS_PERSON','PS_PERSON_SA','PS_PERS_DATA_EFFDT','PS_EMAIL_ADDRESSES','PS_NAMES','PS_NAME_TYPE_TBL','PS_CITIZENSHIP','PS_CITIZEN_STS_TBL','PS_VISA_PMT_DATA','PS_VISA_PERMIT_TBL','PS_DIVERS_ETHNIC','PS_ETHNIC_GRP_TBL','PS_ETHNICITY_DTL','PS_DIVERSITY','PS_ADDRESSES','PS_ADDRESS_TYP_TBL','PS_COUNTRY_TBL','PS_STATE_TBL','PS_ATHL_PART_SPORT','PS_ATHL_PART_STAT','PS_ATHL_PART_TBL','PS_ACAD_CAR_TBL','PS_ACAD_GROUP_TBL','PS_ACAD_PROG_TBL','PS_ACAD_PLAN_TBL','PS_ACAD_SUBPLN_TBL','PS_DEGREE_TBL','PS_DEGR_HONORS_TBL','PS_CIP_CODE_TBL','PS_STDNT_CAREER','PS_STDNT_CAR_SEQ','PS_ACAD_PROG','PS_ACAD_PLAN','PS_ACAD_PLAN_CAF','PS_ACAD_SUBPLAN','PS_ACAD_DEGR','PS_ACAD_DEGR_HONS','PS_ACAD_DEGR_PLAN','PS_ACAD_DEGR_SPLN','PS_STDNT_CAR_TERM','PS_STDNT_SESSION','PS_ACAD_STDNG_ACTN','PS_CRSE_CATALOG','PS_CRSE_ATTRIBUTES','PS_CRSE_EQUIV_TBL','PS_CRSE_OFFER','PS_CRSE_OFFER_OWNR','PS_CLASS_TBL','PS_CLASS_ATTRIBUTE','PS_CLASS_MTG_PAT','PS_SCTN_CMBND','PS_SCTN_CMBND_TBL','PS_STDNT_ENRL','PS_CLASS_INSTR'
)
group by table_name)
select 
        table_name,
        case when empl_id_flag > 0 then 'Y' else 'N' END as transactional_table,
        case 
            when  effdt_flag > 0 then 'Effective Dated'
            else '-'
        end ||
        case 
            when  effstatus_flag > 0 then ' (with Effective Status)'
            else ''
        end ||            
        case 
            when  effseq_flag > 0 then ' (with Effective Seq)'
            else ''
        end as Effective_Dated_Type
        
from cte1;
 

