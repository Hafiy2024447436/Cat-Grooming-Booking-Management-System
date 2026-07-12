<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Customer Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerDashboard.css?v=dashboard-photo-sync-1" />
</head>
<body>

<main class="main">
  <section class="dashboard-page">

    <c:if test="${not empty errorMessage}">
      <div class="alert-error">${errorMessage}</div>
    </c:if>

    <div class="welcome-card">
      <div class="welcome-left">
        <div class="welcome-icon customer-photo-wrap" aria-hidden="true">
          <img
            class="customer-dashboard-photo"
            src="${pageContext.request.contextPath}/CustomerPhotoController?id=${custID}&v=<%= System.currentTimeMillis() %>"
            alt="Customer photo"
            onload="this.style.display='block'; document.getElementById('dashboardPhotoFallback').style.display='none';"
            onerror="this.style.display='none'; document.getElementById('dashboardPhotoFallback').style.display='flex';"
          />

          <span id="dashboardPhotoFallback" class="dashboard-photo-fallback">
            <svg viewBox="0 0 24 24">
              <path d="M20 21a8 8 0 0 0-16 0"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
          </span>
        </div>

        <div>
          <h1>Welcome back,
            <c:choose>
              <c:when test="${not empty sessionScope.userName}">
                <c:out value="${sessionScope.userName}" />
              </c:when>
              <c:otherwise>Customer</c:otherwise>
            </c:choose>
          </h1>
          <p>Manage your cats, appointments, and invoices in one place.</p>
        </div>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon purple">
          <svg class="cat-face-icon" viewBox="0 0 80 80">
            <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
            <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/>
            <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/>
            <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
            <path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
            <path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
            <path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
          </svg>
        </div>
        <div>
          <p class="stat-value">${empty dashboardStats ? 0 : dashboardStats.totalCats}</p>
          <p class="stat-label">Registered Cats</p>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon blue">
          <svg viewBox="0 0 24 24">
            <path d="M8 2v4"/>
            <path d="M16 2v4"/>
            <rect x="3" y="4" width="18" height="17" rx="2"/>
            <path d="M3 10h18"/>
            <circle cx="17" cy="17" r="4"/>
            <path d="M17 15v2l1.5 1"/>
          </svg>
        </div>
        <div>
          <p class="stat-value">${empty dashboardStats ? 0 : dashboardStats.upcomingCount}</p>
          <p class="stat-label">Upcoming Appointments</p>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon green">
          <svg viewBox="0 0 24 24">
            <path d="M4 4h16v16H4z"/>
            <path d="M8 8h8"/>
            <path d="M8 12h8"/>
            <path d="M8 16h5"/>
          </svg>
        </div>
        <div>
          <p class="stat-value">${empty dashboardStats ? 0 : dashboardStats.invoiceCount}</p>
          <p class="stat-label">Invoices</p>
        </div>
      </div>
    </div>

    <div class="dashboard-grid">
      <section class="panel">
        <div class="panel-head">
          <div>
            <h2>Recent Appointments</h2>
            <p>Your latest grooming activities.</p>
          </div>
          <a href="${pageContext.request.contextPath}/CustomerAppointmentController">View all</a>
        </div>

        <div class="appointment-list">
          <c:choose>
            <c:when test="${not empty recentAppointments}">
              <c:forEach var="appt" items="${recentAppointments}">
                <div class="appointment-row">
                  <div class="appointment-left">
                    <div class="appointment-icon">
                      <svg viewBox="0 0 24 24">
                        <path d="M8 2v4"/>
                        <path d="M16 2v4"/>
                        <rect x="3" y="4" width="18" height="17" rx="2"/>
                        <path d="M3 10h18"/>
                      </svg>
                    </div>
                    <div>
                      <strong><c:out value="${appt.appointmentNo}" /></strong>
                      <small>
                        <c:out value="${appt.catName}" /> •
                        <c:out value="${appt.appointmentDate}" /> at
                        <c:out value="${appt.appointmentTime}" />
                      </small>
                    </div>
                  </div>
                  <span class="status-badge status-${appt.statusClass}">
                    <c:out value="${appt.status}" />
                  </span>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="empty-state">
                <div class="empty-icon">
                  <svg viewBox="0 0 24 24">
                    <path d="M8 2v4"/>
                    <path d="M16 2v4"/>
                    <rect x="3" y="4" width="18" height="17" rx="2"/>
                    <path d="M3 10h18"/>
                  </svg>
                </div>
                <h3>No recent appointments yet</h3>
                <p>Your upcoming or past appointments will appear here.</p>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

      <section class="panel info-panel">
        <div class="panel-head">
          <div>
            <h2>Meowy Groom Info</h2>
            <p>Safe, clean, and stress-free grooming.</p>
          </div>
        </div>

        <div class="brand-mini">
          <img src="${pageContext.request.contextPath}/images/meowy logo.JPG" alt="Meowy Groom logo" />
          <div>
            <strong>Meowy Groom</strong>
            <span>Handled with care and professionalism you can trust.</span>
          </div>
        </div>

        <div class="contact-list">
          <div class="contact-item">
            <span class="contact-icon">
              <svg viewBox="0 0 24 24">
                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
              </svg>
            </span>
            <span>+60 10-774 5512</span>
          </div>

          <div class="contact-item">
            <span class="contact-icon">
              <svg viewBox="0 0 24 24">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                <polyline points="22,6 12,13 2,6"/>
              </svg>
            </span>
            <a href="https://mail.google.com/mail/?view=cm&to=support@meowygroom.com" target="_blank" rel="noopener noreferrer">support@meowygroom.com</a>
          </div>

          <div class="contact-item address-item">
            <span class="contact-icon">
              <svg viewBox="0 0 24 24">
                <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/>
                <circle cx="12" cy="10" r="3"/>
              </svg>
            </span>
            <span>G9, Jalan KNMP 2A, 2, Kompleks Niaga Melaka Perdana, 75450 Ayer Keroh, Melaka</span>
          </div>
        </div>

        <div class="social-row">
          <a href="https://www.facebook.com/meowygroom" target="_blank" rel="noopener noreferrer" class="s-fb" aria-label="Facebook">
            <svg viewBox="0 0 24 24">
              <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>
            </svg>
          </a>
          <a href="https://www.instagram.com/meowy_groom/" target="_blank" rel="noopener noreferrer" class="s-ig" aria-label="Instagram">
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
          <a href="https://www.tiktok.com/@meowygroom" target="_blank" rel="noopener noreferrer" class="s-tt" aria-label="TikTok">
            <svg viewBox="0 0 24 24">
              <path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67
                     a2.89 2.89 0 0 1-5.2 1.74 2.89 2.89 0 0 1 2.31-4.64
                     2.93 2.93 0 0 1 .88.13V9.4a6.84 6.84 0 0 0-1-.05
                     A6.33 6.33 0 0 0 5 20.1a6.34 6.34 0 0 0 10.86-4.43v-7
                     a8.16 8.16 0 0 0 4.77 1.52v-3.4a4.85 4.85 0 0 1-1-.1z"/>
            </svg>
          </a>
        </div>
      </section>
    </div>

    <footer class="dashboard-footer">
      © 2026 Meowy Groom. All rights reserved.
    </footer>

  </section>
</main>


<%@ include file="/notification.jsp" %>
</body>
</html>
