-- Create table
create table BACKUP.EVN_XLA_TRANSACTION_ENTITIES
(
  entity_id                 NUMBER(15) not null,
  application_id            NUMBER(15) not null,
  legal_entity_id           NUMBER(15),
  entity_code               VARCHAR2(30) not null,
  creation_date             DATE not null,
  created_by                NUMBER(38) not null,
  last_update_date          DATE not null,
  last_updated_by           NUMBER(38) not null,
  last_update_login         NUMBER(38),
  source_id_int_1           NUMBER(38),
  source_id_char_1          VARCHAR2(30),
  security_id_int_1         NUMBER(38),
  security_id_int_2         NUMBER(38),
  security_id_int_3         NUMBER(38),
  security_id_char_1        VARCHAR2(30),
  security_id_char_2        VARCHAR2(30),
  security_id_char_3        VARCHAR2(30),
  source_id_int_2           NUMBER(38),
  source_id_char_2          VARCHAR2(30),
  source_id_int_3           NUMBER(38),
  source_id_char_3          VARCHAR2(30),
  source_id_int_4           NUMBER(38),
  source_id_char_4          VARCHAR2(30),
  transaction_number        VARCHAR2(240),
  ledger_id                 NUMBER(15) not null,
  valuation_method          VARCHAR2(30),
  source_application_id     NUMBER(15) not null,
  upg_batch_id              NUMBER(15),
  upg_source_application_id NUMBER(15),
  upg_valid_flag            VARCHAR2(1)
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
