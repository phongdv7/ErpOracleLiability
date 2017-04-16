select ho.organization_id,
       ho.org_information1,
       ho.org_information2 legal_entity, -- Legal Entity
       ho.org_information3 sob
  from hr_organization_information ho
 where ho.org_information_context = 'Operating Unit Information'; -- Accounting Information

select lg.ledger_id, lg.chart_of_accounts_id, lg.* from gl_ledgers lg;

select sob.set_of_books_id, sob.chart_of_accounts_id, sob.*
  from gl_sets_of_books sob;
