<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Register Page</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/base.css" />
  <link rel="stylesheet" href="css/register.css?v=green-button-final-2" />

<style>
  /* FINAL REGISTER BUTTON FIX - stronger than old purple style */
  .register-card .register-button-row,
  .register-card .btn-row {
    display: flex !important;
    gap: 18px !important;
    margin-top: 10px !important;
  }

  .register-card .register-button-row .btn,
  .register-card .btn-row .btn {
    flex: 1 !important;
    min-height: 56px !important;
    border-radius: 12px !important;
    border: none !important;
    font-family: 'Nunito', sans-serif !important;
    font-weight: 900 !important;
    font-size: 16px !important;
  }

  .register-card .register-button-row .btn-cancel,
  .register-card .btn-row .btn-cancel {
    order: 1 !important;
    background: #ef4444 !important;
    border-color: #ef4444 !important;
    color: #ffffff !important;
  }

  .register-card .register-button-row .btn-cancel:hover,
  .register-card .btn-row .btn-cancel:hover {
    background: #dc2626 !important;
    border-color: #dc2626 !important;
  }

  .register-card .register-button-row .btn-register,
  .register-card .btn-row .btn-register {
    order: 2 !important;
    background: #5cb85c !important;
    border-color: #5cb85c !important;
    color: #ffffff !important;
  }

  .register-card .register-button-row .btn-register:hover,
  .register-card .btn-row .btn-register:hover {
    background: #16a34a !important;
    border-color: #16a34a !important;
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
.input-wrap.password-field-wrap input {
  padding-right: 52px !important;
}

.password-eye-btn {
  position: absolute;
  right: 10px;
  top: 50%;
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

.password-eye-btn:hover {
  background: #f3e8ff;
}

.input-wrap .password-eye-btn svg {
  position: static !important;
  transform: none !important;
  width: 20px !important;
  height: 20px !important;
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
<!-- ════════════════════════
     HEADER
════════════════════════ -->
<header>
  <div class="header-inner">
    <div class="brand">
      <img src="images/meowy logo.JPG" alt="Meowy Groom logo" />
      <div class="brand-text">
        <h1>Meowy Groom</h1>
        <p>Cat Grooming Booking Management System</p>
      </div>
    </div>

    <nav>
      <a href="index.html" class="nav-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            width="18" height="18">
          <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
          <polyline points="9 22 9 12 15 12 15 22"/>
        </svg>
        Home
      </a>

      <a href="aboutUs.html" class="nav-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            width="18" height="18">
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
          <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
        </svg>
        About Us
      </a>

      <a href="https://tinyurl.com/yf72ex26" target="_blank" rel="noopener noreferrer" class="nav-btn">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            width="18" height="18">
          <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/>
          <rect x="8" y="2" width="8" height="4" rx="1" ry="1"/>
        </svg>
        Feedback
      </a>
    </nav>
  </div>
</header>


<main class="register-page-main">
  <div class="container">
    <section class="register-header" aria-labelledby="registerTitle">
      <div class="logo">
        <svg viewBox="0 0 24 24">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
          <circle cx="12" cy="7" r="4"/>
        </svg>
      </div>

      <h1 id="registerTitle">Register Page</h1>
      <p>Account Registration</p>
    </section>

    <div class="register-card">
      <form action="RegisterController" method="post" data-disable-validation="true" novalidate>
        <div class="field">
          <label>Full Name</label>
          <div class="input-wrap">
            <svg viewBox="0 0 24 24">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
            <input type="text" name="fullName" placeholder="Enter your full name" value="${fullName}" required>
          </div>
        </div>

        <div class="field">
          <label>Username</label>
          <div class="input-wrap">
            <svg viewBox="0 0 24 24">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
            <input type="text" name="username" placeholder="Choose a username" value="${username}" required>
          </div>
        </div>

        <div class="field">
          <label>Phone Number</label>
          <div class="input-wrap">
            <svg viewBox="0 0 24 24">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.61 1h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L7.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
            </svg>
            <input type="tel" name="phoneNumber" placeholder="Enter your phone number" value="${phoneNumber}" required>
          </div>
        </div>

        <div class="field">
          <label>Email</label>
          <div class="input-wrap">
            <svg viewBox="0 0 24 24">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
              <polyline points="22,6 12,13 2,6"/>
            </svg>
            <input type="email" name="email" placeholder="Enter your email" value="${email}" required>
          </div>
        </div>

        <div class="field">
          <label>Password</label>
          <div class="input-wrap password-field-wrap">
            <svg viewBox="0 0 24 24">
              <rect x="3" y="11" width="18" height="11" rx="2"/>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <input type="password" name="password" placeholder="Create a password (min 9 characters)" required>
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
          </div>
        </div>

        <div class="field">
          <label>Confirm Password</label>
          <div class="input-wrap password-field-wrap">
            <svg viewBox="0 0 24 24">
              <rect x="3" y="11" width="18" height="11" rx="2"/>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <input type="password" name="confirmPassword" placeholder="Confirm your password" required>
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
          </div>
        </div>

        <%
          String error = (String) request.getAttribute("error");
          if (error != null) {
        %>
          <div class="alert-error">
            <%
              if (error.equals("empty")) {
                out.print("Please fill in all fields.");
              } else if (error.equals("fullNameInvalid")) {
                out.print("Full name can only contain letters, spaces, hyphens, and apostrophes.");
              } else if (error.equals("fullNameHasNumber")) {
                out.print("Full name cannot contain numbers.");
              } else if (error.equals("fullNameLength")) {
                out.print("Full name must be between 2 to 100 characters.");
              } else if (error.equals("passwordMismatch")) {
                out.print("Passwords do not match.");
              } else if (error.equals("passwordShort")) {
                out.print("Password must be at least 8 characters.");
              } else if (error.equals("phoneInvalid")) {
                out.print("Phone number must be 10-11 digits.");
              } else if (error.equals("usernameExists")) {
                out.print("Username already exists. Please choose another.");
              } else if (error.equals("emailExists")) {
                out.print("Email already exists. Please use another.");
              } else if (error.equals("registrationFailed")) {
                out.print("Registration failed. Please try again.");
              } else if (error.equals("usernameInvalid")) {
                out.print("Username can include lowercase letters, numbers, underscore (_), dot (.) and hyphen (-). Spaces and uppercase letters are not allowed.");
              } else if (error.equals("usernameNumbersOnly")) {
                out.print("Username can include lowercase letters, numbers, underscore (_), dot (.) and hyphen (-). Spaces and uppercase letters are not allowed.");
              } else if (error.equals("usernameLength")) {
                out.print("Username must be between 3 to 20 characters.");
              } else {
                out.print("Registration failed. Please try again.");
              }
            %>
          </div>
        <%
          }
        %>

        <div class="btn-row register-button-row">
          <a href="${pageContext.request.contextPath}/loginPage.jsp"
             class="btn btn-cancel"
             style="background:#ef4444 !important;border-color:#ef4444 !important;color:#ffffff !important;text-decoration:none;display:flex;align-items:center;justify-content:center;">
            Cancel
          </a>

          <button type="submit"
                  class="btn btn-register"
                  style="background:#5cb85c !important;border-color:#5cb85c !important;color:#ffffff !important;">
            Register
          </button>
        </div>
      </form>

      <div class="login-link">
        Already have an account?
        <a href="loginPage.jsp">Log in</a>
      </div>
    </div>
  </div>
</main>

<!-- ════════════════════════
     FOOTER
════════════════════════ -->
<footer>
  <div class="footer-inner">
    <div>
      <h3>Contact Us</h3>
      <ul class="contact-list">
        <li>
          <svg viewBox="0 0 24 24">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07
                     A19.5 19.5 0 0 1 4.36 12a19.79 19.79 0 0 1-3.07-8.67
                     A2 2 0 0 1 3.11 1.18h3a2 2 0 0 1 2 1.72
                     c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11
                     L7.09 9.91a16 16 0 0 0 6 6l1.27-1.27
                     a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7
                     A2 2 0 0 1 21 16.92z"/>
          </svg>
          +60 10-774 5512
        </li>
        <li>
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
              fill="none" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
            <polyline points="22,6 12,13 2,6"/>
          </svg>
          <a href="https://mail.google.com/mail/?view=cm&to=support@meowygroom.com"
             target="_blank" rel="noopener noreferrer" class="footer-mail-link">support@meowygroom.com</a>
        </li>
        <li>
          <svg viewBox="0 0 24 24">
            <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
            <circle cx="12" cy="10" r="3"/>
          </svg>
          <span>G9, Jalan KNMP 2A, 2, Kompleks Niaga<br/>Melaka Perdana, 75450 Ayer Keroh, Melaka</span>
        </li>
      </ul>
    </div>

    <div class="footer-brand">
      <div class="footer-brand-row">
        <img src="images/meowy logo.JPG" alt="Meowy Groom" />
        <span>Meowy Groom</span>
      </div>
      <p>
        Safe, Clean, and Stress-Free Grooming.<br/>
        Handled with care and professionalism<br/>
        you can trust.
      </p>
      <p class="footer-copy">© 2026 Meowy Groom. All rights reserved.</p>
    </div>

    <div class="footer-social">
      <h3>Follow Us</h3>
      <div class="social-row">
        <a href="https://www.facebook.com/meowygroom" target="_blank" rel="noopener noreferrer"
           class="s-fb" aria-label="Facebook">
          <svg viewBox="0 0 24 24">
            <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/>
          </svg>
        </a>
        <a href="https://www.instagram.com/meowy_groom/" target="_blank" rel="noopener noreferrer"
           class="s-ig" aria-label="Instagram">
          <svg viewBox="0 0 24 24">
            <path d="M12 2c2.717 0 3.056.01 4.122.06 1.065.05 1.79.217 2.428.465
                     .66.254 1.216.598 1.772 1.153a4.908 4.908 0 0 1 1.153 1.772
                     c.247.637.415 1.363.465 2.428.047 1.066.06 1.405.06 4.122
                     0 2.717-.01 3.056-.06 4.122-.05 1.065-.218 1.79-.465 2.428
                     a4.883 4.883 0 0 1-1.153 1.772 4.915 4.915 0 0 1-1.772 1.153
                     c-.637.247-1.363.415-2.428.465-1.066.047-1.405.06-4.122.06
                     -2.717 0-3.056-.01-4.122-.06-1.065-.05-1.79-.218-2.428-.465
                     a4.89 4.89 0 0 1-1.772-1.153 4.904 4.904 0 0 1-1.153-1.772
                     c-.248-.637-.415-1.363-.465-2.428C2.013 15.056 2 14.717 2 12
                     c0-2.717.01-3.056.06-4.122.05-1.066.217-1.79.465-2.428
                     a4.88 4.88 0 0 1 1.153-1.772A4.897 4.897 0 0 1 5.45 2.525
                     c.638-.248 1.362-.415 2.428-.465C8.944 2.013 9.283 2 12 2z
                     m0 5a5 5 0 1 0 0 10 5 5 0 0 0 0-10z
                     m6.5-.25a1.25 1.25 0 0 0-2.5 0 1.25 1.25 0 0 0 2.5 0z
                     M12 9a3 3 0 1 1 0 6 3 3 0 0 1 0-6z"/>
          </svg>
        </a>
        <a href="https://www.tiktok.com/@meowygroom" target="_blank" rel="noopener noreferrer"
           class="s-tt" aria-label="TikTok">
          <svg viewBox="0 0 24 24">
            <path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67
                     a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64
                     2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05
                     A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7
                     a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/>
          </svg>
        </a>
      </div>
    </div>
  </div>
</footer>



  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>

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

</body>
</html>
