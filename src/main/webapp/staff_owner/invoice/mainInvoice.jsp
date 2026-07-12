<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>All Invoices</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerInvoice.css?v=font-align-3" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <style>
    .overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 50; align-items: center; justify-content: center; padding: 1rem; }
    .overlay.open { display: flex; }
    .modal { background: #fff; border-radius: 20px; box-shadow: 0 24px 64px rgba(0,0,0,0.18); width: 100%; max-width: 540px; max-height: 90vh; overflow-y: auto; font-family: 'Nunito', sans-serif; }
    .modal-head { display: flex; align-items: center; justify-content: space-between; padding: 1.25rem 1.5rem; border-bottom: 1px solid #f0f0f0; }
    .modal-head h2 { font-size: 1rem; font-weight: 700; margin: 0; color: #111; }
    .close-btn { padding: 6px 16px; border-radius: 8px; background: #f3f4f6; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; color: #6b7280; font-size: 0.875rem; font-weight: 500; line-height: 1; }
    .close-btn:hover { background: #fee2e2; color: #dc2626; }
    .modal-body { padding: 1.5rem; }
    .modal-inv-num { font-size: 1.4rem; font-weight: 700; color: #111; margin-bottom: 0.4rem; letter-spacing: -0.3px; }
    .modal .badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 999px; font-size: 0.72rem; font-weight: 700; text-transform: none; letter-spacing: 0.5px; margin-bottom: 1.25rem; background: #dbeafe; color: #1d4ed8; }
    .modal .badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    /* Completed badge in modal - green */
    .modal .badge.completed { background: #dcfce7; color: #16a34a; }
    .modal-meta-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0.6rem; margin-bottom: 1.25rem; }
    .modal-meta-cell { background: #f9fafb; border-radius: 10px; padding: 0.8rem 1rem; border: 1px solid #f0f0f0; }
    .modal-meta-cell .lbl { font-size: 0.7rem; color: #9ca3af; margin-bottom: 3px; text-transform: uppercase; letter-spacing: 0.4px; }
    .modal-meta-cell .val { font-weight: 600; font-size: 0.9rem; color: #111; }
    .modal-section-title { font-weight: 700; margin-bottom: 0.6rem; font-size: 0.9rem; color: #111; }
    .modal table { width: 100%; border-collapse: collapse; margin-bottom: 1rem; border-radius: 10px; overflow: hidden; border: 1px solid #f0f0f0; }
    .modal table th { background: #f9fafb; padding: 0.65rem 0.9rem; font-size: 0.75rem; text-align: left; color: #9ca3af; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
    .modal table th:last-child, .modal table td:last-child { text-align: right; }
    .modal table .service-group-row td { text-align: left !important; background: #f9fafb; color: #7c3aed; font-weight: 800; }
    .modal table td { padding: 0.75rem 0.9rem; font-size: 0.875rem; border-top: 1px solid #f0f0f0; color: #374151; }
    .totals-box { background: #f9fafb; border-radius: 10px; padding: 1rem 1.1rem; margin-bottom: 1.25rem; border: 1px solid #f0f0f0; }
    .total-row { display: flex; justify-content: space-between; font-size: 0.875rem; color: #6b7280; margin-bottom: 0.35rem; }
    .total-row.grand { font-weight: 700; font-size: 1.05rem; color: #7c3aed; border-top: 1px solid #e5e7eb; padding-top: 0.6rem; margin-top: 0.3rem; margin-bottom: 0; }
    .modal-actions { display: flex; gap: 0.75rem; }
    .modal-btn { flex: 1; padding: 0.7rem 1rem; border-radius: 12px; border: none; font-size: 0.875rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 0.45rem; transition: opacity .15s; }
    .modal-btn:hover { opacity: 0.88; }
    .modal-btn.download    { background: #f3f4f6; color: #374151; }
    .modal-btn.close-modal { background: #7c3aed; color: #fff; }
    
    /* Badge styles - Confirmed (blue), Completed (green) */
    .badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 999px; font-size: 0.72rem; font-weight: 700; text-transform: none; letter-spacing: 0.4px; background: #dbeafe; color: #1d4ed8; }
    .badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
    .badge.completed { background: #dcfce7; color: #16a34a; }
    
    .search-wrap-top { margin-bottom: 0; }
    .search-wrap-top input { width: 100%; padding: 0.65rem 0.9rem; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 0.875rem; font-family: inherit; outline: none; }

    /* Filter pills (All / Confirmed / Completed) — gradient style */
    .filter-row { display: flex; gap: 0.75rem; margin-top: 0.9rem; flex-wrap: wrap; }
    .filter-btn {
      padding: 9px 26px;
      border-radius: 999px;
      border: 1.5px solid #e4e4ec;
      font-size: 0.875rem;
      font-weight: 700;
      cursor: pointer;
      background: #ffffff;
      color: #555;
      font-family: inherit;
      transition: all .18s ease;
    }
    .filter-btn:hover { border-color: #7B2FBE; color: #7B2FBE; background: #ffffff; }
    .filter-btn.active {
      background: linear-gradient(135deg, #7B2FBE, #e040a0);
      border-color: transparent;
      color: #fff;
      box-shadow: 0 3px 10px rgba(123,47,190,0.32);
    }
    @media print { .overlay { display: none !important; } }
  
:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-red: #ef4444;
  --btn-red-hover: #dc2626;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

/* Invoice buttons */
.btn-generate,
.modal-btn.download,
.btn-done,
.btn-save,
.btn-submit {
  background: var(--btn-green) !important;
  border-color: var(--btn-green) !important;
  color: #ffffff !important;
}

.btn-generate:hover,
.modal-btn.download:hover,
.btn-done:hover,
.btn-save:hover,
.btn-submit:hover {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
  color: #ffffff !important;
}

.btn-cancel {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.btn-cancel:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
  color: #ffffff !important;
}

.close-btn,
.btn-close {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.close-btn:hover,
.btn-close:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
  color: #ffffff !important;
}

.btn-group {
  display: flex !important;
  gap: 14px !important;
}

.btn-group .btn-cancel {
  order: 1 !important;
}

.btn-group .btn-generate {
  order: 2 !important;
}

:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-red: #ef4444;
  --btn-red-hover: #dc2626;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

/* Top back/close alignment */
.back-link,
.back-button,
.view-back,
.top-back {
  display: inline-flex !important;
  align-items: center !important;
  gap: 8px !important;
  background: transparent !important;
  color: #374151 !important;
  border: none !important;
  text-decoration: none !important;
  font-size: 0.98rem !important;
  font-weight: 800 !important;
  padding: 0 !important;
  transition: color .15s ease, transform .15s ease !important;
}

.back-link:hover,
.back-button:hover,
.view-back:hover,
.top-back:hover {
  color: #111827 !important;
  transform: translateX(-2px) !important;
}

.back-link svg,
.back-button svg,
.view-back svg,
.top-back svg {
  width: 20px !important;
  height: 20px !important;
  fill: none !important;
  stroke: currentColor !important;
  stroke-width: 2.4 !important;
  stroke-linecap: round !important;
  stroke-linejoin: round !important;
}

/* Bottom back buttons are grey */
.btn-back,
.back-bottom,
.bottom-back {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.btn-back:hover,
.back-bottom:hover,
.bottom-back:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
  color: #ffffff !important;
}



/* ===== UNIVERSAL TYPOGRAPHY ALIGNMENT (MainCat standard) ===== */
html, body, button, input, select, textarea, table {
  font-family: 'Nunito', sans-serif !important;
}
body { font-size: 16px; font-weight: 600; }
.page-title,
.main-title,
.content-title,
.content-header h1,
.page-header h1,
.page-heading h1,
.header h1,
.header-title,
.success-title,
.welcome-card h1,
.login-header h1,
.register-header h1,
.reset-header h1,
.hero h1,
.hero-title {
  font-size: 2rem !important;
  font-weight: 800 !important;
  line-height: 1.2 !important;
  letter-spacing: -0.25px !important;
  color: #111827 !important;
}
.page-subtitle,
.content-subtitle,
.content-header p,
.page-header p,
.page-heading p,
.header p,
.header-subtitle,
.success-sub,
.welcome-card p,
.login-header p,
.register-header p,
.reset-header p,
.hero p,
.hero-subtitle {
  font-size: 1rem !important;
  font-weight: 600 !important;
  line-height: 1.5 !important;
}
.card-title,
.section-title,
.search-card-head h2,
.table-card-head h2,
.panel-head h2,
.panel h2,
.card h2,
.header-card h2,
.modal-header h2,
.modal-header-purple h2 {
  font-size: 1.5rem !important;
  font-weight: 800 !important;
  line-height: 1.25 !important;
  letter-spacing: -0.15px !important;
}
.apt-info h4,
.apt-no,
.appointment-no,
.appointment-id,
.inv-num,
.invoice-number,
.invoice-no,
.invoice-id,
.modal-inv-num,
.id-text {
  font-size: 1.125rem !important;
  font-weight: 700 !important;
  line-height: 1.35 !important;
}
p, label, input, select, textarea, button, td, .info-value, .meta, .normal-text {
  font-size: 1rem;
  font-weight: 600;
}



/* ===== FINAL CONSISTENT TYPOGRAPHY 2026 ===== */
html,
body,
button,
input,
select,
textarea,
table {
  font-family: 'Nunito', sans-serif !important;
}

body {
  font-size: 16px !important;
  font-weight: 600 !important;
}

.page-title,
.content-title,
.content-header > h1,
.content-header h1:first-child,
.page-header > h1,
.page-header h1:first-child,
.page-header h2:first-child,
.page-heading > h1,
.page-heading h1:first-child,
.header-title,
.hero-title,
.hero h1,
.welcome-card h1,
.login-header h1,
.register-header h1,
.reset-header h1,
.header-card > h1,
.header-card > h2,
.success-title {
  font-size: 1.875rem !important;
  font-weight: 800 !important;
  line-height: 1.22 !important;
  letter-spacing: -0.2px !important;
  color: #111827 !important;
}

.page-subtitle,
.content-subtitle,
.content-header > p,
.content-header p:first-of-type,
.page-header > p,
.page-header p:first-of-type,
.page-heading > p,
.page-heading p:first-of-type,
.header-subtitle,
.hero-subtitle,
.hero p,
.welcome-card p,
.login-header p,
.register-header p,
.reset-header p,
.header-card > p,
.success-sub {
  font-size: 1rem !important;
  font-weight: 600 !important;
  line-height: 1.5 !important;
}

.card-title,
.section-title,
.main-title,
.addon-title,
.search-card-head h2,
.table-card-head h2,
.panel-head h2,
.panel h2,
.card > h2,
.form-header h2,
.modal-header h2,
.modal-header-purple h2 {
  font-size: 1.5rem !important;
  font-weight: 800 !important;
  line-height: 1.25 !important;
  letter-spacing: -0.1px !important;
}

.apt-info h4,
.apt-no,
.appointment-no,
.appointment-id,
.inv-num,
.invoice-number,
.invoice-no,
.invoice-id,
.modal-inv-num,
.id-text,
.cat-name,
.service-name {
  font-size: 1.125rem !important;
  font-weight: 700 !important;
  line-height: 1.35 !important;
}

p,
label,
input,
select,
textarea,
button,
td,
.info-value,
.meta,
.normal-text {
  font-size: 1rem;
  font-weight: 600;
}

</style>
</head>
<body>

<div class="page">
  <div class="stats">
    <div class="stat-card">
      <div class="stat-top">
        <div class="stat-icon purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
        <span class="stat-value purple">${fn:length(invoiceList)}</span>
      </div>
      <div class="stat-label">Total Invoices</div>
    </div>
    <div class="stat-card">
      <div class="stat-top">
        <div class="stat-icon yellow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
        <c:set var="totalDue" value="0" />
        <c:forEach var="inv" items="${invoiceList}">
          <c:set var="totalDue" value="${totalDue + inv.totalAmount}" />
        </c:forEach>
        <span class="stat-value yellow">RM <fmt:formatNumber value="${totalDue}" pattern="#,##0.00"/></span>
      </div>
      <div class="stat-label">Total Amount</div>
    </div>
  </div>

  <div class="header-card">
    <h2>All Invoices</h2>
    <p>View and download all invoices</p>
    <div class="search-wrap-top">
      <input type="text" id="search-input" placeholder="Search by customer name..." oninput="searchInvoices()" />
    </div>
    <div class="filter-row">
      <button class="filter-btn active" onclick="filterInvoices(this, 'all')">All</button>
      <button class="filter-btn" onclick="filterInvoices(this, 'confirmed')">Confirmed</button>
      <button class="filter-btn" onclick="filterInvoices(this, 'completed')">Completed</button>
    </div>
  </div>

  <div class="invoice-list" id="invoice-list">
    <c:choose>
      <c:when test="${not empty invoiceList}">
        <c:forEach var="inv" items="${invoiceList}">
          <c:set var="statusClass" value="${fn:toLowerCase(inv.appointmentStatus)}" />
          <div class="invoice-card"
               data-id="${inv.appointmentID}"
               data-invoiceno="${inv.invoiceNo}"
               data-status="${statusClass}"
               data-date="${inv.appointmentDate}"
               data-time="${inv.appointmentTime}"
               data-cat="${fn:toLowerCase(inv.catName)}"
               data-custname="${fn:toLowerCase(inv.custFullName)}"
               data-staff="${inv.staffFullName}"
               data-services="<c:forEach var='svc' items='${inv.services}' varStatus='vs'>${fn:replace(svc.serviceName,'|','/')}::<fmt:formatNumber value='${svc.price}' pattern='#,##0.00'/>::${svc.category}${!vs.last ? '|' : ''}</c:forEach>"
               data-total="<fmt:formatNumber value='${inv.totalAmount}' pattern='#,##0.00'/>">
            <div class="inv-top">
              <div class="inv-left">
                <div class="inv-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg></div>
                <div>
                  <div class="inv-num"><c:out value="${inv.invoiceNo}" /></div>
                </div>
              </div>
              <div class="inv-actions">
                <button class="act-btn view" onclick="window.location.href='${pageContext.request.contextPath}/ViewInvoiceController?appointmentID=${inv.appointmentID}'">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
                <button class="act-btn pdf" onclick="downloadPDF(this.closest('.invoice-card'))">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="14" height="14"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                  PDF
                </button>
              </div>
            </div>
            <div class="inv-meta" style="grid-template-columns: repeat(4, 1fr);">
              <div>
                <div class="meta-label"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="11" height="11" style="vertical-align:middle;margin-right:3px"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg> Customer</div>
                <div class="meta-val">${inv.custFullName}</div>
              </div>
              <div>
                <div class="meta-label"><svg class="cat-meta-icon" viewBox="0 0 80 80" width="11" height="11" style="vertical-align:middle;margin-right:3px">
                    <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
                    <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                  </svg> Cat</div>
                <div class="meta-val">${inv.catName}</div>
              </div>
              <div>
                <div class="meta-label"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="11" height="11" style="vertical-align:middle;margin-right:3px"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg> Service Date</div>
                <div class="meta-val">${inv.appointmentDate} at ${inv.appointmentTime}</div>
              </div>
              <div>
                <div class="meta-label"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="11" height="11" style="vertical-align:middle;margin-right:3px"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg> Amount</div>
                <div class="meta-val large">RM <fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0.00"/></div>
              </div>
            </div>
            <div class="inv-footer" style="display:flex; align-items:center; gap:12px;">
              <span class="badge ${statusClass}">${inv.appointmentStatus}</span>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise><div class="empty"><h3>No Invoices Found</h3></div></c:otherwise>
    </c:choose>
  </div>
</div>

<div class="overlay" id="overlay">
  <div class="modal" id="modal">
    <div class="modal-head">
      <h2>Invoice Details</h2>
      <button class="close-btn" onclick="closeModal()">Close</button>
    </div>
    <div class="modal-body" id="modal-body"></div>
  </div>
</div>

<script>
// ── Helper: format date from DD-MM-YYYY to DD-Mon-YYYY ──
function formatDateToMon(dateStr) {
  if (!dateStr) return '';
  var parts = dateStr.split('-');
  if (parts.length === 3) {
    var year = parts[2];
    var month = parseInt(parts[1]) - 1;
    var day = parts[0];
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return day + '-' + months[month] + '-' + year;
  }
  return dateStr;
}

function parseServices(str) {
  if (!str) return [];
  return str.split('|').filter(Boolean).map(function(pair) {
    var p = pair.split('::');
    return { name: p[0], price: p[1], category: (p[2] || '').toUpperCase() };
  });
}

var currentFilter = 'all';

function filterInvoices(btn, filter) {
  currentFilter = filter;
  document.querySelectorAll('.filter-btn').forEach(function(b) { b.classList.remove('active'); });
  btn.classList.add('active');
  applyFilters();
}

function searchInvoices() {
  applyFilters();
}

function applyFilters() {
  var search = document.getElementById('search-input').value.toLowerCase();
  document.querySelectorAll('.invoice-card').forEach(function(card) {
    var matchesSearch = (search === '' || card.dataset.custname.includes(search) || card.dataset.cat.includes(search));
    var matchesFilter = (currentFilter === 'all' || card.dataset.status === currentFilter);
    card.style.display = (matchesSearch && matchesFilter) ? '' : 'none';
  });
}

function openModal(card) {
  var d      = card.dataset;
  var aptNum = d.invoiceno || ('INV-' + new Date().toISOString().slice(2,10).replace(/-/g, '') + '-' + String(d.id).padStart(4, '0'));
  var status = d.status || 'confirmed';
  var statusLabel = status.toUpperCase();

  var services = parseServices(d.services);
  var mainServices = services.filter(function(s) { return s.category === 'MAIN'; });
  var addOnServices = services.filter(function(s) { return s.category === 'ADDON'; });

  function buildServiceRows(groupLabel, list) {
    if (!list.length) return '';
    var html = '<tr class="service-group-row"><td colspan="2">' + groupLabel + '</td></tr>';
    html += list.map(function(s, i) {
      return '<tr><td>' + (i + 1) + '. ' + s.name + '</td><td>RM ' + s.price + '</td></tr>';
    }).join('');
    return html;
  }

  var rows = buildServiceRows('Main Service', mainServices) + buildServiceRows('Add-On Services', addOnServices);

  var html =
    '<div class="modal-inv-num">' + aptNum + '</div>' +
    '<div style="margin-bottom:1.25rem">' +
      '<span class="badge ' + status + '">' + statusLabel + '</span>' +
    '</div>' +

    '<div class="modal-meta-grid">' +
      '<div class="modal-meta-cell"><div class="lbl">Customer</div><div class="val">' + d.custname + '</div></div>' +
      '<div class="modal-meta-cell"><div class="lbl">Cat</div><div class="val">' + d.cat + '</div></div>' +
      '<div class="modal-meta-cell"><div class="lbl">Service Date</div><div class="val">' + formatDateToMon(d.date) + ' at ' + d.time + '</div></div>' +
      '<div class="modal-meta-cell"><div class="lbl">Staff</div><div class="val">' + d.staff + '</div></div>' +
    '</div>' +

    '<p class="modal-section-title">Services Provided</p>' +
    '<table><thead><tr><th>Services</th><th>Amount</th></tr></thead><tbody>' + rows + '</tbody></table>' +

    '<div class="totals-box">' +
      '<div class="total-row"><span>Subtotal:</span><span>RM ' + d.total + '</span></div>' +
      '<div class="total-row grand"><span>Total:</span><span>RM ' + d.total + '</span></div>' +
    '</div>' +

    '<div class="modal-actions">' +
      '<button class="modal-btn download" onclick="downloadPDFFromModal(\'' +
        aptNum + "','" + d.date + "','" + d.custname + "','" + d.cat + "','" + d.services + "','" + d.total +
      '\')">' +
        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>' +
        ' Download PDF' +
      '</button>' +
    '</div>';

  document.getElementById('modal-body').innerHTML = html;
  document.getElementById('overlay').classList.add('open');
}

function closeModal() {
  document.getElementById('overlay').classList.remove('open');
}

document.getElementById('overlay').addEventListener('click', function(e) {
  if (e.target === this) closeModal();
});

function downloadPDFFromModal(aptNum, date, custName, cat, servicesStr, total) {
  var today = new Date().toLocaleDateString('en-GB', { day:'2-digit', month:'short', year:'numeric' });
  var services = parseServices(servicesStr);
  var mainServices = services.filter(function(s) { return s.category === 'MAIN'; });
  var addOnServices = services.filter(function(s) { return s.category === 'ADDON'; });

  function pdfRows(groupLabel, list) {
    if (!list.length) return '';
    var html = '<tr><td colspan="3" style="padding:10px 14px;text-align:left;font-size:13px;font-weight:700;color:#7c3aed;background:#f9fafb;border-bottom:1px solid #e5e7eb;">' + groupLabel + '</td></tr>';
    html += list.map(function(s, i) {
      return '<tr><td style="padding:14px;font-size:13px;color:#9ca3af;border-bottom:1px solid #f0f0f0;">' + (i + 1) + '</td>' +
             '<td style="padding:14px;font-size:13px;color:#374151;border-bottom:1px solid #f0f0f0;">' + s.name + '</td>' +
             '<td style="padding:14px;font-size:13px;color:#374151;text-align:right;border-bottom:1px solid #f0f0f0;">RM ' + s.price + '</td></tr>';
    }).join('');
    return html;
  }

  var rowsHtml = pdfRows('Main Service', mainServices) + pdfRows('Add-On Services', addOnServices);

  var content =
    '<div style="font-family:Nunito,sans-serif;color:#111;max-width:680px;margin:auto;padding:56px 48px;">' +
      '<div style="display:flex;justify-content:space-between;align-items:center;padding-bottom:24px;border-bottom:2px solid #7c3aed;margin-bottom:32px;">' +
        '<div style="display:flex;align-items:center;gap:10px;">' +
          '<div style="width:36px;height:36px;background:#7c3aed;border-radius:8px;display:flex;align-items:center;justify-content:center;"><span style="color:#fff;font-size:18px;">🐾</span></div>' +
          '<div><div style="font-size:15px;font-weight:700;color:#111;">Meowy Groom</div><div style="font-size:11px;color:#9ca3af;">Professional Cat Care</div></div>' +
        '</div>' +
        '<div style="text-align:right;"><div style="font-size:11px;color:#9ca3af;text-transform:uppercase;letter-spacing:1px;margin-bottom:2px;">Invoice</div><div style="font-size:20px;font-weight:700;color:#7c3aed;">' + aptNum + '</div></div>' +
      '</div>' +
      '<div style="margin-bottom:24px;"><div style="font-size:11px;color:#9ca3af;text-transform:uppercase;margin-bottom:3px;">Billed To</div><div style="font-size:14px;font-weight:600;">' + custName + '</div></div>' +
      '<div style="background:#f9fafb;border-radius:12px;border:1px solid #e5e7eb;padding:20px 24px;margin-bottom:28px;">' +
        '<div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.8px;color:#9ca3af;margin-bottom:14px;">Appointment Details</div>' +
        '<div style="display:flex;gap:0;">' +
          '<div style="flex:1;padding-right:24px;border-right:1px solid #e5e7eb;"><div style="font-size:11px;color:#9ca3af;margin-bottom:3px;">Cat</div><div style="font-size:14px;font-weight:600;">' + cat + '</div></div>' +
          '<div style="flex:1;padding-left:24px;"><div style="font-size:11px;color:#9ca3af;margin-bottom:3px;">Service Date</div><div style="font-size:14px;font-weight:600;">' + formatDateToMon(date) + '</div></div>' +
        '</div>' +
      '</div>' +
      '<table style="width:100%;border-collapse:collapse;margin-bottom:20px;">' +
        '<thead><tr style="background:#f3f4f6;"><th style="padding:10px 14px;text-align:left;font-size:11px;color:#6b7280;border-bottom:1px solid #e5e7eb;">#</th><th style="padding:10px 14px;text-align:left;font-size:11px;color:#6b7280;border-bottom:1px solid #e5e7eb;">Services</th><th style="padding:10px 14px;text-align:right;font-size:11px;color:#6b7280;border-bottom:1px solid #e5e7eb;">Amount</th></tr></thead>' +
        '<tbody>' + rowsHtml + '</tbody>' +
      '</table>' +
      '<div style="background:#f9fafb;border-radius:12px;border:1px solid #e5e7eb;padding:16px 20px;margin-bottom:36px;">' +
        '<div style="display:flex;justify-content:space-between;font-size:13px;color:#6b7280;padding-bottom:10px;margin-bottom:10px;border-bottom:1px solid #e5e7eb;"><span>Subtotal</span><span>RM ' + total + '</span></div>' +
        '<div style="display:flex;justify-content:space-between;font-size:16px;font-weight:700;color:#7c3aed;"><span>Total</span><span>RM ' + total + '</span></div>' +
      '</div>' +
      '<div style="border-top:1px solid #e5e7eb;padding-top:20px;display:flex;justify-content:space-between;align-items:center;">' +
        '<div style="font-size:11px;color:#9ca3af;">Generated on ' + today + '</div>' +
        '<div style="font-size:11px;color:#9ca3af;text-align:right;">Meowy Groom Management System<br/><span style="color:#7c3aed;">support@meowygroom.com</span></div>' +
      '</div>' +
    '</div>';

  html2pdf().set({ margin: 0, filename: aptNum + '_invoice.pdf', image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2 }, jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' } }).from(content).save();
}

function downloadPDF(card) {
  var d      = card.dataset;
  var aptNum = d.invoiceno || ('INV-' + new Date().toISOString().slice(2,10).replace(/-/g, '') + '-' + String(d.id).padStart(4, '0'));
  downloadPDFFromModal(aptNum, d.date, d.custname, d.cat, d.services, d.total);
}
</script>

<%@ include file="/notification.jsp" %>
</body>
</html>