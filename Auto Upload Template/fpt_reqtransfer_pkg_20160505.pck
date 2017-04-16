create or replace package fpt_reqtransfer_pkg is
  procedure sync_program_req(errbuf           out varchar2,
                             retcode          out varchar2,
                             p_application_id number,
                             p_program_list   varchar2);
  procedure sync_program(p_application_id number, p_program_name varchar2);
  procedure sync_template_req(errbuf           out varchar2,
                              retcode          out varchar2,
                              p_app_short_name varchar2,
                              p_request_code   varchar2 default null);
  procedure sync_template(p_app_short_name varchar2,
                          p_request_code   varchar2 default null);
  procedure create_program(p_application_id number,
                           p_program_name   varchar2,
                           p_error_message  out varchar2);
  procedure create_template(p_app_short_name varchar2,
                            p_program_name   varchar2,
                            p_error_message  out varchar2);
  procedure sync_fvs(p_fvs_name varchar2, p_error_message out varchar2);
  procedure create_fvs(p_src_fvs_name  varchar2,
                       p_error_message out varchar2);
  procedure update_fvs(p_src_fvs_name  varchar2,
                       p_error_message out varchar2);
  procedure create_lob(p_app_short_name varchar2,
                       p_template_code  varchar2,
                       p_error_message  out varchar2);
  procedure build_xdolob(p_app_short_name varchar2,
                         p_lob_type       varchar2,
                         p_lob_code       varchar2,
                         p_language       varchar2,
                         p_territory      varchar2,
                         p_blob           out blob,
                         p_error_message  out varchar2);
  function blob_to_clob(blob_in in blob) return clob;
  function clob_to_blob(p_clob clob) return blob;
  procedure print_output(p_text varchar2);
  procedure put_line(p_message varchar2);
  procedure delete_program(p_application_id number,
                           p_request_code   varchar2,
                           p_error_message  out varchar2);
  procedure delete_request(p_application_id number,
                           p_request_code   varchar2);
