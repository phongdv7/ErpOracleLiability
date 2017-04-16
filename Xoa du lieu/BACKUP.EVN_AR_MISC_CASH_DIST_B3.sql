-- Create table
create table BACKUP.EVN_AR_MISC_CASH_DIST_B3
(
  misc_cash_distribution_id      NUMBER(15) not null,
  last_updated_by                NUMBER(15) not null,
  last_update_date               DATE not null,
  last_update_login              NUMBER(15),
  created_by                     NUMBER(15) not null,
  creation_date                  DATE not null,
  cash_receipt_id                NUMBER(15) not null,
  code_combination_id            NUMBER(15) not null,
  set_of_books_id                NUMBER(15) not null,
  gl_date                        DATE not null,
  percent                        NUMBER(19,3),
  amount                         NUMBER not null,
  comments                       VARCHAR2(240),
  gl_posted_date                 DATE,
  apply_date                     DATE not null,
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
  posting_control_id             NUMBER not null,
  acctd_amount                   NUMBER not null,
  attribute11                    VARCHAR2(150),
  attribute12                    VARCHAR2(150),
  attribute13                    VARCHAR2(150),
  attribute14                    VARCHAR2(150),
  attribute15                    VARCHAR2(150),
  program_application_id         NUMBER(15),
  program_id                     NUMBER(15),
  program_update_date            DATE,
  request_id                     NUMBER(15),
  ussgl_transaction_code         VARCHAR2(30),
  ussgl_transaction_code_context VARCHAR2(30),
  created_from                   VARCHAR2(30) not null,
  reversal_gl_date               DATE,
  org_id                         NUMBER(15),
  mrc_gl_posted_date             VARCHAR2(2000),
  mrc_posting_control_id         VARCHAR2(2000),
  mrc_acctd_amount               VARCHAR2(2000),
  event_id                       NUMBER(15),
  cash_receipt_history_id        NUMBER(15)
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
