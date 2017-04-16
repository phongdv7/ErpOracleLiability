-- Create table
create table backup.EVN_RA_CUST_TRX_LINE_GL_B3
(
  CUST_TRX_LINE_GL_DIST_ID       NUMBER(15) not null,
  CUSTOMER_TRX_LINE_ID           NUMBER(15),
  CODE_COMBINATION_ID            NUMBER(15) not null,
  SET_OF_BOOKS_ID                NUMBER(15) not null,
  LAST_UPDATE_DATE               DATE not null,
  LAST_UPDATED_BY                NUMBER(15) not null,
  CREATION_DATE                  DATE not null,
  CREATED_BY                     NUMBER(15) not null,
  LAST_UPDATE_LOGIN              NUMBER(15),
  PERCENT                        NUMBER,
  AMOUNT                         NUMBER,
  GL_DATE                        DATE,
  GL_POSTED_DATE                 DATE,
  CUST_TRX_LINE_SALESREP_ID      NUMBER(15),
  COMMENTS                       VARCHAR2(240),
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
  REQUEST_ID                     NUMBER(15),
  PROGRAM_APPLICATION_ID         NUMBER(15),
  PROGRAM_ID                     NUMBER(15),
  PROGRAM_UPDATE_DATE            DATE,
  CONCATENATED_SEGMENTS          VARCHAR2(240),
  ORIGINAL_GL_DATE               DATE,
  POST_REQUEST_ID                NUMBER(15),
  POSTING_CONTROL_ID             NUMBER(15) not null,
  ACCOUNT_CLASS                  VARCHAR2(20) not null,
  RA_POST_LOOP_NUMBER            NUMBER(15),
  CUSTOMER_TRX_ID                NUMBER(15) not null,
  ACCOUNT_SET_FLAG               VARCHAR2(1) not null,
  ACCTD_AMOUNT                   NUMBER,
  USSGL_TRANSACTION_CODE         VARCHAR2(30),
  USSGL_TRANSACTION_CODE_CONTEXT VARCHAR2(30),
  ATTRIBUTE11                    VARCHAR2(150),
  ATTRIBUTE12                    VARCHAR2(150),
  ATTRIBUTE13                    VARCHAR2(150),
  ATTRIBUTE14                    VARCHAR2(150),
  ATTRIBUTE15                    VARCHAR2(150),
  LATEST_REC_FLAG                VARCHAR2(1),
  ORG_ID                         NUMBER(15),
  MRC_ACCOUNT_CLASS              VARCHAR2(2000),
  MRC_CUSTOMER_TRX_ID            VARCHAR2(2000),
  MRC_AMOUNT                     VARCHAR2(2000),
  MRC_GL_POSTED_DATE             VARCHAR2(2000),
  MRC_POSTING_CONTROL_ID         VARCHAR2(2000),
  MRC_ACCTD_AMOUNT               VARCHAR2(2000),
  COLLECTED_TAX_CCID             NUMBER(15),
  COLLECTED_TAX_CONCAT_SEG       VARCHAR2(240),
  REVENUE_ADJUSTMENT_ID          NUMBER(15),
  REV_ADJ_CLASS_TEMP             VARCHAR2(30),
  REC_OFFSET_FLAG                VARCHAR2(1),
  EVENT_ID                       NUMBER(15),
  USER_GENERATED_FLAG            VARCHAR2(1),
  ROUNDING_CORRECTION_FLAG       VARCHAR2(1),
  COGS_REQUEST_ID                NUMBER(15),
  CCID_CHANGE_FLAG               VARCHAR2(1)
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
