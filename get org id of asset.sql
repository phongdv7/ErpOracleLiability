select fd.ASSET_NUMBER,
       b.org_id,
       gcc.segment1,
       gcc.concatenated_segments,
       t.*
  from FA.FA_DISTRIBUTION_HISTORY t,
       fa_additions               fd,
       gl_code_combinations_kfv   gcc,
       fpt_branches_v             b
 where 1 = 1
   and t.asset_id = &p_asset_id
   and b.org_id = &p_org_id
   and fd.ASSET_ID = t.asset_id
   and t.code_combination_id = gcc.code_combination_id
   and t.date_ineffective is null
   and gcc.segment1 = b.branch_code
