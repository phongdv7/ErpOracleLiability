create view evn_udd_gl_journals_v as
select distinct b.je_batch_id,
                b.name as batch_name,
                b.description,
                b.status,
                b.default_effective_date,
                h.je_source,
                h.ledger_id,
                cc.segment1 as branch_code
  from gl.gl_je_batches        b,
       gl.gl_je_headers        h,
       gl.gl_je_lines          l,
       gl.gl_code_combinations cc
 where b.je_batch_id = h.je_batch_id
   and h.je_header_id = l.je_header_id
   and l.code_combination_id = cc.code_combination_id
   and b.actual_flag = 'A'
   and b.status <> 'P';
