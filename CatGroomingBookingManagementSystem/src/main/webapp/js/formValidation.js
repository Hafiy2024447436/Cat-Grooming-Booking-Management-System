(function () {
  'use strict';

  var DISABLED_COLOR = '#d1d5db';

  function injectDisabledStyle() {
    if (document.getElementById('meowy-disabled-button-style')) return;

    var style = document.createElement('style');
    style.id = 'meowy-disabled-button-style';
    style.textContent = '\n' +
      'button:disabled, input[type="submit"]:disabled, input[type="button"]:disabled, .btn:disabled, .btn-save:disabled, .btn-register:disabled, .btn-submit:disabled, .btn-reset-submit:disabled, .save-btn:disabled, .is-form-disabled {\n' +
      '  background: ' + DISABLED_COLOR + ' !important;\n' +
      '  background-color: ' + DISABLED_COLOR + ' !important;\n' +
      '  background-image: none !important;\n' +
      '  border-color: ' + DISABLED_COLOR + ' !important;\n' +
      '  color: #ffffff !important;\n' +
      '  cursor: not-allowed !important;\n' +
      '  opacity: 1 !important;\n' +
      '  box-shadow: none !important;\n' +
      '  transform: none !important;\n' +
      '}\n' +
      'button:disabled:hover, input[type="submit"]:disabled:hover, input[type="button"]:disabled:hover, .btn:disabled:hover, .btn-save:disabled:hover, .btn-register:disabled:hover, .btn-submit:disabled:hover, .btn-reset-submit:disabled:hover, .save-btn:disabled:hover, .is-form-disabled:hover {\n' +
      '  background: ' + DISABLED_COLOR + ' !important;\n' +
      '  background-color: ' + DISABLED_COLOR + ' !important;\n' +
      '  background-image: none !important;\n' +
      '  border-color: ' + DISABLED_COLOR + ' !important;\n' +
      '  color: #ffffff !important;\n' +
      '  transform: none !important;\n' +
      '  box-shadow: none !important;\n' +
      '}\n' +
      '.input-error, .is-invalid {\n' +
      '  border-color: #ef4444 !important;\n' +
      '  box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.15) !important;\n' +
      '}\n';

    document.head.appendChild(style);
  }

  function valueOf(field) {
    if (!field) return '';
    if (field.type === 'checkbox' || field.type === 'radio') return field.checked ? field.value : '';
    return (field.value || '').trim();
  }

  function isIgnored(field) {
    if (!field || field.disabled || field.readOnly) return true;
    if (field.type === 'hidden' || field.type === 'button' || field.type === 'submit' || field.type === 'reset') return true;
    if (field.type === 'file') return true;
    return false;
  }

  function fieldKey(field) {
    return ((field.name || '') + ' ' + (field.id || '') + ' ' + (field.getAttribute('placeholder') || '')).toLowerCase();
  }

  function validEmail(value) {
    return value.length <= 70 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
  }

  function validFullName(value) {
    return /^[A-Za-zÀ-ÖØ-öø-ÿ' .-]{2,100}$/.test(value) && !/\d/.test(value);
  }

  function validUsername(value) {
    return /^[a-z0-9._-]{3,20}$/.test(value);
  }

  function validPhone(value) {
    return /^[0-9]{10,11}$/.test(value);
  }

  function validDateNotFuture(value) {
    if (!value) return false;
    var selected = new Date(value);
    if (isNaN(selected.getTime())) return false;
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    selected.setHours(0, 0, 0, 0);
    return selected <= today;
  }

  function validOtp(value) {
    return /^\d{6}$/.test(value);
  }

  function setInvalid(field, invalid) {
    if (!field) return;
    field.classList.toggle('input-error', invalid);
    field.classList.toggle('is-invalid', invalid);
  }

  function setDisabledButtonVisual(button, disabled) {
    if (!button) return;

    if (!button.hasAttribute('data-original-style')) {
      button.setAttribute('data-original-style', button.getAttribute('style') || '');
    }

    button.disabled = disabled;
    button.classList.toggle('is-form-disabled', disabled);
    button.setAttribute('aria-disabled', disabled ? 'true' : 'false');

    if (disabled) {
      /* Inline !important is needed because some buttons have inline background styles. */
      button.style.setProperty('background', DISABLED_COLOR, 'important');
      button.style.setProperty('background-color', DISABLED_COLOR, 'important');
      button.style.setProperty('background-image', 'none', 'important');
      button.style.setProperty('border-color', DISABLED_COLOR, 'important');
      button.style.setProperty('color', '#ffffff', 'important');
      button.style.setProperty('cursor', 'not-allowed', 'important');
      button.style.setProperty('opacity', '1', 'important');
      button.style.setProperty('box-shadow', 'none', 'important');
      button.style.setProperty('transform', 'none', 'important');
    } else {
      var originalStyle = button.getAttribute('data-original-style') || '';
      if (originalStyle) {
        button.setAttribute('style', originalStyle);
      } else {
        button.removeAttribute('style');
      }
    }
  }

  function validateRequiredGroup(form, selector) {
    var inputs = Array.prototype.slice.call(form.querySelectorAll(selector));
    if (!inputs.length) return true;
    return inputs.some(function (input) { return input.checked; });
  }

  function validateField(field, form) {
    if (isIgnored(field)) return true;

    var key = fieldKey(field);
    var value = valueOf(field);
    var required = field.hasAttribute('required');
    var shouldValidate = required || value.length > 0;
    var valid = true;

    if (required && value.length === 0) valid = false;

    if (shouldValidate && valid) {
      if (key.indexOf('otp') !== -1) {
        valid = validOtp(value);
      } else if (field.type === 'email' || key.indexOf('email') !== -1) {
        valid = validEmail(value);
      } else if (key.indexOf('phone') !== -1 || key.indexOf('tel') !== -1) {
        valid = validPhone(value);
      } else if (key.indexOf('username') !== -1) {
        valid = validUsername(value);
      } else if (key.indexOf('fullname') !== -1 || key.indexOf('full name') !== -1 || key.indexOf('name') !== -1 && key.indexOf('cat') === -1 && key.indexOf('username') === -1) {
        valid = validFullName(value);
      } else if (field.type === 'date' || key.indexOf('dateofbirth') !== -1 || key.indexOf('date of birth') !== -1 || key.indexOf('dob') !== -1) {
        valid = validDateNotFuture(value);
      } else if (field.type === 'password') {
        var isConfirm = key.indexOf('confirm') !== -1;
        var passwordField = form.querySelector('input[type="password"]:not([name*="confirm" i]):not([id*="confirm" i])');
        var passwordValue = valueOf(passwordField);

        if (!isConfirm) {
          valid = !shouldValidate || value.length >= 8;
        } else {
          valid = (passwordValue.length === 0 && value.length === 0) || (passwordValue.length >= 8 && value === passwordValue);
        }
      }
    }

    if (field.tagName === 'SELECT' && required && value.length === 0) valid = false;

    setInvalid(field, !valid);
    return valid;
  }

  function validateSpecialForm(form) {
    if (form.id === 'editAppointmentForm') {
      var mainOk = validateRequiredGroup(form, '.main-service-input');
      var timeOk = validateRequiredGroup(form, 'input[name="appointmentTime"]');
      var weightOk = true;
      var checkedMain = form.querySelector('.main-service-input:checked');

      if (checkedMain && checkedMain.classList.contains('weight-main-input')) {
        var group = checkedMain.getAttribute('data-group');
        weightOk = !!form.querySelector('.weight-service-radio[data-group="' + group + '"]:checked');
      }

      return mainOk && timeOk && weightOk;
    }

    return true;
  }

  function validateForm(form) {
    var fields = Array.prototype.slice.call(form.querySelectorAll('input, select, textarea'));
    var valid = fields.every(function (field) { return validateField(field, form); });
    valid = valid && validateSpecialForm(form);

    var submitButtons = Array.prototype.slice.call(form.querySelectorAll('button[type="submit"], input[type="submit"]'));
    submitButtons.forEach(function (button) {
      setDisabledButtonVisual(button, !valid);
    });

    return valid;
  }

  function initForm(form) {
    var validateNow = function () { validateForm(form); };

    form.addEventListener('input', validateNow);
    form.addEventListener('change', validateNow);
    form.addEventListener('keyup', validateNow);
    form.addEventListener('reset', function () { setTimeout(validateNow, 0); });

    form.addEventListener('submit', function (event) {
      if (!validateForm(form)) {
        event.preventDefault();
        var firstInvalid = form.querySelector('.input-error, .is-invalid, input:invalid, select:invalid, textarea:invalid');
        if (firstInvalid && typeof firstInvalid.focus === 'function') firstInvalid.focus();
      }
    });

    validateNow();
  }

  document.addEventListener('DOMContentLoaded', function () {
    injectDisabledStyle();
    Array.prototype.slice.call(document.querySelectorAll('form[data-disable-validation="true"]')).forEach(initForm);
  });
})();
