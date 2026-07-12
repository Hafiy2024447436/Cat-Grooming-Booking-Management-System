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
    .dialog-overlay {
      display: none; position: fixed; inset: 0;
      background: rgba(0,0,0,0.5); z-index: 50;
      align-items: center; justify-content: center;
      padding: 1rem; animation: dmFadeIn 0.15s ease;
    }
    .dialog-overlay.open { display: flex; }
    @keyframes dmFadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes dmSlideUp {
      from { opacity: 0; transform: translateY(12px) scale(0.97); }
      to   { opacity: 1; transform: translateY(0) scale(1); }
    }
    .dialog-content {
      background: #fff; border-radius: 12px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.18);
      padding: 1.5rem; width: 100%; max-width: 28rem;
      animation: dmSlideUp 0.2s ease;
    }
    .dialog-header { margin-bottom: 0.75rem; }
    .dialog-title-row { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem; }
    .icon-circle {
      width: 3rem; height: 3rem; background: #fee2e2; border-radius: 50%;
      display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .icon-circle svg { width: 1.5rem; height: 1.5rem; color: #dc2626; stroke: #dc2626; }
    .dialog-title { font-size: 1.25rem; font-weight: 700; color: #111827; }
    .dialog-description { font-size: 0.95rem; color: #6b7280; line-height: 1.5; padding-top: 0.5rem; }
    .dialog-footer { display: flex; gap: 0.75rem; margin-top: 1.5rem; }
    .dm-btn {
      flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 0.4rem;
      padding: 0.55rem 1rem; font-size: 0.9rem; font-weight: 600;
      border-radius: 8px; border: none; cursor: pointer;
      transition: background 0.15s, box-shadow 0.15s, transform 0.1s;
    }
    .dm-btn:active { transform: scale(0.97); }
    .dm-btn svg { width: 1rem; height: 1rem; }
    .dm-btn-outline { background: #fff; border: 1.5px solid #d1d5db; color: #374151; }
    .dm-btn-outline:hover { background: #f9fafb; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
    .dm-btn-danger { background: #dc2626; color: #fff; }
    .dm-btn-danger:hover { background: #b91c1c; box-shadow: 0 2px 8px rgba(220,38,38,0.35); }
  
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
#ownerTable,
#ownerTable thead,
#ownerTable tbody,
#ownerTable tr,
#ownerTable th,
#ownerTable td {
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
      <table id="ownerTable">
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

          <%-- Staff & Owner rows --%>
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
                  <%-- View — all roles --%>
                  <a href="/CatGroomingBookingManagementSystem/ViewOwnerController?id=${u.staffID}"
                     class="act-btn view" title="View">
                    <svg viewBox="0 0 24 24" style="stroke:currentColor">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle cx="12" cy="12" r="3"/>
                    </svg>
                  </a>
				  <%-- Edit — owner goes to EditOwnerController, staff goes to EditStaffController --%>
				<c:choose>
				  <c:when test="${fn:toLowerCase(u.staffRole) == 'owner'}">
				    <a href="${pageContext.request.contextPath}/EditOwnerController?id=${u.staffID}"
				       class="act-btn edit" title="Edit">
				      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
				        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
				        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
				      </svg>
				    </a>
				  </c:when>
				  <c:otherwise>
				    <a href="${pageContext.request.contextPath}/EditStaffController?id=${u.staffID}&source=owner"
				       class="act-btn edit" title="Edit">
				      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
				        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
				        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
				      </svg>
				    </a>
				  </c:otherwise>
				</c:choose>
                  <%-- Delete — hide for owner --%>
                  <c:if test="${fn:toLowerCase(u.staffRole) != 'owner'}">
                    <button class="act-btn del" title="Delete"
                            onclick="openDeleteModal('${u.staffID}', '${u.staffFullName}', '${u.staffUsername}')">
                      <svg viewBox="0 0 24 24" style="stroke:currentColor">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                        <path d="M10 11v6M14 11v6M9 6V4h6v2"/>
                      </svg>
                    </button>
                  </c:if>
                </div>
              </td>
            </tr>
          </c:forEach>

          <%-- Customer rows --%>
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
                  <%-- View --%>
                  <a href="/CatGroomingBookingManagementSystem/ViewCustomerController?id=${c.custID}"
                     class="act-btn view" title="View">
                    <svg viewBox="0 0 24 24" style="stroke:currentColor">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                      <circle cx="12" cy="12" r="3"/>
                    </svg>
                  </a>
                  <%-- Edit --%>
                  <a href="/CatGroomingBookingManagementSystem/EditCustomerController?id=${c.custID}&source=owner"
                     class="act-btn edit" title="Edit">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </a>
                  <%-- Delete --%>
                  <button class="act-btn del" title="Delete"
                          onclick="openDeleteModal('CUST${c.custID}', '${c.custFullName}', '${c.custUsername}')">
                    <svg viewBox="0 0 24 24" style="stroke:currentColor">
                      <polyline points="3 6 5 6 21 6"/>
                      <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                      <path d="M10 11v6M14 11v6M9 6V4h6v2"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>

          <%-- Empty state --%>
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

<%-- Delete Modal --%>
<div class="dialog-overlay" id="deleteModal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
  <div class="dialog-content">
    <div class="dialog-header">
      <div class="dialog-title-row">
        <div class="icon-circle">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
               stroke-linecap="round" stroke-linejoin="round">
            <path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
            <line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
          </svg>
        </div>
        <h2 class="dialog-title" id="modalTitle">Delete User</h2>
      </div>
      <p class="dialog-description" id="modalDescription"></p>
    </div>
    <div class="dialog-footer">
      <button class="dm-btn dm-btn-outline" onclick="closeDeleteModal()">
        Cancel
      </button>
      <button class="dm-btn dm-btn-danger" onclick="confirmDelete()">
        Delete
      </button>
    </div>
  </div>
</div>


<script>
let currentFilter = 'all';
let deletingId    = null;

function filterTable() {
  const q    = document.getElementById('searchInput').value.toLowerCase();
  const rows = document.querySelectorAll('.staff-row');
  let visible = 0;

  rows.forEach(row => {
    const matchSearch = (row.dataset.name     || '').includes(q) ||
                        (row.dataset.email    || '').includes(q) ||
                        (row.dataset.username || '').includes(q);
    const matchFilter = currentFilter === 'all' || row.dataset.role === currentFilter;

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

function openDeleteModal(id, fullname, username) {
  deletingId = id;

  if (id.toString().startsWith('CUST')) {
    document.getElementById('modalTitle').textContent = 'Delete Customer';
    document.getElementById('modalDescription').textContent =
      'This customer may have registered cat records. Deleting ' + fullname +
      ' (@' + username + ') will also remove the related cats from the active list. ' +
      'Appointment history will still be kept. Are you sure you want to continue?';
  } else {
    document.getElementById('modalTitle').textContent = 'Delete User';
    document.getElementById('modalDescription').textContent =
      'Are you sure you want to delete ' + fullname + ' (@' + username + ')? This action cannot be undone.';
  }

  document.getElementById('deleteModal').classList.add('open');
}

function closeDeleteModal() {
  document.getElementById('deleteModal').classList.remove('open');
  deletingId = null;
}

function confirmDelete() {
  if (deletingId) {
    // cek sama ada customer (prefix CUST) atau staff
    if (deletingId.toString().startsWith('CUST')) {
      const custId = deletingId.toString().replace('CUST', '');
      window.location.href = '/CatGroomingBookingManagementSystem/DeleteCustomerController?id=' + custId;
    } else {
    	window.location.href = '/CatGroomingBookingManagementSystem/DeleteStaffController?id=' + deletingId + '&source=owner';
    }
  }
}


document.getElementById('deleteModal').addEventListener('click', function(e) {
  if (e.target === this) closeDeleteModal();
});

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') closeDeleteModal();
});

</script>

<%@ include file="/notification.jsp" %>
</body>
</html>