<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.AppointmentViewRow"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.ServiceDetail"%>

<%!
private String safe(String value) {
    if (value == null || value.trim().isEmpty()) {
        return "-";
    }
    return value;
}

private String money(double value) {
    return String.format("%.2f", value);
}

private String weightDisplay(Double weight) {
    if (weight == null || weight <= 0) {
        return "Not recorded yet";
    }
    return String.format("%.2f kg", weight);
}

private String statusClass(String status) {
    if (status == null) {
        return "status-pending";
    }

    String s = status.trim().toLowerCase();

    if ("confirmed".equals(s)) {
        return "status-confirmed";
    }

    if ("completed".equals(s)) {
        return "status-completed";
    }

    if ("cancelled".equals(s)) {
        return "status-cancelled";
    }

    return "status-pending";
}

private String firstCatName(List<String> catNames) {
    if (catNames == null || catNames.isEmpty()) {
        return "-";
    }
    return catNames.get(0);
}
%>

<%
AppointmentViewRow appt = (AppointmentViewRow) request.getAttribute("appt");

if (appt == null) {
    response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
    return;
}

List<ServiceDetail> services = appt.services;
List<ServiceDetail> mainServices = appt.mainServices;
List<ServiceDetail> addOnServices = appt.addOnServices;

if (services == null) {
    services = new java.util.ArrayList<ServiceDetail>();
}

if (mainServices == null) {
    mainServices = new java.util.ArrayList<ServiceDetail>();
}

if (addOnServices == null) {
    addOnServices = new java.util.ArrayList<ServiceDetail>();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>View Appointment Details</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
      rel="stylesheet">

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Nunito', sans-serif;
    background: linear-gradient(
        160deg,
        #f5f3ff 0%,
        #fdf4ff 42%,
        #eff6ff 100%
    );
    color: #111827;
    min-height: 100vh;
}

.page-wrapper {
    min-height: 100vh;
    padding: 34px 20px 46px;
}

.details-container {
    position: relative;
    max-width: 800px;
    margin: 0 auto;
}

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #ffffff;
    text-decoration: none;
    font-size: 15px;
    font-weight: 900;
    margin-bottom: 18px;
}

.back-link:hover {
    color: #c4b5fd;
}

.back-link svg {
    width: 22px;
    height: 22px;
}

.header-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    margin-bottom: 18px;
}

.header-left {
    display: flex;
    align-items: center;
    gap: 18px;
}

.header-icon {
    width: 58px;
    height: 58px;
    border-radius: 16px;
    background: linear-gradient(135deg, #f97316, #fb923c);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 12px 26px rgba(249, 115, 22, 0.3);
}

.header-icon svg {
    width: 28px;
    height: 28px;
}

.header-title {
    font-family: 'Nunito', sans-serif;
    font-size: 27px;
    font-weight: 700;
    color: white;
}

.header-subtitle {
    margin-top: 4px;
    color: #a7adbd;
    font-size: 14px;
    font-weight: 800;
}

.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 9px 18px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 900;
}

.status-pending {
    background: #fef3c7;
    color: #b45309;
}

.status-confirmed {
    background: #dbeafe;
    color: #1d4ed8;
}

.status-completed {
    background: #dcfce7;
    color: #166534;
}

.status-cancelled {
    background: #fee2e2;
    color: #b91c1c;
}

.card {
    border-radius: 20px;
    padding: 24px 26px;
    margin-bottom: 20px;
    border: 2px solid transparent;
    box-shadow: 0 16px 38px rgba(0, 0, 0, 0.18);
}

.card-blue {
    background: #eff6ff;
    border-color: #bfdbfe;
}

.card-purple {
    background: #f5efff;
    border-color: #ddd6fe;
}

.card-white {
    background: #ffffff;
    border-color: #ffffff;
}

.section-title {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 19px;
    font-weight: 900;
    margin-bottom: 18px;
}

