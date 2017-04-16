select fd.asset_number,
       fds.deprn_reserve,
       fdp.period_name,
       fcb.deprn_reserve_acct tai_khoan

  from fa_deprn_summary  fds,
       fa_additions      fd,
       fa_deprn_periods  fdp,
       fa_category_books fcb,
       evn_branches_v b

 where 1 = 1
   and fd.asset_id = fds.asset_id
   and fds.book_type_code like '%THO%FA%BOOK%'
   and fds.deprn_source_code = 'BOOKS'
   and fds.deprn_reserve <> 0
      --and fd.asset_id in( 1378207, 1378208, 1378212)
   and fdp.period_counter = fds.period_counter
   and fdp.book_type_code = fds.book_type_code
   and fcb.category_id = fd.asset_category_id
   and fcb.book_type_code = fds.book_type_code
   and b.org_id = 
   and fdp.calendar_period_open_date < &p_to_date + 1
 order by fds.asset_id, fdp.period_counter
