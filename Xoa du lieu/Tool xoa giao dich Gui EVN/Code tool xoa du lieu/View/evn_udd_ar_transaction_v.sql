create or replace view evn_udd_ar_transaction_v as
select t.customer_trx_id,
       t.trx_number,
       t.trx_date,
       t.comments,
       b.branch_code
  from ra_customer_trx_all t,
       fpt_branches_v b,
       (select distinct xte.source_id_int_1
          from xla.xla_transaction_entities xte, xla.xla_events xe
         where xte.application_id = 222
           and xte.entity_code = 'TRANSACTIONS'
           and xte.entity_id = xe.entity_id
           and xe.application_id = 222
           and xe.event_status_code = 'P') a
 where t.org_id = b.org_id
   and t.customer_trx_id = a.source_id_int_1(+)
   and a.source_id_int_1 is null;
