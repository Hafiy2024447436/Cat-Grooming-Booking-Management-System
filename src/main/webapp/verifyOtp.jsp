<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  if (session.getAttribute("resetEmail") == null || session.getAttribute("resetOtp") == null) {
      response.sendRedirect(request.getContextPath() + "/ForgotPasswordController");
      return;
  }

  String resetEmail = (String) session.getAttribute("resetEmail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Verify OTP</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/base.css" />
  <link rel="stylesheet" href="css/forgotPassword.css" />
  <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

<main class="reset-page-main">
  <div class="reset-card-wrapper">
    <section class="reset-header">
      <div class="logo-box">
        <i data-lucide="shield-check" class="logo-icon"></i>
      </div>
      <h1>Verify OTP</h1>
      <p>We sent a 6-digit OTP to <strong><%= resetEmail %></strong>.</p>
    </section>

    <div class="reset-card">
      <%
        String error = (String) request.getAttribute("error");
        String sent = request.getParameter("sent");
      %>

      <% if ("success".equals(sent)) { %>
        <div class="alert-success">OTP has been sent successfully. Please check your email.</div>
      <% } %>

      <% if (error != null) { %>
        <div class="alert-error"><%= error %></div>
      <% } %>

      <form action="VerifyOtpController" method="post" data-disable-validation="true" novalidate>
        <div class="form-group">
          <label for="otp">OTP Code</label>
          <div class="input-wrapper">
            <i data-lucide="key-round" class="input-icon"></i>
            <input type="text" id="otp" name="otp" maxlength="6" placeholder="Enter 6-digit OTP"
                   class="form-input" required>
          </div>
        </div>

        <button type="submit" class="btn-reset-submit">
          <i data-lucide="check-circle"></i>
          <span>Verify OTP</span>
        </button>
      </form>

      <div class="back-footer">
        <a href="ForgotPasswordController" class="back-link">Request New OTP</a>
      </div>
    </div>
  </div>
</main>

<script>
  lucide.createIcons();
</script>
  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>
</body>
</html>
