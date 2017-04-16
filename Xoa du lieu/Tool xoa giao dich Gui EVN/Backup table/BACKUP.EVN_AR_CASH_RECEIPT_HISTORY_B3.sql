-- Create table
create table BACKUP.EVN_AR_CASH_RECEIPT_HISTORY_B3
(
  cash_receipt_history_id       NUMBER(15) not null,
  cash_receipt_id               NUMBER(15) not null,
  status                        VARCHAR2(30) not null,
  trx_date                      DATE not null,
  amount                        NUMBER not null,
  first_posted_record_flag      VARCHAR2(1) not null,
  postable_flag                 VARCHAR2(1) not null,
  factor_flag                   VARCHAR2(1) not null,
  gl_date                       DATE not null,
  current_record_flag           VARCHAR2(1),
  batch_id                      NUMBER(15),
  account_code_combination_id   NUMBER(15),
  reversal_gl_date              DATE,
  reversal_cash_receipt_hist_id NUMBER(15),
  factor_discount_amount        NUMBER,
  bank_charge_account_ccid      NUMBER(15),
  posting_control_id            NUMBER(15) not null,
  reversal_posting_control_id   NUMBER(15),
  gl_posted_date                DATE,
  reversal_gl_posted_date       DATE,
  last_update_login             NUMBER(15),
  acctd_amount                  NUMBER not null,
  acctd_factor_discount_amount  NUMBER,
  created_by                    NUMBER(15) not null,
  creation_date                 DATE not null,
  exchange_date                 DATE,
  exchange_rate                 NUMBER,
  exchange_rate_type            VARCHAR2(30),
  last_update_date              DATE not null,
  program_application_id        NUMBER(15),
  program_id                    NUMBER(15),
  program_update_date           DATE,
  request_id                    NUMBER(15),
  last_updated_by               NUMBER(15) not null,
  prv_stat_cash_receipt_hist_id NUMBER(15),
  created_from                  VARCHAR2(30) not null,
  reversal_created_from         VARCHAR2(30),
  attribute1                    VARCHAR2(150),
  attribute2                    VARCHAR2(150),
  attribute3                    VARCHAR2(150),
  attribute4                    VARCHAR2(150),
  attribute5                    VARCHAR2(150),
  attribute6                    VARCHAR2(150),
  attribute7                    VARCHAR2(150),
  attribute8                    VARCHAR2(150),
  attribute9                    VARCHAR2(150),
  attribute10                   VARCHAR2(150),
  attribute11                   VARCHAR2(150),
  attribute12                   VARCHAR2(150),
  attribute13                   VARCHAR2(150),
  attribute14                   VARCHAR2(150),
  attribute15                   VARCHAR2(150),
  attribute_category            VARCHAR2(30),
  note_status                   VARCHAR2(30),
  org_id                        NUMBER(15),
  mrc_posting_control_id        VARCHAR2(2000),
  mrc_gl_posted_date            VARCHAR2(2000),
  mrc_reversal_gl_posted_date   VARCHAR2(2000),
  mrc_acctd_amount              VARCHAR2(2000),
  mrc_acctd_factor_disc_amount  VARCHAR2(2000),
  mrc_exchange_date             VARCHAR2(2000),
  mrc_exchange_rate             VARCHAR2(2000),
  mrc_exchange_rate_type        VARCHAR2(2000),
  event_id                      NUMBER(15)
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
