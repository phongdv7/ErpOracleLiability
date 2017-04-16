/*
xdl.source_distribution_type = 'AP_PMT_DIST ' 
and xdl.source_distribution_id_num_1 = 
AP_PAYMENT_HIST_DISTS.payment_hist_dist_id 
------------ 
xdl.source_distribution_type = 'AP_INV_DIST' 
and xdl.source_distribution_id_num_1 = 
AP_INVOICE_DISTRIBUTIONS_ALL.invoice_distribution_ id 
----------- 
xdl.source_distribution_type = 'AR_DISTRIBUTIONS_ALL' 
and xdl.source_distribution_id_num_1 = AR_DISTRIBUTIONS_ALL.line_id 
and AR_DISTRIBUTIONS_ALL.source_id = 
AR_RECEIVABLE_APPLICATIONS_ALL.receivable_applicat ion_id 
------------- 
xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL' 
and xdl.source_distribution_id_num_1 = 
RA_CUST_TRX_LINE_GL_DIST_ALL.cust_trx_line_gl_dist _id 
------------ 
xdl.source_distribution_type = 'MTL_TRANSACTION_ACCOUNTS' 
and xdl.source_distribution_id_num_1 = 
MTL_TRANSACTION_ACCOUNTS.inv_sub_ledger_id 
------------- 
xdl.source_distribution_type = 'WIP_TRANSACTION_ACCOUNTS' 
and xdl.source_distribution_id_num_1 = 
WIP_TRANSACTION_ACCOUNTS.wip_sub_ledger_id 
------------- 
xdl.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER' 
and xdl.source_distribution_id_num_1 = 
RCV_RECEIVING_SUB_LEDGER.rcv_sub_ledger_id
*/
select * from xla.xla_events xe where xe.event_id = 83661;
select * from xla.xla_ae_headers h where h.ae_header_id = 58766;
　
select t.source_distribution_type,
t.applied_to_entity_id,
t.applied_to_dist_id_num_1 as invoice_distribution_id,
t.applied_to_source_id_num_1,
t.source_distribution_id_num_1 as prepay_app_dist_id
from xla.xla_distribution_links t
where t.applied_to_entity_id = 51320;
-- xla_distribution_links 
-- source_distribution_type = AP_PREPAY
-- APPLIED_TO_ENTITY_ID 51320 -> XLA Entity
-- APPLIED_TO_DIST_ID_NUM_1 46145 --> AP Distribution
-- APPLIED_TO_SOURCE_ID_NUM_1 42791 --> AP Invoice
-- SOURCE_DISTRIBUTION_ID_NUM_1 19502 
-- AP_PREPAY -> prepay_app_dist_id
-- AP_PMT_DIST -> AP_PAYMENT_HIST_DISTS.payment_hist_dist_id
-- AP_INV_DIST -> AP_INVOICE_DISTRIBUTIONS_ALL.invoice_distribution_ id
select aid.accounting_event_id,
aid.invoice_distribution_id,
aid.description,
aid.invoice_line_number,
aid.distribution_line_number
from ap.ap_invoice_distributions_all aid
where aid.invoice_id = 42791;
 
Thanks & Regards
Phan Thanh Tâm
