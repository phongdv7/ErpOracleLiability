-- Create Table
create table EVN.EVN_SECURITY_USERS
(
  USER_ID           NUMBER not null,
  CONC_PROGRAM_ID   NUMBER,
  RESP_ID           NUMBER,
  CREATION_DATE     DATE,
  CREATED_BY        NUMBER,
  LAST_UPDATE_DATE  DATE,
  LAST_UPDATED_BY   NUMBER,
  LAST_UPDATE_LOGIN NUMBER,
  DESCRIPTION       VARCHAR2(240),
  START_DATE        DATE,
  END_DATE          DATE
);

-- Create Synonym
create synonym evn_security_users for evn.evn_security_users;
