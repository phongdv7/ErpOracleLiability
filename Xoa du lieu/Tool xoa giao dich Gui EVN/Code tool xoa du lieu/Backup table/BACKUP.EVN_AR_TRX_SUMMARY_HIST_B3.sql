-- Create table
create table BACKUP.EVN_AR_TRX_SUMMARY_HIST_B3
(
  history_id           NUMBER(15) not null,
  last_update_date     DATE not null,
  last_updated_by      NUMBER(15) not null,
  creation_date        DATE not null,
  created_by           NUMBER(15) not null,
  last_update_login    NUMBER(15),
  customer_trx_id      NUMBER(15),
  cash_receipt_id      NUMBER(15),
  payment_schedule_id  NUMBER(15),
  previous_history_id  NUMBER(15),
  due_date             DATE,
  amount_in_dispute    NUMBER,
  amount_due_original  NUMBER,
  amount_adjusted      NUMBER,
  complete_flag        VARCHAR2(1),
  customer_id          NUMBER(15),
  site_use_id          NUMBER(15),
  amount_due_remaining NUMBER,
  currency_code        VARCHAR2(30),
  trx_date             DATE,
  event_name           VARCHAR2(240),
  installments         NUMBER
)
