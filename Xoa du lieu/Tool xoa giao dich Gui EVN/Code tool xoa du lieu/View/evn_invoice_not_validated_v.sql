create view evn_invoice_not_validated_v as
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
       ('P', 'Y')
   and not exists (select 1
          from ap_invoices_all      inv,
               ap_invoices_all      inv1,
               ap_invoice_lines_all ail
         where inv.invoice_id = ail.prepay_invoice_id
           and inv1.invoice_id = ail.invoice_id
           and ail.line_type_lookup_code = 'PREPAY'
           and inv1.invoice_id = ai.invoice_id
           and ail.amount <> 0);
