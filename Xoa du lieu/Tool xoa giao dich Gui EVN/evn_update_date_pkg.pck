create or replace package evn_update_date_pkg is

  g_gl_journal     constant varchar2(20) := 'GL_JOURNAL';
  g_ap_invoice     constant varchar2(20) := 'AP_INVOICE';
  g_ap_payment     constant varchar2(20) := 'AP_PAYMENT';
  g_ar_transaction constant varchar2(20) := 'AR_TRANSACTION';
  g_ar_receipt     constant varchar2(20) := 'AR_RECEIPT';
  g_date_format    constant varchar2(30) := 'rrrr/mm/dd hh24:mi:ss';

  procedure ap_invoice_date(errbuf       out nocopy varchar2,
                            retcode      out nocopy varchar2,
                            p_company_code   varchar2,
                            p_invoice_id number,
                            p_new_date   varchar2);
  procedure ap_invoice(errbuf       out nocopy varchar2,
                       retcode      out nocopy varchar2,
                       p_company_code   varchar2,
                       p_invoice_id number,
                       p_new_date   varchar2);
  procedure ar_transaction(errbuf            out nocopy varchar2,
                           retcode           out nocopy varchar2,
                           p_segment1        varchar2,
                           p_customer_trx_id number,
                           p_new_date        varchar2);
  procedure ar_receipt(errbuf            out nocopy varchar2,
                       retcode           out nocopy varchar2,
                       p_company_code        varchar2,
                       p_cash_receipt_id number,
                       p_new_date        varchar2);
  procedure xla_by_entity(p_application_id number,
                          p_entity_code    varchar2,
                          p_object_id      number,
                          p_new_date       date);
  procedure xla_by_event(p_event_id number, p_new_date date);
  function get_posting_name(p_posting_status varchar2) return varchar2;
