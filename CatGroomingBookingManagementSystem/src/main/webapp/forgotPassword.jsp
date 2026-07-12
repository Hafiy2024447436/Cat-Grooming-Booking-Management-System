<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Forgot Password</title>

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
        <i data-lucide="key-round" class="logo-icon"></i>
      </div>
      <h1>Forgot Password</h1>
      <p>Enter your registered email to receive an OTP code.</p>
    </section>

    <div class="reset-card">
      <%
        String error = (String) request.getAttribute("error");
        String role = (String) request.getAttribute("role");
        String email = (String) request.getAttribute("email");
        if (role == null) role = "customer";
        if (email == null) email = "";
      %>

      <% if (error != null) { %>
        <div class="alert-error"><%= error %></div>
      <% } %>

      <form action="ForgotPasswordController" method="post" data-disable-validation="true" novalidate>
        <div class="form-group">
          <label for="role">Account Role</label>
          <div class="input-wrapper">
            <i data-lucide="user" class="input-icon"></i>
            <select id="role" name="role" class="form-input" required>
              <option value="customer" <%= "customer".equals(role) ? "selected" : "" %>>Customer</option>
              <option value="staff" <%= "staff".equals(role) ? "selected" : "" %>>Staff</option>
              <option value="owner" <%= "owner".equals(role) ? "selected" : "" %>>Owner</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label for="email">Registered Email</label>
          <div class="input-wrapper">
            <i data-lucide="mail" class="input-icon"></i>
            <input type="email" id="email" name="email" value="<%= email %>"
                   placeholder="Enter your email" class="form-input" required>
          </div>
        </div>

        <button type="submit" class="btn-reset-submit">
          <i data-lucide="send"></i>
          <span>Send OTP</span>
        </button>
      </form>

      <div class="back-footer">
        <a href="loginPage.jsp" class="back-link">Back to Login</a>
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
