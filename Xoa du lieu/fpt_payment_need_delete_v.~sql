create view evns_payment_need_delete_v as
select ac.check_id,
       ac.check_number,
       ac.description      as check_desc,
       ac.bank_account_num,
       ac.org_id,
       v.branch_code       as parent_company_code

  from ap.ap_checks_all ac, fpt_branches_v v
 where ac.org_id = v.org_id
   and ap_checks_pkg.get_posting_status(ac.check_id) not in ('P', 'Y')
   and ac.status_lookup_code = 'VOIDED';
