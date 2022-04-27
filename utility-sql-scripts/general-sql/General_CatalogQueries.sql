-- ETL Tool 0.001
select 
'TRUNCATE TABLE CS_STAGE.' || TABLE_NAME || ';' || CHR(10) ||
'INSERT INTO CS_STAGE.' || TABLE_NAME || ' SELECT * FROM SYSADM.' || TABLE_NAME || '@CS_CNV;' || CHR(10) ||
'COMMIT;' || CHR(10) 
as Script
from all_tables where owner = 'CS_STAGE'
ORDER BY 1;

-- TRIM ME
select column_name || ' = TRIM(' || column_name || '),' from all_tab_columns where table_name = 'AMTEMP_MAPPING' order by column_id;

-- TS Details
SELECT df.tablespace_name "Tablespace",
  totalusedspace "Used MB",
  (df.totalspace - tu.totalusedspace) "Free MB",
  df.totalspace "Total MB",
  ROUND(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace)) "% Free"
FROM
  (SELECT tablespace_name,
    ROUND(SUM(bytes) / 1048576) TotalSpace
  FROM dba_data_files
  GROUP BY tablespace_name
  ) df,
  (SELECT ROUND(SUM(bytes)/(1024*1024)) totalusedspace,
    tablespace_name
  FROM dba_segments
  GROUP BY tablespace_name
  ) tu
WHERE df.tablespace_name = tu.tablespace_name
ORDER BY 1;

-- Kill my Session (eg getting ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired)
SELECT * FROM V$SESSION WHERE STATUS = 'ACTIVE' 
AND USERNAME='AMAHESH';

SELECT 'ALTER SYSTEM KILL SESSION '''||SID||','||SERIAL#||''' immediate;' FROM V$SESSION WHERE STATUS = 'ACTIVE' 
AND USERNAME='AMAHESH';

ALTER SYSTEM KILL SESSION '38,262' immediate;

ALTER SYSTEM KILL SESSION '418,15896' immediate;


ALTER SYSTEM KILL SESSION '31,32143' immediate;


-- Drop My Tables
select 'drop table ' || table_name || ';' from user_tables WHERE table_name like 'PS%' order by 1;
select 'drop view ' || view_name || ';' from user_views WHERE view_name like 'BKP%' order by 1;
--where view_name not like 'V_PS%' order by 1;
select 'TRUNCATE TABLE S_' || view_name || ';' from user_views where view_name like 'V_PS%' order by 1;
select 'INSERT INTO S_' || view_name || ' select * from ' || view_name || ';' from user_views where view_name like 'V_PS%' order by 1;