end evn_update_date_pkg;
/
create or replace package body evn_update_date_pkg is

  /*
  PhongDV2: ĐTrường hợp User nhập Ngày hóa đơn VAT, user nhập nhầm rất nhiều
  =>Chi Thanh8 yeu cau chi update invoice date
  */
  procedure ap_invoice_date(errbuf       out nocopy varchar2,
                            retcode      out nocopy varchar2,
                            p_company_code   varchar2,
                            p_invoice_id number,
                            p_new_date   varchar2) is
    v_new_date date;
    v_line_id number;
    -- Lay cac invoice chua final post
    cursor c is
      select t.invoice_id, t.invoice_num
        from evn_ap_invoice_all_v t
       where (t.branch_code = p_company_code or p_company_code is null)
         and (t.invoice_id = p_invoice_id or p_invoice_id is null);
  begin
    -- New Date
    if p_new_date is null then
      v_new_date := trunc(sysdate);
    else
      v_new_date := to_date(p_new_date, g_date_format);
    end if;
  
    for r in c loop
      -- Invoice
      update ap_invoices_all aia
         set aia.invoice_date = v_new_date
       where aia.invoice_id = r.invoice_id;
    
      write_output('Invoice ' || r.invoice_num ||
                   ': Updated Invoice Date to ' ||
                   to_char(v_new_date, 'dd/mm/rrrr'));
      -- Luu lich su request vao bang log
      select EVN_DELETE_REQUEST_LOG_S.nextval
          into v_line_id
      from dual;
      insert into EVN_DELETE_REQUEST_LOG 
             values (v_line_id, FND_GLOBAL.CONC_REQUEST_ID, 'EVN AP Update Invoice Date',
             'p_company_code: ' || p_company_code || '; p_invoice_id: ' || p_invoice_id || 
             '(invoice_num: ' || r.invoice_num || '); ' || 'p_new_date: ' || p_new_date,
             (select user_name from fnd_user u where u.user_id = fnd_global.user_id), sysdate);
    
    end loop;
  
    -- Finally Commit
    commit;
  
  exception
    when others then
      rollback;
      errbuf  := 'Exception: ' || substr(sqlerrm, 1, 100);
      retcode := 2;
      write_output('Exception: ' || sqlerrm);
      write_output('at ' || dbms_utility.format_error_backtrace);
  end;

  /* AP Invoice
  Posting Status: 'Y' - Posted
                  'N' - Unposted
                  'S' - Selected
                  'P' - Partially Posted
                  'D' - Draft
  Chi update nhung in voi chua
  */
  procedure ap_invoice(errbuf       out nocopy varchar2,
                       retcode      out nocopy varchar2,
                       p_company_code   varchar2,
                       p_invoice_id number,
                       p_new_date   varchar2) is
    v_new_date date;
    v_line_id number;
    -- Lay cac invoice chua final post
    cursor c is
      select t.invoice_id,
             t.invoice_num,
             t.description,
             t.posting_status,
             t.gl_date
        from evn_udd_ap_invoices_v t
       where (t.branch_code = p_company_code or p_company_code is null)
         and (t.invoice_id = p_invoice_id or p_invoice_id is null);
  begin
    -- New Date
    if p_new_date is null then
      v_new_date := trunc(sysdate);
    else
      v_new_date := to_date(p_new_date, g_date_format);
    end if;
  
    write_output('Update GL Date to ' || to_char(v_new_date, 'dd/mm/rrrr') ||
                 chr(10));
    write_output('GL Date      Invoice number      Posting Status    Description');
    write_output(rpad('-', 100, '-'));
  
    for r in c loop
      -- Truong hop Partial chi update Distribution, Event
      -- Co truong hop line cung Partial -> Khong update line
      if r.posting_status = 'P' then
      
        -- Distribution
        update ap.ap_invoice_distributions_all aid
           set aid.accounting_date = v_new_date,
               aid.period_name     = to_char(v_new_date, 'mm-rrrr')
         where aid.invoice_id = r.invoice_id
           and aid.posted_flag <> 'Y';
      
        -- Event
        update xla.xla_events xe
           set xe.event_date = v_new_date, xe.transaction_date = v_new_date
         where xe.event_id in
               (select aid.accounting_event_id
                  from ap.ap_invoice_distributions_all aid
                 where aid.invoice_id = r.invoice_id
                   and aid.posted_flag <> 'Y')
           and xe.process_status_code <> 'P';
      
      else
      
        -- Invoice
        update ap_invoices_all aia
           set aia.gl_date = v_new_date, aia.invoice_date = v_new_date
         where aia.invoice_id = r.invoice_id;
      
        -- Invoice Lines
        update ap_invoice_lines_all aila
           set aila.accounting_date = v_new_date,
               aila.period_name     = to_char(v_new_date, 'mm-rrrr')
         where aila.invoice_id = r.invoice_id;
      
        -- Invoice Distribution
        update ap_invoice_distributions_all aida
           set aida.accounting_date = v_new_date,
               aida.period_name     = to_char(v_new_date, 'mm-rrrr')
         where aida.invoice_id = r.invoice_id;
      
        -- Update Prepay History
        update ap.ap_prepay_history_all t
           set t.accounting_date = v_new_date
         where t.invoice_id = r.invoice_id;
      
        -- Tax Line
        update zx_lines zl
           set zl.tax_currency_conversion_date = v_new_date,
               zl.trx_date                     = v_new_date,
               zl.tax_point_date               = v_new_date,
               zl.trx_line_date                = v_new_date,
               zl.tax_determine_date           = v_new_date,
               zl.tax_date                     = v_new_date
         where zl.trx_id = r.invoice_id;
      
        -- Tax Detail
        update zx_lines_det_factors zd
           set zd.trx_communicated_date = v_new_date,
               zd.trx_line_date         = v_new_date,
               zd.trx_date              = v_new_date,
               zd.trx_line_gl_date      = v_new_date,
               zd.trx_due_date          = v_new_date
         where zd.trx_id = r.invoice_id;
      
        -- Tax Distribution
        update zx_rec_nrec_dist dis
           set dis.tax_currency_conversion_date = v_new_date,
               dis.gl_date                      = v_new_date
         where dis.trx_id = r.invoice_id;
      
        -- Update XLA Entity
        xla_by_entity(p_application_id => 200,
                      p_entity_code    => 'AP_INVOICES',
                      p_object_id      => r.invoice_id,
                      p_new_date       => v_new_date);
      
      end if;
    
      write_output(to_char(r.gl_date, 'dd/mm/rrrr') || '   ' ||
                   rpad(r.invoice_num, 20, ' ') ||
                   rpad(get_posting_name(r.posting_status), 18, ' ') ||
                   r.description);
                   
      -- Luu lich su request vao bang log
      select EVN_DELETE_REQUEST_LOG_S.nextval
          into v_line_id
      from dual;
      insert into EVN_DELETE_REQUEST_LOG 
             values (v_line_id, FND_GLOBAL.CONC_REQUEST_ID, 'EVN AP Update AP Invoice Unapply/Apply sai ngay ',
             'p_company_code: ' || p_company_code || '; p_invoice_id: ' || p_invoice_id || 
             '(invoice_num: ' || r.invoice_num || '); ' || 'p_new_date: ' || p_new_date,
             (select user_name from fnd_user u where u.user_id = fnd_global.user_id), sysdate);
    
    end loop;
  
    -- Finally Commit
    commit;
  
  exception
    when others then
      rollback;
      errbuf  := 'Exception: ' || substr(sqlerrm, 1, 100);
      retcode := 2;
      write_output('Exception: ' || sqlerrm);
      write_output('at ' || dbms_utility.format_error_backtrace);
  end;

  -- AR Transaction
  --------------------------
  procedure ar_transaction(errbuf            out nocopy varchar2,
                           retcode           out nocopy varchar2,
                           p_segment1        varchar2,
                           p_customer_trx_id number,
                           p_new_date        varchar2) is
    v_new_date date;
    v_count    number;
  
    cursor c is
      select t.customer_trx_id, t.trx_number, t.trx_date, t.comments
        from evn_udd_ar_transaction_v t
       where (t.branch_code = p_segment1 or p_segment1 is null)
         and (t.customer_trx_id = p_customer_trx_id or
             p_customer_trx_id is null);
  begin
    -- New Date
    if p_new_date is null then
      v_new_date := trunc(sysdate);
    else
      v_new_date := to_date(p_new_date, g_date_format);
    end if;
  
    write_output('Update GL Date to ' || to_char(v_new_date, 'dd/mm/rrrr') ||
                 chr(10));
    write_output('Trx Date     Trans number      Description');
    write_output(rpad('-', 100, '-'));
  
    for r in c loop
      -- Check Partial Accounting
      select count(1)
        into v_count
        from ra_customer_trx_all          t,
             xla.xla_transaction_entities xte,
             xla.xla_events               xe
       where t.customer_trx_id = xte.source_id_int_1
         and xte.application_id = 222
         and xte.entity_code = 'TRANSACTIONS'
         and xte.entity_id = xe.entity_id
         and xe.application_id = 222
         and xe.event_status_code = 'P'
         and t.customer_trx_id = r.customer_trx_id;
    
      if v_count = 0 then
      
        -- Transaction
        update ar.ra_customer_trx_all t
           set t.trx_date      = v_new_date,
               t.exchange_date = v_new_date,
               t.term_due_date = nvl2(t.term_due_date, v_new_date, null)
         where t.customer_trx_id = r.customer_trx_id;
      
        -- Summary History
        update ar.ar_trx_summary_hist tsh
           set tsh.trx_date = v_new_date
         where tsh.customer_trx_id = r.customer_trx_id;
      
        -- Payment Schedule
        update ar.ar_payment_schedules_all ps
           set ps.trx_date      = v_new_date,
               ps.gl_date       = v_new_date,
               ps.due_date      = nvl2(ps.due_date, v_new_date, null),
               ps.exchange_date = nvl2(ps.exchange_date, v_new_date, null)
         where ps.customer_trx_id = r.customer_trx_id;
      
        write_output(to_char(r.trx_date, 'dd/mm/rrrr') || '   ' ||
                     rpad(r.trx_number, 18, ' ') || r.comments);
      
      end if;
    
    end loop;
  
    -- Theo Event ID
    for re in (select xe.event_id
                 from ra_customer_trx_all          t,
                      fpt_branches_v               b,
                      xla.xla_transaction_entities xte,
                      xla.xla_events               xe
                where t.org_id = b.org_id
                  and t.customer_trx_id = xte.source_id_int_1
                  and xte.application_id = 222
                  and xte.entity_code = 'TRANSACTIONS'
                  and xte.entity_id = xe.entity_id
                  and xe.application_id = 222
                  and xe.event_status_code <> 'P'
                  and (b.branch_code = p_segment1 or p_segment1 is null)
                  and (t.customer_trx_id = p_customer_trx_id or
                      p_customer_trx_id is null)) loop
    
      -- Line Distribution
      update ar.ra_cust_trx_line_gl_dist_all tld
         set tld.gl_date = v_new_date
       where tld.event_id = re.event_id;
    
      -- Receivable Application
      update ar.ar_receivable_applications_all ra
         set ra.gl_date          = v_new_date,
             ra.apply_date       = v_new_date,
             ra.reversal_gl_date = nvl2(ra.reversal_gl_date,
                                        v_new_date,
                                        null)
       where ra.event_id = re.event_id;
    
      -- XLA By Entity
      xla_by_event(p_event_id => re.event_id, p_new_date => v_new_date);
    
    end loop;
  
  exception
    when others then
      rollback;
      errbuf  := 'Exception: ' || substr(sqlerrm, 1, 100);
      retcode := 2;
      write_output('Exception: ' || sqlerrm);
      write_output('at ' || dbms_utility.format_error_backtrace);
  end;

  -- AR Receipt
  -----------------------
  procedure ar_receipt(errbuf            out nocopy varchar2,
                       retcode           out nocopy varchar2,
                       p_company_code        varchar2,
                       p_cash_receipt_id number,
                       p_new_date        varchar2) is
    v_new_date date;
    v_count    number;
    v_line_id number;

    cursor c is
      select distinct rec.cash_receipt_id,
                      rec.receipt_number,
                      rec.receipt_date,
                      rec.comments
        from evn_udd_ar_receipts_v rec
       where (rec.branch_code = p_company_code or p_company_code is null)
         and (rec.cash_receipt_id = p_cash_receipt_id or
             p_cash_receipt_id is null);
  begin
    -- New Date
    if p_new_date is null then
      v_new_date := trunc(sysdate);
    else
      v_new_date := to_date(p_new_date, g_date_format);
    end if;
  
    write_output('Update GL Date to ' || to_char(v_new_date, 'dd/mm/rrrr') ||
                 chr(10));
    --write_output('GL Date      Receipt number      Description');
    --write_output(rpad('-', 100, '-'));
  
    for r in c loop
    
      select count(1)
        into v_count
        from ar_cash_receipts_all         cr,
             fpt_branches_v               b,
             xla.xla_transaction_entities xte,
             xla.xla_events               xe
       where cr.org_id = b.org_id
         and cr.cash_receipt_id = xte.source_id_int_1
         and xte.application_id = 222
         and xte.entity_code = 'RECEIPTS'
         and xte.entity_id = xe.entity_id
         and xe.application_id = 222
         and xe.event_status_code = 'P'
         and cr.cash_receipt_id = r.cash_receipt_id;
    
      -- Truong hop giao dich chua 
      if v_count = 0 then
      
        -- Cash Receipt
        update ar.ar_cash_receipts_all cr
           set cr.receipt_date  = v_new_date,
               cr.reversal_date = nvl2(cr.reversal_date, v_new_date, null),
               cr.exchange_date = nvl2(cr.exchange_date, v_new_date, null),
               cr.deposit_date  = v_new_date
         where cr.cash_receipt_id = r.cash_receipt_id;
      
        -- Payment Schedule
        update ar.ar_payment_schedules_all ps
           set ps.trx_date      = v_new_date,
               ps.gl_date       = v_new_date,
               ps.due_date      = nvl2(ps.due_date, v_new_date, null),
               ps.exchange_date = nvl2(ps.exchange_date, v_new_date, null)
         where ps.cash_receipt_id = r.cash_receipt_id;
      
        /*write_output(to_char(r.receipt_date, 'dd/mm/rrrr') || '   ' ||
                     rpad(r.receipt_number, 20, ' ') || r.comments);*/
      /*write_output('Updated receipt_number: ' || r.receipt_number);
      -- Luu lich su request vao bang log
      select EVN_DELETE_REQUEST_LOG_S.nextval
          into v_line_id
      from dual;
      insert into EVN_DELETE_REQUEST_LOG 
             values (v_line_id, FND_GLOBAL.CONC_REQUEST_ID, 'EVN AR Update Receipt Unapply/Apply sai ngay',
             'p_company_code: ' || p_company_code || '; p_cash_receipt_id: ' || p_cash_receipt_id || 
             '(receipt_number: ' || r.receipt_number || '); ' || 'p_new_date: ' || p_new_date,
             (select user_name from fnd_user u where u.user_id = fnd_global.user_id), sysdate);*/
      end if;
    
    end loop;
  
    -- Theo Event
    for re in (select xe.event_id, cr.receipt_number
                 from ar_cash_receipts_all         cr,
                      fpt_branches_v               b,
                      xla.xla_transaction_entities xte,
                      xla.xla_events               xe
                where cr.org_id = b.org_id
                  and cr.cash_receipt_id = xte.source_id_int_1
                  and xte.application_id = 222
                  and xte.entity_code = 'RECEIPTS'
                  and xte.entity_id = xe.entity_id
                  and xe.application_id = 222
                  and xe.event_status_code <> 'P'
                  and (b.branch_code = p_company_code or p_company_code is null)
                  and (cr.cash_receipt_id = p_cash_receipt_id or
                      p_cash_receipt_id is null)) loop
    
      -- Cash Distribution
      update ar.ar_misc_cash_distributions_all cd
         set cd.gl_date = v_new_date, cd.apply_date = v_new_date
       where cd.event_id = re.event_id;
    
      -- Cash Receipt History
      update ar.ar_cash_receipt_history_all crh
         set crh.trx_date         = v_new_date,
             crh.gl_date          = v_new_date,
             crh.reversal_gl_date = nvl2(crh.reversal_gl_date,
                                         v_new_date,
                                         null),
             crh.exchange_date    = nvl2(crh.exchange_date, v_new_date, null)
       where crh.event_id = re.event_id;
    
      -- Receivable
      update ar.ar_receivable_applications_all ra
         set ra.gl_date          = v_new_date,
             ra.apply_date       = v_new_date,
             ra.reversal_gl_date = nvl2(ra.reversal_gl_date,
                                        v_new_date,
                                        null)
       where ra.event_id = re.event_id;
    
      -- XLA by Event
      xla_by_event(p_event_id => re.event_id, p_new_date => v_new_date);
    
      write_output('Updated receipt_number: ' || re.receipt_number);
      -- Luu lich su request vao bang log
      select EVN_DELETE_REQUEST_LOG_S.nextval
          into v_line_id
      from dual;
      insert into EVN_DELETE_REQUEST_LOG 
             values (v_line_id, FND_GLOBAL.CONC_REQUEST_ID, 'EVN AR Update Receipt Unapply/Apply sai ngay',
             'p_company_code: ' || p_company_code || '; p_cash_receipt_id: ' || p_cash_receipt_id || 
             '(receipt_number: ' || re.receipt_number || '); ' || 'p_new_date: ' || p_new_date,
             (select user_name from fnd_user u where u.user_id = fnd_global.user_id), sysdate);
    end loop;
  -- Finally Commit
  commit;
  
  exception
    when others then
      rollback;
      errbuf  := 'Exception: ' || substr(sqlerrm, 1, 100);
      retcode := 2;
      write_output('Exception: ' || sqlerrm);
      write_output('at ' || dbms_utility.format_error_backtrace);
  end;

  -- Update XLA Entity
  ----------------------------
  procedure xla_by_entity(p_application_id number,
                          p_entity_code    varchar2,
                          p_object_id      number,
                          p_new_date       date) is
    cursor c is
      select xe.event_id
        from xla.xla_transaction_entities xte, xla.xla_events xe
       where xte.entity_code = p_entity_code
         and xte.application_id = p_application_id
         and xte.source_id_int_1 = p_object_id
         and xte.entity_id = xe.entity_id
         and xe.application_id = p_application_id
         and xe.process_status_code <> 'P';
  begin
    -- Loop Event
    for r in c loop
      xla_by_event(p_event_id => r.event_id, p_new_date => p_new_date);
    
    end loop;
  
  end;

  -- XLA Entity by Event ID
  -----------------------------
  procedure xla_by_event(p_event_id number, p_new_date date) is
    v_new_date date := nvl(p_new_date, trunc(sysdate));
  begin
    write_log('Update event date by p_event_id = ' || p_event_id);
    -- Update Event
    update xla.xla_events xe
       set xe.event_date = v_new_date, xe.transaction_date = v_new_date
     where xe.event_id = p_event_id;
  
    -- Update Header
    update xla.xla_ae_headers xh
       set xh.accounting_date = v_new_date,
           xh.period_name     = to_char(p_new_date, 'mm-rrrr')
     where xh.event_id = p_event_id;
  
    -- Update Line
    update xla.xla_ae_lines xl
       set xl.accounting_date = v_new_date
     where xl.ae_header_id in
           (select xh.ae_header_id
              from xla.xla_ae_headers xh
             where xh.event_id = p_event_id);
  
  end;

  -- Get Posting Status Name
  ------------------------------
  function get_posting_name(p_posting_status varchar2) return varchar2 is
    v_posting_status varchar2(30);
  begin
    select t.displayed_field
      into v_posting_status
      from ap_lookup_codes t
     where t.lookup_type = 'POSTING STATUS'
       and t.lookup_code = p_posting_status;
  
    return v_posting_status;
  
  exception
    when others then
      return 'N/A';
  end;

end evn_update_date_pkg;
/
