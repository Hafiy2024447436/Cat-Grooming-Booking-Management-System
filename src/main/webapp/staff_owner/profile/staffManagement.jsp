<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>User Management</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profilePage.css?v=button-colors-2">
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

/* Delete modal: cancel grey, delete red */
.dm-btn-outline,
.btn-cancel-delete,
.mbtn-cancel.delete-cancel,
.delete-actions .btn-cancel-delete,
.delete-actions .dm-btn-outline {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.dm-btn-outline:hover,
.btn-cancel-delete:hover,
.mbtn-cancel.delete-cancel:hover,
.delete-actions .btn-cancel-delete:hover,
.delete-actions .dm-btn-outline:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
  color: #ffffff !important;
}

.dm-btn-danger,
.btn-confirm-delete,
.delete-actions .btn-confirm-delete,
.delete-actions .dm-btn-danger,
.act-btn.del {
  color: var(--btn-red) !important;
}

.dm-btn-danger,
.btn-confirm-delete,
.delete-actions .btn-confirm-delete,
.delete-actions .dm-btn-danger {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.dm-btn-danger:hover,
.btn-confirm-delete:hover,
.delete-actions .btn-confirm-delete:hover,
.delete-actions .dm-btn-danger:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
  color: #ffffff !important;
}

.delete-actions,
.dm-actions,
.m-ftr.delete-footer {
  display: flex !important;
  gap: 14px !important;
}

.delete-actions .btn-cancel-delete,
.dm-actions .dm-btn-outline {
  order: 1 !important;
}

.delete-actions .btn-confirm-delete,
.dm-actions .dm-btn-danger {
  order: 2 !important;
}


/* User list profile photo */
.user-cell .u-avatar {
  position: relative !important;
  overflow: hidden !important;
  border-radius: 50% !important;
  flex-shrink: 0 !important;
}

.user-cell .u-avatar-photo {
  position: absolute !important;
  inset: 0 !important;
  width: 100% !important;
  height: 100% !important;
  max-width: 100% !important;
  max-height: 100% !important;
  object-fit: cover !important;
  object-position: center !important;
  border-radius: 50% !important;
  display: block;
}

.user-cell .u-avatar-fallback {
  position: absolute !important;
  inset: 0 !important;
  width: 100% !important;
  height: 100% !important;
  display: flex;
  align-items: center !important;
  justify-content: center !important;
}

.user-cell .u-avatar-fallback svg {
  width: 24px !important;
  height: 24px !important;
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


/* Page background */
.main {
  background: linear-gradient(
      160deg,
      #f5f3ff 0%,
      #fdf4ff 42%,
      #eff6ff 100%
  ) !important;
}

/* Keep the user management table white */
.table-card,
#staffTable,
#staffTable thead,
#staffTable tbody,
#staffTable tr,
#staffTable th,
#staffTable td {
  background: #ffffff !important;
}

</style>
</head>
<body>

