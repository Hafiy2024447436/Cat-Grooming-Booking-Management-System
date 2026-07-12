<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Login Page</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/base.css" />
  <link rel="stylesheet" href="css/login.css" />
  <script src="https://unpkg.com/lucide@latest"></script>

  <style>
    .password-field-wrap .form-input {
      padding-right: 48px;
    }

    .password-eye-btn {
      position: absolute;
      right: 12px;
      top: 50%;
      transform: translateY(-50%);
      width: 34px;
      height: 34px;
      border: none;
      background: transparent;
      color: #7c3aed;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      border-radius: 8px;
      padding: 0;
    }

    .password-eye-btn:hover {
      background: #f3e8ff;
    }

    .password-eye-btn svg {
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


<main class="login-page-main">
  <div class="login-container">
    <div class="login-card-wrapper">
      <section class="login-header" aria-labelledby="loginTitle">
        <div class="logo-box">
          <i data-lucide="user" class="logo-icon"></i>
        </div>
        <h1 id="loginTitle">Welcome Back!</h1>
        <p>Login to Meowy Groom</p>
      </section>

      <div class="login-card">
        <form id="loginForm" action="LoginController" method="post">
          <div class="form-group">
            <label for="role">Login As</label>
            <div class="input-wrapper">
              <i data-lucide="user" class="input-icon"></i>
              <select id="role" name="role" class="form-input">
                <option value="customer">Customer</option>
                <option value="staff">Staff</option>
                <option value="owner">Owner</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="username">Username</label>
            <div class="input-wrapper">
              <i data-lucide="user" class="input-icon"></i>
              <input type="text" id="username" name="username" placeholder="Enter your username" class="form-input" required>
            </div>
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper password-field-wrap">
              <i data-lucide="lock" class="input-icon"></i>
              <input type="password" id="password" name="password" placeholder="Enter your password" class="form-input" required>
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

          <div class="forgot-row">
            <a href="ForgotPasswordController" class="forgot-link">Forgot Password?</a>
          </div>

          <button type="submit" class="btn-login-submit">
            <i data-lucide="log-in"></i>
            <span>Login</span>
          </button>
        </form>

        <%
          String errorMessage = (String) request.getAttribute("errorMessage");
          if (errorMessage != null) {
        %>
          <div class="alert-error"><%= errorMessage %></div>
        <%
          }
        %>

      

        <div class="register-footer">
          <span>Don't have an account? </span>
          <a href="register.jsp" class="register-link">Register here</a>
        </div>
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


<script>
  lucide.createIcons();
</script>


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

<%@ include file="/notification.jsp" %>
</body>
</html>
