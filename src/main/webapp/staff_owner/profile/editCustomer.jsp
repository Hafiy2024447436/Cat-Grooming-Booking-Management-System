<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Customer</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
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

/* Button color alignment */
.save-btn,
.btn-save,
.btn-submit,
.btn-generate,
.btn-create,
.mbtn-save,
.btn-done,
.modal-btn.download,
button[type="submit"].save-btn,
button[type="submit"].btn-save {
  background: var(--btn-green) !important;
  border-color: var(--btn-green) !important;
  color: #ffffff !important;
}

.save-btn:hover,
.btn-save:hover,
.btn-submit:hover,
.btn-generate:hover,
.btn-create:hover,
.mbtn-save:hover,
.btn-done:hover,
.modal-btn.download:hover,
button[type="submit"].save-btn:hover,
button[type="submit"].btn-save:hover {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
  color: #ffffff !important;
}

.cancel-btn,
.btn-cancel,
.btn-cancel-sm,
.mbtn-cancel {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.cancel-btn:hover,
.btn-cancel:hover,
.btn-cancel-sm:hover,
.mbtn-cancel:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
  color: #ffffff !important;
}

.close-btn[aria-label],
.btn-x,
.m-close {
  background: transparent !important;
  border: none !important;
  color: #111827 !important;
  box-shadow: none !important;
}

.close-btn[aria-label]:hover,
.btn-x:hover,
.m-close:hover {
  background: transparent !important;
  color: #111827 !important;
  opacity: .7 !important;
}

button:disabled,
.btn:disabled,
input:disabled,
select:disabled {
  background-color: var(--btn-disabled) !important;
  cursor: not-allowed !important;
}

.btn-row,
.btn-group,
.form-actions {
  display: flex !important;
  gap: 14px !important;
}

.btn-row .cancel-btn,
.btn-group .btn-cancel,
.form-actions .btn-cancel-sm {
  order: 1 !important;
}

.btn-row .save-btn,
.btn-group .btn-generate,
.form-actions .btn-save,
.form-actions .btn-create {
  order: 2 !important;
}


/* Requested: username readonly box clean */
.input-wrap.disabled-input {
  background: #f8fafc !important;
}

.input-wrap.disabled-input .readonly-username,
.input-wrap.disabled-input input[readonly] {
  background: transparent !important;
  color: #111827 !important;
  cursor: default !important;
}

.input-wrap.disabled-input .input-note {
  background: transparent !important;
}


