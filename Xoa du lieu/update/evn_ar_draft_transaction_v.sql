create or replace view evn_ar_draft_transaction_v as
select cr.customer_trx_id,
       cr.trx_number,
       cr.trx_date,
       cr.comments,
       b.branch_code
  from xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       xla.xla_ae_headers           h,
       ra_customer_trx_all          cr,
       fpt_branches_v               b
 where 1 = 1
   --and b.branch_code = '081100'
      --
   and cr.org_id = b.org_id
   and xte.source_id_int_1 = cr.customer_trx_id
   and xte.entity_code = 'TRANSACTIONS'
   and xte.application_id = 222
   and xe.application_id = 222
   and h.application_id = 222
   and xte.entity_id = xe.entity_id
   and xe.entity_id = h.entity_id
   and xe.event_id = h.event_id
   and h.balance_type_code <> 'E'
   and h.accounting_entry_status_code <> 'F'
 order by cr.customer_trx_id, cr.trx_number
;
