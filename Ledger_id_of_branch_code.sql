create or replace view evn_ledger_branch_v as
select e.ledger_id, v.org_id, v.branch_code, v.branch_name
  from fnd_id_flex_structures_vl a,
       fnd_id_flex_segments_vl   b,
       fnd_flex_value_sets       c,
       gl_ledgers                d,
       gl_ledger_segment_values  e,
       fpt_branches_v            v
 where a.application_id = 101
   and a.id_flex_num = b.id_flex_num
   and a.application_id = b.application_id
   and a.id_flex_code = b.id_flex_code
   and b.flex_value_set_id = c.flex_value_set_id
   and a.id_flex_code = 'GL#'
   and a.id_flex_num = d.chart_of_accounts_id
   and d.ledger_id = e.ledger_id
   and b.segment_name = 'CONGTY'
   and v.branch_code = e.segment_value
   and d.ledger_id <> 2533
   and v.org_id not in (1971, 1972);
