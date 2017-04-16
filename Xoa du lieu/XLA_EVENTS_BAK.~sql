-- Create table
create table backup.EVN_XLA_EVENTS_BAK
(
  EVENT_ID                  NUMBER(15) not null,
  APPLICATION_ID            NUMBER(15) not null,
  EVENT_TYPE_CODE           VARCHAR2(30) not null,
  EVENT_DATE                DATE not null,
  ENTITY_ID                 NUMBER(15) not null,
  EVENT_STATUS_CODE         VARCHAR2(1) not null,
  PROCESS_STATUS_CODE       VARCHAR2(1) not null,
  REFERENCE_NUM_1           NUMBER,
  REFERENCE_NUM_2           NUMBER,
  REFERENCE_NUM_3           NUMBER,
  REFERENCE_NUM_4           NUMBER,
  REFERENCE_CHAR_1          VARCHAR2(240),
  REFERENCE_CHAR_2          VARCHAR2(240),
  REFERENCE_CHAR_3          VARCHAR2(240),
  REFERENCE_CHAR_4          VARCHAR2(240),
  REFERENCE_DATE_1          DATE,
  REFERENCE_DATE_2          DATE,
  REFERENCE_DATE_3          DATE,
  REFERENCE_DATE_4          DATE,
  EVENT_NUMBER              NUMBER(38) not null,
  ON_HOLD_FLAG              VARCHAR2(1) not null,
  CREATION_DATE             DATE not null,
  CREATED_BY                NUMBER(15) not null,
  LAST_UPDATE_DATE          DATE not null,
  LAST_UPDATED_BY           NUMBER(15) not null,
  LAST_UPDATE_LOGIN         NUMBER(15),
  PROGRAM_UPDATE_DATE       DATE,
  PROGRAM_APPLICATION_ID    NUMBER(15),
  PROGRAM_ID                NUMBER(15),
  REQUEST_ID                NUMBER(15),
  UPG_BATCH_ID              NUMBER(15),
  UPG_SOURCE_APPLICATION_ID NUMBER(15),
  UPG_VALID_FLAG            VARCHAR2(1),
  TRANSACTION_DATE          DATE not null,
  BUDGETARY_CONTROL_FLAG    VARCHAR2(1),
  MERGE_EVENT_SET_ID        NUMBER(15)
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
