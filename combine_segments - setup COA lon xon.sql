function combine_segments(p_ledger_id     number,
                            p_segment1      varchar2 default null,
                            p_segment2      varchar2 default null,
                            p_segment3      varchar2 default null,
                            p_segment4      varchar2 default null,
                            p_segment5      varchar2 default null,
                            p_segment6      varchar2 default null,
                            p_segment7      varchar2 default null,
                            p_segment8      varchar2 default null,
                            p_segment9      varchar2 default null,
                            p_error_message out varchar2) return varchar2 is
    -- SEGMENT1(8 ky tu)
    type segment_type is table of varchar2(15) index by varchar2(8);
    v_segments         segment_type;
    v_coa_id           number := get_coa_id(p_ledger_id);
    v_combine_segments varchar2(200);
  begin
    -- Ky thuat Fix Để Động
    -- ban khong xu ly dong duoc p_segment1 .. p_segment9
    -- Nhung ban lai hoan toan xu ly duoc v_segments('SEGMENT1') .. v_segments('SEGMENT9')
    -- Ky thuat nay da duoc su dung lam bao cao dong cho Budget cua bac Quach
    v_segments('SEGMENT1') := p_segment1;
    v_segments('SEGMENT2') := p_segment2;
    v_segments('SEGMENT3') := p_segment3;
    v_segments('SEGMENT4') := p_segment4;
    v_segments('SEGMENT5') := p_segment5;
    v_segments('SEGMENT6') := p_segment6;
    v_segments('SEGMENT7') := p_segment7;
    v_segments('SEGMENT8') := p_segment8;
    v_segments('SEGMENT9') := p_segment9;
  
    for r in (select fs.application_column_name as column_name,
                     fs.default_type,
                     fs.default_value
                from fnd_id_flex_segments_vl fs
               where fs.application_id = 101
                 and fs.id_flex_code = 'GL#'
                 and fs.id_flex_num = v_coa_id
               order by fs.segment_num) loop
      
      -- Neu tham so null -> Lay default value theo setup      
      if v_segments(r.column_name) is null then
        -- Chi lay default type la Constant, SQL thi chiu
        if r.default_type = 'C' and
           r.default_value is not null then
          v_segments(r.column_name) := r.default_value;
        else
          p_error_message := p_error_message || r.column_name || ' can not be null.';
        end if;      
      end if;
    
      v_combine_segments := v_combine_segments || '.' ||
                            v_segments(r.column_name);
    end loop;
  
    -- Neu co loi -> return null
    if p_error_message is not null then
      return null;
    end if;
  
    return substr(v_combine_segments, 2);
  
  end;
