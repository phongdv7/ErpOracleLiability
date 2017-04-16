-- Create table
create table BACKUP.EVN_RA_CUST_TRX_LINE_SALE_B3
(
  cust_trx_line_salesrep_id      NUMBER(15) not null,
  last_update_date               DATE not null,
  last_updated_by                NUMBER(15) not null,
  creation_date                  DATE not null,
  created_by                     NUMBER(15) not null,
  last_update_login              NUMBER(15),
  customer_trx_id                NUMBER(15) not null,
  salesrep_id                    NUMBER(15) not null,
  customer_trx_line_id           NUMBER(15),
  revenue_amount_split           NUMBER,
  non_revenue_amount_split       NUMBER,
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
  non_revenue_percent_split      NUMBER,
  revenue_percent_split          NUMBER,
  original_line_salesrep_id      NUMBER(15),
  prev_cust_trx_line_salesrep_id NUMBER(15),
  attribute11                    VARCHAR2(150),
  attribute12                    VARCHAR2(150),
  attribute13                    VARCHAR2(150),
  attribute14                    VARCHAR2(150),
  attribute15                    VARCHAR2(150),
  org_id                         NUMBER(15),
  wh_update_date                 DATE,
  revenue_adjustment_id          NUMBER(15),
  revenue_salesgroup_id          NUMBER,
  non_revenue_salesgroup_id      NUMBER
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
