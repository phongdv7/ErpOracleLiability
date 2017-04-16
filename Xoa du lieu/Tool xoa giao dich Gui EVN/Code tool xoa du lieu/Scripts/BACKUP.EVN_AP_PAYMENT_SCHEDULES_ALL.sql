-- Create table
create table BACKUP.EVN_AP_PAYMENT_SCHEDULES_ALL
(
  invoice_id                 NUMBER(15) not null,
  last_updated_by            NUMBER(15) not null,
  last_update_date           DATE not null,
  payment_cross_rate         NUMBER not null,
  payment_num                NUMBER(15) not null,
  amount_remaining           NUMBER,
  created_by                 NUMBER(15),
  creation_date              DATE,
  discount_date              DATE,
  due_date                   DATE,
  future_pay_due_date        DATE,
  gross_amount               NUMBER,
  hold_flag                  VARCHAR2(1),
  last_update_login          NUMBER(15),
  payment_method_lookup_code VARCHAR2(25),
  payment_priority           NUMBER(2),
  payment_status_flag        VARCHAR2(25),
  second_discount_date       DATE,
  third_discount_date        DATE,
  batch_id                   NUMBER(15),
  discount_amount_available  NUMBER,
  second_disc_amt_available  NUMBER,
  third_disc_amt_available   NUMBER,
  attribute1                 VARCHAR2(150),
  attribute10                VARCHAR2(150),
  attribute11                VARCHAR2(150),
  attribute12                VARCHAR2(150),
  attribute13                VARCHAR2(150),
  attribute14                VARCHAR2(150),
  attribute15                VARCHAR2(150),
  attribute2                 VARCHAR2(150),
  attribute3                 VARCHAR2(150),
  attribute4                 VARCHAR2(150),
  attribute5                 VARCHAR2(150),
  attribute6                 VARCHAR2(150),
  attribute7                 VARCHAR2(150),
  attribute8                 VARCHAR2(150),
  attribute9                 VARCHAR2(150),
  attribute_category         VARCHAR2(150),
  discount_amount_remaining  NUMBER,
  org_id                     NUMBER(15),
  global_attribute_category  VARCHAR2(150),
  global_attribute1          VARCHAR2(150),
  global_attribute2          VARCHAR2(150),
  global_attribute3          VARCHAR2(150),
  global_attribute4          VARCHAR2(150),
  global_attribute5          VARCHAR2(150),
  global_attribute6          VARCHAR2(150),
  global_attribute7          VARCHAR2(150),
  global_attribute8          VARCHAR2(150),
  global_attribute9          VARCHAR2(150),
  global_attribute10         VARCHAR2(150),
  global_attribute11         VARCHAR2(150),
  global_attribute12         VARCHAR2(150),
  global_attribute13         VARCHAR2(150),
  global_attribute14         VARCHAR2(150),
  global_attribute15         VARCHAR2(150),
  global_attribute16         VARCHAR2(150),
  global_attribute17         VARCHAR2(150),
  global_attribute18         VARCHAR2(150),
  global_attribute19         VARCHAR2(150),
  global_attribute20         VARCHAR2(150),
  external_bank_account_id   NUMBER(15),
  inv_curr_gross_amount      NUMBER,
  checkrun_id                NUMBER(15),
  dbi_events_complete_flag   VARCHAR2(1) default 'N',
  iby_hold_reason            VARCHAR2(2000),
  payment_method_code        VARCHAR2(30),
  remittance_message1        VARCHAR2(150),
  remittance_message2        VARCHAR2(150),
  remittance_message3        VARCHAR2(150),
  remit_to_supplier_name     VARCHAR2(240),
  remit_to_supplier_id       NUMBER(15),
  remit_to_supplier_site     VARCHAR2(240),
  remit_to_supplier_site_id  NUMBER(15),
  relationship_id            NUMBER(15)
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