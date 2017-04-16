create or replace package evn_security_pkg is

  function security_request_user(p_user_id         number,
                                 p_conc_program_id number,
                                 p_resp_id         number default null)
    return boolean;
  function security_request_delete return boolean;
  procedure write_output(p_text varchar2);

/*
  -- Create Table
create table evn.evn_security_users(
security_type varchar2(15) not null,
user_id number not null,
conc_program_id number,
resp_id number,
creation_date date,
created_by number,
last_update_date date,
last_updated_by number,
last_update_login number
);

-- Create Synonym
create synonym evn_security_users for evn.evn_security_users;

*/

end evn_security_pkg;
/
create or replace package body evn_security_pkg is

  /*--------------------------------------------------------
  -- Package su dung de thuc hien security
  -- Nguoi tao: TamPT5
  -- Ngay tao: 12/02/2016
  
  Lich su thay doi
  1.0  TamPT5  Tao moi
  --------------------------------------------------------*/

  -- Security Request by User
  -- TamPT5 12/02/2016
  -- Result: True = Valid, False = Invalid
  function security_request_user(p_user_id         number,
                                 p_conc_program_id number,
                                 p_resp_id         number default null)
    return boolean is
    v_count number;
  begin
  
    select count(1)
      into v_count
      from evn.evn_security_users su
     where su.conc_program_id = p_conc_program_id
       and su.user_id = p_user_id
       and (su.resp_id = p_resp_id or p_resp_id is null or
           su.resp_id is null)
       and (trunc(su.start_date) <= sysdate or su.start_date is null)
       and (trunc(su.end_date) >= trunc(sysdate) or su.end_date is null);
  
    if v_count > 0 then
      return true;
    end if;
  
    return false;
  
  end;

  -- Security User cho cac Request Delete
  -- evn_delete_pkg
  function security_request_delete return boolean is
    v_result          boolean;
    v_user_id         number := fnd_profile.value('USER_ID');
    v_user_name varchar2(50) := fnd_profile.value('USERNAME');
    v_conc_program_id number := fnd_global.conc_program_id;
  begin
    v_result := evn_security_pkg.security_request_user(p_user_id         => v_user_id,
                                                       p_conc_program_id => v_conc_program_id);
    if not v_result then
    
      v_result := fnd_concurrent.set_completion_status('WARNING',
                                                       'User ' || v_user_name || ' khong co quyen chay request nay');
    
      write_output('User ' || v_user_name || ' khong co quyen chay request nay');
      write_output('User ID: ' || v_user_id);
      write_output('Program ID: ' || v_conc_program_id);
    
      return false;
    
    end if;
  
    return true;
  
  end;

  procedure write_output(p_text varchar2) is
  begin
    fnd_file.put_line(fnd_file.output, p_text);
  end;

end evn_security_pkg;
/
