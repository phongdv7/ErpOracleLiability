create or replace view evn_udd_ar_receipts_v as
select distinct cr.cash_receipt_id,
                cr.receipt_number,
                cr.receipt_date,
                cr.reversal_date,
                cr.receivables_trx_id,
                cr.comments,
                b.branch_code /*,
                cr.status,
                crh.status*/
  from ar_cash_receipts_all cr,
       fpt_branches_v b,
       xla.xla_transaction_entities xte,
       xla.xla_events xe,
       ar_cash_receipt_history_all crh,
       (select a.cash_receipt_id, count(1)
          from (select distinct cr1.cash_receipt_id, h1.accounting_entry_status_code
                  from ar_cash_receipts_all         cr1,
                       xla.xla_transaction_entities xte1,
                       xla.xla_events               xe1,
                       xla.xla_ae_headers           h1,
                       ar_cash_receipt_history_all  crh1
                 where cr1.cash_receipt_id = xte1.source_id_int_1
                       and xe1.entity_id = h1.entity_id
                       and xe1.event_id = h1.event_id
                   and xte1.application_id = 222
                   and xte1.entity_code = 'RECEIPTS'
                   and xte1.entity_id = xe1.entity_id
                   and xe1.application_id = 222
                   and cr1.type = 'CASH'
                   and crh1.cash_receipt_id = cr1.cash_receipt_id
                   and crh1.org_id = cr1.org_id
                   and crh1.current_record_flag =
                       nvl('Y', cr1.receipt_number)
                   and crh1.status <> 'REVERSED'
                --and cr1.cash_receipt_id = cr.cash_receipt_id
                --and cr1.receipt_number = 'DK_20'
                --and b1.branch_code = '081900'
                ) a
         group by a.cash_receipt_id
        having count(1) > 1) a
 where cr.org_id = b.org_id
   and a.cash_receipt_id = cr.cash_receipt_id
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
;
