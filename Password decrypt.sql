--Gia ma password
select usr.user_name,
       get_pwd.decrypt((select (select get_pwd.decrypt(fnd_web_sec.get_guest_username_pwd,
                                                      usertable.encrypted_foundation_password)
                                 from dual) as apps_password
                         from fnd_user usertable
                        where usertable.user_name =
                              (select substr(fnd_web_sec.get_guest_username_pwd,
                                             1,
                                             instr(fnd_web_sec.get_guest_username_pwd,
                                                   '/') - 1)
                                 from dual)),
                       usr.encrypted_user_password) password
  from fnd_user usr
 where upper(usr.user_name) = upper('&user_name');
