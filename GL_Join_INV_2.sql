select mta.transaction_id,
       mmt.organization_id,
       msi.segment1,
       mta.transaction_date,
       mta.primary_quantity,
       gcc.segment1 || '.' || gcc.segment2 || '.' || gcc.segment3 || '.' ||
       gcc.segment4 || '.' || gcc.segment5 account,
       decode(sign(mta.transaction_value),
              1,
              mta.transaction_value,
              0,
              0,
              null,
              decode(sign(mta.base_transaction_value),
                     1,
                     mta.base_transaction_value,
                     null)) entered_dr,
       decode(sign(mta.transaction_value),
              -1,
              (-1 * mta.transaction_value),
              0,
              0,
              null,
              decode(sign(mta.base_transaction_value),
                     -1,
                     (-1 * mta.base_transaction_value))) entered_cr,
       decode(sign(mta.base_transaction_value),
              1,
              mta.base_transaction_value,
              0,
              0,
              null) accounted_dr,
       decode(sign(mta.base_transaction_value),
              -1,
              (-1 * mta.base_transaction_value),
              0,
              0,
              null) accounted_cr,
       gh.currency_code,
       mtt.transaction_type_name,
       decode(mta.gl_batch_id, -1, 'N', 'Y') "Transfered_Flag",
       mta.gl_batch_id,
       gh.je_header_id
  from inv.mtl_material_transactions mmt,
       inv.mtl_transaction_types     mtt,
       inv.mtl_system_items_b        msi,
       inv.mtl_transaction_accounts  mta,
       gl.gl_code_combinations       gcc,
       gl.gl_je_batches              gb,
       gl.gl_je_headers              gh,
       gl.gl_je_lines                gl,
       gl.gl_import_references       gr
 where mmt.organization_id = msi.organization_id
   and msi.inventory_item_id = mmt.inventory_item_id
   and mmt.transaction_id = mta.transaction_id
   and gcc.code_combination_id = mta.reference_account
   and mtt.transaction_type_id = mmt.transaction_type_id
   and gb.je_batch_id = gh.je_batch_id
   and gh.je_header_id = gl.je_header_id
   and gl.code_combination_id = mta.reference_account
   and mta.gl_batch_id =
       to_number(substr(gb.name, 1, instr(gb.name, ' ') - 1))
   and gh.je_category = 'MTL'
   and gh.je_source = 'Inventory'
   and gh.name = 'XXX' ---REPLACE XXX WITH NAME
   and gl.je_line_num = gr.je_line_num
   and gr.je_header_id = gl.je_header_id
   and gr.je_line_num = gl.je_line_num
   and mta.gl_batch_id = gr.reference_1
   and gh.period_name = '&period_name' -- ENTER THE PERIOD
   and upper(gb.name) like upper('%&gl_batch_name%')
 order by 1
