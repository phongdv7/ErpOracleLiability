-- Create table
--AR_MISC_CASH_DISTRIBUTIONS_B3
create table BACKUP.EVN_AR_MISC_CASH_DIST_B3
(
  MISC_CASH_DISTRIBUTION_ID      NUMBER(15) not null,
  LAST_UPDATED_BY                NUMBER(15) not null,
  LAST_UPDATE_DATE               DATE not null,
  LAST_UPDATE_LOGIN              NUMBER(15),
  CREATED_BY                     NUMBER(15) not null,
  CREATION_DATE                  DATE not null,
  CASH_RECEIPT_ID                NUMBER(15) not null,
  CODE_COMBINATION_ID            NUMBER(15) not null,
  SET_OF_BOOKS_ID                NUMBER(15) not null,
  GL_DATE                        DATE not null,
  PERCENT                        NUMBER(19,3),
  AMOUNT                         NUMBER not null,
  COMMENTS                       VARCHAR2(240),
  GL_POSTED_DATE                 DATE,
  APPLY_DATE                     DATE not null,
  ATTRIBUTE_CATEGORY             VARCHAR2(30),
  ATTRIBUTE1                     VARCHAR2(150),
  ATTRIBUTE2                     VARCHAR2(150),
  ATTRIBUTE3                     VARCHAR2(150),
  ATTRIBUTE4                     VARCHAR2(150),
  ATTRIBUTE5                     VARCHAR2(150),
  ATTRIBUTE6                     VARCHAR2(150),
  ATTRIBUTE7                     VARCHAR2(150),
  ATTRIBUTE8                     VARCHAR2(150),
  ATTRIBUTE9                     VARCHAR2(150),
  ATTRIBUTE10                    VARCHAR2(150),
  POSTING_CONTROL_ID             NUMBER not null,
  ACCTD_AMOUNT                   NUMBER not null,
  ATTRIBUTE11                    VARCHAR2(150),
  ATTRIBUTE12                    VARCHAR2(150),
  ATTRIBUTE13                    VARCHAR2(150),
  ATTRIBUTE14                    VARCHAR2(150),
  ATTRIBUTE15                    VARCHAR2(150),
  PROGRAM_APPLICATION_ID         NUMBER(15),
  PROGRAM_ID                     NUMBER(15),
  PROGRAM_UPDATE_DATE            DATE,
  REQUEST_ID                     NUMBER(15),
  USSGL_TRANSACTION_CODE         VARCHAR2(30),
  USSGL_TRANSACTION_CODE_CONTEXT VARCHAR2(30),
  CREATED_FROM                   VARCHAR2(30) not null,
  REVERSAL_GL_DATE               DATE,
  ORG_ID                         NUMBER(15),
  MRC_GL_POSTED_DATE             VARCHAR2(2000),
  MRC_POSTING_CONTROL_ID         VARCHAR2(2000),
  MRC_ACCTD_AMOUNT               VARCHAR2(2000),
  EVENT_ID                       NUMBER(15),
  CASH_RECEIPT_HISTORY_ID        NUMBER(15)
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
