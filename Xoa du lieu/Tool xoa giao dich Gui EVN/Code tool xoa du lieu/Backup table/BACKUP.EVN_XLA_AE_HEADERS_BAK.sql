-- Create table
create table BACKUP.EVN_XLA_AE_HEADERS_BAK
(
  ae_header_id                   NUMBER(15) not null,
  application_id                 NUMBER(15) not null,
  ledger_id                      NUMBER(15) not null,
  entity_id                      NUMBER(15) not null,
  event_id                       NUMBER(15) not null,
  event_type_code                VARCHAR2(30) not null,
  accounting_date                DATE not null,
  gl_transfer_status_code        VARCHAR2(30) not null,
  gl_transfer_date               DATE,
  je_category_name               VARCHAR2(30) not null,
  accounting_entry_status_code   VARCHAR2(30) not null,
  accounting_entry_type_code     VARCHAR2(30) not null,
  amb_context_code               VARCHAR2(30),
  product_rule_type_code         VARCHAR2(1),
  product_rule_code              VARCHAR2(30),
  product_rule_version           VARCHAR2(30),
  description                    VARCHAR2(1996),
  doc_sequence_id                NUMBER,
  doc_sequence_value             NUMBER,
  accounting_batch_id            NUMBER(15),
  completion_acct_seq_version_id NUMBER(15),
  close_acct_seq_version_id      NUMBER(15),
  completion_acct_seq_value      NUMBER,
  close_acct_seq_value           NUMBER,
  budget_version_id              NUMBER(15),
  funds_status_code              VARCHAR2(30),
  encumbrance_type_id            NUMBER(15),
  balance_type_code              VARCHAR2(1) not null,
  reference_date                 DATE,
  completed_date                 DATE,
  period_name                    VARCHAR2(15),
  packet_id                      NUMBER(15),
  completion_acct_seq_assign_id  NUMBER(15),
  close_acct_seq_assign_id       NUMBER(15),
  doc_category_code              VARCHAR2(30),
  attribute_category             VARCHAR2(30),
  attribute1                     VARCHAR2(150),
  attribute2                     VARCHAR2(150),
  attribute3                     VARCHAR2(150),
  attribute4                     VARCHAR2(150),
  attribute5                     VARCHAR2(150),
  attribute6                     VARCHAR2(150),
  attribute7                     VARCHAR2(150),
  attribute8                     VARCHAR2(150),
  attribute9                     VARCHAR2(150),
  attribute10                    VARCHAR2(150),
  attribute11                    VARCHAR2(150),
  attribute12                    VARCHAR2(150),
  attribute13                    VARCHAR2(150),
  attribute14                    VARCHAR2(150),
  attribute15                    VARCHAR2(150),
  group_id                       NUMBER(15),
  doc_sequence_version_id        NUMBER(15),
  doc_sequence_assign_id         NUMBER(15),
  creation_date                  DATE not null,
  created_by                     NUMBER(15) not null,
  last_update_date               DATE not null,
  last_updated_by                NUMBER(15) not null,
  last_update_login              NUMBER(15),
  program_update_date            DATE,
  program_application_id         NUMBER(15),
  program_id                     NUMBER(15),
  request_id                     NUMBER(15),
  upg_batch_id                   NUMBER(15),
  upg_source_application_id      NUMBER(15),
  upg_valid_flag                 VARCHAR2(1),
  zero_amount_flag               VARCHAR2(1),
  parent_ae_header_id            NUMBER(15),
  parent_ae_line_num             NUMBER(15),
  accrual_reversal_flag          VARCHAR2(1),
  merge_event_id                 NUMBER(15),
  need_bal_flag                  VARCHAR2(1)
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
