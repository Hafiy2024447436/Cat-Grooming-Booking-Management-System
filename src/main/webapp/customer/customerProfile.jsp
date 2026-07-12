<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>My Profile</title>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />

  <!-- v=final-fix forces browser to load the latest CSS, not old cached CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerProfile.css?v=update-password-box-1" />

  <style>
    .field-input-wrap.password-field-wrap input {
      padding-right: 54px;
    }

    .field-input-wrap.password-field-wrap .password-eye-btn {
      position: absolute;
      right: 14px;
      top: 28px;
      transform: translateY(-50%);
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

    .field-input-wrap.password-field-wrap .password-eye-btn:hover {
      background: #f3e8ff;
    }

    .field-input-wrap.password-field-wrap .password-eye-btn svg {
      width: 20px;
      height: 20px;
      stroke: currentColor;
      fill: none;
      stroke-width: 2;
      stroke-linecap: round;
      stroke-linejoin: round;
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

<!-- SVG symbol defs -->
<svg xmlns="http://www.w3.org/2000/svg" style="display:none">
  <symbol id="ico-user" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
  </symbol>
  <symbol id="ico-at-sign" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <circle cx="12" cy="12" r="4"/><path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"/>
  </symbol>
  <symbol id="ico-lock" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
  </symbol>
  <symbol id="ico-phone" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
  </symbol>
  <symbol id="ico-mail" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
    <polyline points="22,6 12,13 2,6"/>
  </symbol>
</svg>

<main class="main">
  <div class="profile-page-inner">

    <div class="page-heading">
      <h1 class="page-title">Profile</h1>
      <p class="page-subtitle">View and update your personal information</p>
    </div>

    <div class="profile-card">

      <div class="profile-header">
        <div class="avatar-section">
          <div class="avatar-wrapper" id="avatar-wrapper">
            <div class="avatar-circle" id="avatar-circle"></div>

            <label class="avatar-overlay" id="avatar-overlay" style="display: none;">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
                <circle cx="12" cy="13" r="4"/>
              </svg>
              <input type="file" accept="image/*" id="photo-input" name="custProfilePhoto" form="edit-profile-section" />
            </label>

            <button class="remove-photo-btn" id="remove-photo-btn" type="button" style="display: none;" title="Remove photo">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <div class="profile-name-section">
            <h2 id="display-fullname">${cust.custFullName}</h2>
            <p id="display-username">${cust.custUsername}</p>
            <p class="edit-photo-hint" id="edit-photo-hint"></p>
          </div>
        </div>

        <button id="edit-btn" class="edit-btn" type="button" title="Edit Profile" aria-label="Edit Profile">
          <svg class="edit-icon" viewBox="0 0 24 24" aria-hidden="true">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
          </svg>
        </button>
      </div>

      <!-- VIEW PROFILE SECTION -->
      <div id="view-profile-section" class="view-section">
        <div>
          <label class="field-label">Full Name</label>
          <div class="field-display">
            <svg><use href="#ico-user"/></svg>
            <span id="text-fullname">${cust.custFullName}</span>
          </div>
        </div>

        <div>
          <label class="field-label">Username</label>
          <div class="field-display username-display">
            <svg><use href="#ico-at-sign"/></svg>
            <span id="text-username" class="username-text">${cust.custUsername}</span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>

        <div>
          <label class="field-label">Phone Number</label>
          <div class="field-display">
            <svg><use href="#ico-phone"/></svg>
            <span id="text-phone">${cust.custPhoneNumber}</span>
          </div>
        </div>

        <div>
          <label class="field-label">Email Address</label>
          <div class="field-display">
            <svg><use href="#ico-mail"/></svg>
            <span id="text-email">${cust.custEmail}</span>
          </div>
        </div>
      </div>

      <!-- EDIT PROFILE SECTION -->
      <form action="${pageContext.request.contextPath}/CustomerProfileController" method="POST" enctype="multipart/form-data"
            id="edit-profile-section" class="edit-section" style="display: none;" data-disable-validation="true" novalidate>

        <input type="hidden" name="username" value="${cust.custUsername}" />
        <input type="hidden" name="removePhoto" id="remove-photo-input" value="false" />

        <div>
          <label class="field-label">Full Name</label>
          <div class="field-input-wrap">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
            </svg>
            <input type="text" id="input-fullname" name="fullname" value="${cust.custFullName}" placeholder="Full name" minlength="2" maxlength="100" required />
          </div>
          <p id="fullname-error" class="field-error" style="display:none;">Full name must contain letters only and be 2 to 100 characters.</p>
        </div>

        <div>
          <label class="field-label">Username</label>
          <div class="readonly-field username-display">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="4"/>
              <path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"/>
            </svg>
            <span id="edit-readonly-username" class="username-text">${cust.custUsername}</span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>

        <div>
          <label class="field-label">Phone Number</label>
          <div class="field-input-wrap">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
            </svg>
            <input type="tel" id="input-phone" name="phone" value="${cust.custPhoneNumber}" placeholder="Phone number" inputmode="numeric" maxlength="15" required />
          </div>
          <p id="phone-error" class="field-error" style="display:none;">Phone number must contain 10 or 11 digits only.</p>
        </div>

        <div>
          <label class="field-label">Email Address</label>
          <div class="field-input-wrap">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
              <polyline points="22,6 12,13 2,6"/>
            </svg>
            <input type="email" id="input-email" name="email" value="${cust.custEmail}" placeholder="Email address" maxlength="100" required />
          </div>
          <p id="email-error" class="field-error" style="display:none;">Please enter a valid email address.</p>
        </div>

        <div class="password-update-section">
          <div class="password-section-head">
            <h3>Update Password</h3>
            <p>Leave blank if you do not want to change the password.</p>
          </div>

          <div>
            <label class="field-label">New Password</label>
            <div class="field-input-wrap password-field-wrap">
              <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
              </svg>
              <input type="password" id="input-password" name="password" value="" placeholder="Enter new password" autocomplete="new-password" />
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
              <p id="password-error" class="field-error" style="display: none;">Password must be at least 8 characters.</p>
            </div>
          </div>

          <div>
            <label class="field-label">Confirm New Password</label>
            <div class="field-input-wrap password-field-wrap">
              <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
              </svg>
              <input type="password" id="input-confirm-password" name="confirmPassword" value="" placeholder="Confirm new password" autocomplete="new-password" />
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
              <p id="confirm-password-error" class="field-error" style="display: none;">Passwords do not match.</p>
            </div>
          </div>
        </div>

        <div class="action-buttons">
          <button id="cancel-btn" class="btn-cancel" type="button">Cancel</button>
          <button id="save-btn" class="btn-save" type="submit" disabled>Save</button>
        </div>
      </form>
    </div>
  </div>
</main>


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
  (function() {
    let profilePhoto = '${pageContext.request.contextPath}/CustomerPhotoController?id=${cust.custID}&v=<%= System.currentTimeMillis() %>';
    let isEditing = false;

    let profile = {
      fullname: '<c:out value="${cust.custFullName}"/>',
      username: '<c:out value="${cust.custUsername}"/>',
      phone: '<c:out value="${cust.custPhoneNumber}"/>',
      email: '<c:out value="${cust.custEmail}"/>'
    };

    const viewSection = document.getElementById('view-profile-section');
    const editSection = document.getElementById('edit-profile-section');
    const editBtn = document.getElementById('edit-btn');
    const avatarCircle = document.getElementById('avatar-circle');
    const avatarOverlay = document.getElementById('avatar-overlay');
    const removePhotoBtn = document.getElementById('remove-photo-btn');
    const photoInput = document.getElementById('photo-input');
    const editPhotoHint = document.getElementById('edit-photo-hint');
    const removePhotoInput = document.getElementById('remove-photo-input');
    const inputFullname = document.getElementById('input-fullname');
    const inputPassword = document.getElementById('input-password');
    const inputConfirmPassword = document.getElementById('input-confirm-password');
    const inputPhone = document.getElementById('input-phone');
    const inputEmail = document.getElementById('input-email');
    const editReadonlyUsernameSpan = document.getElementById('edit-readonly-username');
    const cancelBtn = document.getElementById('cancel-btn');
    const saveBtn = document.getElementById('save-btn');
    const passwordError = document.getElementById('password-error');
    const confirmPasswordError = document.getElementById('confirm-password-error');
    const fullnameError = document.getElementById('fullname-error');
    const phoneError = document.getElementById('phone-error');
    const emailError = document.getElementById('email-error');

    function setFieldState(input, errorElement, isValid) {
      if (!input || !errorElement) return true;
      if (isValid) {
        errorElement.style.display = 'none';
        input.classList.remove('input-error');
      } else {
        errorElement.style.display = 'block';
        input.classList.add('input-error');
      }
      return isValid;
    }

    function validateProfileFields() {
      const fullnameValue = inputFullname.value.trim();
      const phoneDigits = inputPhone.value.replace(/\D/g, '');
      const emailValue = inputEmail.value.trim();

      const fullnameValid = /^[A-Za-zÀ-ÖØ-öø-ÿ'\- ]{2,100}$/.test(fullnameValue);
      const phoneValid = /^(\d{10}|\d{11})$/.test(phoneDigits);
      const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailValue);

      setFieldState(inputFullname, fullnameError, fullnameValid);
      setFieldState(inputPhone, phoneError, phoneValid);
      setFieldState(inputEmail, emailError, emailValid);

      return fullnameValid && phoneValid && emailValid;
    }

    function renderDefaultAvatar() {
      const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
      svg.setAttribute('width', '40');
      svg.setAttribute('height', '40');
      svg.setAttribute('viewBox', '0 0 24 24');
      svg.setAttribute('fill', 'none');
      svg.setAttribute('stroke', '#7c3aed');
      svg.setAttribute('stroke-width', '2');
      svg.setAttribute('stroke-linecap', 'round');
      svg.setAttribute('stroke-linejoin', 'round');
      svg.innerHTML = '<circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>';
      avatarCircle.appendChild(svg);
    }

    function renderAvatar() {
      avatarCircle.innerHTML = '';

      if (profilePhoto) {
        const img = document.createElement('img');
        img.src = profilePhoto;
        img.alt = 'Profile avatar';
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.objectFit = 'cover';
        img.onerror = function() {
          profilePhoto = null;
          avatarCircle.innerHTML = '';
          renderDefaultAvatar();
        };
        avatarCircle.appendChild(img);
      } else {
        renderDefaultAvatar();
      }
    }

    function validateForm() {
      const fieldsValid = validateProfileFields();
      const passwordValue = inputPassword.value.trim();
      const confirmValue = inputConfirmPassword.value.trim();

      const hasPassword = passwordValue.length > 0 || confirmValue.length > 0;
      const isTooShort = passwordValue.length > 0 && passwordValue.length < 8;
      const isMismatch = hasPassword && passwordValue !== confirmValue;

      setFieldState(inputPassword, passwordError, !isTooShort);
      setFieldState(inputConfirmPassword, confirmPasswordError, !isMismatch);

      const valid = fieldsValid && !isTooShort && !isMismatch;
      saveBtn.disabled = !valid;
      return valid;
    }

    function setEditingMode(editing) {
      isEditing = editing;

      if (isEditing) {
        viewSection.style.display = 'none';
        editSection.style.display = 'flex';
        avatarOverlay.style.display = 'flex';
        editPhotoHint.style.display = 'block';
        editBtn.style.display = 'none';
        removePhotoBtn.style.display = profilePhoto ? 'flex' : 'none';
        editPhotoHint.textContent = 'Click camera icon to change photo';
      } else {
        viewSection.style.display = 'flex';
        editSection.style.display = 'none';
        avatarOverlay.style.display = 'none';
        editPhotoHint.style.display = 'none';
        editBtn.style.display = 'flex';
        removePhotoBtn.style.display = 'none';
      }
    }

    function cancelChanges() {
      inputFullname.value = profile.fullname;
      inputPhone.value = profile.phone;
      inputEmail.value = profile.email;
      inputPassword.value = '';
      inputConfirmPassword.value = '';
      photoInput.value = '';
      if (removePhotoInput) removePhotoInput.value = 'false';
      validateForm();

      if (editReadonlyUsernameSpan) {
        editReadonlyUsernameSpan.textContent = profile.username;
      }

      setEditingMode(false);
    }

    photoInput.addEventListener('change', function(e) {
      const file = e.target.files && e.target.files[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onloadend = function() {
        profilePhoto = reader.result;
        if (removePhotoInput) removePhotoInput.value = 'false';
        renderAvatar();
        if (isEditing) removePhotoBtn.style.display = 'flex';
      };
      reader.readAsDataURL(file);
    });

    removePhotoBtn.addEventListener('click', function() {
      profilePhoto = null;
      photoInput.value = '';
      if (removePhotoInput) removePhotoInput.value = 'true';
      renderAvatar();
      if (isEditing) removePhotoBtn.style.display = 'none';
    });

    editBtn.addEventListener('click', function() {
      inputFullname.value = profile.fullname;
      inputPhone.value = profile.phone;
      inputEmail.value = profile.email;
      inputPassword.value = '';
      inputConfirmPassword.value = '';
      photoInput.value = '';
      if (removePhotoInput) removePhotoInput.value = 'false';
      validateForm();

      if (editReadonlyUsernameSpan) {
        editReadonlyUsernameSpan.textContent = profile.username;
      }

      setEditingMode(true);
    });

    cancelBtn.addEventListener('click', cancelChanges);

    avatarOverlay.addEventListener('click', function(e) {
      e.stopPropagation();
      if (isEditing) photoInput.click();
    });

    inputFullname.addEventListener('input', validateForm);
    inputPhone.addEventListener('input', function() {
      this.value = this.value.replace(/[^0-9]/g, '').slice(0, 11);
      validateForm();
    });
    inputEmail.addEventListener('input', validateForm);
    inputPassword.addEventListener('input', validateForm);
    inputConfirmPassword.addEventListener('input', validateForm);

    editSection.addEventListener('submit', function(e) {
      if (!validateForm()) {
        e.preventDefault();

        if (inputFullname.classList.contains('input-error')) {
          inputFullname.focus();
        } else if (inputPhone.classList.contains('input-error')) {
          inputPhone.focus();
        } else if (inputEmail.classList.contains('input-error')) {
          inputEmail.focus();
        } else if (inputPassword.classList.contains('input-error')) {
          inputPassword.focus();
        } else if (inputConfirmPassword.classList.contains('input-error')) {
          inputConfirmPassword.focus();
        }
      }
    });

    renderAvatar();
    validateForm();
    setEditingMode(false);
  })();
</script>


  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>
