select gcc.segment1,
       gcc.segment4,
       sum(l.accounted_dr) dr,
       sum(l.accounted_cr) cr,
       sum(nvl(l.accounted_cr, 0)) - sum(nvl(l.accounted_dr, 0)) xxx
  from gl_je_headers h, gl_je_lines l, apps.gl_code_combinations_kfv gcc
 where h.je_header_id = l.je_header_id
   and l.code_combination_id = gcc.code_combination_id
   and h.status = 'P'
   and h.actual_flag = 'A'
   and h.ledger_id = 2021
      /*and l.effective_date >= '01-JAN-2015'
      and l.effective_date <= '31-DEC-2015'*/
      and h.ledger_id = &p_ledger_id
   and h.default_effective_date >= &p_from_date
   and h.default_effective_date <= &p_to_date
   and (gcc.segment4 like '635%')
   and (&p_quarter_type is null and h.period_name not like 'DC1%' and
       h.period_name not like 'DC2%')
   and gcc.segment1 = '000100'
   and segment7 = '999'
   and segment8 = '000000'
   and h.ledger_id = 2021
 group by gcc.segment1, gcc.segment4
