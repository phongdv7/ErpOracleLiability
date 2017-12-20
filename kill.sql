select s.sid,
       s.serial#,
       name,
       s.module,
       s.action,
       s.logon_time,
       s.last_call_et,
       s.status,
       l.blocking_others,
       s.*
  from sys.dba_dml_locks l, v$session s
 where l.session_id = s.sid
   and l.name not like '%DEFERRED%'
   and s.last_call_et > 60
 order by s.last_call_et desc;
--------------
--ALTER SYSTEM KILL SESSION '2022, 1453' IMMEDIATE;
