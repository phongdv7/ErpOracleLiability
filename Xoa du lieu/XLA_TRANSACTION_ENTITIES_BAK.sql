-- Create table
--XLA_TRANSACTION_ENTITIES_BAK
create table BACKUP.EVN_XLA_TRANSACTION_ENTITIES
(
  ENTITY_ID                 NUMBER(15) not null,
  APPLICATION_ID            NUMBER(15) not null,
  LEGAL_ENTITY_ID           NUMBER(15),
  ENTITY_CODE               VARCHAR2(30) not null,
  CREATION_DATE             DATE not null,
  CREATED_BY                NUMBER(38) not null,
  LAST_UPDATE_DATE          DATE not null,
  LAST_UPDATED_BY           NUMBER(38) not null,
  LAST_UPDATE_LOGIN         NUMBER(38),
  SOURCE_ID_INT_1           NUMBER(38),
  SOURCE_ID_CHAR_1          VARCHAR2(30),
  SECURITY_ID_INT_1         NUMBER(38),
  SECURITY_ID_INT_2         NUMBER(38),
  SECURITY_ID_INT_3         NUMBER(38),
  SECURITY_ID_CHAR_1        VARCHAR2(30),
  SECURITY_ID_CHAR_2        VARCHAR2(30),
  SECURITY_ID_CHAR_3        VARCHAR2(30),
  SOURCE_ID_INT_2           NUMBER(38),
  SOURCE_ID_CHAR_2          VARCHAR2(30),
  SOURCE_ID_INT_3           NUMBER(38),
  SOURCE_ID_CHAR_3          VARCHAR2(30),
  SOURCE_ID_INT_4           NUMBER(38),
  SOURCE_ID_CHAR_4          VARCHAR2(30),
  TRANSACTION_NUMBER        VARCHAR2(240),
  LEDGER_ID                 NUMBER(15) not null,
  VALUATION_METHOD          VARCHAR2(30),
  SOURCE_APPLICATION_ID     NUMBER(15) not null,
  UPG_BATCH_ID              NUMBER(15),
  UPG_SOURCE_APPLICATION_ID NUMBER(15),
  UPG_VALID_FLAG            VARCHAR2(1)
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