-- RowCount Analysis Query
select table_name,num_rows,'select ''' || table_name ||  ''',count(*) from ' || table_name || ' UNION ' from user_tables where table_name like 'AM%';

-- Truncate Tables
select 'truncate table ' || table_name || ';' from user_tables WHERE table_name like 'MSTR%' order by 1;

-- Backup
select 'create table B' || table_name || ' as select * from '|| table_name || ';' from user_tables where table_name like 'MSTR%' order by 1;

-- Select Statement
select 'select * from ' || table_name || ' order by 1,2,3;' from user_tables order by 1;

-- List of Table/Views in specific schemas
WITH
    all_TabViews
    AS
        (SELECT *
           FROM all_objects
          WHERE object_type IN ('TABLE', 'VIEW'))
  SELECT tv.object_type,
         tv.owner,
         tv.object_name,
         tab.num_rows,
         tab.last_analyzed,
         comm.comments
    FROM all_TabViews tv
         LEFT OUTER JOIN all_tables tab
             ON tv.owner = tab.owner AND tv.object_name = tab.table_name
         LEFT OUTER JOIN all_tab_comments comm
             ON tab.owner = comm.owner AND tab.table_name = comm.table_name
   WHERE     tv.owner IN ('AMAHESH') and tv.object_type = 'TABLE'
         --AND tv.object_name  LIKE 'DIM%'
ORDER BY tv.object_type, tv.owner, tv.object_name;

-- Columns for Tables & Views ($$$$)
WITH
    all_TabViews
    AS
        (SELECT *
           FROM all_objects
          WHERE object_type IN ('TABLE', 'VIEW'))
  SELECT tv.object_type,
         tv.owner,
         tv.object_name,
         col.COLUMN_ID,
         col.column_name,
         col.data_type,
         CASE
             WHEN col.char_length = 0 THEN col.data_type
             ELSE col.data_type || '(' || col.char_length || ')'
         END                 AS data_type_ext,
         col.data_length,
         col.data_precision,
         col.data_scale,
         col.nullable,
         col.data_default    AS DEFAULT_VALUE,
         comm.comments
    FROM all_TabViews tv
         INNER JOIN all_tab_columns col
             ON col.owner = tv.owner AND col.table_name = tv.object_name
         LEFT JOIN all_col_comments comm
             ON     col.owner = comm.owner
                AND col.table_name = comm.table_name
                AND col.column_name = comm.column_name
   WHERE  (tv.owner IN ('AMAHESH') AND (tv.object_name LIKE 'AMTEMP_APP_MAPPING' OR tv.object_name LIKE 'XXX')
   )
ORDER BY tv.object_name,col.column_id;


-- Find Schemas of Tables
  SELECT owner || '.' || object_name     qualified_obj_name,
         owner,
         object_name,
         object_type,
         'SELECT * FROM ' || owner || '.' || object_name || ';' SQL_Statement   
    FROM all_objects
   WHERE     
--        owner IN ('ACAD_REPORT',
--                       'IR_REPORT',
--                       'CONFORMED_DIM_REPORT',
--                       'FINAID_REPORT',
--                       'FACULTY_REPORT',
--                       'WH_REPORT_ACAD')
--         AND 
         object_name IN ('EN_PERSON_APPLICATION')
ORDER BY object_type, owner, object_name; 

-- Find Tables & Views in which a column Exists
select * 
from all_tab_columns 
where owner IN ('ACAD_REPORT',
                       'IR_REPORT',
                       'CONFORMED_DIM_REPORT',
                       'FINAID_REPORT',
                       'FACULTY_REPORT',
                       'WH_REPORT_ACAD')
and column_name like '%DEG_LEVEL_CD%';

         
-- Find Tables with a Name
select owner||'.'||table_name, a.*
from all_tables a
where table_name like 'DIM_COL%';


-- Select View Details
select 'SELECT * FROM ' || owner||'.'||view_name ||';', a.*
 from all_views a
where view_name in
(
'V_DIM_ENR_STUD_DEG_LEVEL',
'V_DIM_ENR_DEG_LEVEL_CATGRY',
'V_DIM_ENR_COL_DEGREE_PROGRAM',
'V_DIM_ENR_DEGREE_PROG',
'V_DIM_COLLEGE_CURRENT',
'V_DIM_COLLEGE_CURRENT',
'V_DIM_COLLEGE',
'V_DIM_GRADN_DEGREE_LEVEL',
'V_DIM_GRADN_DEG_LEVEL_CATGRY',
'V_DIM_GRADN_COL_DEGREE_PROGRAM',
'V_DIM_GRADN_COL_DEGREE_PROGRAM',
'V_DIM_GRADN_DEGREE_STATUS'
);


       
 -- Multi-Row-Insert
 INSERT ALL
INTO DATA_DICT_RECS VALUES('ACAD_PLAN', 'Y', sysdate,'AM')
INTO DATA_DICT_RECS VALUES('ACAD_PROG', 'Y', sysdate,'AM')
INTO DATA_DICT_RECS VALUES('ACAD_SUBPLAN', 'Y', sysdate,'AM')
SELECT 1 FROM DUAL;


select * from DATA_DICT_RECS;



-- Which of these values are not in a table
select column_value 
from table(sys.dbms_debug_vc2coll(
'INSTITUTION_TBL',
'ACAD_CAR_TBL',
'ACAD_GROUP_TBL'
))
minus
select recname
from v_data_dict_record;

-- DB link Creation
CREATE DATABASE LINK cs_cfg
CONNECT TO DEVANURAG identified by "D25thiaheY!!"
USING 
'  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.63.129.34)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME=bucfg1.buocisubpridbas.buocivcnashdevn.oraclevcn.com )
    )
  )';


CREATE DATABASE LINK adw_prod
CONNECT TO amahesh identified by "G7dAz5su6PL#j2M"
USING 
' (DESCRIPTION  =
  (ADDRESS_LIST =           
   (ADDRESS = (PROTOCOL = TCP)(HOST = istedwp)(PORT = 1521)))
    (CONNECT_DATA = (SID = whdata1a)))';


CREATE DATABASE LINK cs_tst1
CONNECT TO DEVANURAG identified by "D25thiaheY!!"
USING 
'  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 10.63.130.46)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME=  butst1.buocisubpridbas.buocivcnashtest.oraclevcn.com)
    )
  )';






select * from USER_DB_LINKS;

