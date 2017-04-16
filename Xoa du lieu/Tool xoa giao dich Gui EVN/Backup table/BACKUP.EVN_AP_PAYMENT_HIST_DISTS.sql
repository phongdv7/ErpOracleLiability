-- Create table
create table BACKUP.EVN_AP_PAYMENT_HIST_DISTS
(
  payment_hist_dist_id          NUMBER(15) not null,
  accounting_event_id           NUMBER(15) not null,
  pay_dist_lookup_code          VARCHAR2(30) not null,
  invoice_distribution_id       NUMBER(15) not null,
  amount                        NUMBER not null,
  payment_history_id            NUMBER(15) not null,
  invoice_payment_id            NUMBER(15) not null,
  bank_curr_amount              NUMBER,
  cleared_base_amount           NUMBER,
  historical_flag               VARCHAR2(1),
  invoice_dist_amount           NUMBER,
  invoice_dist_base_amount      NUMBER,
  invoice_adjustment_event_id   NUMBER(15),
  matured_base_amount           NUMBER,
  paid_base_amount              NUMBER,
  rounding_amt                  NUMBER,
  reversal_flag                 VARCHAR2(1),
  reversed_pay_hist_dist_id     NUMBER(15),
  created_by                    NUMBER(15),
  creation_date                 DATE,
  last_update_date              DATE,
  last_updated_by               NUMBER(15),
  last_update_login             NUMBER(15),
  program_application_id        NUMBER(15),
  program_id                    NUMBER(15),
  program_login_id              NUMBER(15),
  program_update_date           DATE,
  request_id                    NUMBER(15),
  awt_related_id                NUMBER(15),
  release_inv_dist_derived_from NUMBER(15),
  pa_addition_flag              VARCHAR2(1),
  amount_variance               NUMBER,
  invoice_base_amt_variance     NUMBER,
  quantity_variance             NUMBER,
  invoice_base_qty_variance     NUMBER,
  gain_loss_indicator           VARCHAR2(1)
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
