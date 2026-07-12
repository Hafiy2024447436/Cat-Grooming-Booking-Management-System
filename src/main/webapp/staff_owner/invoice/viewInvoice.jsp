<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Invoice Details</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <style>
    *, *::before, *::after {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    html,
    body {
      width: 100%;
      min-height: 100%;
      background: linear-gradient(
          160deg,
          #f5f3ff 0%,
          #fdf4ff 42%,
          #eff6ff 100%
      );
      font-family: 'Nunito', sans-serif;
      color: #1e1b2e;
    }

    .overlay {
      position: fixed;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 1rem;
      background: rgba(0, 0, 0, 0.5);
      z-index: 50;
    }

    .modal {
      width: 100%;
      max-width: 540px;
      max-height: 90vh;
      overflow-y: auto;
      background: #ffffff;
      border-radius: 20px;
      box-shadow: 0 24px 64px rgba(0, 0, 0, 0.18);
    }

    .modal-head {
      position: sticky;
      top: 0;
      z-index: 1;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      padding: 1.25rem 1.5rem;
      background: #ffffff;
      border-bottom: 1px solid #f0f0f0;
    }

    .modal-head h2 {
      margin: 0;
      color: #111111;
      font-size: 1rem;
      font-weight: 700;
    }

    .close-btn {
      width: 40px;
      height: 40px;
      padding: 0;
      border: none;
      border-radius: 0;
      background: transparent;
      color: #111827;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2rem;
      font-weight: 500;
      line-height: 1;
      flex-shrink: 0;
    }

    .close-btn:hover {
      background: transparent;
      color: #111827;
      opacity: .7;
    }

    .modal-body {
      padding: 1.5rem;
    }

    .modal-inv-num {
      color: #111111;
      font-size: 1.4rem;
      font-weight: 700;
      letter-spacing: -0.3px;
      margin-bottom: 0.4rem;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 0.72rem;
      font-weight: 700;
      letter-spacing: 0.2px;
      text-transform: none;
      margin-bottom: 1.25rem;
    }

    .badge::before {
      content: '';
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: currentColor;
    }

    .badge.confirmed {
      background: #dbeafe;
      color: #1d4ed8;
    }

    .badge.completed {
      background: #dcfce7;
      color: #16a34a;
    }

    .badge.other {
      background: #f3f4f6;
      color: #6b7280;
    }

    .modal-meta-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 0.6rem;
      margin-bottom: 1.25rem;
    }

    .modal-meta-cell {
      min-height: 72px;
      padding: 0.8rem 1rem;
      background: #f9fafb;
      border: 1px solid #f0f0f0;
      border-radius: 10px;
    }

    .modal-meta-cell .lbl {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-bottom: 3px;
      color: #9ca3af;
      font-size: 0.7rem;
      letter-spacing: 0.2px;
      text-transform: none;
    }

    .modal-meta-cell .lbl svg {
      width: 14px;
      height: 14px;
      flex: 0 0 14px;
      fill: none;
      stroke: currentColor;
      stroke-width: 2.3;
      stroke-linecap: round;
      stroke-linejoin: round;
    }

    .modal-meta-cell .lbl .cat-sidebar-icon {
      width: 16px;
      height: 16px;
      flex: 0 0 16px;
      color: currentColor;
    }

    .modal-meta-cell .val {
      color: #111111;
      font-size: 0.9rem;
      font-weight: 600;
      line-height: 1.4;
      overflow-wrap: anywhere;
    }

    .modal-section-title {
      margin-bottom: 0.6rem;
      color: #111111;
      font-size: 0.9rem;
      font-weight: 700;
    }

    table {
      width: 100%;
      margin-bottom: 1rem;
      border-collapse: collapse;
      overflow: hidden;
      border: 1px solid #f0f0f0;
      border-radius: 10px;
    }

    table th {
      padding: 0.65rem 0.9rem;
      background: #f9fafb;
      color: #9ca3af;
      text-align: left;
      font-size: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.2px;
      text-transform: none;
    }

    table th:last-child,
    table td:last-child {
      text-align: right;
    }

    table td {
      padding: 0.75rem 0.9rem;
      border-top: 1px solid #f0f0f0;
      color: #374151;
      font-size: 0.875rem;
      line-height: 1.45;
    }

    .service-group-row td {
      background: #f9fafb;
      color: #7c3aed;
      font-weight: 700;
      text-align: left !important;
    }

    .totals-box {
      padding: 1rem 1.1rem;
      margin-bottom: 1.25rem;
      background: #f9fafb;
      border: 1px solid #f0f0f0;
      border-radius: 10px;
    }

    .total-row {
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      margin-bottom: 0.35rem;
      color: #6b7280;
      font-size: 0.875rem;
    }

    .total-row.grand {
      margin-top: 0.3rem;
      margin-bottom: 0;
      padding-top: 0.6rem;
      border-top: 1px solid #e5e7eb;
      color: #7c3aed;
      font-size: 1.05rem;
      font-weight: 700;
    }

    .modal-actions {
      display: flex;
      gap: 0.75rem;
    }

    .modal-btn {
      flex: 1;
      padding: 0.7rem 1rem;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.45rem;
      font-family: 'Nunito', sans-serif;
      font-size: 0.875rem;
      font-weight: 600;
      transition: opacity .15s;
    }

    .modal-btn:hover {
      opacity: 0.88;
    }

    .modal-btn.close-modal {
      background: #7c3aed;
      color: #ffffff;
    }

    .empty-box {
      padding: 2rem 1.5rem;
      text-align: center;
      color: #6b7280;
      font-weight: 600;
    }

    @media (max-width: 560px) {
      .modal-meta-grid {
        grid-template-columns: 1fr;
      }
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

.close-btn[aria-label],
.btn-close[aria-label] {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  color: #111827 !important;
}

.close-btn[aria-label]:hover,
.btn-close[aria-label]:hover {
  background: transparent !important;
  border: none !important;
  color: #111827 !important;
  opacity: .7 !important;
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

<c:set var="statusClass" value="${fn:toLowerCase(invoice.appointmentStatus)}" />
<c:if test="${statusClass ne 'confirmed' and statusClass ne 'completed'}">
  <c:set var="statusClass" value="other" />
</c:if>

<div class="overlay" id="overlay">
  <div class="modal" id="invoice-print-area">
    <div class="modal-head">
      <h2>Invoice Details</h2>
      <button class="close-btn" type="button" onclick="goBackToInvoices()" aria-label="Close invoice details">&times;</button>
    </div>

    <div class="modal-body">
      <c:choose>
        <c:when test="${not empty invoice}">
          <div class="modal-inv-num"><c:out value="${invoice.invoiceNo}" /></div>

          <span class="badge ${statusClass}">
            <c:choose>
              <c:when test="${statusClass eq 'confirmed'}">Confirmed</c:when>
              <c:when test="${statusClass eq 'completed'}">Completed</c:when>
              <c:otherwise><c:out value="${invoice.appointmentStatus}" /></c:otherwise>
            </c:choose>
          </span>

          <div class="modal-meta-grid">
            <div class="modal-meta-cell">
              <div class="lbl">
                <svg viewBox="0 0 24 24">
                  <path d="M20 21a8 8 0 0 0-16 0" />
                  <circle cx="12" cy="7" r="4" />
                </svg>
                Customer
              </div>
              <div class="val"><c:out value="${invoice.custFullName}" /></div>
            </div>

            <div class="modal-meta-cell">
              <div class="lbl">
                <svg class="cat-sidebar-icon" viewBox="0 0 80 80">
                  <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" />
                  <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none" />
                  <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none" />
                  <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" />
                  <path d="M40 41v7" />
                  <path d="M34 41h12" />
                  <path d="M12 43h13M13 50h13M55 43h13M54 50h13" />
                </svg>
                Cat
              </div>
              <div class="val"><c:out value="${invoice.catName}" /></div>
            </div>

            <div class="modal-meta-cell">
              <div class="lbl">
                <svg viewBox="0 0 24 24">
                  <path d="M8 2v4" />
                  <path d="M16 2v4" />
                  <rect x="3" y="4" width="18" height="17" rx="2" />
                  <path d="M3 10h18" />
                </svg>
                Service Date
              </div>
              <div class="val"><c:out value="${invoice.appointmentDate}" /> at <c:out value="${invoice.appointmentTime}" /></div>
            </div>

            <div class="modal-meta-cell">
              <div class="lbl">
                <svg viewBox="0 0 24 24">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                  <circle cx="12" cy="7" r="4" />
                </svg>
                Staff
              </div>
              <div class="val"><c:out value="${invoice.staffFullName}" /></div>
            </div>
          </div>

          <p class="modal-section-title">Services Provided</p>
          <table>
            <thead>
              <tr>
                <th>Services</th>
                <th>Amount</th>
              </tr>
            </thead>
            <tbody>
              <c:if test="${not empty invoice.mainServices}">
                <tr class="service-group-row">
                  <td colspan="2">Main Service</td>
                </tr>
                <c:forEach var="svc" items="${invoice.mainServices}" varStatus="vs">
                  <tr>
                    <td>${vs.index + 1}. <c:out value="${svc.serviceName}" /></td>
                    <td>RM <fmt:formatNumber value="${svc.price}" pattern="#,##0.00" /></td>
                  </tr>
                </c:forEach>
              </c:if>

              <c:if test="${not empty invoice.addOnServices}">
                <tr class="service-group-row">
                  <td colspan="2">Add-On Services</td>
                </tr>
                <c:forEach var="svc" items="${invoice.addOnServices}" varStatus="vs">
                  <tr>
                    <td>${vs.index + 1}. <c:out value="${svc.serviceName}" /></td>
                    <td>RM <fmt:formatNumber value="${svc.price}" pattern="#,##0.00" /></td>
                  </tr>
                </c:forEach>
              </c:if>
            </tbody>
          </table>

          <div class="totals-box">
            <div class="total-row">
              <span>Subtotal:</span>
              <span>RM <fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0.00" /></span>
            </div>
            <div class="total-row grand">
              <span>Total:</span>
              <span>RM <fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0.00" /></span>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-box">Invoice details not found.</div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<script>
function goBackToInvoices() {
  window.location.href = '${pageContext.request.contextPath}/MainInvoiceController';
}

document.getElementById('overlay').addEventListener('click', function(e) {
  if (e.target === this) {
    goBackToInvoices();
  }
});
</script>

</body>
</html>
