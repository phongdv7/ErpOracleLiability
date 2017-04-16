-- Create table
create table BACKUP.EVN_AR_DISTRIBUTIONS_ALL_B3
(
  line_id                      NUMBER(15) not null,
  source_id                    NUMBER(15) not null,
  source_table                 VARCHAR2(10) not null,
  source_type                  VARCHAR2(30) not null,
  code_combination_id          NUMBER(15) not null,
  amount_dr                    NUMBER,
  amount_cr                    NUMBER,
  acctd_amount_dr              NUMBER,
  acctd_amount_cr              NUMBER,
  creation_date                DATE not null,
  created_by                   NUMBER(15) not null,
  last_updated_by              NUMBER(15) not null,
  last_update_date             DATE not null,
  last_update_login            NUMBER(15),
  org_id                       NUMBER(15),
  source_table_secondary       VARCHAR2(10),
  source_id_secondary          NUMBER(15),
  currency_code                VARCHAR2(15),
  currency_conversion_rate     NUMBER,
  currency_conversion_type     VARCHAR2(30),
  currency_conversion_date     DATE,
  taxable_entered_dr           NUMBER,
  taxable_entered_cr           NUMBER,
  taxable_accounted_dr         NUMBER,
  taxable_accounted_cr         NUMBER,
  tax_link_id                  NUMBER(15),
  third_party_id               NUMBER(15),
  third_party_sub_id           NUMBER(15),
  reversed_source_id           NUMBER(15),
  tax_code_id                  NUMBER(15),
  location_segment_id          NUMBER(15),
  source_type_secondary        VARCHAR2(30),
  tax_group_code_id            NUMBER(15),
  ref_customer_trx_line_id     NUMBER(15),
  ref_cust_trx_line_gl_dist_id NUMBER(15),
  ref_account_class            VARCHAR2(30),
  activity_bucket              VARCHAR2(30),
  ref_line_id                  NUMBER(15),
  from_amount_dr               NUMBER,
  from_amount_cr               NUMBER,
  from_acctd_amount_dr         NUMBER,
  from_acctd_amount_cr         NUMBER,
  ref_mf_dist_flag             VARCHAR2(1),
  ref_dist_ccid                NUMBER(15)
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
