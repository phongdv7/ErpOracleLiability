select mt.transaction_date,
       mt.transaction_id,
       cc.segment1,
       v.branch_name,
       mp.organization_id,
       mp.organization_code,
       mt.inventory_item_id,
       msi.segment1,
       l.entered_dr         dr,
       l.entered_cr         cr
  from gl_code_combinations         cc,
       xla.xla_transaction_entities xte,
       xla.xla_events               xe,
       xla.xla_ae_headers           h,
       xla.xla_ae_lines             l,
       mtl_material_transactions    mt,
       mtl_parameters               mp,
       mtl_system_items_b           msi,
       fpt_branches_v               v
 where 1 = 1
   and v.branch_code = '082300'
   and msi.inventory_item_id = mt.inventory_item_id
   and msi.segment1 = '3.20.35.806.000.00.000'
   and msi.organization_id = mt.organization_id
      --and mp.organization_code = 'UH1'
   and v.branch_code = cc.segment1
   and mp.organization_id = mt.organization_id
      --and l.accounting_class_code in ('INVENTORY_VALUATION')
   and xte.application_id = 707
   and xe.application_id = 707
   and h.application_id = 707
   and l.application_id = 707
   and xte.entity_id = xe.entity_id
   and xe.entity_id = h.entity_id
   and xe.event_id = h.event_id
   and h.ae_header_id = l.ae_header_id
   and xte.ledger_id = h.ledger_id
   and h.ledger_id = l.ledger_id
   and l.code_combination_id = cc.code_combination_id(+)
   and xte.source_id_int_1 = mt.transaction_id
