select b.branch_code,
       b.branch_name,
       'AP_INVOICE' nguon_ps,
       i.invoice_num so_gd,
       i.invoice_date ngay_gd,
       cc.segment4 tai_khoan,
       xdl.unrounded_entered_dr entered_dr,
       xdl.unrounded_entered_cr entered_cr,
       ail.amount,
       ail.line_number,
       i.description noi_dung,
       h.accounting_entry_status_code,
       u1.user_name nguoi_tao,
       u2.user_name nguoi_cap_nhat
  from ap.ap_invoices_all              i,
       gl.gl_code_combinations      cc,
       xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       xla.xla_ae_headers           h,
       xla.xla_ae_lines             l,
       apps.fpt_branches_v               b,
       apps.fnd_user                u1,
       apps.fnd_user                u2,
       XLA_DISTRIBUTION_LINKS xdl,
       AP_INVOICE_DISTRIBUTIONS_ALL aid,
       ap_invoice_lines_all ail
 where 1 = 1
and i.invoice_Id =  450977
and ail.invoice_id = i.invoice_id
and ail.invoice_id = aid.invoice_Id
and ail.line_number = aid.invoice_line_number
and xdl.source_distribution_type = 'AP_INV_DIST'
and xdl.source_distribution_id_num_1 = aid.invoice_distribution_id
and xte.application_id = xdl.application_id
and h.entity_id = xte.entity_id
and h.ae_header_id = xdl.ae_header_id
and h.event_id = xdl.event_id
and l.ae_line_num = xdl.ae_line_num
      -->>Tham so
   and (b.branch_code = &p_don_vi or &p_don_vi is null)
   and (cc.segment4 = &p_tai_khoan or &p_tai_khoan is null)
   and l.accounting_date >= &p_from_date
   and l.accounting_date <= &p_to_date
      --<<
   and u1.user_id = i.created_by
   and u2.user_id = i.last_updated_by
   and i.org_id = b.org_id
   and xte.source_id_int_1 = i.invoice_id
   and xte.entity_code = 'AP_INVOICES'
   and xte.application_id = 200
   --and xe.application_id = 200
   --and h.application_id = 200
   --and l.application_id = 200
   and xte.entity_id = xe.entity_id
   and xe.entity_id = h.entity_id
   and xe.event_id = h.event_id
   and h.ae_header_id = l.ae_header_id
   and i.legal_entity_id = xte.legal_entity_id
   and xte.ledger_id = h.ledger_id
   and h.ledger_id = l.ledger_id
   and i.org_id = xte.security_id_int_1
   and l.code_combination_id = cc.code_combination_id(+)
