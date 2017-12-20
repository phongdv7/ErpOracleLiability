/*How to kill long running/hang concurrent request*/
SELECT ses.sid, 
ses.serial# 
FROM v$session ses, 
v$process pro 
WHERE ses.paddr = pro.addr 
AND pro.spid IN (SELECT oracle_process_id 
FROM fnd_concurrent_requests 
WHERE request_id =11613265); 

--You will get spid & pid from above request. Pass your request id in above query.
--And run below query with sys user.
SQL> ALTER SYSTEM KILL SESSION ' 1114, 8017' IMMEDIATE;
System altered.

--Issue: Request is in pending from long time,
--#First Terminate the Request as follows
update fnd_concurrent_requests
   set status_code='X', phase_code='C'
   where request_id=31783706;

commit;

--#Then change the status with Completed-Error as follows.
update fnd_concurrent_requests
   set status_code='E', phase_code='C'
   where request_id=31783706;

commit;

/*
#This will change the status of any request.
#Status Code
E -  Error
X -  Terminate
G -  Warning
*/