select s.sid,
       l.lock_type,
       l.mode_held,
       l.mode_requested,
       l.lock_id1,
       'alter system kill session ''' || s.sid || ',' || s.serial# ||
       ''' immediate;' kill_sid
  from dba_lock_internal l, v$session s
 where s.sid = l.session_id
   and upper(l.lock_id1) like '%&package_name%'
   and l.lock_type = 'Body Definition Lock';
   
-----
alter system kill session '3,56713' immediate;
