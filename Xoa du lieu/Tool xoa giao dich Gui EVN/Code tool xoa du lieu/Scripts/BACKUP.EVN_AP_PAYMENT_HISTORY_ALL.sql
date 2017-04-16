-- Create table
create table BACKUP.EVN_AP_PAYMENT_HISTORY_ALL
(
  payment_history_id          NUMBER(15) not null,
  check_id                    NUMBER(15) not null,
  accounting_date             DATE not null,
  transaction_type            VARCHAR2(30) not null,
  posted_flag                 VARCHAR2(1) not null,
  matched_flag                VARCHAR2(1),
  accounting_event_id         NUMBER(15),
  org_id                      NUMBER(15),
  creation_date               DATE not null,
  created_by                  NUMBER(15) not null,
  last_update_date            DATE not null,
  last_updated_by             NUMBER(15) not null,
  last_update_login           NUMBER(15),
  program_update_date         DATE,
  program_application_id      NUMBER(15),
  program_id                  NUMBER(15),
  request_id                  NUMBER(15),
  rev_pmt_hist_id             NUMBER(15),
  trx_bank_amount             NUMBER,
  errors_bank_amount          NUMBER,
  charges_bank_amount         NUMBER,
  trx_pmt_amount              NUMBER not null,
  errors_pmt_amount           NUMBER,
  charges_pmt_amount          NUMBER,
  trx_base_amount             NUMBER,
  errors_base_amount          NUMBER,
  charges_base_amount         NUMBER,
  bank_currency_code          VARCHAR2(15),
  bank_to_base_xrate_type     VARCHAR2(30),
  bank_to_base_xrate_date     DATE,
  bank_to_base_xrate          NUMBER,
  pmt_currency_code           VARCHAR2(15) not null,
  pmt_to_base_xrate_type      VARCHAR2(30),
  pmt_to_base_xrate_date      DATE,
  pmt_to_base_xrate           NUMBER,
  mrc_pmt_to_base_xrate_type  VARCHAR2(2000),
  mrc_pmt_to_base_xrate_date  VARCHAR2(2000),
  mrc_pmt_to_base_xrate       VARCHAR2(2000),
  mrc_bank_to_base_xrate_type VARCHAR2(2000),
  mrc_bank_to_base_xrate_date VARCHAR2(2000),
  mrc_bank_to_base_xrate      VARCHAR2(2000),
  mrc_trx_base_amount         VARCHAR2(2000),
  mrc_errors_base_amount      VARCHAR2(2000),
  mrc_charges_base_amount     VARCHAR2(2000),
  related_event_id            NUMBER(15),
  historical_flag             VARCHAR2(1),
  invoice_adjustment_event_id NUMBER(15),
  gain_loss_indicator         VARCHAR2(1)
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
