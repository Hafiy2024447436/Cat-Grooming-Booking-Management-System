<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Staff</title>

<style>
body{
  margin:0;
  font-family:'Nunito', sans-serif;
  background: linear-gradient(
      160deg,
      #f5f3ff 0%,
      #fdf4ff 42%,
      #eff6ff 100%
  );
  color:#1f2937;
}
.page{ padding:32px; max-width:960px; margin:0 auto; }
.header{
  position:relative;
  overflow:hidden;
  background:linear-gradient(135deg, rgba(255,255,255,.96) 0%, rgba(250,245,255,.98) 58%, rgba(243,232,255,.92) 100%);
  color:#111827;
  border:1px solid #dfd4e7;
  border-radius:24px;
  padding:34px 36px;
  margin:0 auto 28px;
  max-width:760px;
  box-shadow:0 14px 34px rgba(74,53,91,.09);
}
.header::before,
.header::after{
  content:"";
  position:absolute;
  border-radius:50%;
  pointer-events:none;
  z-index:0;
}
.header::before{
  width:210px;
  height:210px;
  top:-100px;
  right:-55px;
  background:radial-gradient(circle, rgba(168,85,247,.20) 0%, rgba(168,85,247,0) 72%);
}
.header::after{
  width:180px;
  height:180px;
  bottom:-100px;
  left:-65px;
  background:radial-gradient(circle, rgba(96,165,250,.13) 0%, rgba(96,165,250,0) 72%);
}
.header > *{
  position:relative;
  z-index:1;
}
.header h1{ margin:0; font-size:34px; font-weight:900; color:#111827; letter-spacing:-.45px; line-height:1.15; }
.header p{ margin:10px 0 0; color:#4b5563; opacity:1; font-weight:700; line-height:1.55; }
.card{
  background:white;
  border-radius:20px;
  padding:28px;
  max-width:760px;
  margin:0 auto;
  box-shadow:0 10px 30px rgba(88,28,135,.12);
}
.form-grid{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:20px;
}
.field{
  display:flex;
  flex-direction:column;
  gap:8px;
}
.field.full{ grid-column:1 / -1; }
label{
  font-weight:600;
  color:#374151;
}
input, select, textarea{
  border:1px solid #ddd6fe;
  border-radius:12px;
  padding:13px 14px;
  font-size:15px;
  outline:none;
}
input[readonly]{ background:#f3f4f6; color:#6b7280; cursor:not-allowed; }
input:focus, select:focus, textarea:focus{
  border-color:#7e22ce;
  box-shadow:0 0 0 3px rgba(126,34,206,.12);
}
textarea{
  min-height:90px;
  resize:vertical;
}
.btn-row{
  margin-top:26px;
  display:flex;
  justify-content:flex-end;
  gap:12px;
}
.btn{
  border:none;
  border-radius:12px;
  padding:12px 22px;
  font-weight:700;
  cursor:pointer;
}
.btn-cancel{
  background:#f3f4f6;
  color:#374151;
}
.btn-submit{
  background:#581c87;
  color:white;
}
.alert{
  padding:14px 16px;
  border-radius:12px;
  margin-bottom:18px;
  font-weight:600;
}
.error{
  background:#fee2e2;
  color:#991b1b;
  border:1px solid #fecaca;
}
.success{
  background:#dcfce7;
  color:#166534;
  border:1px solid #bbf7d0;
}
.hint{
  font-size:13px;
  color:#6b7280;
}
@media(max-width:700px){
  .form-grid{grid-template-columns:1fr;}
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

/* Register staff buttons */
.btn-submit {
  background: var(--btn-green) !important;
  border-color: var(--btn-green) !important;
  color: #ffffff !important;
}

.btn-submit:hover {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
}

.btn-cancel {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.btn-cancel:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
}

.btn-row .btn-cancel {
  order: 1 !important;
}

.btn-row .btn-submit {
  order: 2 !important;
}


/* Requested: Clear button grey */
.btn-row .btn-cancel[type="reset"] {
  background: #b9bfc4 !important;
  border-color: #b9bfc4 !important;
  color: #ffffff !important;
}

.btn-row .btn-cancel[type="reset"]:hover {
  background: #a8aeb3 !important;
  border-color: #a8aeb3 !important;
}



/* Requested button colors */
.btn-row {
  display: flex !important;
  justify-content: flex-end !important;
  gap: 12px !important;
}

.btn-row .btn-cancel[type="reset"] {
  order: 1 !important;
  background: #b9bfc4 !important;
  border-color: #b9bfc4 !important;
  color: #ffffff !important;
}

.btn-row .btn-cancel[type="reset"]:hover {
  background: #a8aeb3 !important;
  border-color: #a8aeb3 !important;
}

.btn-row .btn-submit[type="submit"] {
  order: 2 !important;
  background: #5cb85c !important;
  border-color: #5cb85c !important;
  color: #ffffff !important;
}

.btn-row .btn-submit[type="submit"]:hover {
  background: #16a34a !important;
  border-color: #16a34a !important;
}


.validation-error{
  display:none;
  font-size:13px;
  font-weight:600;
  color:#dc2626;
}
input.input-error, textarea.input-error{
  border-color:#ef4444 !important;
  box-shadow:0 0 0 3px rgba(239,68,68,.12) !important;
}
.generated-password-box{
  background:#f0fdf4;
  border:1px solid #bbf7d0;
  color:#166534;
  border-radius:12px;
  padding:14px 16px;
  margin-bottom:18px;
  font-weight:600;
  line-height:1.5;
}
.generated-password-box code{
  display:inline-block;
  background:#ffffff;
  color:#111827;
  border:1px solid #bbf7d0;
  border-radius:8px;
  padding:6px 10px;
  margin-top:6px;
  font-size:16px;
  font-weight:800;
}
.auto-password-note{
  background:#f8fafc;
  border:1px solid #ddd6fe;
  border-radius:12px;
  padding:14px;
  font-size:14px;
  font-weight:600;
  color:#4b5563;
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



/* Final fix: keep register staff header text aligned with dashboard title style */
.header h1 {
  color: #111827 !important;
}
.header p {
  color: #4b5563 !important;
}

</style>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>

<body>

<div class="page">
  <div class="header">
    <h1>Register New Staff</h1>
    <p>Add staff account for Meowy Groom system.</p>
  </div>

  <div class="card">

    <% if(request.getAttribute("generatedStaffUsername") != null){ %>
      <div class="generated-password-box">
        Staff account has been registered successfully.<br>
        Username: <strong>@<%= request.getAttribute("generatedStaffUsername") %></strong><br>
        Temporary password has been sent to <strong><%= request.getAttribute("generatedStaffEmail") %></strong>.
      </div>
    <% } %>

    <% if(request.getAttribute("error") != null){ %>
      <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form id="registerStaffForm" action="${pageContext.request.contextPath}/RegisterStaffController" method="post" data-disable-validation="true" novalidate>
      <div class="form-grid">

        <div class="field">
          <label>Username</label>
          <input type="text" id="staffUsername" name="staffUsername" value="${staffUsername}" placeholder="e.g. nur_khalifah.01" pattern="[a-z0-9._-]+" minlength="3" maxlength="20" title="Use lowercase letters, numbers, underscore (_), dot (.) or hyphen (-). Spaces are not allowed." required>
          <div class="hint">Use lowercase letters, numbers, underscore (_), dot (.) or hyphen (-). No spaces.</div>
          <div id="usernameError" class="validation-error">Username must be 3-20 characters and use lowercase letters, numbers, underscore, dot or hyphen only.</div>
        </div>

        <div class="field">
          <label>Email</label>
          <input type="email" id="staffEmail" name="staffEmail" value="${staffEmail}" placeholder="Enter email" required>
          <div id="emailError" class="validation-error">Please enter a valid email address.</div>
        </div>

        <div class="field">
          <label>Role</label>
          <input type="text" value="Staff" readonly>
        </div>

      </div>

      <div class="btn-row">
        <button type="reset" class="btn btn-cancel">Clear</button>
        <button type="submit" id="registerBtn" class="btn btn-submit">Register Staff</button>
      </div>
    </form>

  </div>
</div>


<script>
(function() {
  const form = document.getElementById('registerStaffForm');
  if (!form) return;

  const username = document.getElementById('staffUsername');
  const email = document.getElementById('staffEmail');

  function setError(input, errorId, isInvalid) {
    const error = document.getElementById(errorId);
    if (input) input.classList.toggle('input-error', isInvalid);
    if (error) error.style.display = isInvalid ? 'block' : 'none';
  }

  function validateForm() {
    const usernameValue = username.value.trim();
    const emailValue = email.value.trim();

    const usernameInvalid = !/^[a-z0-9._-]+$/.test(usernameValue) || usernameValue.length < 3 || usernameValue.length > 20;
    const emailInvalid = !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(emailValue);

    setError(username, 'usernameError', usernameInvalid && usernameValue.length > 0);
    setError(email, 'emailError', emailInvalid && emailValue.length > 0);

    const valid = usernameValue.length > 0 && emailValue.length > 0 && !usernameInvalid && !emailInvalid;
    return valid;
  }

  username.addEventListener('input', function() {
    username.value = username.value.toLowerCase().replace(/\s/g, '');
    validateForm();
  });

  email.addEventListener('input', validateForm);

  username.addEventListener('blur', validateForm);
  email.addEventListener('blur', validateForm);

  form.addEventListener('reset', function() {
    setTimeout(validateForm, 0);
  });

  form.addEventListener('submit', function(event) {
    if (!validateForm()) {
      event.preventDefault();
    }
  });

  validateForm();
})();
</script>

  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>