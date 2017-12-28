create or replace package fpt_request_imp_pkg is
  type t_rec_field is record(
    field_name  varchar2(50),
    field_value varchar2(4000));

  type t_tbl_field is table of t_rec_field index by pls_integer;

  procedure main;
  procedure insert_data(p_clob              clob,
                        p_source_table_name varchar2,
                        p_dest_table_name   varchar2);
  procedure create_table(p_source_table_name varchar2,
                         p_dest_table_name   out varchar2);
  function blob_to_clob(blob_in in blob) return clob;
  function decode_sc(p_string varchar2) return varchar2;

end fpt_request_imp_pkg;
/
create or replace package body fpt_request_imp_pkg is

  procedure main is
    v_dest_table_name varchar2(50);
    v_clob            clob;
  begin
    select t.data_clob into v_clob from fpt_clob_data t;
  
    -- Loop Table Name
    for rt in (select value  (e).getrootelement()   as table_name,
                      extract(value(e), '/').getclobval() as table_data
                 from table(xmlsequence(extract(xmltype(v_clob), '/DATA/*'))) e) loop
    
      --insert into fpt_clob_data2 values (rt.table_name, rt.xml);
    
      create_table(rt.table_name, v_dest_table_name);
    
      dbms_output.put_line('select * from ' || v_dest_table_name || ';');
    
      insert_data(p_clob              => rt.table_data,
                  p_source_table_name => rt.table_name,
                  p_dest_table_name   => v_dest_table_name);
    
    end loop;
  
    commit;
  
  end;

  /*
  -- Thu tuc Insert du lieu vao bang trung gian
  */
  procedure insert_data(p_clob              clob,
                        p_source_table_name varchar2,
                        p_dest_table_name   varchar2) is
    v_row         xmltype;
    v_count       number := 0;
    v_path_row    varchar2(200);
    v_stmt        varchar2(4000);
    v_query_field varchar2(4000);
    v_query_value varchar2(4000);
  
    v_table_field t_tbl_field;
    v_index       number;
    v_cursor      number;
    v_dummy       number;
    v_date_value  date;
  begin
    select count(1)
      into v_count
      from table(xmlsequence(extract(xmltype(p_clob),
                                     '/' || p_source_table_name || '/ROW')));
  
    --dbms_output.put_line('Row Count: ' || v_count);
  
    for i in 1 .. v_count loop
      begin
        v_path_row := '/' || p_source_table_name || '/ROW[' || i || ']';
        v_row      := xmltype(p_clob).extract(v_path_row);
      
        --dbms_output.put_line(v_row.getstringval());
      
        v_query_field := null;
        v_query_value := null;
        v_index       := 0;
      
        for rc in (select xmltype(extract(value(e), '/').getstringval())
                          .getrootelement() as field_name,
                          extractvalue(value(e), '/*') as field_value
                     from table(xmlsequence(extract(v_row, '/ROW/*'))) e) loop
        
          -- Gan gia tri vao table variable
          v_index := v_index + 1;
          v_table_field(v_index).field_name := rc.field_name;
          v_table_field(v_index).field_value := rc.field_value;
        
          -- Build field & bind variable list
          v_query_field := v_query_field || ',' || rc.field_name;
          v_query_value := v_query_value || ',:' || rc.field_name;
        
        end loop;
      
        -- Build Insert Statement
        v_stmt := 'insert into ' || p_dest_table_name || '(' ||
                  substr(v_query_field, 2) || ') values(' ||
                  substr(v_query_value, 2) || ')';
      
        -- Open Cursor & Parse Statement
        v_cursor := dbms_sql.open_cursor;
        dbms_sql.parse(v_cursor, v_stmt, dbms_sql.native);
      
        -- Loop field to bind variables
        for j in 1 .. v_table_field.count loop
          if instr(v_table_field(j).field_value, '$D$') > 0 then
            v_date_value := to_date(replace(v_table_field(j).field_value, '$D$'),
                                    'rrmmddhh24miss');
            dbms_sql.bind_variable(v_cursor,
                                   ':' || v_table_field(j).field_name,
                                   v_date_value);
          else
            dbms_sql.bind_variable(v_cursor,
                                   ':' || v_table_field(j).field_name,
                                   decode_sc(v_table_field(j).field_value));
          end if;
        
        end loop;
      
        v_dummy := dbms_sql.execute(v_cursor);
      
        -- Release
        dbms_sql.close_cursor(v_cursor);
        v_table_field.delete;
      
      exception
        when others then
          dbms_output.put_line('Error!!! ' || sqlerrm || chr(10) || v_stmt);
          for j in 1 .. v_table_field.count loop
            dbms_output.put_line(v_table_field(j).field_name || ': ' || v_table_field(j)
                                 .field_value);
          end loop;
          dbms_sql.close_cursor(v_cursor);
          v_table_field.delete;
      end;
    
    end loop;
  
  end;

  procedure create_table(p_source_table_name varchar2,
                         p_dest_table_name   out varchar2) is
    --v_dest_table_name varchar2(50);
    v_query varchar2(2000);
    v_count number;
  begin
    p_dest_table_name := replace(replace(upper(p_source_table_name),
                                         'FND_',
                                         'FPT_'),
                                 'XDO_',
                                 'FPT_');
  
    select count(1)
      into v_count
      from all_tables t
     where t.owner = 'APPS'
       and t.table_name = p_dest_table_name;
  
    if v_count > 0 then
      execute immediate 'delete from ' || p_dest_table_name;
      return;
    end if;
  
    if p_source_table_name = 'FND_FLEX_VALIDATION_TABLES' then
      v_query := 'create table FPT_FLEX_VALIDATION_TABLES
          (
            flex_value_set_id              NUMBER(10) not null,
            last_update_date               DATE not null,
            last_updated_by                NUMBER(15) not null,
            creation_date                  DATE not null,
            created_by                     NUMBER(15) not null,
            application_table_name         VARCHAR2(240) not null,
            last_update_login              NUMBER(15),
            value_column_name              VARCHAR2(240) not null,
            value_column_type              VARCHAR2(1) not null,
            value_column_size              NUMBER(3) not null,
            compiled_attribute_column_name VARCHAR2(240) not null,
            enabled_column_name            VARCHAR2(240) not null,
            hierarchy_level_column_name    VARCHAR2(240) not null,
            start_date_column_name         VARCHAR2(240) not null,
            end_date_column_name           VARCHAR2(240) not null,
            summary_allowed_flag           VARCHAR2(1) not null,
            summary_column_name            VARCHAR2(240) not null,
            id_column_name                 VARCHAR2(240),
            id_column_size                 NUMBER(3),
            id_column_type                 VARCHAR2(1),
            meaning_column_name            VARCHAR2(240),
            meaning_column_size            NUMBER(3),
            meaning_column_type            VARCHAR2(1),
            table_application_id           NUMBER(10),
            additional_quickpick_columns   VARCHAR2(240),
            additional_where_clause        LONG
          )';
    else
    
      v_query := 'create table ' || p_dest_table_name || ' as select * from ' ||
                 upper(p_source_table_name) || ' where 1=2';
    
    end if;
  
    execute immediate v_query;
  
  exception
    when others then
      dbms_output.put_line('FPT_REQUEST_IMP_PKG.CREATE_TABLE ' ||
                           p_dest_table_name || chr(10) || sqlerrm);
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

  /* Decode Special Characters
  &amp;  decode to (&) 
  &quot; decode to (") 
  &apos; decode to (') 
  &lt;   decode to (<) 
  &gt;   decode to (>)
  ----------------------------------*/
  function decode_sc(p_string varchar2) return varchar2 is
  begin
    return(replace(replace(replace(replace(replace(p_string, '&amp;', '&'),
                                           '&quot;',
                                           '"'),
                                   '&apos;',
                                   ''''),
                           '&lt;',
                           '<'),
                   '&gt;',
                   '>'));
  end;

  -- Code nay su dung tren form
  /*
    procedure COMPILE_DESC_FLEXS is
    numrows   number;       -- Number of rows in flex_list
  --  app_id    varchar2(10); -- Descriptive flexfield application ID
  --  dfn       varchar2(40); -- Descriptive flexfield name
   
    begin
      numrows := Get_Group_Row_Count(flex_list);
  
      for i in 1 .. numrows loop
        :world.app_id := get_group_number_cell(flex_app_id, i);
        :world.dfn := get_group_char_cell(flex_name, i);
  
        begin  -- delete previous compiled info for this flex
          delete from fnd_compiled_descriptive_flexs
            where application_id = :world.app_id 
              and descriptive_flexfield_name = :world.dfn;
        exception
          when NO_DATA_FOUND then
            null;
        end;
  
        user_exit('FND COMPDESC :world.app_id :world.dfn');
        if (not FORM_SUCCESS) then
          fnd_message.set_name('FND', 
                             'FLEX-UNABLE TO COMPILE DESC');
          fnd_message.error;
        end if;
      end loop;
  
      if (numrows > 0) then
        -- Remove all rows from list 
        delete_group_row(flex_list, ALL_ROWS);
      end if;
    end COMPILE_DESC_FLEXS;
    */
  /*
  Request:
  FDFCMPD - Compile Descriptive Flexfields
  */
  procedure compile_descr_flex is
  
    type app_id_tab is table of fnd_descriptive_flexs.application_id%type index by binary_integer;
  
    type desc_flex_name_tab is table of fnd_descriptive_flexs.descriptive_flexfield_name%type index by binary_integer;
  
    type ctx_sync_flag_tab is table of fnd_descriptive_flexs.context_synchronization_flag%type index by binary_integer;
  
    l_app_id         app_id_tab;
    l_desc_flex_name desc_flex_name_tab;
    l_ctx_sync_flag  ctx_sync_flag_tab;
  
    l_compiler_ver    number;
    l_user_id         fnd_user.user_id%type;
    l_user_name       fnd_user.user_name%type;
    l_resp_appl_id    fnd_responsibility.application_id%type;
    l_resp_key        fnd_responsibility.responsibility_key%type;
    l_resp_id         fnd_responsibility.responsibility_id%type;
    l_appl_short_name fnd_application.application_short_name%type;
    l_conc_prog_name  varchar2(30);
    l_arg1_val        varchar2(30);
    l_request_id      number;
  
  begin
  
    l_compiler_ver := 11510;
  
    select application_id,
           descriptive_flexfield_name,
           context_synchronization_flag
      bulk collect
      into l_app_id, l_desc_flex_name, l_ctx_sync_flag
      from fnd_descriptive_flexs
     where context_synchronization_flag = 'Y';
  
    if nvl(l_desc_flex_name.count, 0) > 0 then
    
      for i in 1 .. l_desc_flex_name.count loop
      
        l_ctx_sync_flag(i) := 'N';
      
      end loop;
    
      forall i in 1 .. l_desc_flex_name.count
        update fnd_descriptive_flexs
           set context_synchronization_flag = l_ctx_sync_flag(i)
         where application_id = l_app_id(i)
           and descriptive_flexfield_name = l_desc_flex_name(i);
    
      forall i in 1 .. l_desc_flex_name.count
        delete from fnd_compiled_descriptive_flexs
         where application_id = l_app_id(i)
           and descriptive_flexfield_name = l_desc_flex_name(i)
           and compiler_version_num = l_compiler_ver;
    
      commit;
    
      l_appl_short_name := 'FND';
      l_user_name       := 'SYSADMIN';
      l_resp_key        := 'SYSTEM_ADMINISTRATOR';
    
      begin
      
        select u.user_id
          into l_user_id
          from fnd_user u
         where u.user_name = l_user_name;
      
        select r.application_id, r.responsibility_id
          into l_resp_appl_id, l_resp_id
          from fnd_application a, fnd_responsibility r
         where r.application_id = a.application_id
           and a.application_short_name = l_appl_short_name
           and r.responsibility_key = l_resp_key;
      
        fnd_global.apps_initialize(user_id      => l_user_id,
                                   resp_id      => l_resp_id,
                                   resp_appl_id => l_resp_appl_id);
      
        l_conc_prog_name := 'FDFCMPN';
        l_arg1_val       := 'N';
      
        fnd_profile.put('CONC_PRIORITY', 1);
      
        l_request_id := fnd_request.submit_request(application => l_appl_short_name,
                                                   program     => l_conc_prog_name,
                                                   start_time  => null,
                                                   sub_request => false,
                                                   argument1   => l_arg1_val);
      
        if l_request_id = 0 then
          null;
        end if;
      
      exception
        when others then
          -- This is not a severe error, suppress exception
          -- if the compilation request cannot be submitted.
          -- Flex can compile on-the-fly
          null;
      end;
    
    end if;
  
  end;

end fpt_request_imp_pkg;
/
