create view evn_ar_receipt_delete_v as
(
-- Kiem Thanh: xoa giao dich reversed chua hach toan Final
-- PhongDV2 fix lai cho nhanh
select t.cash_receipt_id,
       t.receipt_number,
       t.reversal_comments,
       t.org_id,
       fb.branch_code,
       fb.branch_name
  from ar_cash_receipts_all         t,
       fpt_branches_v               fb,
       xla.xla_transaction_entities xte,
       xla.xla_ae_headers           xh
 where t.status in ('STOP', 'REV', 'CC_CHARGEBACK_REV')
   and t.org_id = fb.org_id
      --
   and xte.source_id_int_1 = t.cash_receipt_id
   and xh.entity_id = xte.entity_id
   and xh.accounting_entry_status_code <> 'F'
   and xte.entity_code = 'RECEIPTS'
   and xte.application_id = 222
   and xh.application_id = 222
)
;