.section-title.blue {
    color: #1d4ed8;
}

.section-title.purple {
    color: #6d28d9;
}

.section-title.dark {
    color: #111827;
}

.section-title svg {
    width: 22px;
    height: 22px;
}

.info-grid-3 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
}

.info-grid-2 {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
}

.info-box {
    background: white;
    border-radius: 12px;
    padding: 14px;
    min-height: 64px;
}

.info-label {
    color: #6b7280;
    font-size: 14px;
    font-weight: 800;
    margin-bottom: 6px;
    display: flex;
    align-items: center;
    gap: 7px;
}

.info-label svg {
    width: 16px;
    height: 16px;
}

.info-value {
    color: #111827;
    font-size: 15px;
    font-weight: 900;
    word-break: break-word;
}

.full-box {
    grid-column: 1 / -1;
}

.cat-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 8px;
}

.cat-tag {
    background: #ede9fe;
    color: #6d28d9;
    padding: 5px 12px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 900;
}

.service-group-title {
    font-size: 13px;
    font-weight: 900;
    color: #6d28d9;
    margin: 18px 0 10px;
}

.service-group-title:first-of-type {
    margin-top: 0;
}

.service-row {
    background: #f9fafb;
    border-radius: 14px;
    padding: 14px 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 12px;
}

.service-left {
    display: flex;
    align-items: center;
    gap: 12px;
}

.service-num {
    width: 40px;
    height: 40px;
    border-radius: 11px;
    background: #ede9fe;
    color: #7c3aed;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900;
}

.service-name {
    font-size: 15px;
    font-weight: 900;
    color: #111827;
}

.service-description {
    margin-top: 5px;
    font-size: 14px;
    font-weight: 700;
    color: #6b7280;
    line-height: 1.45;
}

.service-price {
    font-size: 15px;
    font-weight: 900;
    color: #374151;
    white-space: nowrap;
}

