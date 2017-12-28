create or replace package fpt_request_exp_pkg is

  pv_cp_like1     varchar2(100) := 'EVN%HN';
  pv_cp_like2     varchar2(100) := '';
  pv_cp_like3     varchar2(100) := '';
  pv_cp_not_like1 varchar2(100) := 'EVN%THHN';
  pv_cp_not_like2 varchar2(100) := '';
  pv_cp_not_like3 varchar2(100) := '';

  procedure main;
  procedure build_executable(p_source_clob in out clob);
  procedure build_program(p_source_clob in out clob);
  procedure build_descr_flex(p_source_clob in out clob);
  procedure build_descr_flex_context(p_source_clob in out clob);
  procedure build_descr_flex_column_usage(p_source_clob in out clob);
  procedure build_xdo_definition(p_source_clob in out clob);
  procedure build_xdo_template(p_source_clob in out clob);
  procedure build_flex_value_set(p_source_clob in out clob);
  procedure input_clob(p_clob in out clob, p_input_text varchar2);
  procedure concat_clob(p_source_clob in out clob, p_input_clob clob);
  function encode_sc(p_string varchar2) return varchar2;

/*  -- Create table
create table FPT_CLOB_DATA
(
  data_id       VARCHAR2(30),
  data_clob     CLOB,
  creation_date DATE
)*/

