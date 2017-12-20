select distinct xal.accounting_date, glh.*
  from xla_transaction_entities_upg xte,
       xla_events                   xe,
       xla_distribution_links       xdl,
       mtl_transaction_accounts     mta,
       xla_ae_headers               xah,
       xla_ae_lines                 xal,
       gl_import_references         gir,
       gl_je_headers                glh,
       gl_je_lines gjl
 where 1 = 1
   and xte.source_id_int_1 in
       (select t.transaction_id
          from mtl_material_transactions t
         where t.attribute15 in ('01.HX8.12.0037',
                                 '01.HX8.12.0035',
                                 '03.HY8.42.0090',
                                 '01.HX8.12.0056',
                                 '01.HX8.12.0036')) --= &transaction_id
   and xte.entity_id = xe.entity_id
   and mta.transaction_id = xte.source_id_int_1
   and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
   and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
   and xdl.ae_header_id = xah.ae_header_id
   and xal.ae_header_id = xdl.ae_header_id
   and xal.ae_header_id = xah.ae_header_id
   and gir.gl_sl_link_table = 'XLAJEL'
   and gir.gl_sl_link_id = xal.gl_sl_link_id
   and gir.je_header_id = glh.je_header_id
   --
   and glh.je_header_id = gjl.je_header_id
   and mta.reference_account = gjl.code_combination_id
   and gjl.je_line_num = gir.je_line_num
   and gir.je_header_id = gjl.je_header_id
   and gir.je_line_num = gjl.je_line_num;
--------------------------------------------------------------------------------------
select xal.accounting_date,
       glh.name,
       gjl.je_line_num,
       gjl.accounted_dr,
       gjl.accounted_cr
  from xla_transaction_entities_upg xte,
       xla_events                   xe,
       xla_distribution_links       xdl,
       mtl_transaction_accounts     mta,
       xla_ae_headers               xah,
       xla_ae_lines                 xal,
       gl_import_references         gir,
       gl_je_headers                glh,
       gl_je_lines                  gjl
 where 1 = 1
   and xte.source_id_int_1 in
       (select t.transaction_id
          from mtl_material_transactions t
         where t.attribute15 in ('01.HX8.12.0037',
                                 '01.HX8.12.0035',
                                 '03.HY8.42.0090',
                                 '01.HX8.12.0056',
                                 '01.HX8.12.0036')) --= &transaction_id
   and xte.entity_id = xe.entity_id
   and mta.transaction_id = xte.source_id_int_1
   and xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS'
   and xdl.source_distribution_id_num_1 = mta.inv_sub_ledger_id
   and xdl.ae_header_id = xah.ae_header_id
   and xal.ae_header_id = xdl.ae_header_id
   and xal.ae_header_id = xah.ae_header_id
   and gir.gl_sl_link_table = 'XLAJEL'
   and gir.gl_sl_link_id = xal.gl_sl_link_id
   and gir.je_header_id = glh.je_header_id
      --
   and glh.je_header_id = gjl.je_header_id
   and mta.reference_account = gjl.code_combination_id
   and gjl.je_line_num = gir.je_line_num
   and gir.je_header_id = gjl.je_header_id
   and gir.je_line_num = gjl.je_line_num;
