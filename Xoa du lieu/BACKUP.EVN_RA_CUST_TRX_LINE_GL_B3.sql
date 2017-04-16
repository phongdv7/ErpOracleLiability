-- Create table
create table BACKUP.EVN_RA_CUST_TRX_LINE_GL_B3
(
  cust_trx_line_gl_dist_id       NUMBER(15) not null,
  customer_trx_line_id           NUMBER(15),
  code_combination_id            NUMBER(15) not null,
  set_of_books_id                NUMBER(15) not null,
  last_update_date               DATE not null,
  last_updated_by                NUMBER(15) not null,
  creation_date                  DATE not null,
  created_by                     NUMBER(15) not null,
  last_update_login              NUMBER(15),
  percent                        NUMBER,
  amount                         NUMBER,
  gl_date                        DATE,
  gl_posted_date                 DATE,
  cust_trx_line_salesrep_id      NUMBER(15),
  comments                       VARCHAR2(240),
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
  request_id                     NUMBER(15),
  program_application_id         NUMBER(15),
  program_id                     NUMBER(15),
  program_update_date            DATE,
  concatenated_segments          VARCHAR2(240),
  original_gl_date               DATE,
  post_request_id                NUMBER(15),
  posting_control_id             NUMBER(15) not null,
  account_class                  VARCHAR2(20) not null,
  ra_post_loop_number            NUMBER(15),
  customer_trx_id                NUMBER(15) not null,
  account_set_flag               VARCHAR2(1) not null,
  acctd_amount                   NUMBER,
  ussgl_transaction_code         VARCHAR2(30),
  ussgl_transaction_code_context VARCHAR2(30),
  attribute11                    VARCHAR2(150),
  attribute12                    VARCHAR2(150),
  attribute13                    VARCHAR2(150),
  attribute14                    VARCHAR2(150),
  attribute15                    VARCHAR2(150),
  latest_rec_flag                VARCHAR2(1),
  org_id                         NUMBER(15),
  mrc_account_class              VARCHAR2(2000),
  mrc_customer_trx_id            VARCHAR2(2000),
  mrc_amount                     VARCHAR2(2000),
  mrc_gl_posted_date             VARCHAR2(2000),
  mrc_posting_control_id         VARCHAR2(2000),
  mrc_acctd_amount               VARCHAR2(2000),
  collected_tax_ccid             NUMBER(15),
  collected_tax_concat_seg       VARCHAR2(240),
  revenue_adjustment_id          NUMBER(15),
  rev_adj_class_temp             VARCHAR2(30),
  rec_offset_flag                VARCHAR2(1),
  event_id                       NUMBER(15),
  user_generated_flag            VARCHAR2(1),
  rounding_correction_flag       VARCHAR2(1),
  cogs_request_id                NUMBER(15),
  ccid_change_flag               VARCHAR2(1)
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
