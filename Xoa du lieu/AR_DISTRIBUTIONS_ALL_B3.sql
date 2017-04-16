--drop table AR_DISTRIBUTIONS_ALL_B3
-- Create table
create table BACKUP.EVN_AR_DISTRIBUTIONS_ALL_B3
(
  LINE_ID                      NUMBER(15) not null,
  SOURCE_ID                    NUMBER(15) not null,
  SOURCE_TABLE                 VARCHAR2(10) not null,
  SOURCE_TYPE                  VARCHAR2(30) not null,
  CODE_COMBINATION_ID          NUMBER(15) not null,
  AMOUNT_DR                    NUMBER,
  AMOUNT_CR                    NUMBER,
  ACCTD_AMOUNT_DR              NUMBER,
  ACCTD_AMOUNT_CR              NUMBER,
  CREATION_DATE                DATE not null,
  CREATED_BY                   NUMBER(15) not null,
  LAST_UPDATED_BY              NUMBER(15) not null,
  LAST_UPDATE_DATE             DATE not null,
  LAST_UPDATE_LOGIN            NUMBER(15),
  ORG_ID                       NUMBER(15),
  SOURCE_TABLE_SECONDARY       VARCHAR2(10),
  SOURCE_ID_SECONDARY          NUMBER(15),
  CURRENCY_CODE                VARCHAR2(15),
  CURRENCY_CONVERSION_RATE     NUMBER,
  CURRENCY_CONVERSION_TYPE     VARCHAR2(30),
  CURRENCY_CONVERSION_DATE     DATE,
  TAXABLE_ENTERED_DR           NUMBER,
  TAXABLE_ENTERED_CR           NUMBER,
  TAXABLE_ACCOUNTED_DR         NUMBER,
  TAXABLE_ACCOUNTED_CR         NUMBER,
  TAX_LINK_ID                  NUMBER(15),
  THIRD_PARTY_ID               NUMBER(15),
  THIRD_PARTY_SUB_ID           NUMBER(15),
  REVERSED_SOURCE_ID           NUMBER(15),
  TAX_CODE_ID                  NUMBER(15),
  LOCATION_SEGMENT_ID          NUMBER(15),
  SOURCE_TYPE_SECONDARY        VARCHAR2(30),
  TAX_GROUP_CODE_ID            NUMBER(15),
  REF_CUSTOMER_TRX_LINE_ID     NUMBER(15),
  REF_CUST_TRX_LINE_GL_DIST_ID NUMBER(15),
  REF_ACCOUNT_CLASS            VARCHAR2(30),
  ACTIVITY_BUCKET              VARCHAR2(30),
  REF_LINE_ID                  NUMBER(15),
  FROM_AMOUNT_DR               NUMBER,
  FROM_AMOUNT_CR               NUMBER,
  FROM_ACCTD_AMOUNT_DR         NUMBER,
  FROM_ACCTD_AMOUNT_CR         NUMBER,
  REF_MF_DIST_FLAG             VARCHAR2(1),
  REF_DIST_CCID                NUMBER(15)/*,
  REF_PREV_CUST_TRX_LINE_ID    NUMBER(15)*/
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
