create or replace package fpt_lob_pkg is

  procedure split_xdolob_all(p_app_short_name varchar2,
                             p_template_code  varchar2);
  procedure split_xdolob(p_app_short_name varchar2,
                         p_lob_type       varchar2,
                         p_lob_code       varchar2,
                         p_language       varchar2,
                         p_territory      varchar2);

end fpt_lob_pkg;
/
create or replace package body fpt_lob_pkg is

  /*
  create table DEV.FPT_SPLIT_DATA
(
  OBJECT_CODE   VARCHAR2(30),
  LOB_TYPE      VARCHAR2(30),
  LOB_CODE      VARCHAR2(30),
  SPLIT_NUM     NUMBER(5),
  SPLIT_CONTENT VARCHAR2(4000),
  CREATION_DATE DATE,
  ATTRIBUTE1    VARCHAR2(50),
  ATTRIBUTE2    VARCHAR2(50),
  ATTRIBUTE3    VARCHAR2(50)
);
create synonym FPT_SPLIT_DATA for DEV.FPT_SPLIT_DATA;
  */
  
  procedure split_xdolob_all(p_app_short_name varchar2,
                             p_template_code  varchar2) is
  begin
    for r in (select xl.lob_type,
                     xl.application_short_name,
                     xl.lob_code,
                     xl.language,
                     xl.territory
                from xdo_lobs xl
               where xl.application_short_name = p_app_short_name
                 and xl.lob_code = p_template_code) loop
    
      split_xdolob(p_app_short_name => r.application_short_name,
                   p_lob_type       => r.lob_type,
                   p_lob_code       => r.lob_code,
                   p_language       => r.language,
                   p_territory      => r.territory);
    
    end loop;
  end;

  procedure split_xdolob(p_app_short_name varchar2,
                         p_lob_type       varchar2,
                         p_lob_code       varchar2,
                         p_language       varchar2,
                         p_territory      varchar2) is
    v_blob    blob;
    v_varchar varchar2(4000);
    v_start   pls_integer := 1;
    v_buffer  pls_integer := 4000;
    v_num     number(5);
  begin
  
    /* Delete old content
    */
    delete from fpt_split_data t
     where t.object_code = 'XDO_LOB'
       and t.lob_type = p_lob_type
       and t.lob_code = p_lob_code
       and t.attribute1 = p_language
       and t.attribute2 = p_territory
       and t.attribute3 = p_app_short_name;
  
    select xl.file_data
      into v_blob
      from xdo_lobs xl
     where xl.application_short_name = p_app_short_name
       and xl.lob_type = p_lob_type
       and xl.lob_code = p_lob_code
       and xl.language = p_language
       and xl.territory = p_territory;
  
    v_num := 0;
  
    for i in 1 .. ceil(dbms_lob.getlength(v_blob) / v_buffer) loop
    
      v_varchar := utl_raw.cast_to_varchar2(dbms_lob.substr(v_blob,
                                                            v_buffer,
                                                            v_start));
      v_num     := v_num + 1;
    
      insert into fpt_split_data
        (object_code,
         lob_type,
         lob_code,
         attribute1,
         attribute2,
         attribute3,
         split_num,
         split_content,
         creation_date)
      values
        ('XDO_LOB',
         p_lob_type,
         p_lob_code,
         p_language,
         p_territory,
         p_app_short_name,
         v_num,
         v_varchar,
         sysdate);
    
      v_start := v_start + v_buffer;
    
    end loop;
    
    commit;
    
  end;

end fpt_lob_pkg;
/
