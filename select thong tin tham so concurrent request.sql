--Concurrent Program
select t.user_concurrent_program_name,
       t.concurrent_program_name,
       fat.application_name,
       t.description,
       fe.executable_name,
       t.output_file_type
  from fnd_concurrent_programs_vl t,
       fnd_application            app,
       fnd_application_tl         fat,
       fnd_executables            fe
 where app.application_id = t.application_id
   and app.application_id = fat.application_id
   and fe.executable_id = t.executable_id
   and upper(concurrent_program_name) like 'EVN_GL_059_BK_HNEVN';
-----Select tham so
select v.column_seq_num,
       v.end_user_column_name,
       v.enabled_flag,
       fl.flex_value_set_name          valueset,
       b.default_type                  default_type,
       b.default_value                 default_value,
       b.required_flag                 required,
       b.security_enabled_flag                  enable_security,
       v.display_flag,
       v.display_size,
       v.concatenation_description_len,
       v.form_left_prompt,
       v.srw_param
  from fnd_descr_flex_col_usage_vl  v,
       fnd_descr_flex_column_usages b,
       apps.fnd_flex_value_sets     fl
 where b.application_id = v.application_id
   and b.descriptive_flexfield_name = v.descriptive_flexfield_name
   and b.descriptive_flex_context_code = v.descriptive_flex_context_code
   and b.application_column_name = v.application_column_name
   and fl.flex_value_set_id = v.flex_value_set_id
      --
--   and (v.application_id = '222')
   and (v.descriptive_flexfield_name like '$SRS$.EVN_GL_059_BK_HNEVN')
 order by v.column_seq_num
