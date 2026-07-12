<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (!Boolean.TRUE.equals(session.getAttribute("resetOtpVerified"))) {
        response.sendRedirect(
            request.getContextPath() + "/ForgotPasswordController"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reset Password</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="css/base.css">

    <link rel="stylesheet"
          href="css/forgotPassword.css">

    <style>
        /* Hide browser default password reveal icon */
        .password-input::-ms-reveal,
        .password-input::-ms-clear {
            display: none;
            width: 0;
            height: 0;
        }

        .password-input::-webkit-credentials-auto-fill-button,
        .password-input::-webkit-caps-lock-indicator {
            display: none !important;
        }

        /* Space for custom eye button */
        .password-input {
            padding-right: 52px !important;
        }

        /* Custom eye button */
        .input-wrapper .password-toggle {
            position: absolute !important;
            top: 50% !important;
            right: 14px !important;
            transform: translateY(-50%) !important;

            width: 24px !important;
            height: 24px !important;
            min-width: 24px !important;
            min-height: 24px !important;

            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;

            padding: 0 !important;
            margin: 0 !important;

            background: transparent !important;
            border: none !important;
            border-radius: 0 !important;
            box-shadow: none !important;
            outline: none !important;

            color: #8b5cf6 !important;
            cursor: pointer;
            z-index: 5;

            appearance: none;
            -webkit-appearance: none;
        }

        .input-wrapper .password-toggle:hover,
        .input-wrapper .password-toggle:focus,
        .input-wrapper .password-toggle:focus-visible,
        .input-wrapper .password-toggle:active {
            background: transparent !important;
            border: none !important;
            box-shadow: none !important;
            outline: none !important;
            color: #7c3aed !important;
            transform: translateY(-50%) !important;
        }

        .input-wrapper .password-toggle svg {
            display: block !important;
            width: 22px !important;
            height: 22px !important;

            margin: 0 !important;
            padding: 0 !important;

            fill: none !important;
            stroke: currentColor !important;
            stroke-width: 2 !important;
            stroke-linecap: round !important;
            stroke-linejoin: round !important;

            pointer-events: none;
        }
    </style>

    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body>

<main class="reset-page-main">

    <div class="reset-card-wrapper">

        <section class="reset-header no-logo-header">
            <h1>Reset Password</h1>

            <p>
                Create a new password for your account.
            </p>
        </section>

        <div class="reset-card">

            <%
                String error =
                    (String) request.getAttribute("error");
            %>

            <% if (error != null) { %>

                <div class="alert-error">
                    <%= error %>
                </div>

            <% } %>

            <form action="ResetPasswordController"
                  method="post"
                  data-disable-validation="true"
                  novalidate>

                <!-- New Password -->
                <div class="form-group">

                    <label for="newPassword">
                        New Password
                    </label>

                    <div class="input-wrapper password-wrapper">

                        <i data-lucide="lock"
                           class="input-icon"></i>

                        <input type="password"
                               id="newPassword"
                               name="newPassword"
                               placeholder="Enter new password"
                               class="form-input password-input"
                               autocomplete="new-password"
                               required>

                        <button type="button"
                                class="password-toggle"
                                onclick="togglePassword('newPassword', this)"
                                aria-label="Show new password"
                                aria-pressed="false">

                            <!-- Eye open: password is hidden -->
                            <svg viewBox="0 0 24 24"
                                 aria-hidden="true">

                                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"></path>

                                <circle cx="12"
                                        cy="12"
                                        r="3"></circle>
                            </svg>

                        </button>

                    </div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">

                    <label for="confirmPassword">
                        Confirm Password
                    </label>

                    <div class="input-wrapper password-wrapper">

                        <i data-lucide="lock"
                           class="input-icon"></i>

                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Confirm new password"
                               class="form-input password-input"
                               autocomplete="new-password"
                               required>

                        <button type="button"
                                class="password-toggle"
                                onclick="togglePassword('confirmPassword', this)"
                                aria-label="Show confirm password"
                                aria-pressed="false">

                            <!-- Eye open: password is hidden -->
                            <svg viewBox="0 0 24 24"
                                 aria-hidden="true">

                                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"></path>

                                <circle cx="12"
                                        cy="12"
                                        r="3"></circle>
                            </svg>

                        </button>

                    </div>
                </div>

                <button type="submit"
                        class="btn-reset-submit">

                    <span>Reset Password</span>

                </button>

            </form>

        </div>

    </div>

</main>

<script>
    /*
     * Convert Lucide lock icons only.
     * Password eye icons use custom SVG so they can
     * change reliably between eye and eye-off.
     */
    lucide.createIcons();

    function getEyeOpenIcon() {
        return `
            <svg viewBox="0 0 24 24"
                 aria-hidden="true">

                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"></path>

                <circle cx="12"
                        cy="12"
                        r="3"></circle>
            </svg>
        `;
    }

    function getEyeOffIcon() {
        return `
            <svg viewBox="0 0 24 24"
                 aria-hidden="true">

                <path d="M3 3l18 18"></path>

                <path d="M10.6 10.6a2 2 0 0 0 2.8 2.8"></path>

                <path d="M9.9 4.2A10.6 10.6 0 0 1 12 4c6.5 0 10 8 10 8a17.8 17.8 0 0 1-2.1 3.3"></path>

                <path d="M6.6 6.6C3.5 8.4 2 12 2 12s3.5 8 10 8a10.7 10.7 0 0 0 5.4-1.4"></path>
            </svg>
        `;
    }

    function togglePassword(inputId, button) {
        const input =
            document.getElementById(inputId);

        if (!input || !button) {
            return;
        }

        const isPasswordHidden =
            input.type === "password";

        if (isPasswordHidden) {
            input.type = "text";

            /* Show eye with slash */
            button.innerHTML =
                getEyeOffIcon();

            button.setAttribute(
                "aria-label",
                "Hide password"
            );

            button.setAttribute(
                "aria-pressed",
                "true"
            );
        } else {
            input.type = "password";

            /* Show normal eye */
            button.innerHTML =
                getEyeOpenIcon();

            button.setAttribute(
                "aria-label",
                "Show password"
            );

            button.setAttribute(
                "aria-pressed",
                "false"
            );
        }
    }
</script>

<script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

</body>
</html>