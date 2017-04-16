--Get responsibility_id
select fr.responsibility_id, fpov.profile_option_value
  from applsys.fnd_profile_option_values fpov,
       applsys.fnd_profile_options       fpo,
       applsys.fnd_profile_options_tl    fpot,
       applsys.fnd_responsibility_tl     fr
 where 1 = 1
   and fpo.profile_option_name = fpot.profile_option_name
   and fpo.profile_option_id = fpov.profile_option_id
   and fr.responsibility_id(+) = fpov.level_value
      -- AND fr.responsibility_id = :$PROFILES$.RESP_ID
   and fpot.profile_option_name = 'ORG_ID'
      --and fpov.profile_option_value = '11'
   and fr.responsibility_name like '%Super%User%'
   and fr.application_id = 275
   and fpov.profile_option_value = '88';

