select e.ledger_id, c.flex_value_set_name, v.branch_code, v.branch_name
  from apps.fnd_id_flex_structures_vl a,
       apps.fnd_id_flex_segments_vl b,
       apps.fnd_flex_value_sets c,
       apps.gl_ledgers d,
       apps.gl_ledger_segment_values e,
       (select fsp.set_of_books_id,
               fsp.org_id,
               ou.name as org_name,
               c.branch_code,
               c.branch_name,
               c.enabled_flag,
               c.start_date_active,
               c.end_date_active,
               hoi.org_information5
          from ap.financials_system_params_all fsp,
               hr_all_organization_units_vl ou,
               gl.gl_code_combinations gcc,
               hr_organization_information hoi,
               (select fv.flex_value        branch_code,
                       fv.description       branch_name,
                       fv.enabled_flag,
                       fv.start_date_active,
                       fv.end_date_active
                  from applsys.fnd_flex_value_sets fvs,
                       apps.fnd_flex_values_vl     fv
                 where fvs.flex_value_set_name = 'EVN_CONGTY'
                   and fvs.flex_value_set_id = fv.flex_value_set_id
                   and fv.summary_flag = 'N') c
         where fsp.org_id = ou.organization_id
           and fsp.accts_pay_code_combination_id = gcc.code_combination_id
           and gcc.segment1 = c.branch_code
           and hoi.organization_id = fsp.org_id
           and hoi.org_information_context = 'Operating Unit Information') v
 where a.application_id = 101
   and a.id_flex_num = b.id_flex_num
   and a.application_id = b.application_id
   and a.id_flex_code = b.id_flex_code
   and b.flex_value_set_id = c.flex_value_set_id
   and a.id_flex_code = 'GL#'
   and a.id_flex_num = d.chart_of_accounts_id
   and d.ledger_id = e.ledger_id
   and b.segment_name = 'TAIKHOAN'
   and v.branch_code = e.segment_value
order by v.branch_code
