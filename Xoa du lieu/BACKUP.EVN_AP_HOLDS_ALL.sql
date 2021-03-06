-- Create table
create table BACKUP.EVN_AP_HOLDS_ALL
(
  invoice_id          NUMBER(15) not null,
  line_location_id    NUMBER(15),
  hold_lookup_code    VARCHAR2(25) not null,
  last_update_date    DATE not null,
  last_updated_by     NUMBER(15) not null,
  held_by             NUMBER(15) not null,
  hold_date           DATE not null,
  hold_reason         VARCHAR2(240),
  release_lookup_code VARCHAR2(25),
  release_reason      VARCHAR2(240),
  status_flag         VARCHAR2(25),
  last_update_login   NUMBER(15),
  creation_date       DATE,
  created_by          NUMBER(15),
  attribute_category  VARCHAR2(150),
  attribute1          VARCHAR2(150),
  attribute2          VARCHAR2(150),
  attribute3          VARCHAR2(150),
  attribute4          VARCHAR2(150),
  attribute5          VARCHAR2(150),
  attribute6          VARCHAR2(150),
  attribute7          VARCHAR2(150),
  attribute8          VARCHAR2(150),
  attribute9          VARCHAR2(150),
  attribute10         VARCHAR2(150),
  attribute11         VARCHAR2(150),
  attribute12         VARCHAR2(150),
  attribute13         VARCHAR2(150),
  attribute14         VARCHAR2(150),
  attribute15         VARCHAR2(150),
  org_id              NUMBER(15),
  responsibility_id   NUMBER(15),
  rcv_transaction_id  NUMBER,
  hold_details        VARCHAR2(2000),
  line_number         NUMBER,
  hold_id             NUMBER(15) not null,
  wf_status           VARCHAR2(30)
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
