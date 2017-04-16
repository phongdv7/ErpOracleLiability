-- Create table
create table BACKUP.EVN_XLA_AE_LINES_BAK
(
  ae_header_id              NUMBER(15) not null,
  ae_line_num               NUMBER(15) not null,
  application_id            NUMBER(15) not null,
  code_combination_id       NUMBER(15) not null,
  gl_transfer_mode_code     VARCHAR2(1),
  gl_sl_link_id             NUMBER(15),
  accounting_class_code     VARCHAR2(30) not null,
  party_id                  NUMBER(15),
  party_site_id             NUMBER(15),
  party_type_code           VARCHAR2(1),
  entered_dr                NUMBER,
  entered_cr                NUMBER,
  accounted_dr              NUMBER,
  accounted_cr              NUMBER,
  description               VARCHAR2(1996),
  statistical_amount        NUMBER,
  currency_code             VARCHAR2(15) not null,
  currency_conversion_date  DATE,
  currency_conversion_rate  NUMBER,
  currency_conversion_type  VARCHAR2(30),
  ussgl_transaction_code    VARCHAR2(30),
  jgzz_recon_ref            VARCHAR2(240),
  control_balance_flag      VARCHAR2(1),
  analytical_balance_flag   VARCHAR2(1),
  attribute_category        VARCHAR2(30),
  attribute1                VARCHAR2(150),
  attribute2                VARCHAR2(150),
  attribute3                VARCHAR2(150),
  attribute4                VARCHAR2(150),
  attribute5                VARCHAR2(150),
  attribute6                VARCHAR2(150),
  attribute7                VARCHAR2(150),
  attribute8                VARCHAR2(150),
  attribute9                VARCHAR2(150),
  attribute10               VARCHAR2(150),
  attribute11               VARCHAR2(150),
  attribute12               VARCHAR2(150),
  attribute13               VARCHAR2(150),
  attribute14               VARCHAR2(150),
  attribute15               VARCHAR2(150),
  gl_sl_link_table          VARCHAR2(30),
  displayed_line_number     NUMBER(15),
  creation_date             DATE not null,
  created_by                NUMBER(15) not null,
  last_update_date          DATE not null,
  last_updated_by           NUMBER(15) not null,
  last_update_login         NUMBER(15),
  program_update_date       DATE,
  program_application_id    NUMBER(15),
  program_id                NUMBER(15),
  request_id                NUMBER(15),
  upg_batch_id              NUMBER(15),
  upg_tax_reference_id1     NUMBER(15),
  upg_tax_reference_id2     NUMBER(15),
  upg_tax_reference_id3     NUMBER(15),
  unrounded_accounted_dr    NUMBER,
  unrounded_accounted_cr    NUMBER,
  gain_or_loss_flag         VARCHAR2(1),
  unrounded_entered_dr      NUMBER,
  unrounded_entered_cr      NUMBER,
  substituted_ccid          NUMBER(15),
  business_class_code       VARCHAR2(30),
  mpa_accrual_entry_flag    VARCHAR2(1),
  encumbrance_type_id       NUMBER(15),
  funds_status_code         VARCHAR2(30),
  merge_code_combination_id NUMBER(15),
  merge_party_id            NUMBER(15),
  merge_party_site_id       NUMBER(15),
  accounting_date           DATE not null,
  ledger_id                 NUMBER(15) not null,
  source_table              VARCHAR2(30),
  source_id                 NUMBER(15),
  account_overlay_source_id NUMBER(15)
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
