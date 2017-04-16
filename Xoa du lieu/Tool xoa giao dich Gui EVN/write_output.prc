create or replace procedure evn_write_output(p_text varchar2) is
begin
  fnd_file.put_line(fnd_file.output, p_text);
end;
/
