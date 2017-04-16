-- Create table
create table EVN_DELETE_REQUEST_LOG
(
  line_id      NUMBER not null,
  request_id   NUMBER,
  request_name VARCHAR2(1000),
  parameter    VARCHAR2(1000),
  created_by   VARCHAR2(100),
  created_date DATE
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255;
-- Create/Recreate primary, unique and foreign key constraints 
alter table EVN_DELETE_REQUEST_LOG
  add constraint EVN_PK_LINE_ID primary key (LINE_ID)
  using index 
  tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 2
  maxtrans 255;
