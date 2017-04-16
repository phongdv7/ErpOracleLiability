-- Create table
create table FPT_SPLIT_DATA
(
  object_code   VARCHAR2(30),
  lob_type      VARCHAR2(30),
  lob_code      VARCHAR2(30),
  split_num     NUMBER(5),
  split_content VARCHAR2(4000),
  creation_date DATE,
  attribute1    VARCHAR2(50),
  attribute2    VARCHAR2(50),
  attribute3    VARCHAR2(50)
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
