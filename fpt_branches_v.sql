create or replace view fpt_branches_v as
select fsp.set_of_books_id,
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
          from applsys.fnd_flex_value_sets fvs, apps.fnd_flex_values_vl fv
         where fvs.flex_value_set_name = 'SBV_COA_COMPANY'
           and fvs.flex_value_set_id = fv.flex_value_set_id
           and fv.summary_flag = 'N') c
 where fsp.org_id = ou.organization_id
   and fsp.accts_pay_code_combination_id = gcc.code_combination_id
   and gcc.segment1 = c.branch_code
   and hoi.organization_id = fsp.org_id
   and fsp.org_id not in (1971, 1972)
   and hoi.org_information_context = 'Operating Unit Information';
