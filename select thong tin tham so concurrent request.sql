select v.column_seq_num,
       v.end_user_column_name,
       v.enabled_flag,
       fl.flex_value_set_name          valueset,
       b.default_type                  default_type,
       b.default_value                 default_value,
       b.required_flag                 required,
       b.enabled_flag                  enable_security,
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
   and (v.application_id = '222')
   and (v.descriptive_flexfield_name like '$SRS$.EVN_AR_003')
 order by v.column_seq_num
