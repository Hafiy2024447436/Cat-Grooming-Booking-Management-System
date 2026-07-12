<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>View Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profilePage.css?v=profile-photo-1">
<style>

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



/* Role label colors like management page */
.vrole-pill.customer,
.badge-customer {
  background: #e8eeff !important;
  color: #2563eb !important;
}

.vrole-pill.staff,
.badge-staff {
  background: #dcfce7 !important;
  color: #059669 !important;
}

.vrole-pill.owner,
.badge-owner {
  background: #f3e8ff !important;
  color: #7e22ce !important;
}

.vrole-pill {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  padding: 5px 16px !important;
  border-radius: 999px !important;
  font-size: 0.82rem !important;
  font-weight: 800 !important;
  margin-top: 8px !important;
  line-height: 1.2 !important;
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
<div class="layout">
<main class="main">

  <div class="back-link" onclick="history.back()" style="cursor:pointer;">
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
      <line x1="19" y1="12" x2="5" y2="12"/>
      <polyline points="12 19 5 12 12 5"/>
    </svg>
    Back
  </div>

  <c:choose>
    <c:when test="${not empty cust}">
      <div class="view-card">

        <div class="v-hdr">
          <div class="v-avatar">
            <img
              class="v-avatar-photo"
              src="${pageContext.request.contextPath}/CustomerPhotoController?id=${cust.custID}&amp;v=<%= System.currentTimeMillis() %>"
              alt="${cust.custFullName}"
              onload="this.style.display='block'; this.nextElementSibling.style.display='none';"
              onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
            />
            <span class="v-avatar-fallback" style="display:none;">
              <svg viewBox="0 0 24 24">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
              </svg>
            </span>
          </div>
          <div>
            <div class="v-name">${cust.custFullName}</div>
            <div class="v-uname">@${cust.custUsername}</div>
            <div class="vrole-pill customer">Customer</div>
          </div>
        </div>

        <hr class="v-divider">

        <div class="section-title">
          <svg viewBox="0 0 24 24">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
          Personal Information
        </div>

        <div class="info-box">
          <div class="info-grid">
            <div>
              <div class="il">Full Name</div>
              <div class="iv">${cust.custFullName}</div>
            </div>
            <div>
              <div class="il">Username</div>
              <div class="iv">@${cust.custUsername}</div>
            </div>
            <div>
              <div class="il">Email Address</div>
              <div class="iv">${cust.custEmail}</div>
            </div>
            <div>
              <div class="il">Phone Number</div>
              <div class="iv">${cust.custPhoneNumber}</div>
            </div>
            <div>
              <div class="il">Role</div>
              <div class="iv">Customer</div>
            </div>
          </div>
        </div>

      </div>
    </c:when>
    <c:otherwise>
      <div class="view-card">
        <p class="empty">Customer not found.</p>
      </div>
    </c:otherwise>
  </c:choose>

</main>
</div>
</body>
</html>