--Get short name application
select distinct rn.application_id,
                substr(rn.responsibility_name,
                       (instr(rn.responsibility_name, '_', 1, 1) + 1),
                       2)
  from fnd_responsibility_tl rn
 where rn.responsibility_name like '%Super%User%';
--------------------------------------------------------------------------------
--Get application info
select fa.application_id         "Application ID",
       fat.application_name      "Application Name",
       fa.application_short_name "Application Short Name",
       fa.basepath               "Basepath"
  from fnd_application fa, fnd_application_tl fat
 where fa.application_id = fat.application_id
   and fat.language = userenv('LANG')
-- AND fat.application_name = 'Payables'  -- <change it>
 order by fat.application_name;
