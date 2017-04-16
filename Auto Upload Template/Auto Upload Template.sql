declare
  errbuf  varchar2(1000);
  retcode varchar2(1000);
begin
  for c in (select t.application_short_name, t.data_source_code
              from xdo_ds_definitions_b@LINK_TO_8025_APPS.FPT.COM.VN t
             where t.data_source_code like 'FPT_VAL_%'
               and t.creation_date > '1-AUG-2015') loop
    fpt_reqtransfer_pkg.sync_template_req(errbuf           => errbuf,
                                          retcode          => retcode,
                                          p_app_short_name => c.application_short_name,
                                          p_request_code   => c.data_source_code);
  end loop;
end;
