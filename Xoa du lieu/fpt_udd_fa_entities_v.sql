create view evn_udd_fa_entities_v as
select xe.event_id,
       xte.entity_code,
       ft.asset_id,
       ft.asset_number,
       fab.DESCRIPTION as asset_desc,
       ft.book_type_code,
       xe.process_status_code,
       xe.event_status_code,
       xe.event_date,
       /*ft.period_name,*/
       to_char(xe.event_date, 'mm-yyyy') as period_name,
       xte.entity_id,
       xte.ledger_id,
       xte.legal_entity_id,
       xte.transaction_number,
       xte.transaction_number || '-' || ft.description as description,
       xte.source_id_int_1,
       xte.source_id_char_1
  from xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       fa_transactions_v            ft,
       fa_additions fab
 where xte.application_id = 140
   and xe.application_id = 140
   and xte.entity_code = 'TRANSACTIONS'
   and xte.entity_id = xe.entity_id
   and xe.process_status_code <> 'P'
   and xte.source_id_int_1 = ft.transaction_header_id
   and ft.asset_id = fab.ASSET_ID
union all
select xe.event_id,
       xte.entity_code,
       fab.asset_id,
       fab.asset_number,
       fab.DESCRIPTION as asset_desc,
       xte.source_id_char_1,
       xe.process_status_code,
       xe.event_status_code,
       xe.event_date,
       to_char(xe.event_date, 'mm-yyyy') as period_name,
       xte.entity_id,
       xte.ledger_id,
       xte.legal_entity_id,
       xte.transaction_number,
       xte.entity_code || '-' || xte.source_id_int_1 as description,
       xte.source_id_int_1,
       xte.source_id_char_1
  from xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       fa_additions            fab
 where xte.application_id = 140
   and xe.application_id = 140
   and xte.entity_code = 'DEPRECIATION'
   and xte.entity_id = xe.entity_id
   and xe.process_status_code <> 'P'
   and xte.source_id_int_1 = fab.asset_id;
