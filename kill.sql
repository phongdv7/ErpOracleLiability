select 
s.SID,
s.SERIAL#,
name,
s.MODULE,
s.ACTION,
s.LOGON_TIME,
s.LAST_CALL_ET,
s.STATUS,
l.blocking_others,
s.*
 from sys.dba_dml_locks l, v$session s
where
l.session_id = s.SID
and l.name not like  '%DEFERRED%'
and s.LAST_CALL_ET>60
order by s.LAST_CALL_ET desc;
--------------
ALTER SYSTEM KILL SESSION '2022, 1453' IMMEDIATE;