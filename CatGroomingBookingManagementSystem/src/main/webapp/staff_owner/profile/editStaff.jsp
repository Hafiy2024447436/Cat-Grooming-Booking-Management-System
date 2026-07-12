<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Edit Staff</title>
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
.input-wrap input.input-error,
.input-wrap textarea.input-error{
  border-color:#ef4444 !important;
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
.password-readonly-note{
  background:#f8fafc;
  border:1px solid #e5e7eb;
  border-radius:12px;
  padding:14px 16px;
  color:#6b7280;
  font-weight:700;
  line-height:1.45;
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



/* Password eye toggle */
.input-wrap.password-field-wrap {
  position: relative;
}

.input-wrap.password-field-wrap input {
  padding-right: 44px;
}

.input-wrap.password-field-wrap .password-eye-btn {
  flex: 0 0 auto;
  width: 36px;
  height: 36px;
  border: none;
  background: transparent;
  color: #7c3aed;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  border-radius: 9px;
  padding: 0;
}

.input-wrap.password-field-wrap .password-eye-btn:hover {
  background: #f3e8ff;
}

.input-wrap.password-field-wrap .password-eye-btn svg {
  width: 20px !important;
  height: 20px !important;
  flex: 0 0 20px !important;
  stroke: currentColor !important;
  fill: none !important;
  stroke-width: 2 !important;
  stroke-linecap: round !important;
  stroke-linejoin: round !important;
}

.password-eye-btn .eye-closed,
.password-eye-btn.is-visible .eye-open {
  display: none;
}

.password-eye-btn.is-visible .eye-closed {
  display: block;
}

</style>
</head>
<body>

<div class="layout">
  <main class="main">
    <div class="content-wrap">
<c:choose>
        <c:when test="${not empty staff}">
          <div class="view-card">
            <div class="card-title">Edit Staff Account</div>
            <div class="card-subtitle">Update staff information</div>

            <hr class="v-divider" />

            <%-- show error message if redirected back with error --%>
            <c:if test="${not empty param.error}">
              <div class="form-alert error-alert">
                <c:choose>
                  <c:when test="${param.error == 'passwordMismatch'}">Password and confirm password do not match.</c:when>
                  <c:when test="${param.error == 'invalidPassword'}">Password must contain at least 8 characters.</c:when>
                  <c:when test="${param.error == 'fullNameInvalid'}">Full name can only contain letters, spaces, hyphens, and apostrophes.</c:when>
                  <c:when test="${param.error == 'phoneInvalid'}">Phone number must be 10-11 digits.</c:when>
                  <c:when test="${param.error == 'emailInvalid'}">Please enter a valid email address.</c:when>
                  <c:otherwise>Update failed. Please try again.</c:otherwise>
                </c:choose>
              </div>
            </c:if>

            <form id="editStaffForm" class="edit-form" method="POST" enctype="multipart/form-data"
                  action="${pageContext.request.contextPath}/EditStaffController" data-disable-validation="true" novalidate>

              <%-- hantar ID sebagai int terus, no more STF prefix --%>
              <input type="hidden" name="staffId" value="${staff.staffID}">
              <div class="edit-photo-section">
                <div class="edit-photo-wrapper">
                  <div class="edit-photo-avatar">
                    <img id="profilePhotoPreview"
                             src="${pageContext.request.contextPath}/StaffPhotoController?id=${staff.staffID}"
                             alt="Profile photo"
                             onerror="this.style.display='none'; document.getElementById('profilePhotoFallback').style.display='flex';">
                        <div class="edit-photo-fallback" id="profilePhotoFallback" style="display:none;">
                          <svg class="default-user-icon" viewBox="0 0 24 24">
                            <path d="M20 21a8 8 0 0 0-16 0"/>
                            <circle cx="12" cy="7" r="4"/>
                          </svg>
                        </div>
                  </div>

                  <label class="edit-photo-overlay" for="staffProfilePhoto">
                    <svg viewBox="0 0 24 24">
                      <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
                      <circle cx="12" cy="13" r="4"/>
                    </svg>
                  </label>
                </div>

                <div>
                  <div class="edit-photo-title">Profile Photo</div>
                  <div class="edit-photo-subtitle">Hover the photo to change picture.</div>
                </div>
              </div>

              <input type="file" id="staffProfilePhoto" name="staffProfilePhoto" accept="image/*" hidden>


              <div class="field-group">
                <label class="field-label">Full Name *</label>
                <div class="input-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                    <circle cx="12" cy="7" r="4"/>
                  </svg>
                  <input type="text" name="fullname" id="fullname" minlength="2" maxlength="100"
                         value="${staff.staffFullName}" required>
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
                  <input type="text" value="@${staff.staffUsername}" readonly tabindex="-1" class="readonly-username">
                  <span class="input-note">(Cannot be changed)</span>
                </div>
              </div>

              <div class="field-group">
                <label class="field-label">Phone Number *</label>
                <div class="input-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.61 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.09a16 16 0 0 0 6 6l.91-.91a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
                  </svg>
                  <input type="tel" name="phone" id="phone" inputmode="numeric"
                         value="${staff.staffPhoneNumber}" required>
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
                  <input type="email" name="email" id="email"
                         value="${staff.staffEmail}" required>
                  <p id="emailError" class="field-error">Please enter a valid email address.</p>
                </div>
              </div>


              <div class="field-group">
                <label class="field-label">Address</label>
                <div class="input-wrap textarea-wrap">
                  <svg viewBox="0 0 24 24">
                    <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
                    <circle cx="12" cy="10" r="3"/>
                  </svg>
                  <textarea name="address" rows="3" placeholder="Enter address">${staff.staffAddress}</textarea>
                </div>
              </div>

              <c:if test="${canEditPassword}">
                <div class="password-section">
                  <div class="password-title">Update Password</div>
                  <div class="password-subtitle">Leave blank if you do not want to change the password.</div>

                  <div class="field-group">
                    <label class="field-label">New Password</label>
                    <div class="input-wrap password-field-wrap">
                      <svg viewBox="0 0 24 24">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                      </svg>
                      <input type="password" name="newPassword" id="newPassword" placeholder="Enter new password" minlength="8">
<button type="button" class="password-eye-btn" onclick="togglePasswordVisibility(this)" aria-label="Show password">
                      <svg class="eye-open" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/>
                        <circle cx="12" cy="12" r="3"/>
                      </svg>
                      <svg class="eye-closed" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 19C5 19 1 12 1 12a20.29 20.29 0 0 1 5.06-5.94"/>
                        <path d="M9.9 4.24A10.76 10.76 0 0 1 12 4c7 0 11 8 11 8a20.34 20.34 0 0 1-3.17 4.24"/>
                        <path d="M14.12 14.12A3 3 0 0 1 9.88 9.88"/>
                        <line x1="1" y1="1" x2="23" y2="23"/>
                      </svg>
              </button>
                      <p id="passwordError" class="field-error">Password must contain at least 8 characters.</p>
                    </div>
                  </div>

                  <div class="field-group">
                    <label class="field-label">Confirm New Password</label>
                    <div class="input-wrap password-field-wrap">
                      <svg viewBox="0 0 24 24">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                      </svg>
                      <input type="password" name="confirmNewPassword" id="confirmNewPassword" placeholder="Confirm new password" minlength="8">
<button type="button" class="password-eye-btn" onclick="togglePasswordVisibility(this)" aria-label="Show password">
                      <svg class="eye-open" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/>
                        <circle cx="12" cy="12" r="3"/>
                      </svg>
                      <svg class="eye-closed" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M17.94 17.94A10.94 10.94 0 0 1 12 19C5 19 1 12 1 12a20.29 20.29 0 0 1 5.06-5.94"/>
                        <path d="M9.9 4.24A10.76 10.76 0 0 1 12 4c7 0 11 8 11 8a20.34 20.34 0 0 1-3.17 4.24"/>
                        <path d="M14.12 14.12A3 3 0 0 1 9.88 9.88"/>
                        <line x1="1" y1="1" x2="23" y2="23"/>
                      </svg>
              </button>
                      <p id="confirmPasswordError" class="field-error">Password and confirm password do not match.</p>
                    </div>
                  </div>
                </div>
              </c:if>

              <c:if test="${not canEditPassword}">
                <div class="password-section">
                  <div class="password-title">Update Password</div>
                  <div class="password-readonly-note">Password can only be changed by the account owner.</div>
                </div>
              </c:if>

              <div class="btn-row">
                <button type="button" class="cancel-btn"
                        onclick="window.location.href='${pageContext.request.contextPath}/${'owner' eq source ? 'OwnerController' : 'StaffController'}'">
                  Cancel
                </button>
                <input type="hidden" name="source" value="${source}">
                <button type="submit" class="save-btn">Save</button>
              </div>

            </form>
          </div>
        </c:when>
        <c:otherwise>
          <div class="view-card">
            <p class="empty">User not found.</p>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>



<script>
  function togglePasswordVisibility(button) {
    const wrapper = button.closest('.password-field-wrap');
    if (!wrapper) return;

    const input = wrapper.querySelector('input');
    if (!input) return;

    const showPassword = input.type === 'password';
    input.type = showPassword ? 'text' : 'password';
    button.classList.toggle('is-visible', showPassword);
    button.setAttribute('aria-label', showPassword ? 'Hide password' : 'Show password');
  }
</script>

<script>

function setupProfileValidation(formId) {
  const form = document.getElementById(formId);
  if (!form) return;

  const fullName = form.querySelector('[name="fullname"]');
  const phone = form.querySelector('[name="phone"]');
  const email = form.querySelector('[name="email"]');
  const password = form.querySelector('[name="newPassword"]');
  const confirmPassword = form.querySelector('[name="confirmNewPassword"]');
  const saveBtn = form.querySelector('.save-btn');

  function showError(input, errorId, invalid) {
    const error = document.getElementById(errorId);
    const wrap = input ? input.closest('.input-wrap') : null;

    if (input) input.classList.toggle('input-error', invalid);
    if (wrap) wrap.classList.toggle('has-error', invalid);
    if (error) error.style.display = invalid ? 'block' : 'none';
  }

  function validate() {
    const fullNameValue = fullName ? fullName.value.trim() : '';
    const phoneValue = phone ? phone.value.trim() : '';
    const phoneDigits = phoneValue.replace(/\D/g, '');
    const emailValue = email ? email.value.trim() : '';
    const passwordValue = password ? password.value : '';
    const confirmValue = confirmPassword ? confirmPassword.value : '';

    const fullNameInvalid = !/^[a-zA-Z\s\-'.\u00C0-\u024F]+$/.test(fullNameValue) || /\d/.test(fullNameValue) || fullNameValue.length < 2 || fullNameValue.length > 100;
    const phoneInvalid = phoneDigits.length < 10 || phoneDigits.length > 11;
    const emailInvalid = !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(emailValue);

    const hasPassword = passwordValue.length > 0 || confirmValue.length > 0;
    const passwordInvalid = password ? (passwordValue.length > 0 && passwordValue.length < 8) : false;
    const passwordMismatch = password ? (hasPassword && passwordValue !== confirmValue) : false;

    showError(fullName, 'fullNameError', fullNameInvalid && fullNameValue.length > 0);
    showError(phone, 'phoneError', phoneInvalid && phoneValue.length > 0);
    showError(email, 'emailError', emailInvalid && emailValue.length > 0);
    if (password) showError(password, 'passwordError', passwordInvalid);
    if (confirmPassword) showError(confirmPassword, 'confirmPasswordError', passwordMismatch);

    const valid = fullNameValue.length > 0 && phoneValue.length > 0 && emailValue.length > 0
      && !fullNameInvalid && !phoneInvalid && !emailInvalid && !passwordInvalid && !passwordMismatch;

    if (saveBtn) saveBtn.disabled = !valid;
    return valid;
  }

  [fullName, phone, email, password, confirmPassword].forEach(function(input) {
    if (!input) return;
    input.addEventListener('input', function() {
      if (input === phone) {
        input.value = input.value.replace(/[^0-9]/g, '').slice(0, 11);
      }
      validate();
    });
    input.addEventListener('blur', validate);
  });

  form.addEventListener('submit', function(event) {
    if (!validate()) {
      event.preventDefault();
    }
  });

  validate();
}

const profilePhotoInput = document.getElementById('staffProfilePhoto');
const profilePhotoPreview = document.getElementById('profilePhotoPreview');
const profilePhotoFallback = document.getElementById('profilePhotoFallback');

setupProfileValidation('editStaffForm');

if (profilePhotoInput) {
  profilePhotoInput.addEventListener('change', function () {
    const file = this.files && this.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (event) {
      profilePhotoPreview.src = event.target.result;
      profilePhotoPreview.style.display = 'block';
      if (profilePhotoFallback) {
        profilePhotoFallback.style.display = 'none';
      }
    };
    reader.readAsDataURL(file);
  });
}
</script>


  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>