.field-error{
  display:none;
  margin-top:6px;
  font-size:13px;
  font-weight:600;
  color:#dc2626;
}
.input-wrap.has-error{
  border-color:#ef4444 !important;
  box-shadow:0 0 0 3px rgba(239,68,68,.12) !important;
}
.save-btn:disabled{
  background:#d1d5db !important;
  border-color:#d1d5db !important;
  cursor:not-allowed !important;
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
    <div class="content-wrap">
<c:choose>
        <c:when test="${not empty cust}">
          <div class="view-card">
            <div class="card-title">Edit Customer Account</div>
            <div class="card-subtitle">Update customer information</div>
            <hr class="v-divider"/>

            <c:if test="${not empty param.error}">
              <div class="form-alert error-alert">
                <c:choose>
                  <c:when test="${param.error == 'fullNameInvalid'}">Full name can only contain letters, spaces, hyphens, and apostrophes.</c:when>
                  <c:when test="${param.error == 'phoneInvalid'}">Phone number must be 10-11 digits.</c:when>
                  <c:when test="${param.error == 'emailInvalid'}">Please enter a valid email address.</c:when>
                  <c:otherwise>Update failed. Please try again.</c:otherwise>
                </c:choose>
              </div>
            </c:if>

            <form id="editCustomerForm" class="edit-form" method="POST"
                  action="${pageContext.request.contextPath}/EditCustomerController" data-disable-validation="true" novalidate>

              <input type="hidden" name="custId" value="${cust.custID}">
               <input type="hidden" name="source" value="${source}">

              <div class="field-group">
                <label class="field-label">Full Name *</label>
                <div class="input-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                  </svg>
                  <input type="text" name="fullname" id="fullname" value="${cust.custFullName}" minlength="2" maxlength="100" required>
                  <p id="fullNameError" class="field-error">Full name can only contain letters, spaces, hyphens, and apostrophes.</p>
                </div>
              </div>

              <div class="field-group">
                <label class="field-label">Username</label>
                <div class="input-wrap disabled-input">
                  <svg viewBox="0 0 24 24">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                  </svg>
                  <input type="text" value="@${cust.custUsername}" readonly tabindex="-1" class="readonly-username">
                  <span class="input-note">(Cannot be changed)</span>
                </div>
              </div>

              <div class="field-group">
                <label class="field-label">Phone Number *</label>
                <div class="input-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.61 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.09a16 16 0 0 0 6 6l.91-.91a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
                  </svg>
                  <input type="tel" name="phone" id="phone" value="${cust.custPhoneNumber}" inputmode="numeric" required>
                  <p id="phoneError" class="field-error">Phone number must be 10-11 digits.</p>
                </div>
              </div>

              <div class="field-group">
                <label class="field-label">Email Address *</label>
                <div class="input-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                    <polyline points="22,6 12,13 2,6"/>
                  </svg>
                  <input type="email" name="email" id="email" value="${cust.custEmail}" required>
                  <p id="emailError" class="field-error">Please enter a valid email address.</p>
                </div>
              </div>

              <div class="btn-row">
                <button type="button" class="cancel-btn"
                        onclick="window.location.href='${pageContext.request.contextPath}/${'owner' eq source ? 'OwnerController' : 'StaffController'}'">
                  Cancel
                </button>
                <button type="submit" class="save-btn">Save</button>
                
              </div>

            </form>
          </div>
        </c:when>
        <c:otherwise>
          <div class="view-card">
            <p class="empty">Customer not found.</p>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>


<script>
(function() {
  const form = document.getElementById('editCustomerForm');
  if (!form) return;

  const fullName = form.querySelector('[name="fullname"]');
  const phone = form.querySelector('[name="phone"]');
  const email = form.querySelector('[name="email"]');
  const saveBtn = form.querySelector('.save-btn');

  function showError(input, errorId, invalid) {
    const error = document.getElementById(errorId);
    const wrap = input ? input.closest('.input-wrap') : null;
    if (input) input.classList.toggle('input-error', invalid);
    if (wrap) wrap.classList.toggle('has-error', invalid);
    if (error) error.style.display = invalid ? 'block' : 'none';
  }

  function validate() {
    const fullNameValue = fullName.value.trim();
    const phoneValue = phone.value.trim();
    const phoneDigits = phoneValue.replace(/\D/g, '');
    const emailValue = email.value.trim();

    const fullNameInvalid = !/^[a-zA-Z\s\-'.\u00C0-\u024F]+$/.test(fullNameValue) || /\d/.test(fullNameValue) || fullNameValue.length < 2 || fullNameValue.length > 100;
    const phoneInvalid = phoneDigits.length < 10 || phoneDigits.length > 11;
    const emailInvalid = !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(emailValue);

    showError(fullName, 'fullNameError', fullNameInvalid && fullNameValue.length > 0);
    showError(phone, 'phoneError', phoneInvalid && phoneValue.length > 0);
    showError(email, 'emailError', emailInvalid && emailValue.length > 0);

    const valid = fullNameValue.length > 0 && phoneValue.length > 0 && emailValue.length > 0
      && !fullNameInvalid && !phoneInvalid && !emailInvalid;

    saveBtn.disabled = !valid;
    return valid;
  }

  [fullName, phone, email].forEach(function(input) {
    input.addEventListener('input', function() {
      if (input === phone) {
        input.value = input.value.replace(/[^0-9]/g, '').slice(0, 11);
      }
      validate();
    });
    input.addEventListener('blur', validate);
  });

  form.addEventListener('submit', function(event) {
    if (!validate()) event.preventDefault();
  });

  validate();
})();
</script>

  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>