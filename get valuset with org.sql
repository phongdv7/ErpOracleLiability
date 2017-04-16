select a.id_flex_num,
       a.id_flex_structure_code,
       b.application_column_name,
       b.segment_name,
       c.flex_value_set_name
  from fnd_id_flex_structures_vl a,
       fnd_id_flex_segments_vl   b,
       fnd_flex_value_sets       c,
       gl_ledgers                d,
       gl_ledger_segment_values  e
 where a.application_id = 101
   and a.id_flex_structure_code in
       ('CPC_TAIKHOAN_KETOAN',
        'EVN_TAIKHOAN_KETOAN',
        'GENCO3_TAIKHOAN_KETOAN',
        'HAN_TAIKHOAN_KETOAN',
        'HCM_TAIKHOAN_KETOAN',
        'NPC_TAIKHOAN_KETOAN',
        'NPT1_TAIKHOAN_KETOAN',
        'NPT_COA',
        'NPT_TAIKHOAN_KETOAN',
        'SPC_TAIKHOAN_KETOAN')
   and a.id_flex_num = b.id_flex_num
   and a.application_id = b.application_id
   and a.id_flex_code = b.id_flex_code
   and b.flex_value_set_id = c.flex_value_set_id
   and a.id_flex_code = 'GL#'
   and a.id_flex_num = d.chart_of_accounts_id
   and d.ledger_id = e.ledger_id
   and e.segment_value = &p_segment1
   and e.ledger_id = &p_ledger_id
 order by a.id_flex_structure_code;
