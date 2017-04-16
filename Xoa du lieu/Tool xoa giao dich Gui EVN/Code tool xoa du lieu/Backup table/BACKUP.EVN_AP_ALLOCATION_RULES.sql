-- Create table
create table BACKUP.EVN_AP_ALLOCATION_RULES
(
  invoice_id               NUMBER(15) not null,
  chrg_invoice_line_number NUMBER not null,
  rule_type                VARCHAR2(30) not null,
  rule_generation_type     VARCHAR2(30) not null,
  status                   VARCHAR2(30),
  creation_date            DATE,
  created_by               NUMBER(15),
  last_updated_by          NUMBER(15) not null,
  last_update_date         DATE not null,
  last_update_login        NUMBER(15),
  program_application_id   NUMBER(15),
  program_id               NUMBER(15),
  program_update_date      DATE,
  request_id               NUMBER(15)
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
