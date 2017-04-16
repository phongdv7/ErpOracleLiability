-- Create table
create table backup.EVN_XLA_AE_HEADERS_BAK
(
  AE_HEADER_ID                   NUMBER(15) not null,
  APPLICATION_ID                 NUMBER(15) not null,
  LEDGER_ID                      NUMBER(15) not null,
  ENTITY_ID                      NUMBER(15) not null,
  EVENT_ID                       NUMBER(15) not null,
  EVENT_TYPE_CODE                VARCHAR2(30) not null,
  ACCOUNTING_DATE                DATE not null,
  GL_TRANSFER_STATUS_CODE        VARCHAR2(30) not null,
  GL_TRANSFER_DATE               DATE,
  JE_CATEGORY_NAME               VARCHAR2(30) not null,
  ACCOUNTING_ENTRY_STATUS_CODE   VARCHAR2(30) not null,
  ACCOUNTING_ENTRY_TYPE_CODE     VARCHAR2(30) not null,
  AMB_CONTEXT_CODE               VARCHAR2(30),
  PRODUCT_RULE_TYPE_CODE         VARCHAR2(1),
  PRODUCT_RULE_CODE              VARCHAR2(30),
  PRODUCT_RULE_VERSION           VARCHAR2(30),
  DESCRIPTION                    VARCHAR2(1996),
  DOC_SEQUENCE_ID                NUMBER,
  DOC_SEQUENCE_VALUE             NUMBER,
  ACCOUNTING_BATCH_ID            NUMBER(15),
  COMPLETION_ACCT_SEQ_VERSION_ID NUMBER(15),
  CLOSE_ACCT_SEQ_VERSION_ID      NUMBER(15),
  COMPLETION_ACCT_SEQ_VALUE      NUMBER,
  CLOSE_ACCT_SEQ_VALUE           NUMBER,
  BUDGET_VERSION_ID              NUMBER(15),
  FUNDS_STATUS_CODE              VARCHAR2(30),
  ENCUMBRANCE_TYPE_ID            NUMBER(15),
  BALANCE_TYPE_CODE              VARCHAR2(1) not null,
  REFERENCE_DATE                 DATE,
  COMPLETED_DATE                 DATE,
  PERIOD_NAME                    VARCHAR2(15),
  PACKET_ID                      NUMBER(15),
  COMPLETION_ACCT_SEQ_ASSIGN_ID  NUMBER(15),
  CLOSE_ACCT_SEQ_ASSIGN_ID       NUMBER(15),
  DOC_CATEGORY_CODE              VARCHAR2(30),
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
  ATTRIBUTE11                    VARCHAR2(150),
  ATTRIBUTE12                    VARCHAR2(150),
  ATTRIBUTE13                    VARCHAR2(150),
  ATTRIBUTE14                    VARCHAR2(150),
  ATTRIBUTE15                    VARCHAR2(150),
  GROUP_ID                       NUMBER(15),
  DOC_SEQUENCE_VERSION_ID        NUMBER(15),
  DOC_SEQUENCE_ASSIGN_ID         NUMBER(15),
  CREATION_DATE                  DATE not null,
  CREATED_BY                     NUMBER(15) not null,
  LAST_UPDATE_DATE               DATE not null,
  LAST_UPDATED_BY                NUMBER(15) not null,
  LAST_UPDATE_LOGIN              NUMBER(15),
  PROGRAM_UPDATE_DATE            DATE,
  PROGRAM_APPLICATION_ID         NUMBER(15),
  PROGRAM_ID                     NUMBER(15),
  REQUEST_ID                     NUMBER(15),
  UPG_BATCH_ID                   NUMBER(15),
  UPG_SOURCE_APPLICATION_ID      NUMBER(15),
  UPG_VALID_FLAG                 VARCHAR2(1),
  ZERO_AMOUNT_FLAG               VARCHAR2(1),
  PARENT_AE_HEADER_ID            NUMBER(15),
  PARENT_AE_LINE_NUM             NUMBER(15),
  ACCRUAL_REVERSAL_FLAG          VARCHAR2(1),
  MERGE_EVENT_ID                 NUMBER(15),
  NEED_BAL_FLAG                  VARCHAR2(1)
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
