create or replace procedure evn_write_log(p_text varchar2) is
begin
  fnd_file.put_line(fnd_file.log, p_text);
end;
/
