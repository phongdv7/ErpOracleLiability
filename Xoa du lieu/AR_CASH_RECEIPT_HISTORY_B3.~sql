-- Create table
create table BACKUP.EVN_AR_CASH_RECEIPT_HISTORY_B3
(
  CASH_RECEIPT_HISTORY_ID       NUMBER(15) not null,
  CASH_RECEIPT_ID               NUMBER(15) not null,
  STATUS                        VARCHAR2(30) not null,
  TRX_DATE                      DATE not null,
  AMOUNT                        NUMBER not null,
  FIRST_POSTED_RECORD_FLAG      VARCHAR2(1) not null,
  POSTABLE_FLAG                 VARCHAR2(1) not null,
  FACTOR_FLAG                   VARCHAR2(1) not null,
  GL_DATE                       DATE not null,
  CURRENT_RECORD_FLAG           VARCHAR2(1),
  BATCH_ID                      NUMBER(15),
  ACCOUNT_CODE_COMBINATION_ID   NUMBER(15),
  REVERSAL_GL_DATE              DATE,
  REVERSAL_CASH_RECEIPT_HIST_ID NUMBER(15),
  FACTOR_DISCOUNT_AMOUNT        NUMBER,
  BANK_CHARGE_ACCOUNT_CCID      NUMBER(15),
  POSTING_CONTROL_ID            NUMBER(15) not null,
  REVERSAL_POSTING_CONTROL_ID   NUMBER(15),
  GL_POSTED_DATE                DATE,
  REVERSAL_GL_POSTED_DATE       DATE,
  LAST_UPDATE_LOGIN             NUMBER(15),
  ACCTD_AMOUNT                  NUMBER not null,
  ACCTD_FACTOR_DISCOUNT_AMOUNT  NUMBER,
  CREATED_BY                    NUMBER(15) not null,
  CREATION_DATE                 DATE not null,
  EXCHANGE_DATE                 DATE,
  EXCHANGE_RATE                 NUMBER,
  EXCHANGE_RATE_TYPE            VARCHAR2(30),
  LAST_UPDATE_DATE              DATE not null,
  PROGRAM_APPLICATION_ID        NUMBER(15),
  PROGRAM_ID                    NUMBER(15),
  PROGRAM_UPDATE_DATE           DATE,
  REQUEST_ID                    NUMBER(15),
  LAST_UPDATED_BY               NUMBER(15) not null,
  PRV_STAT_CASH_RECEIPT_HIST_ID NUMBER(15),
  CREATED_FROM                  VARCHAR2(30) not null,
  REVERSAL_CREATED_FROM         VARCHAR2(30),
  ATTRIBUTE1                    VARCHAR2(150),
  ATTRIBUTE2                    VARCHAR2(150),
  ATTRIBUTE3                    VARCHAR2(150),
  ATTRIBUTE4                    VARCHAR2(150),
  ATTRIBUTE5                    VARCHAR2(150),
  ATTRIBUTE6                    VARCHAR2(150),
  ATTRIBUTE7                    VARCHAR2(150),
  ATTRIBUTE8                    VARCHAR2(150),
  ATTRIBUTE9                    VARCHAR2(150),
  ATTRIBUTE10                   VARCHAR2(150),
  ATTRIBUTE11                   VARCHAR2(150),
  ATTRIBUTE12                   VARCHAR2(150),
  ATTRIBUTE13                   VARCHAR2(150),
  ATTRIBUTE14                   VARCHAR2(150),
  ATTRIBUTE15                   VARCHAR2(150),
  ATTRIBUTE_CATEGORY            VARCHAR2(30),
  NOTE_STATUS                   VARCHAR2(30),
  ORG_ID                        NUMBER(15),
  MRC_POSTING_CONTROL_ID        VARCHAR2(2000),
  MRC_GL_POSTED_DATE            VARCHAR2(2000),
  MRC_REVERSAL_GL_POSTED_DATE   VARCHAR2(2000),
  MRC_ACCTD_AMOUNT              VARCHAR2(2000),
  MRC_ACCTD_FACTOR_DISC_AMOUNT  VARCHAR2(2000),
  MRC_EXCHANGE_DATE             VARCHAR2(2000),
  MRC_EXCHANGE_RATE             VARCHAR2(2000),
  MRC_EXCHANGE_RATE_TYPE        VARCHAR2(2000),
  EVENT_ID                      NUMBER(15)
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