end fpt_reqtransfer_pkg;
/
create or replace package body fpt_reqtransfer_pkg is

  procedure sync_program_req(errbuf           out varchar2,
                             retcode          out varchar2,
                             p_application_id number,
                             p_program_list   varchar2) is
  begin
  
    for r in (select cp.application_id, t.program_name
                from (select trim(regexp_substr(p_program_list,
                                                '[^,]+',
                                                1,
                                                level)) as program_name
                        from dual
                      connect by regexp_substr(p_program_list,
                                               '[^,]+',
                                               1,
                                               level) is not null) t,
                     fnd_concurrent_programs@dev2 cp
               where t.program_name = cp.concurrent_program_name
                 and cp.application_id = p_application_id) loop
    
      sync_program(p_application_id => p_application_id,
                   p_program_name   => r.program_name);
    
    end loop;
  
  exception
    when others then
      errbuf  := 'Exception\' || sqlerrm;
      retcode := 2;
  end;

  -- Synchronize Concurrent Program
  -----------------------------------
  procedure sync_program(p_application_id number, p_program_name varchar2) is
    v_step              varchar2(100);
    v_error_message     varchar2(500);
    v_program_file_type varchar2(30);
    v_app_short_name    varchar2(30);
  begin
    print_output('');
    print_output(p_program_name);
    print_output('------------------------------');
  
    v_step := 'Get app_short_name';
    select a.application_short_name
      into v_app_short_name
      from fnd_application a
     where a.application_id = p_application_id;
  
    v_step := 'Get program file type';
    select cp.output_file_type
      into v_program_file_type
      from fnd_concurrent_programs@dev2 cp
     where cp.application_id = p_application_id
       and cp.concurrent_program_name = p_program_name;
  
    v_step := 'delete_program';
    delete_program(p_application_id => p_application_id,
                   p_request_code   => p_program_name,
                   p_error_message  => v_error_message);
  
    if v_error_message is not null then
      rollback;
      print_output(v_error_message);
      return;
    end if;
  
    v_step := 'create_program';
    create_program(p_application_id => p_application_id,
                   p_program_name   => p_program_name,
                   p_error_message  => v_error_message);
  
    if v_error_message is not null then
      rollback;
      print_output(v_error_message);
      return;
    end if;
  
    commit;
  
    if v_program_file_type = 'XML' then
      create_template(p_app_short_name => v_app_short_name,
                      p_program_name   => p_program_name,
                      p_error_message  => v_error_message);
    end if;
  
    if v_error_message is not null then
      print_output(v_error_message);
    end if;
  
  exception
    when others then
      rollback;
      print_output('sync_program\' || v_step || '\' || sqlerrm);
  end;

  procedure sync_template_req(errbuf           out varchar2,
                              retcode          out varchar2,
                              p_app_short_name varchar2,
                              p_request_code   varchar2 default null) is
  begin
    sync_template(p_app_short_name, p_request_code);
  exception
    when others then
      errbuf  := 'Exception\' || sqlerrm;
      retcode := 2;
  end;

  -- Synchonize Template
  ------------------------------
  procedure sync_template(p_app_short_name varchar2,
                          p_request_code   varchar2 default null) is
    cursor c is
      select t.application_short_name, t.data_source_code
        from xdo_ds_definitions_b@dev2 t
       where t.application_short_name = p_app_short_name
         and (t.data_source_code = p_request_code or p_request_code is null)
         and t.creation_date > '1-AUG-2015';
    v_error_message varchar2(500);
  begin
  
    for r in c loop
      print_output(r.data_source_code);
    
      -- xdo_lobs    
      delete from xdo_lobs l
       where l.lob_code in
             (select tb.template_code
                from xdo_templates_b tb
               where tb.application_short_name = p_app_short_name
                 and tb.data_source_code = r.data_source_code);
    
      -- xdo_templates_tl
      delete from xdo_templates_tl t
       where t.template_code in
             (select tb.template_code
                from xdo_templates_b tb
               where tb.application_short_name = p_app_short_name
                 and tb.data_source_code = r.data_source_code);
    
      -- xdo_templates_b
      delete from xdo_templates_b t
       where t.application_short_name = p_app_short_name
         and t.data_source_code = r.data_source_code;
    
      -- xdo_ds_definitions_tl
      delete from xdo_ds_definitions_tl t
       where t.application_short_name = p_app_short_name
         and t.data_source_code = r.data_source_code;
    
      -- xdo_ds_definitions_b
      delete from xdo_ds_definitions_b t
       where t.application_short_name = p_app_short_name
         and t.data_source_code = r.data_source_code;
    
      v_error_message := null;
    
      create_template(p_app_short_name => r.application_short_name,
                      p_program_name   => r.data_source_code,
                      p_error_message  => v_error_message);
    
      if v_error_message is not null then
        print_output(v_error_message);
      else
        print_output('  Success');
      end if;
    
    end loop;
  
  end;

  -- Create Program
  ------------------------------
  procedure create_program(p_application_id number,
                           p_program_name   varchar2,
                           p_error_message  out varchar2) is
    v_step           varchar2(100);
    v_count          number;
    v_src_program_id number;
    v_des_execute_id number;
    v_src_execute_id number;
    rec_exe          fnd_executables%rowtype;
    rec_cp           fnd_concurrent_programs%rowtype;
    v_flex_name      varchar2(100);
    v_fvs_error      varchar2(500);
    v_old_fvs_id     number;
    v_old_fvs_name   varchar2(100);
  
    rec_dfc fnd_descr_flex_column_usages%rowtype;
  
    cursor cdfc is
      select *
        from fnd_descr_flex_column_usages@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = '$SRS$.' || p_program_name;
  
  begin
    if p_application_id is null or
       p_program_name is null then
      p_error_message := 'Tham so khong duoc null';
    end if;
  
    v_step := 'Check exist';
    ------------------------------------
    select count(1)
      into v_count
      from fnd_concurrent_programs cp
     where cp.application_id = p_application_id
       and cp.concurrent_program_name = p_program_name;
  
    if v_count > 0 then
      p_error_message := 'Progam is existed';
      return;
    end if;
  
    v_step := 'Get Program information';
    -------------------------------------
    select *
      into rec_cp
      from fnd_concurrent_programs@dev2 cp
     where cp.application_id = p_application_id
       and cp.concurrent_program_name = p_program_name;
  
    ---------------------------
    v_step := 'Execute';
    ---------------------------
    v_src_execute_id := rec_cp.executable_id;
  
    begin
      select fed.executable_id
        into v_des_execute_id
        from fnd_executables@dev2 fes, fnd_executables fed
       where fes.executable_id = v_src_execute_id
         and fes.application_id = fed.application_id
         and fes.executable_name = fed.executable_name;
    exception
      when others then
        v_des_execute_id := -1;
    end;
  
    if v_des_execute_id = -1 then
      -- Chua co -> Tao moi
      select *
        into rec_exe
        from fnd_executables@dev2 fe
       where fe.executable_id = v_src_execute_id;
    
      select fnd_executables_s.nextval into v_des_execute_id from dual;
      rec_exe.executable_id := v_des_execute_id;
    
      -- Create Executeable
      rec_exe.created_by       := 0;
      rec_exe.last_updated_by  := 0;
      rec_exe.creation_date    := sysdate;
      rec_exe.last_update_date := sysdate;
      insert into fnd_executables values rec_exe;
    
      insert into fnd_executables_tl
        (application_id,
         executable_id,
         language,
         source_lang,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by,
         last_update_login,
         user_executable_name,
         description)
        select fel.application_id,
               rec_exe.executable_id,
               fel.language,
               fel.source_lang,
               sysdate,
               0,
               sysdate,
               0,
               fel.last_update_login,
               fel.user_executable_name,
               fel.description
          from fnd_executables_tl@dev2 fel
         where fel.executable_id = rec_cp.executable_id;
    
      print_output('Create executable successfully');
    
    end if;
  
    v_step := 'Program';
    -------------------------------------
    v_src_program_id             := rec_cp.concurrent_program_id;
    rec_cp.executable_id         := v_des_execute_id;
    rec_cp.concurrent_program_id := fnd_concurrent_programs_s.nextval;
  
    -- Create Program
    rec_cp.created_by       := 0;
    rec_cp.last_updated_by  := 0;
    rec_cp.creation_date    := sysdate;
    rec_cp.last_update_date := sysdate;
    insert into fnd_concurrent_programs values rec_cp;
  
    insert into fnd_concurrent_programs_tl
      (application_id,
       concurrent_program_id,
       language,
       user_concurrent_program_name,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by,
       last_update_login,
       description,
       source_lang)
      select cpl.application_id,
             rec_cp.concurrent_program_id,
             cpl.language,
             cpl.user_concurrent_program_name,
             sysdate,
             0,
             sysdate,
             0,
             cpl.last_update_login,
             cpl.description,
             cpl.source_lang
        from fnd_concurrent_programs_tl@dev2 cpl
       where cpl.application_id = p_application_id
         and cpl.concurrent_program_id = v_src_program_id;
  
    v_flex_name := '$SRS$.' || p_program_name;
  
    v_step := 'fnd_descriptive_flexs';
    -------------------------------------
  
    insert into fnd_descriptive_flexs
      (application_id,
       application_table_name,
       descriptive_flexfield_name,
       table_application_id,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       last_update_login,
       context_required_flag,
       context_column_name,
       context_user_override_flag,
       concatenated_segment_delimiter,
       freeze_flex_definition_flag,
       protected_flag,
       default_context_field_name,
       default_context_value,
       context_default_type,
       context_default_value,
       context_override_value_set_id,
       context_runtime_property_funct,
       concatenated_segs_view_name,
       context_synchronization_flag)
      select application_id,
             application_table_name,
             descriptive_flexfield_name,
             table_application_id,
             sysdate,
             0,
             sysdate,
             0,
             last_update_login,
             context_required_flag,
             context_column_name,
             context_user_override_flag,
             concatenated_segment_delimiter,
             freeze_flex_definition_flag,
             protected_flag,
             default_context_field_name,
             default_context_value,
             context_default_type,
             context_default_value,
             context_override_value_set_id,
             context_runtime_property_funct,
             concatenated_segs_view_name,
             context_synchronization_flag
        from fnd_descriptive_flexs@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = v_flex_name;
  
    insert into fnd_descriptive_flexs_tl
      (application_id,
       descriptive_flexfield_name,
       language,
       title,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       last_update_login,
       form_context_prompt,
       source_lang,
       description)
      select application_id,
             descriptive_flexfield_name,
             language,
             title,
             sysdate,
             0,
             sysdate,
             0,
             last_update_login,
             form_context_prompt,
             source_lang,
             description
        from fnd_descriptive_flexs_tl@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = v_flex_name;
  
    v_step := 'fnd_descr_flex_contexts';
    -------------------------------------
    insert into fnd_descr_flex_contexts
      (application_id,
       descriptive_flexfield_name,
       descriptive_flex_context_code,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       last_update_login,
       enabled_flag,
       global_flag)
      select application_id,
             descriptive_flexfield_name,
             descriptive_flex_context_code,
             sysdate,
             0,
             sysdate,
             0,
             last_update_login,
             enabled_flag,
             global_flag
        from fnd_descr_flex_contexts@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = v_flex_name;
  
    insert into fnd_descr_flex_contexts_tl
      (application_id,
       descriptive_flexfield_name,
       descriptive_flex_context_code,
       language,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       last_update_login,
       description,
       descriptive_flex_context_name,
       source_lang)
      select application_id,
             descriptive_flexfield_name,
             descriptive_flex_context_code,
             language,
             sysdate,
             0,
             sysdate,
             0,
             last_update_login,
             description,
             descriptive_flex_context_name,
             source_lang
        from fnd_descr_flex_contexts_tl@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = v_flex_name;
  
    v_step := 'fnd_descr_flex_column_usages';
  
    open cdfc;
  
    loop
    
      fetch cdfc
        into rec_dfc;
    
      exit when cdfc%notfound;
    
      v_old_fvs_id := rec_dfc.flex_value_set_id;
    
      -- Sync fvs
      select fvs.flex_value_set_name
        into v_old_fvs_name
        from fnd_flex_value_sets@dev2 fvs
       where fvs.flex_value_set_id = v_old_fvs_id;
    
      v_fvs_error := null;
      sync_fvs(p_fvs_name      => v_old_fvs_name,
               p_error_message => v_fvs_error);
    
      if v_fvs_error is not null then
        print_output(v_fvs_error);
      end if;
    
      begin
        select fd.flex_value_set_id
          into rec_dfc.flex_value_set_id
          from fnd_flex_value_sets@dev2 fs, fnd_flex_value_sets fd
         where fs.flex_value_set_id = rec_dfc.flex_value_set_id
           and fs.flex_value_set_name = fd.flex_value_set_name;
      exception
        when others then
          rec_dfc.flex_value_set_id := 103585; -- 30 Characters
          print_output('Not existed flex value set');
      end;
    
      rec_dfc.created_by       := 0;
      rec_dfc.last_updated_by  := 0;
      rec_dfc.creation_date    := sysdate;
      rec_dfc.last_update_date := sysdate;
      insert into fnd_descr_flex_column_usages values rec_dfc;
    
    end loop;
  
    close cdfc;
  
    insert into fnd_descr_flex_col_usage_tl
      (application_id,
       descriptive_flexfield_name,
       descriptive_flex_context_code,
       application_column_name,
       language,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       last_update_login,
       form_left_prompt,
       form_above_prompt,
       description,
       source_lang)
      select application_id,
             descriptive_flexfield_name,
             descriptive_flex_context_code,
             application_column_name,
             language,
             sysdate,
             0,
             sysdate,
             0,
             last_update_login,
             form_left_prompt,
             form_above_prompt,
             description,
             source_lang
        from fnd_descr_flex_col_usage_tl@dev2
       where application_id = p_application_id
         and descriptive_flexfield_name = v_flex_name;
  
    print_output('Create program successfully');
  
  exception
    when others then
      p_error_message := p_program_name || '\create_program\' || v_step || '\' ||
                         sqlerrm;
  end;

  -- Synchronize Flex Value Set
  --------------------------------
  procedure sync_fvs(p_fvs_name varchar2, p_error_message out varchar2) is
    v_count number;
  begin
  
    -- Check exists
    select count(1)
      into v_count
      from fnd_flex_value_sets fvs
     where fvs.flex_value_set_name = p_fvs_name;
  
    if v_count = 0 then
      -- Neu khong ton tai -> Copy
      create_fvs(p_src_fvs_name  => p_fvs_name,
                 p_error_message => p_error_message);
    
    else
      -- Neu da ton tai -> Update
      update_fvs(p_src_fvs_name  => p_fvs_name,
                 p_error_message => p_error_message);
    
    end if;
  
  end;

  -- Create Flex Value Set
  --------------------------------
  procedure create_fvs(p_src_fvs_name  varchar2,
                       p_error_message out varchar2) is
    v_step           varchar2(50);
    v_old_src_fvs_id number;
    rec_src_fvs      fnd_flex_value_sets%rowtype;
    rec_src_fvt      fnd_flex_validation_tables%rowtype;
  begin
    v_step := 'Get source flex value set';
    select t.*
      into rec_src_fvs
      from fnd_flex_value_sets@dev2 t
     where t.flex_value_set_name = p_src_fvs_name;
  
    v_old_src_fvs_id := rec_src_fvs.flex_value_set_id;
  
    rec_src_fvs.flex_value_set_id := fnd_flex_value_sets_s.nextval;
    rec_src_fvs.created_by        := 0;
    rec_src_fvs.last_updated_by   := 0;
    rec_src_fvs.creation_date     := sysdate;
    rec_src_fvs.last_update_date  := sysdate;
    insert into fnd_flex_value_sets values rec_src_fvs;
  
    if rec_src_fvs.validation_type = 'F' then
      v_step := 'Get source flex validation table';
      select t.*
        into rec_src_fvt
        from fnd_flex_validation_tables@dev2 t
       where t.flex_value_set_id = v_old_src_fvs_id;
    
      rec_src_fvt.flex_value_set_id := rec_src_fvs.flex_value_set_id;
    
      rec_src_fvt.created_by       := 0;
      rec_src_fvt.last_updated_by  := 0;
      rec_src_fvt.creation_date    := sysdate;
      rec_src_fvt.last_update_date := sysdate;
      insert into fnd_flex_validation_tables values rec_src_fvt;
    
    end if;
  
    print_output('Create Flex Value Set successfully ' || p_src_fvs_name);
  
  exception
    when others then
      p_error_message := 'copy_fvs\' || v_step || ':' || sqlerrm;
  end;

  -- Update Flex Value Set
  ------------------------------
  procedure update_fvs(p_src_fvs_name  varchar2,
                       p_error_message out varchar2) is
    rec_fvt      fnd_flex_validation_tables%rowtype;
    v_count      number;
    v_des_fvs_id number;
  begin
    select count(1)
      into v_count
      from fnd_flex_value_sets fvs
     where fvs.flex_value_set_name = p_src_fvs_name
       and fvs.validation_type = 'F';
  
    if v_count = 0 then
      return;
    end if;
  
    for r in (select vss.flex_value_set_id,
                     vss.flex_value_set_name,
                     vss.maximum_size,
                     vss.validation_type,
                     vts.application_table_name,
                     vts.value_column_name,
                     vts.value_column_type,
                     vts.value_column_size,
                     vts.id_column_name,
                     vts.id_column_type,
                     vts.id_column_size,
                     vts.meaning_column_name,
                     vts.meaning_column_type,
                     vts.meaning_column_size,
                     vts.additional_where_clause
                from fnd_flex_validation_tables@dev2 vts,
                     fnd_flex_value_sets@dev2        vss
               where vts.flex_value_set_id = vss.flex_value_set_id
                 and vss.flex_value_set_name = p_src_fvs_name) loop
    
      -- Check maximum_size
      select count(1)
        into v_count
        from fnd_flex_value_sets t
       where t.flex_value_set_name = r.flex_value_set_name
         and t.validation_type = 'F'
         and t.maximum_size = r.maximum_size;
    
      if v_count = 0 then
      
        update fnd_flex_value_sets t
           set t.maximum_size     = r.maximum_size,
               t.last_updated_by  = 0,
               t.last_update_date = sysdate
         where t.flex_value_set_name = r.flex_value_set_name
           and t.validation_type = 'F';
      
      end if;
    
      -- Get fvs id
      select vss.flex_value_set_id
        into v_des_fvs_id
        from fnd_flex_value_sets vss
       where vss.validation_type = 'F'
         and vss.flex_value_set_name = p_src_fvs_name;
    
      select count(1)
        into v_count
        from fnd_flex_validation_tables vts, fnd_flex_value_sets vss
       where vts.flex_value_set_id = vss.flex_value_set_id
         and vss.validation_type = 'F'
         and vss.flex_value_set_name = p_src_fvs_name;
    
      -- Truong hop moi dang ky -> Chua co thong tin validation table
      if v_count = 0 then
        -- Khong co lay tu UAT insert
        select fvt.*
          into rec_fvt
          from fnd_flex_validation_tables@dev2 fvt
         where fvt.flex_value_set_id = r.flex_value_set_id;
      
        rec_fvt.flex_value_set_id := v_des_fvs_id;
        rec_fvt.created_by        := 0;
        rec_fvt.last_updated_by   := 0;
        rec_fvt.creation_date     := sysdate;
        rec_fvt.last_update_date  := sysdate;
        insert into fnd_flex_validation_tables values rec_fvt;
      
      else
        -- Neu co -> Check & Update
        select vts.*
          into rec_fvt
          from fnd_flex_validation_tables vts, fnd_flex_value_sets vss
         where vts.flex_value_set_id = vss.flex_value_set_id
           and vss.validation_type = 'F'
           and vss.flex_value_set_name = p_src_fvs_name;
      
        if (rec_fvt.application_table_name <> r.application_table_name) or
           (nvl(rec_fvt.value_column_name, 'X') <>
           nvl(r.value_column_name, 'X')) or
           (nvl(rec_fvt.value_column_type, 'X') <>
           nvl(r.value_column_type, 'X')) or
           (nvl(rec_fvt.value_column_size, -9999) <>
           nvl(r.value_column_size, -9999)) or
           (nvl(rec_fvt.id_column_name, 'X') <> nvl(r.id_column_name, 'X')) or
           (nvl(rec_fvt.id_column_type, 'X') <> nvl(r.id_column_type, 'X')) or
           (nvl(rec_fvt.id_column_size, -9999) <>
           nvl(r.id_column_size, -9999)) or
           (nvl(rec_fvt.meaning_column_name, 'X') <>
           nvl(r.meaning_column_name, 'X')) or
           (nvl(rec_fvt.meaning_column_type, 'X') <>
           nvl(r.meaning_column_type, 'X')) or
           (nvl(rec_fvt.meaning_column_size, -9999) <>
           nvl(r.meaning_column_size, -9999)) or
           nvl(rec_fvt.additional_where_clause, 'X') <>
           nvl(r.additional_where_clause, 'X') then
        
          print_output('Update Flex Validation Table ' || p_src_fvs_name);
        
          update fnd_flex_validation_tables t
             set t.application_table_name  = r.application_table_name,
                 t.value_column_name       = r.value_column_name,
                 t.value_column_type       = r.value_column_type,
                 t.value_column_size       = r.value_column_size,
                 t.id_column_name          = r.id_column_name,
                 t.id_column_size          = r.id_column_size,
                 t.id_column_type          = r.id_column_type,
                 t.meaning_column_name     = r.meaning_column_name,
                 t.meaning_column_size     = r.meaning_column_size,
                 t.meaning_column_type     = r.meaning_column_type,
                 t.additional_where_clause = r.additional_where_clause,
                 t.last_update_date        = sysdate,
                 t.last_updated_by         = 0
           where t.flex_value_set_id = rec_fvt.flex_value_set_id;
        
        end if;
      
      end if;
    
    end loop;
  
  exception
    when others then
      p_error_message := p_src_fvs_name || '\update_fvs\' || sqlerrm;
  end;

  -- Create Template
  ------------------------------
  procedure create_template(p_app_short_name varchar2,
                            p_program_name   varchar2,
                            p_error_message  out varchar2) is
    v_step      varchar2(100);
    v_count     number;
    v_lob_error varchar2(500);
  
    cursor c is
      select *
        from xdo_templates_b@dev2 xt
       where xt.ds_app_short_name = p_app_short_name
         and xt.data_source_code = p_program_name;
  
    rec_templates_b xdo_templates_b%rowtype;
  
  begin
  
    v_step := 'xdo_ds_definitions_b';
    ---------------------------------------
    select count(1)
      into v_count
      from xdo_ds_definitions_b t
     where t.application_short_name = p_app_short_name
       and t.data_source_code = p_program_name;
  
    if v_count > 0 then
      p_error_message := 'Template da ton tai';
      return;
    end if;
  
    insert into xdo_ds_definitions_b
      (application_short_name,
       data_source_code,
       data_source_status,
       start_date,
       end_date,
       object_version_number,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       last_update_login)
      select application_short_name,
             data_source_code,
             data_source_status,
             start_date,
             end_date,
             object_version_number,
             0,
             sysdate,
             0,
             sysdate,
             last_update_login
        from xdo_ds_definitions_b@dev2
       where application_short_name = p_app_short_name
         and data_source_code = p_program_name;
  
    insert into xdo_ds_definitions_tl
      (application_short_name,
       data_source_code,
       language,
       data_source_name,
       description,
       source_lang,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date,
       last_update_login)
      select application_short_name,
             data_source_code,
             language,
             data_source_name,
             description,
             source_lang,
             0,
             sysdate,
             0,
             sysdate,
             last_update_login
        from xdo_ds_definitions_tl@dev2
       where application_short_name = p_app_short_name
         and data_source_code = p_program_name;
  
    v_step := 'rec_templates_b';
    ---------------------------------------
    open c;
  
    loop
    
      fetch c
        into rec_templates_b;
    
      exit when c%notfound;
    
      rec_templates_b.template_id := xdo_templates_seq.nextval;
    
      rec_templates_b.created_by      := 0;
      rec_templates_b.last_updated_by := 0;
      insert into xdo_templates_b values rec_templates_b;
    
      insert into xdo_templates_tl
        (application_short_name,
         template_code,
         language,
         template_name,
         description,
         source_lang,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         last_update_login)
        select application_short_name,
               template_code,
               language,
               template_name,
               description,
               source_lang,
               0,
               sysdate,
               0,
               sysdate,
               last_update_login
          from xdo_templates_tl@dev2
         where application_short_name =
               rec_templates_b.application_short_name
           and template_code = rec_templates_b.template_code;
    
      commit;
    
      create_lob(p_app_short_name => rec_templates_b.application_short_name,
                 p_template_code  => rec_templates_b.template_code,
                 p_error_message  => v_lob_error);
    
      -- Truong hop create lob loi -> bo qua
      if v_lob_error is not null then
        print_output(v_lob_error);
        v_lob_error := null;
      end if;
    
    end loop;
  
    close c;
  
  exception
    when others then
      p_error_message := p_program_name || '\create_template\' || v_step || '\' ||
                         sqlerrm;
  end;

  -- Create XDO Lob
  -----------------------------
  procedure create_lob(p_app_short_name varchar2,
                       p_template_code  varchar2,
                       p_error_message  out varchar2) is
    v_blob blob;
  begin
  
    fpt_lob_pkg.split_xdolob_all@dev2(p_app_short_name, p_template_code);
  
    for r in (select xl.lob_type,
                     xl.application_short_name,
                     xl.lob_code,
                     xl.language,
                     xl.territory,
                     xl.file_name,
                     xl.xdo_file_type,
                     xl.file_status,
                     xl.file_content_type,
                     xl.program,
                     xl.program_tag,
                     xl.created_by,
                     xl.creation_date,
                     xl.last_updated_by,
                     xl.last_update_date,
                     xl.last_update_login,
                     xl.trans_complete
                from xdo_lobs@dev2 xl
               where xl.application_short_name = p_app_short_name
                 and xl.lob_code = p_template_code) loop
    
      /*v_blob := null;*/
    
      build_xdolob(p_app_short_name => r.application_short_name,
                   p_lob_type       => r.lob_type,
                   p_lob_code       => r.lob_code,
                   p_language       => r.language,
                   p_territory      => r.territory,
                   p_blob           => v_blob,
                   p_error_message  => p_error_message);
    
      if p_error_message is not null then
        rollback;
        return;
      end if;
    
      insert into xdo_lobs
        (lob_type,
         application_short_name,
         lob_code,
         language,
         territory,
         file_name,
         xdo_file_type,
         file_status,
         file_content_type,
         file_data,
         program,
         program_tag,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date,
         last_update_login,
         trans_complete)
      values
        (r.lob_type,
         r.application_short_name,
         r.lob_code,
         r.language,
         r.territory,
         r.file_name,
         r.xdo_file_type,
         r.file_status,
         r.file_content_type,
         v_blob,
         r.program,
         r.program_tag,
         0,
         sysdate,
         0,
         sysdate,
         r.last_update_login,
         r.trans_complete);
    
    end loop;
  
    commit;
  
  exception
    when others then
      rollback;
      p_error_message := p_template_code || '\create_lob\' || sqlerrm;
    
  end;

  procedure build_xdolob(p_app_short_name varchar2,
                         p_lob_type       varchar2,
                         p_lob_code       varchar2,
                         p_language       varchar2,
                         p_territory      varchar2,
                         p_blob           out blob,
                         p_error_message  out varchar2) is
    cursor c is
      select split_content
        from fpt_split_data@dev2
       where object_code = 'XDO_LOB'
         and lob_type = p_lob_type
         and lob_code = p_lob_code
         and attribute1 = p_language
         and attribute2 = p_territory
         and attribute3 = p_app_short_name
       order by split_num;
  
    v_clob clob;
  
  begin
  
    for r in c loop
      v_clob := v_clob || to_clob(r.split_content);
    end loop;
  
    p_blob := clob_to_blob(v_clob);
  
  exception
    when others then
      rollback;
      p_error_message := p_lob_code || '\build_lob\' || sqlerrm;
  end;

  /* Convert Blob to Clob
  */
  function blob_to_clob(blob_in in blob) return clob as
    v_clob    clob;
    v_varchar varchar2(32767);
    v_start   pls_integer := 1;
    v_buffer  pls_integer := 32767;
  begin
    dbms_lob.createtemporary(v_clob, true);
  
    for i in 1 .. ceil(dbms_lob.getlength(blob_in) / v_buffer) loop
    
      v_varchar := utl_raw.cast_to_varchar2(dbms_lob.substr(blob_in,
                                                            v_buffer,
                                                            v_start));
    
      dbms_lob.writeappend(v_clob, length(v_varchar), v_varchar);
    
      v_start := v_start + v_buffer;
    
    end loop;
  
    return v_clob;
  
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

  --
  ------------------------------
  procedure print_output(p_text varchar2) is
  begin
    --fnd_file.put_line(fnd_file.output, p_text);
    dbms_output.put_line(p_text);
  end;

  /* Put line
  */
  procedure put_line(p_message varchar2) is
  begin
    print_output(p_message);
  end;

  -- Delete Program
  ----------------------------
  procedure delete_program(p_application_id number,
                           p_request_code   varchar2,
                           p_error_message  out varchar2) is
    v_srs_request_code varchar2(100) := '$SRS$.' || p_request_code;
    v_app_short_name   varchar2(100);
  begin
    select a.application_short_name
      into v_app_short_name
      from fnd_application a
     where a.application_id = p_application_id;
  
    -- Request group unit
    delete from fnd_request_group_units
     where request_unit_id in
           (select concurrent_program_id
              from fnd_concurrent_programs t
             where t.application_id = p_application_id
               and t.concurrent_program_name = p_request_code);
  
    -- xdo_lobs
    delete from xdo_lobs l
     where l.lob_code in
           (select tb.template_code
              from xdo_templates_b tb
             where tb.application_id = p_application_id
               and tb.data_source_code = p_request_code);
  
    -- xdo_templates_b
    delete from xdo_templates_tl t
     where t.template_code in
           (select tb.template_code
              from xdo_templates_b tb
             where tb.application_id = p_application_id
               and tb.data_source_code = p_request_code);
  
    delete from xdo_templates_b t
     where t.application_id = p_application_id
       and t.data_source_code = p_request_code;
  
    -- xdo_ds_definitions_b
    delete from xdo_ds_definitions_b t
     where t.application_short_name = v_app_short_name
       and t.data_source_code = p_request_code;
  
    delete from xdo_ds_definitions_tl t
     where t.application_short_name = v_app_short_name
       and t.data_source_code = p_request_code;
  
    -- fnd_descriptive_flexs
    delete from fnd_descriptive_flexs t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descriptive_flexs_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_descr_flex_contexts
    delete from fnd_descr_flex_contexts t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descr_flex_contexts_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_descr_flex_column_usages
    delete from fnd_descr_flex_column_usages t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descr_flex_col_usage_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_concurrent_programs
    delete from fnd_concurrent_programs_tl t
     where t.concurrent_program_id in
           (select t.concurrent_program_id
              from fnd_concurrent_programs t
             where t.concurrent_program_name = p_request_code
               and t.application_id = p_application_id);
  
    delete from fnd_concurrent_programs t
     where t.concurrent_program_name = p_request_code
       and t.application_id = p_application_id;
  
  exception
    when others then
      p_error_message := 'delete_program\' || sqlerrm;
  end;

  -- Delete Request
  ----------------------------
  procedure delete_request(p_application_id number,
                           p_request_code   varchar2) is
    v_srs_request_code varchar2(100) := '$SRS$.' || p_request_code;
    v_app_short_name   varchar2(100);
  begin
    select a.application_short_name
      into v_app_short_name
      from fnd_application a
     where a.application_id = p_application_id;
  
    -- xdo_lobs
    delete from xdo_lobs l
     where l.lob_code in
           (select tb.template_code
              from xdo_templates_b tb
             where tb.application_id = p_application_id
               and tb.data_source_code = p_request_code);
  
    -- xdo_templates_b
    delete from xdo_templates_tl t
     where t.template_code in
           (select tb.template_code
              from xdo_templates_b tb
             where tb.application_id = p_application_id
               and tb.data_source_code = p_request_code);
  
    delete from xdo_templates_b t
     where t.application_id = p_application_id
       and t.data_source_code = p_request_code;
  
    -- xdo_ds_definitions_b
    delete from xdo_ds_definitions_b t
     where t.application_short_name = v_app_short_name
       and t.data_source_code = p_request_code;
  
    delete from xdo_ds_definitions_tl t
     where t.application_short_name = v_app_short_name
       and t.data_source_code = p_request_code;
  
    -- Execute
    delete from fnd_executables_tl t
     where t.executable_id in
           (select t.executable_id
              from fnd_concurrent_programs t
             where t.concurrent_program_name = p_request_code
               and t.application_id = p_application_id);
  
    delete from fnd_executables t
     where t.executable_id in
           (select t.executable_id
              from fnd_concurrent_programs t
             where t.concurrent_program_name = p_request_code
               and t.application_id = p_application_id);
  
    -- fnd_descriptive_flexs
    delete from fnd_descriptive_flexs t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descriptive_flexs_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_descr_flex_contexts
    delete from fnd_descr_flex_contexts t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descr_flex_contexts_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_descr_flex_column_usages
    delete from fnd_descr_flex_column_usages t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    delete from fnd_descr_flex_col_usage_tl t
     where t.descriptive_flexfield_name = v_srs_request_code
       and t.application_id = p_application_id;
  
    -- fnd_concurrent_programs
    delete from fnd_concurrent_programs_tl t
     where t.concurrent_program_id in
           (select t.concurrent_program_id
              from fnd_concurrent_programs t
             where t.concurrent_program_name = p_request_code
               and t.application_id = p_application_id);
  
    delete from fnd_concurrent_programs t
     where t.concurrent_program_name = p_request_code
       and t.application_id = p_application_id;
  
  end;

end fpt_reqtransfer_pkg;
/
