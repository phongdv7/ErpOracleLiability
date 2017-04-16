create view fpt_entities_v as
select hoi2.org_information3   as ledger_id,
       lg.chart_of_accounts_id as coa_id,
       hoi2.org_information2   as legal_entity_id,
       hoi1.organization_id    as org_id,
       hoi2.org_information5   as org_short_name,
       org.name                as org_name,
       ep.party_id             as party_id,
       ep.name                 as legal_entity_name,
       le.flex_segment_value   as segment1,
       fv.description          as segment1_desc,
       reg.registration_number as registration_number, -- Ma so thue
       loc.address_line_1      as address,
       loc.town_or_city        as city
  from hr_organization_information  hoi1,
       hr_organization_information  hoi2,
       gl_ledgers                   lg,
       hr_all_organization_units_vl org,
       xle_entity_profiles          ep,
       gl_legal_entities_bsvs       le,
       fnd_flex_values_vl           fv,
       xle_registrations            reg,
       hr_locations_all             loc
 where hoi1.organization_id = hoi2.organization_id
   and hoi1.org_information_context = 'CLASS'
   and hoi1.org_information1 = 'OPERATING_UNIT'
   and hoi1.org_information2 = 'Y' -- Thay bon Oracle thi theo   
   and hoi2.org_information_context = 'Operating Unit Information'
   and hoi2.org_information3 = lg.ledger_id
   and hoi1.organization_id = org.organization_id
   and hoi2.org_information2 = ep.legal_entity_id
   and ep.legal_entity_id = le.legal_entity_id
   and le.flex_value_set_id = fv.flex_value_set_id
   and le.flex_segment_value = fv.flex_value
   and le.legal_entity_id = reg.source_id
   and reg.source_table = 'XLE_ENTITY_PROFILES'
   and reg.location_id = loc.location_id
