create or replace view fpt_accounts_parent_child_v as
(
-- Kiem Thanh tao ngay 1/12/2015
--khoi tk cha con
select t.flex_value_set_id,
       g.parent_flex_value,
       g.child_flex_value,
       'PARENT' as block,
       g.summary_flag
  from gl_seg_val_hierarchies g, fnd_flex_value_sets t
 where g.flex_value_set_id = t.flex_value_set_id
   and t.flex_value_set_name = 'SBV_COA_ACCOUNT'
   and g.parent_flex_value <> 'T'
--and g.summary_flag = 'N'

union all
-- khoi tk con: cha la chinh no
select t.flex_value_set_id,
       g.flex_value as parent_flex_value,
       g.flex_value as child_flex_value,
       'CHILD' as block,
       g.summary_flag
  from fnd_flex_values g, fnd_flex_value_sets t
 where g.flex_value_set_id = t.flex_value_set_id
   and t.flex_value_set_name = 'SBV_COA_ACCOUNT'
   and g.summary_flag = 'N'
)
;
