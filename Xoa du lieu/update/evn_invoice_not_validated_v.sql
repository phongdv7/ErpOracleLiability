create or replace view evn_invoice_not_validated_v as
select ai.invoice_id,
       ai.invoice_num,
       ai.description as invoice_desc,
       ai.org_id,
       v.branch_code  as parent_company_code
  from ap.ap_invoices_all ai, fpt_branches_v v
 where ai.org_id = v.org_id
   and apps.ap_invoices_pkg.get_approval_status(ai.invoice_id,
                                                ai.invoice_amount,
                                                ai.payment_status_flag,
                                                ai.invoice_type_lookup_code) in
       ('NEVER APPROVED', 'NEEDS REAPPROVAL', 'UNAPPROVED')
   and apps.ap_invoices_pkg.get_posting_status(ai.invoice_id) not in
       ('P', 'Y');
