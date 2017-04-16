declare
  v_user_name varchar2(50) := 'DUONGTT9.FPTERP';
  v_user_id   number;
begin
  select u.user_id
    into v_user_id
    from fnd_user u
   where u.user_name = upper(v_user_name);

  insert into evn.evn_security_users
    (user_id,
     conc_program_id,
     description,
     creation_date,
     created_by,
     last_update_date,
     last_updated_by,
     last_update_login)
    select v_user_id,
           cp.concurrent_program_id,
           cp.user_concurrent_program_name,
           sysdate,
           0,
           sysdate,
           0,
           0
      from fnd_concurrent_programs_vl cp
     where cp.concurrent_program_name like 'EVN_DEL%'
       and not exists
     (select 1
              from evn.evn_security_users su
             where su.user_id = v_user_id
               and su.conc_program_id = cp.concurrent_program_id);
               
   commit;               

end;
