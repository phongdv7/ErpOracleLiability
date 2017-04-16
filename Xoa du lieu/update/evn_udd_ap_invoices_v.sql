create or replace view evn_udd_ap_invoices_v as
select ai.invoice_id,
       ai.invoice_num,
       ai.description,
       ap_invoices_pkg.get_posting_status(ai.invoice_id) as posting_status,
       ai.gl_date,
       c.branch_code
  from ap.ap_invoices_all ai, fpt_branches_v c
 where ai.org_id = c.org_id
   -- Update ca nhung thang Partial -> Lay het tru Final Post
   and ap_invoices_pkg.get_posting_status(ai.invoice_id) <> 'Y'
;
