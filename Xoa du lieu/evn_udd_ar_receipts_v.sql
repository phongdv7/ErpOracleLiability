create view evn_udd_ar_receipts_v as
select distinct cr.cash_receipt_id,
                cr.receipt_number,
                cr.receipt_date,
                cr.reversal_date,
                cr.receivables_trx_id,
                cr.comments,
                b.branch_code/*,
                cr.status,
                crh.status*/
  from ar_cash_receipts_all         cr,
       fpt_branches_v               b,
       xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       ar_cash_receipt_history_all  crh
 where cr.org_id = b.org_id
   and cr.cash_receipt_id = xte.source_id_int_1
   and xte.application_id = 222
   and xte.entity_code = 'RECEIPTS'
   and xte.entity_id = xe.entity_id
   and xe.application_id = 222
   and xe.event_status_code <> 'P'
   and cr.type = 'CASH'
   and crh.cash_receipt_id = cr.cash_receipt_id
   and crh.org_id = cr.org_id
   and crh.current_record_flag = nvl('Y', cr.receipt_number)
   and crh.status <> 'REVERSED'
   --and cr.status <> 'APP'
   --and cr.receipt_number = 'TT_L003'
;
