--------------------------------
-- Set Diagnostic
--------------------------------
declare
  v_user_id number;
  v_check   boolean;
begin
  select u.user_id
    into v_user_id
    from fnd_user u
   where u.user_name = 'ERP2017';

  -- Level that you're setting at: 'SITE','APPL','RESP','USER', etc.

  -- Hide Diagnostics menu entry
  v_check := fnd_profile.save(x_name               => 'FND_HIDE_DIAGNOSTICS',
                              x_value              => 'N',
                              x_level_name         => 'USER',
                              x_level_value        => v_user_id,
                              x_level_value_app_id => null);

  -- Utilities:Diagnostics
  v_check := fnd_profile.save(x_name               => 'DIAGNOSTICS',
                              x_value              => 'Y',
                              x_level_name         => 'USER',
                              x_level_value        => v_user_id,
                              x_level_value_app_id => null);

end;