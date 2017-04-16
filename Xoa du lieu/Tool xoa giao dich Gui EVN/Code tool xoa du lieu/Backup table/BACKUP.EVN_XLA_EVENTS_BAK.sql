-- Create table
create table BACKUP.EVN_XLA_EVENTS_BAK
(
  event_id                  NUMBER(15) not null,
  application_id            NUMBER(15) not null,
  event_type_code           VARCHAR2(30) not null,
  event_date                DATE not null,
  entity_id                 NUMBER(15) not null,
  event_status_code         VARCHAR2(1) not null,
  process_status_code       VARCHAR2(1) not null,
  reference_num_1           NUMBER,
  reference_num_2           NUMBER,
  reference_num_3           NUMBER,
  reference_num_4           NUMBER,
  reference_char_1          VARCHAR2(240),
  reference_char_2          VARCHAR2(240),
  reference_char_3          VARCHAR2(240),
  reference_char_4          VARCHAR2(240),
  reference_date_1          DATE,
  reference_date_2          DATE,
  reference_date_3          DATE,
  reference_date_4          DATE,
  event_number              NUMBER(38) not null,
  on_hold_flag              VARCHAR2(1) not null,
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
  upg_source_application_id NUMBER(15),
  upg_valid_flag            VARCHAR2(1),
  transaction_date          DATE not null,
  budgetary_control_flag    VARCHAR2(1),
  merge_event_set_id        NUMBER(15)
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