<div class="layout">
  <main class="main">

    <div class="search-wrap">
      <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
      <input type="text" id="searchInput" placeholder="Search by name, email, or username..." oninput="filterTable()" />
    </div>

    <div class="filter-tabs">
      <button class="filter-tab active" onclick="setFilter(this,'all')">All Users</button>
      <button class="filter-tab" onclick="setFilter(this,'customer')">Customers</button>
      <button class="filter-tab" onclick="setFilter(this,'staff')">Staff</button>
      <button class="filter-tab" onclick="setFilter(this,'owner')">Owners</button>
    </div>

    <div class="table-card">
      <table id="staffTable">
        <thead>
          <tr>
            <th>User</th>
            <th>Contact</th>
            <th>Role</th>
            <th>Created By</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>

          <c:forEach var="u" items="${staffList}">
            <tr class="staff-row"
                data-role="${fn:toLowerCase(u.staffRole)}"
                data-name="${fn:toLowerCase(u.staffFullName)}"
                data-email="${fn:toLowerCase(u.staffEmail)}"
                data-username="${fn:toLowerCase(u.staffUsername)}">

              <td>
                <div class="user-cell">
                  <div class="u-avatar">
                    <img
                      class="u-avatar-photo"
                      src="${pageContext.request.contextPath}/StaffPhotoController?id=${u.staffID}&amp;v=<%= System.currentTimeMillis() %>"
                      alt="${u.staffFullName}"
                      onload="this.style.display='block'; this.nextElementSibling.style.display='none';"
                      onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                    />
                    <span class="u-avatar-fallback" style="display:none;">
                      <svg viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                      </svg>
                    </span>
                  </div>
                  <div>
                    <div class="u-name">${u.staffFullName}</div>
                    <div class="u-uname">@${u.staffUsername}</div>
                  </div>
                </div>
              </td>

              <td>
                <div class="c-email">${u.staffEmail}</div>
                <div class="c-phone">${u.staffPhoneNumber}</div>
              </td>

              <td>
                <span class="badge
                  <c:choose>
                    <c:when test="${fn:toLowerCase(u.staffRole) == 'staff'}">badge-staff</c:when>
                    <c:when test="${fn:toLowerCase(u.staffRole) == 'owner'}">badge-owner</c:when>
                    <c:otherwise>badge-customer</c:otherwise>
                  </c:choose>">
                  ${fn:toUpperCase(fn:substring(u.staffRole,0,1))}${fn:substring(u.staffRole,1,fn:length(u.staffRole))}
                </span>
              </td>

              <td>
                <c:choose>
                  <c:when test="${fn:toLowerCase(u.staffRole) == 'staff'}">
                    <div class="c-email">${u.createdByOwner}</div>
                  </c:when>
                  <c:otherwise>
                    <span style="color:#9ca3af;">-</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td>
                <div class="actions">
                  <a href="${pageContext.request.contextPath}/ViewStaffController?id=${u.staffID}"
                     class="act-btn view" title="View">
                    <svg viewBox="0 0 24 24" style="stroke:currentColor">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle cx="12" cy="12" r="3"/>
                    </svg>
                  </a>

                  <c:if test="${fn:toLowerCase(u.staffRole) != 'owner'}">
                    <a href="${pageContext.request.contextPath}/EditStaffController?id=${u.staffID}"
                       class="act-btn edit" title="Edit">
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                    </a>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>

          <c:forEach var="c" items="${customerList}">
            <tr class="staff-row"
                data-role="customer"
                data-name="${fn:toLowerCase(c.custFullName)}"
                data-email="${fn:toLowerCase(c.custEmail)}"
                data-username="${fn:toLowerCase(c.custUsername)}">

              <td>
                <div class="user-cell">
                  <div class="u-avatar">
                    <img
                      class="u-avatar-photo"
                      src="${pageContext.request.contextPath}/CustomerPhotoController?id=${c.custID}&amp;v=<%= System.currentTimeMillis() %>"
                      alt="${c.custFullName}"
                      onload="this.style.display='block'; this.nextElementSibling.style.display='none';"
                      onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
                    />
                    <span class="u-avatar-fallback" style="display:none;">
                      <svg viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                      </svg>
                    </span>
                  </div>
                  <div>
                    <div class="u-name">${c.custFullName}</div>
                    <div class="u-uname">@${c.custUsername}</div>
                  </div>
                </div>
              </td>

              <td>
                <div class="c-email">${c.custEmail}</div>
                <div class="c-phone">${c.custPhoneNumber}</div>
              </td>

              <td>
                <span class="badge badge-customer">Customer</span>
              </td>

              <td>
                <span style="color:#9ca3af;">-</span>
              </td>

              <td>
                <div class="actions">
                  <a href="${pageContext.request.contextPath}/ViewCustomerController?id=${c.custID}"
                     class="act-btn view" title="View">
                    <svg viewBox="0 0 24 24" style="stroke:currentColor">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle cx="12" cy="12" r="3"/>
                    </svg>
                  </a>

                  <a href="${pageContext.request.contextPath}/EditCustomerController?id=${c.custID}&source=staff"
                     class="act-btn edit" title="Edit">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </a>
                </div>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty staffList and empty customerList}">
            <tr>
              <td colspan="5" class="empty">No users found.</td>
            </tr>
          </c:if>

        </tbody>
      </table>

      <div id="emptyState" class="empty hidden">No users found.</div>
    </div>

  </main>
</div>

<div id="toast"><strong id="t-title"></strong><span id="t-msg"></span></div>

<script>
let currentFilter = 'all';

function filterTable() {
  const q = document.getElementById('searchInput').value.toLowerCase();
  const rows = document.querySelectorAll('.staff-row');
  let visible = 0;

  rows.forEach(row => {
    const name = row.dataset.name || '';
    const email = row.dataset.email || '';
    const username = row.dataset.username || '';
    const role = row.dataset.role || '';

    const matchSearch = name.includes(q) || email.includes(q) || username.includes(q);
    const matchFilter = currentFilter === 'all' || role === currentFilter;

    if (matchSearch && matchFilter) {
      row.style.display = '';
      visible++;
    } else {
      row.style.display = 'none';
    }
  });

  document.getElementById('emptyState').classList.toggle('hidden', visible > 0);
}

function setFilter(btn, role) {
  document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  currentFilter = role;
  filterTable();
}
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>