end fpt_request_exp_pkg;
/
create or replace package body fpt_request_exp_pkg is

  function get_value(p_table_owner varchar2,
                     p_table_name  varchar2,
                     p_column_name varchar2,
                     p_data_type   varchar2,
                     p_column_key1 varchar2,
                     p_value_key1  varchar2,
                     p_column_key2 varchar2 default null,
                     p_value_key2  varchar2 default null,
                     p_column_key3 varchar2 default null,
                     p_value_key3  varchar2 default null,
                     p_column_key4 varchar2 default null,
                     p_value_key4  varchar2 default null,
                     p_column_key5 varchar2 default null,
                     p_value_key5  varchar2 default null) return varchar2 is
    v_sql        varchar2(1000);
    v_value      varchar2(4000);
    v_value_date date;
  begin
    v_sql := 'select ' || p_column_name || ' from ' || p_table_owner || '.' ||
             p_table_name || ' where ' || p_column_key1 || ' = ''' ||
             p_value_key1 || '''';
  
    if p_column_key2 is not null and
       p_value_key2 is not null then
      v_sql := v_sql || ' and ' || p_column_key2 || ' = ''' || p_value_key2 || '''';
    end if;
  
    if p_column_key3 is not null and
       p_value_key3 is not null then
      v_sql := v_sql || ' and ' || p_column_key3 || ' = ''' || p_value_key3 || '''';
    end if;
  
    if p_column_key4 is not null and
       p_value_key4 is not null then
      v_sql := v_sql || ' and ' || p_column_key4 || ' = ''' || p_value_key4 || '''';
    end if;
  
    if p_column_key5 is not null and
       p_value_key5 is not null then
      v_sql := v_sql || ' and ' || p_column_key5 || ' = ''' || p_value_key5 || '''';
    end if;
  
    --dbms_output.put_line(v_sql);
  
    if p_data_type = 'DATE' then
      execute immediate v_sql
        into v_value_date;
    
      v_value := '$D$' || to_char(v_value_date, 'rrmmddhh24miss');
    
    else
      execute immediate v_sql
        into v_value;
    end if;
  
    return v_value;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm || chr(10) || v_sql);
      return null;
  end;

  function build_xml(p_table_owner varchar2,
                     p_table_name  varchar2,
                     p_column_key1 varchar2,
                     p_value_key1  varchar2,
                     p_column_key2 varchar2 default null,
                     p_value_key2  varchar2 default null,
                     p_column_key3 varchar2 default null,
                     p_value_key3  varchar2 default null,
                     p_column_key4 varchar2 default null,
                     p_value_key4  varchar2 default null,
                     p_column_key5 varchar2 default null,
                     p_value_key5  varchar2 default null) return varchar2 is
    v_xml   varchar2(4000);
    v_value varchar2(4000);
  begin
  
    for r in (select tc.column_name,
                     tc.column_id,
                     tc.data_type,
                     tc.data_length,
                     tc.data_precision,
                     tc.data_scale
                from all_tab_columns tc
               where tc.owner = p_table_owner
                 and tc.table_name = p_table_name
              /*and tc.column_name not in
              ('CREATION_DATE',
               'CREATED_BY',
               'LAST_UPDATE_DATE',
               'LAST_UPDATED_BY',
               'LAST_UPDATE_LOGIN')*/
               order by tc.column_id) loop
    
      v_value := get_value(p_table_owner => p_table_owner,
                           p_table_name  => p_table_name,
                           p_column_name => r.column_name,
                           p_data_type   => r.data_type,
                           p_column_key1 => p_column_key1,
                           p_value_key1  => p_value_key1,
                           p_column_key2 => p_column_key2,
                           p_value_key2  => p_value_key2,
                           p_column_key3 => p_column_key3,
                           p_value_key3  => p_value_key3,
                           p_column_key4 => p_column_key4,
                           p_value_key4  => p_value_key4,
                           p_column_key5 => p_column_key5,
                           p_value_key5  => p_value_key5);
    
      if v_value is not null then
        v_xml := v_xml || '<' || r.column_name || '>';
        v_xml := v_xml || encode_sc(v_value);
        v_xml := v_xml || '</' || r.column_name || '>';
      end if;
    
    end loop;
  
    return v_xml;
  
  end;

  procedure main is
    v_clob clob;
  begin
    -- Initital
    dbms_lob.createtemporary(v_clob, true);
  
    -- Open Root Tag
    input_clob(v_clob, '<DATA>');
  
    build_executable(v_clob);
  
    build_program(v_clob);
  
    build_descr_flex(v_clob);
  
    build_descr_flex_column_usage(v_clob);
  
    build_xdo_definition(v_clob);
  
    build_xdo_template(v_clob);
  
    build_flex_value_set(v_clob);
  
    -- Close Root Tag
    input_clob(v_clob, '</DATA>');
  
    delete from fpt_clob_data;
    insert into fpt_clob_data
    values
      (to_char(sysdate, 'rrmmddhh24miss'), v_clob, sysdate);
    commit;
  
    -- Release
    dbms_lob.freetemporary(v_clob);
  
  end;

  procedure build_executable(p_source_clob in out clob) is
    cursor c1 is
      select distinct cp.executable_application_id, cp.executable_id
        from fnd_concurrent_programs cp
       where (cp.concurrent_program_name like pv_cp_like1 or
             cp.concurrent_program_name like pv_cp_like2 or
             cp.concurrent_program_name like pv_cp_like3)
         and (cp.concurrent_program_name not like pv_cp_not_like1 or
             pv_cp_not_like1 is null)
         and (cp.concurrent_program_name not like pv_cp_not_like2 or
             pv_cp_not_like2 is null)
         and (cp.concurrent_program_name not like pv_cp_not_like3 or
             pv_cp_not_like3 is null)
         and cp.enabled_flag = 'Y';
  
    cursor c2 is
      select el.application_id, el.executable_id, el.language
        from fnd_executables_tl el
       where (el.application_id, el.executable_id) in
             (select cp.executable_application_id, cp.executable_id
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
    v_xml varchar2(32767);
  begin
    -- FND_EXECUTABLES
    input_clob(p_source_clob, '<FND_EXECUTABLES>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_EXECUTABLES',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r1.executable_application_id,
                                  p_column_key2 => 'EXECUTABLE_ID',
                                  p_value_key2  => r1.executable_id);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_EXECUTABLES>');
  
    -- FND_EXECUTABLES_TL
    input_clob(p_source_clob, '<FND_EXECUTABLES_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_EXECUTABLES_TL',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r2.application_id,
                                  p_column_key2 => 'EXECUTABLE_ID',
                                  p_value_key2  => r2.executable_id,
                                  p_column_key3 => 'LANGUAGE',
                                  p_value_key3  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_EXECUTABLES_TL>');
  
  end;

  procedure build_program(p_source_clob in out clob) is
    cursor c1 is
      select cp.application_id,
             cp.concurrent_program_id,
             cp.concurrent_program_name
        from fnd_concurrent_programs cp
       where (cp.concurrent_program_name like pv_cp_like1 or
             cp.concurrent_program_name like pv_cp_like2 or
             cp.concurrent_program_name like pv_cp_like3)
         and (cp.concurrent_program_name not like pv_cp_not_like1 or
             pv_cp_not_like1 is null)
         and (cp.concurrent_program_name not like pv_cp_not_like2 or
             pv_cp_not_like2 is null)
         and (cp.concurrent_program_name not like pv_cp_not_like3 or
             pv_cp_not_like3 is null)
         and cp.enabled_flag = 'Y';
  
    cursor c2 is
      select cpl.application_id, cpl.concurrent_program_id, cpl.language
        from fnd_concurrent_programs_tl cpl
       where (cpl.application_id, cpl.concurrent_program_id) in
             (select cp.application_id, cp.concurrent_program_id
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
    v_xml varchar2(32767);
  begin
    -- FND_CONCURRENT_PROGRAMS
    input_clob(p_source_clob, '<FND_CONCURRENT_PROGRAMS>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml ||
               build_xml(p_table_owner => 'APPLSYS',
                         p_table_name  => 'FND_CONCURRENT_PROGRAMS',
                         p_column_key1 => 'APPLICATION_ID',
                         p_value_key1  => r1.application_id,
                         p_column_key2 => 'CONCURRENT_PROGRAM_ID',
                         p_value_key2  => r1.concurrent_program_id);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_CONCURRENT_PROGRAMS>');
  
    -- FND_CONCURRENT_PROGRAMS_TL
    input_clob(p_source_clob, '<FND_CONCURRENT_PROGRAMS_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_CONCURRENT_PROGRAMS_TL',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r2.application_id,
                                  p_column_key2 => 'CONCURRENT_PROGRAM_ID',
                                  p_value_key2  => r2.concurrent_program_id,
                                  p_column_key3 => 'LANGUAGE',
                                  p_value_key3  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_CONCURRENT_PROGRAMS_TL>');
  
  end;

  ----------------------------------------------
  -- Build Descriptive Flex
  ----------------------------------------------
  procedure build_descr_flex(p_source_clob in out clob) is
    cursor c1 is
      select f.application_id, f.descriptive_flexfield_name
        from fnd_descriptive_flexs f
       where (f.application_id, f.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    cursor c2 is
      select fl.application_id, fl.descriptive_flexfield_name, fl.language
        from fnd_descriptive_flexs_tl fl
       where (fl.application_id, fl.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    v_xml varchar2(32767);
  begin
    -- FND_DESCRIPTIVE_FLEXS
    input_clob(p_source_clob, '<FND_DESCRIPTIVE_FLEXS>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml ||
               build_xml(p_table_owner => 'APPLSYS',
                         p_table_name  => 'FND_DESCRIPTIVE_FLEXS',
                         p_column_key1 => 'APPLICATION_ID',
                         p_value_key1  => r1.application_id,
                         p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                         p_value_key2  => r1.descriptive_flexfield_name);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCRIPTIVE_FLEXS>');
  
    -- FND_DESCRIPTIVE_FLEXS_TL
    input_clob(p_source_clob, '<FND_DESCRIPTIVE_FLEXS_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_DESCRIPTIVE_FLEXS_TL',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r2.application_id,
                                  p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                                  p_value_key2  => r2.descriptive_flexfield_name,
                                  p_column_key3 => 'LANGUAGE',
                                  p_value_key3  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCRIPTIVE_FLEXS_TL>');
  
  end;

  ----------------------------------------------
  -- Build Descriptive Flex
  ----------------------------------------------
  procedure build_descr_flex_context(p_source_clob in out clob) is
    cursor c1 is
      select fc.application_id, fc.descriptive_flexfield_name
        from fnd_descr_flex_contexts fc
       where (fc.application_id, fc.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    cursor c2 is
      select fcl.application_id, fcl.descriptive_flexfield_name, fcl.language
        from fnd_descr_flex_contexts_tl fcl
       where (fcl.application_id, fcl.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    v_xml varchar2(32767);
  begin
    -- FND_DESCR_FLEX_CONTEXTS
    input_clob(p_source_clob, '<FND_DESCR_FLEX_CONTEXTS>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml ||
               build_xml(p_table_owner => 'APPLSYS',
                         p_table_name  => 'FND_DESCR_FLEX_CONTEXTS',
                         p_column_key1 => 'APPLICATION_ID',
                         p_value_key1  => r1.application_id,
                         p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                         p_value_key2  => r1.descriptive_flexfield_name);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCR_FLEX_CONTEXTS>');
  
    -- FND_DESCR_FLEX_CONTEXTS_TL
    input_clob(p_source_clob, '<FND_DESCR_FLEX_CONTEXTS_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_DESCR_FLEX_CONTEXTS_TL',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r2.application_id,
                                  p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                                  p_value_key2  => r2.descriptive_flexfield_name,
                                  p_column_key3 => 'LANGUAGE',
                                  p_value_key3  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCR_FLEX_CONTEXTS_TL>');
  
  end;

  ----------------------------------------------
  -- Build Descriptive Flex Column Usage
  ----------------------------------------------
  procedure build_descr_flex_column_usage(p_source_clob in out clob) is
    cursor c1 is
      select fcu.application_id,
             fcu.descriptive_flexfield_name,
             fcu.application_column_name
        from fnd_descr_flex_column_usages fcu
       where (fcu.application_id, fcu.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    cursor c2 is
      select fcul.application_id,
             fcul.descriptive_flexfield_name,
             fcul.application_column_name,
             fcul.language
        from fnd_descr_flex_col_usage_tl fcul
       where (fcul.application_id, fcul.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    v_xml varchar2(32767);
  begin
    -- FND_DESCR_FLEX_COLUMN_USAGES
    input_clob(p_source_clob, '<FND_DESCR_FLEX_COLUMN_USAGES>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml ||
               build_xml(p_table_owner => 'APPLSYS',
                         p_table_name  => 'FND_DESCR_FLEX_COLUMN_USAGES',
                         p_column_key1 => 'APPLICATION_ID',
                         p_value_key1  => r1.application_id,
                         p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                         p_value_key2  => r1.descriptive_flexfield_name,
                         p_column_key3 => 'APPLICATION_COLUMN_NAME',
                         p_value_key3  => r1.application_column_name);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCR_FLEX_COLUMN_USAGES>');
  
    -- FND_DESCR_FLEX_COL_USAGE_TL
    input_clob(p_source_clob, '<FND_DESCR_FLEX_COL_USAGE_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_DESCR_FLEX_COL_USAGE_TL',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r2.application_id,
                                  p_column_key2 => 'DESCRIPTIVE_FLEXFIELD_NAME',
                                  p_value_key2  => r2.descriptive_flexfield_name,
                                  p_column_key3 => 'APPLICATION_COLUMN_NAME',
                                  p_value_key3  => r2.application_column_name,
                                  p_column_key4 => 'LANGUAGE',
                                  p_value_key4  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</FND_DESCR_FLEX_COL_USAGE_TL>');
  
  end;

  ----------------------------------------------
  -- Build Descriptive Flex Column Usage
  ----------------------------------------------
  procedure build_xdo_definition(p_source_clob in out clob) is
    cursor c1 is
      select d.application_short_name, d.data_source_code
        from xdo_ds_definitions_b d
       where (d.application_short_name, d.data_source_code) in
             (select a.application_short_name, cp.concurrent_program_name
                from fnd_concurrent_programs cp, fnd_application a
               where cp.application_id = a.application_id
                 and (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    cursor c2 is
      select dl.application_short_name, dl.data_source_code, dl.language
        from xdo_ds_definitions_tl dl
       where (dl.application_short_name, dl.data_source_code) in
             (select a.application_short_name, cp.concurrent_program_name
                from fnd_concurrent_programs cp, fnd_application a
               where cp.application_id = a.application_id
                 and (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    v_xml varchar2(32767);
  begin
    -- XDO_DS_DEFINITIONS_B
    input_clob(p_source_clob, '<XDO_DS_DEFINITIONS_B>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml ||
               build_xml(p_table_owner => 'XDO',
                         p_table_name  => 'XDO_DS_DEFINITIONS_B',
                         p_column_key1 => 'APPLICATION_SHORT_NAME',
                         p_value_key1  => r1.application_short_name,
                         p_column_key2 => 'DATA_SOURCE_CODE',
                         p_value_key2  => r1.data_source_code);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</XDO_DS_DEFINITIONS_B>');
  
    -- FND_DESCR_FLEX_COL_USAGE_TL
    input_clob(p_source_clob, '<XDO_DS_DEFINITIONS_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'XDO',
                                  p_table_name  => 'XDO_DS_DEFINITIONS_TL',
                                  p_column_key1 => 'APPLICATION_SHORT_NAME',
                                  p_value_key1  => r2.application_short_name,
                                  p_column_key2 => 'DATA_SOURCE_CODE',
                                  p_value_key2  => r2.data_source_code,
                                  p_column_key4 => 'LANGUAGE',
                                  p_value_key4  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</XDO_DS_DEFINITIONS_TL>');
  
  end;

  procedure build_xdo_template(p_source_clob in out clob) is
    cursor c1 is
      select t.application_id, t.template_code
        from xdo_templates_b t
       where (t.ds_app_short_name, t.data_source_code) in
             (select d.application_short_name, d.data_source_code
                from fnd_concurrent_programs cp,
                     fnd_application         a,
                     xdo_ds_definitions_b    d
               where cp.application_id = a.application_id
                 and cp.concurrent_program_name = d.data_source_code
                 and a.application_short_name = d.application_short_name
                 and (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    cursor c2 is
      select tl.application_short_name, tl.template_code, tl.language
        from xdo_templates_tl tl
       where (tl.application_short_name, tl.template_code) in
             (select d.application_short_name, d.data_source_code
                from fnd_concurrent_programs cp,
                     fnd_application         a,
                     xdo_ds_definitions_b    d,
                     xdo_templates_b         t
               where cp.application_id = a.application_id
                 and cp.concurrent_program_name = d.data_source_code
                 and a.application_short_name = d.application_short_name
                 and d.application_short_name = t.ds_app_short_name
                 and d.data_source_code = t.data_source_code
                 and (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y');
  
    v_xml varchar2(32767);
  begin
    -- XDO_TEMPLATES_B
    input_clob(p_source_clob, '<XDO_TEMPLATES_B>');
  
    for r1 in c1 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'XDO',
                                  p_table_name  => 'XDO_TEMPLATES_B',
                                  p_column_key1 => 'APPLICATION_ID',
                                  p_value_key1  => r1.application_id,
                                  p_column_key2 => 'TEMPLATE_CODE',
                                  p_value_key2  => r1.template_code);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</XDO_TEMPLATES_B>');
  
    -- XDO_TEMPLATES_TL
    input_clob(p_source_clob, '<XDO_TEMPLATES_TL>');
  
    for r2 in c2 loop
      v_xml := '<ROW>';
      v_xml := v_xml || build_xml(p_table_owner => 'XDO',
                                  p_table_name  => 'XDO_TEMPLATES_TL',
                                  p_column_key1 => 'APPLICATION_SHORT_NAME',
                                  p_value_key1  => r2.application_short_name,
                                  p_column_key2 => 'TEMPLATE_CODE',
                                  p_value_key2  => r2.template_code,
                                  p_column_key4 => 'LANGUAGE',
                                  p_value_key4  => r2.language);
      v_xml := v_xml || '</ROW>';
      input_clob(p_source_clob, v_xml);
    end loop;
  
    input_clob(p_source_clob, '</XDO_TEMPLATES_TL>');
  
  end;

  procedure build_flex_value_set(p_source_clob in out clob) is
    cursor c is
      select distinct fcu.flex_value_set_id
        from fnd_descr_flex_column_usages fcu, fnd_flex_value_sets fvs
       where fcu.flex_value_set_id = fvs.flex_value_set_id
         and (fcu.application_id, fcu.descriptive_flexfield_name) in
             (select cp.application_id, '$SRS$.' || cp.concurrent_program_name
                from fnd_concurrent_programs cp
               where (cp.concurrent_program_name like pv_cp_like1 or
                     cp.concurrent_program_name like pv_cp_like2 or
                     cp.concurrent_program_name like pv_cp_like3)
                 and (cp.concurrent_program_name not like pv_cp_not_like1 or
                     pv_cp_not_like1 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like2 or
                     pv_cp_not_like2 is null)
                 and (cp.concurrent_program_name not like pv_cp_not_like3 or
                     pv_cp_not_like3 is null)
                 and cp.enabled_flag = 'Y')
         and fvs.last_update_date > '01-OCT-2017';
  
    v_clob_fv_set   clob;
    v_clob_fv_table clob;
    v_xml_fv_set    varchar2(32767);
    v_xml_fv_table  varchar2(32767);
  begin
    dbms_lob.createtemporary(v_clob_fv_set, true);
    dbms_lob.createtemporary(v_clob_fv_table, true);
  
    -- FND_FLEX_VALUE_SETS, FND_FLEX_VALIDATION_TABLES
    input_clob(v_clob_fv_set, '<FND_FLEX_VALUE_SETS>');
    input_clob(v_clob_fv_table, '<FND_FLEX_VALIDATION_TABLES>');
  
    for r in c loop
      -- FND_FLEX_VALUE_SETS
      v_xml_fv_set := '<ROW>';
      v_xml_fv_set := v_xml_fv_set ||
                      build_xml(p_table_owner => 'APPLSYS',
                                p_table_name  => 'FND_FLEX_VALUE_SETS',
                                p_column_key1 => 'FLEX_VALUE_SET_ID',
                                p_value_key1  => r.flex_value_set_id);
      v_xml_fv_set := v_xml_fv_set || '</ROW>';
      input_clob(v_clob_fv_set, v_xml_fv_set);
    
      -- FND_FLEX_VALIDATION_TABLES
      v_xml_fv_table := '<ROW>';
      v_xml_fv_table := v_xml_fv_table ||
                        build_xml(p_table_owner => 'APPLSYS',
                                  p_table_name  => 'FND_FLEX_VALIDATION_TABLES',
                                  p_column_key1 => 'FLEX_VALUE_SET_ID',
                                  p_value_key1  => r.flex_value_set_id);
      v_xml_fv_table := v_xml_fv_table || '</ROW>';
      input_clob(v_clob_fv_table, v_xml_fv_table);
    
    end loop;
  
    input_clob(v_clob_fv_set, '</FND_FLEX_VALUE_SETS>');
    input_clob(v_clob_fv_table, '</FND_FLEX_VALIDATION_TABLES>');
  
    -- Input Source Clob
    concat_clob(p_source_clob, v_clob_fv_set);
    concat_clob(p_source_clob, v_clob_fv_table);
  
    -- Release temp clob
    dbms_lob.freetemporary(v_clob_fv_set);
    dbms_lob.freetemporary(v_clob_fv_table);
  
  end;

  /* Convert Clob to Blob
  */
  function clob_to_blob(p_clob clob) return blob as
    l_blob          blob;
    l_dest_offset   integer := 1;
    l_source_offset integer := 1;
    l_lang_context  integer := dbms_lob.default_lang_ctx;
    l_warning       integer := dbms_lob.warn_inconvertible_char;
  begin
  
    dbms_lob.createtemporary(l_blob, true);
  
    dbms_lob.converttoblob(dest_lob     => l_blob,
                           src_clob     => p_clob,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => l_dest_offset,
                           src_offset   => l_source_offset,
                           blob_csid    => dbms_lob.default_csid,
                           lang_context => l_lang_context,
                           warning      => l_warning);
  
    return l_blob;
  
  end;

  procedure input_clob(p_clob in out clob, p_input_text varchar2) is
  begin
    --p_clob := p_clob || p_input_text;
    dbms_lob.writeappend(p_clob, length(p_input_text), p_input_text);
  end;

  procedure concat_clob(p_source_clob in out clob, p_input_clob clob) is
  begin
    dbms_lob.append(p_source_clob, p_input_clob);
  end;

  ----------------------------
  -- Get Length in byte Clob
  ----------------------------
  function lengthb_clob(p_clob clob) return number is
    v_buffer number := 3000;
    v_start  number := 1;
    v_length number := 0;
  begin
    if p_clob is null then
      return 0;
    end if;
  
    for i in 1 .. ceil(dbms_lob.getlength(p_clob) / v_buffer) loop
      v_length := v_length +
                  lengthb(dbms_lob.substr(p_clob, v_buffer, v_start));
      v_start  := v_start + v_buffer;
    end loop;
  
    return v_length;
  
  end;

  /* Encode Special Characters
  (&) encode to &amp; 
  (") encode to &quot; 
  (') encode to &apos; 
  (<) encode to &lt; 
  (>) encode to &gt;
  ----------------------------------*/
  function encode_sc(p_string varchar2) return varchar2 is
  begin
    return(replace(replace(replace(replace(replace(p_string, '&', '&amp;'),
                                           '"',
                                           '&quot;'),
                                   '''',
                                   '&apos;'),
                           '<',
                           '&lt;'),
                   '>',
                   '&gt;'));
  end;

end fpt_request_exp_pkg;
/