.total-row {
    border-top: 1px solid #e5e7eb;
    margin-top: 22px;
    padding-top: 22px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.total-label {
    font-size: 19px;
    font-weight: 900;
    color: #111827;
}

.total-amount {
    font-size: 24px;
    font-weight: 900;
    color: #7c3aed;
}

.empty-service {
    background: #f9fafb;
    color: #6b7280;
    font-weight: 800;
    padding: 14px;
    border-radius: 12px;
}


/* compact view form */
.details-container {
    max-width: 800px;
}

.header-row {
    margin-bottom: 18px;
}

.card {
    border-radius: 18px;
    padding: 24px 26px;
    margin-bottom: 20px;
}

.info-grid-3,
.info-grid-2 {
    gap: 12px;
}

.info-box {
    padding: 14px;
    min-height: 64px;
}

.service-row {
    padding: 14px 16px;
    margin-bottom: 10px;
}

.total-row {
    margin-top: 18px;
    padding-top: 18px;
}

@media (max-width: 768px) {
    .header-row {
        align-items: flex-start;
        flex-direction: column;
    }

    .info-grid-3,
    .info-grid-2 {
        grid-template-columns: 1fr;
    }

    .service-row {
        align-items: flex-start;
        flex-direction: column;
    }

    .service-price {
        align-self: flex-end;
    }
}



/* Top back link same simple style as viewCat */
.back-link {
  display: inline-flex !important;
  align-items: center !important;
  gap: 8px !important;
  background: transparent !important;
  border: none !important;
  color: #374151 !important;
  text-decoration: none !important;
  font-size: 0.98rem !important;
  font-weight: 800 !important;
  margin-bottom: 22px !important;
  transition: color .15s ease, transform .15s ease !important;
}

.back-link:hover {
  color: #111827 !important;
  transform: translateX(-2px) !important;
}

.back-link svg {
  width: 20px !important;
  height: 20px !important;
  stroke: currentColor !important;
  fill: none !important;
  stroke-width: 2.4 !important;
  stroke-linecap: round !important;
  stroke-linejoin: round !important;
}

.btn-back,
.back-button,
.bottom-back {
  background: #b9bfc4 !important;
  border-color: #b9bfc4 !important;
  color: #ffffff !important;
}

.btn-back:hover,
.back-button:hover,
.bottom-back:hover {
  background: #a8aeb3 !important;
  border-color: #a8aeb3 !important;
  color: #ffffff !important;
}



/* ===== Softer staff view appointment design alignment ===== */
body{background:linear-gradient(160deg,#f5f3ff 0%,#fdf4ff 42%,#eff6ff 100%)!important;color:#1f1b2d!important;font-family:'Nunito',sans-serif!important}.page-wrapper{padding:32px 16px 64px!important}.details-container{max-width:920px!important}.back-link{color:#374151!important;font-weight:800!important}.back-link:hover{color:#111827!important}.header-row{background:#fff!important;border:1px solid #eee7f7!important;border-radius:18px!important;padding:24px 28px!important;box-shadow:0 4px 16px rgba(0,0,0,.08)!important}.header-icon{background:linear-gradient(135deg,#ede9fe,#fce7f3)!important;color:#7c3aed!important;box-shadow:none!important}.header-title{color:#1f1b2d!important;font-size:2rem!important;font-weight:900!important;letter-spacing:-.35px!important}.header-subtitle{color:#6b7280!important;font-size:1.05rem!important;font-weight:700!important}.card{border-radius:18px!important;box-shadow:0 4px 16px rgba(0,0,0,.07)!important;border:1px solid #eee7f7!important;background:#fff!important}.section-title{font-size:1.12rem!important;font-weight:900!important;color:#1f1b2d!important}.info-box{background:#f9fafb!important;border:1px solid #eef0f4!important;border-radius:14px!important}.info-label{font-weight:800!important;color:#6b7280!important}.info-value,.service-name{font-weight:700!important;color:#1f1b2d!important}.service-row{border-radius:14px!important;border:1px solid #eef0f4!important;background:#fff!important;padding:14px!important;margin-bottom:10px!important}.service-price{font-weight:800!important;color:#7c3aed!important}.total-box,.total-card{border-radius:16px!important;background:linear-gradient(135deg,#faf5ff,#fff7fb)!important;border:1px solid #ddd6fe!important}.status-badge{font-weight:700!important;border-radius:999px!important;letter-spacing:0!important}


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


/* ===== STAFF VIEW STATUS ICON REMOVED ===== */
.status-badge svg { display: none !important; }
.status-badge { gap: 0 !important; }


/* ===== FINAL VIEW APPOINTMENT DETAIL TITLE FIX ===== */
.header-title {
  font-size: 1.875rem !important;
  font-weight: 800 !important;
}
.header-subtitle {
  font-size: 1rem !important;
  font-weight: 600 !important;
}

</style>
</head>

<body>

<div class="page-wrapper">
    <div class="details-container">
        <a class="back-link"
           href="<%= request.getContextPath() %>/StaffAppointmentController"
           onclick="if (window.parent && window.parent.navigate) { window.parent.navigate('appointments', '<%= request.getContextPath() %>/StaffAppointmentController'); return false; }">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 12H5"></path>
                <path d="M12 19l-7-7 7-7"></path>
            </svg>
            Back
        </a>

        <div class="header-row">
            <div class="header-left">
                <div class="header-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </div>

                <div>
                    <div class="header-title">Appointment Details</div>
                    <div class="header-subtitle"><%=appt.appointmentNo%></div>
                </div>
            </div>

            <div class="status-badge <%=statusClass(appt.appointmentStatus)%>">
                <%=safe(appt.appointmentStatus)%>
            </div>
        </div>

        <div class="card card-blue">
            <div class="section-title blue">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                Customer Information
            </div>

            <div class="info-grid-3">
                <div class="info-box">
                    <div class="info-label">Name</div>
                    <div class="info-value"><%=safe(appt.custFullName)%></div>
                </div>

                <div class="info-box">
                    <div class="info-label">Email</div>
                    <div class="info-value"><%=safe(appt.custEmail)%></div>
                </div>

                <div class="info-box">
                    <div class="info-label">Phone</div>
                    <div class="info-value"><%=safe(appt.custPhoneNumber)%></div>
                </div>
            </div>
        </div>

        <div class="card card-purple">
            <div class="section-title purple">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                Appointment Details
            </div>

            <div class="info-grid-3">
                <div class="info-box">
                    <div class="info-label">
                        Date
                    </div>
                    <div class="info-value"><%=safe(appt.appointmentDate)%></div>
                </div>

                <div class="info-box">
                    <div class="info-label">
                        Time
                    </div>
                    <div class="info-value"><%=safe(appt.appointmentTime)%></div>
                </div>

                <div class="info-box">
                    <div class="info-label">
                        Current Weight
                    </div>
                    <div class="info-value"><%=weightDisplay(appt.weight)%></div>
                </div>

                <div class="info-box full-box">
                    <div class="info-label">Cat(s)</div>

                    <div class="cat-tags">
                        <%
                        if (appt.catNames == null || appt.catNames.isEmpty()) {
                        %>
                            <span class="cat-tag">-</span>
                        <%
                        } else {
                            for (String catName : appt.catNames) {
                        %>
                            <span class="cat-tag"><%=safe(catName)%></span>
                        <%
                            }
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <div class="card card-white">
            <div class="section-title dark">
                Services
            </div>

            <%
            int count = 1;

            if (services.isEmpty()) {
            %>
                <div class="empty-service">
                    No services found.
                </div>
            <%
            } else {
                if (!mainServices.isEmpty()) {
            %>
                    <div class="service-group-title">Main Service</div>

                    <%
                    for (ServiceDetail svc : mainServices) {
                    %>
                        <div class="service-row">
                            <div class="service-left">
                                <div class="service-num"><%=count%></div>

                                <div>
                                    <div class="service-name"><%=safe(svc.serviceName)%></div>
                                    <div class="service-description"><%=safe(svc.description)%></div>
                                </div>
                            </div>

                            <div class="service-price">
                                RM <%=money(svc.price)%>
                            </div>
                        </div>
                    <%
                        count++;
                    }
                }

                if (!addOnServices.isEmpty()) {
                    %>
                    <div class="service-group-title">Add-On Services</div>

                    <%
                    for (ServiceDetail svc : addOnServices) {
                    %>
                        <div class="service-row">
                            <div class="service-left">
                                <div class="service-num"><%=count%></div>

                                <div>
                                    <div class="service-name"><%=safe(svc.serviceName)%></div>
                                    <div class="service-description"><%=safe(svc.description)%></div>
                                </div>
                            </div>

                            <div class="service-price">
                                RM <%=money(svc.price)%>
                            </div>
                        </div>
                    <%
                        count++;
                    }
                }

                if (mainServices.isEmpty() && addOnServices.isEmpty()) {
                    for (ServiceDetail svc : services) {
                    %>
                        <div class="service-row">
                            <div class="service-left">
                                <div class="service-num"><%=count%></div>

                                <div>
                                    <div class="service-name"><%=safe(svc.serviceName)%></div>
                                    <div class="service-description"><%=safe(svc.description)%></div>
                                </div>
                            </div>

                            <div class="service-price">
                                RM <%=money(svc.price)%>
                            </div>
                        </div>
                    <%
                        count++;
                    }
                }
            }
            %>

            <div class="total-row">
                <div class="total-label">Total Amount</div>
                <div class="total-amount">RM <%=money(appt.totalAmount)%></div>
            </div>
        </div>
</div>
</div>

</body>
</html>