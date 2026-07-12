<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.ConfirmBookingRow"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.StaffOption"%>

<%!
private String safe(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;");
}

private String statusClass(String status) {
    if (status == null) return "status-pending";

    switch (status.trim().toLowerCase()) {
        case "confirmed": return "status-confirmed";
        case "cancelled": return "status-cancelled";
        case "completed": return "status-completed";
        default: return "status-pending";
    }
}
%>

<%
List<ConfirmBookingRow> appointments =
        (List<ConfirmBookingRow>) request.getAttribute("appointments");
List<StaffOption> staffOptions =
        (List<StaffOption>) request.getAttribute("staffOptions");

Integer pendingCount = (Integer) request.getAttribute("pendingCount");
Integer confirmedCount = (Integer) request.getAttribute("confirmedCount");

String message = (String) request.getAttribute("message");
String error = (String) request.getAttribute("error");

if (pendingCount == null) pendingCount = 0;
if (confirmedCount == null) confirmedCount = 0;
if (appointments == null) appointments = new java.util.ArrayList<>();
if (staffOptions == null) staffOptions = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Confirm Bookings</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/confirmBooking.css?v=disabled-fix-2" />

<style>
.confirmed-notif {
    background: #dbeafe;
    color: #2563eb;
    padding: 10px 14px;
    border-radius: 12px;
    font-weight: 800;
    margin-bottom: 10px;
}

.invoice-hint {
    background: #f8fafc;
    color: #64748b;
    padding: 10px 14px;
    border-radius: 12px;
    font-size: 0.88rem;
    font-weight: 700;
    margin-bottom: 12px;
}

.confirmed-actions {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.btn-invoice {
    background: #7c3aed;
    color: #ffffff;
    text-decoration: none;
    justify-content: center;
}

.btn-invoice:hover {
    background: #6d28d9;
}



.status-cancelled {
    background: #fee2e2;
    color: #dc2626;
}

/* Button color alignment */
:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-red: #ef4444;
  --btn-red-hover: #dc2626;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

.btn-confirm,
.popup-submit.confirm {
  background: var(--btn-green) !important;
  border-color: var(--btn-green) !important;
  color: #ffffff !important;
}

.btn-confirm:hover:not(:disabled),
.popup-submit.confirm:hover:not(:disabled) {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
}

.btn-reject,
.popup-submit.reject {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.btn-reject:hover:not(:disabled),
.popup-submit.reject:hover:not(:disabled) {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
}

.popup-cancel {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.popup-cancel:hover:not(:disabled) {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
}

.popup-footer,
.apt-actions {
  display: flex !important;
  gap: 12px !important;
}

.popup-cancel,
.btn-reject {
  order: 1 !important;
}

.popup-submit,
.btn-confirm {
  order: 2 !important;
}

button:disabled,
button:disabled:hover,
.btn:disabled,
.btn:hover:disabled,
.btn-confirm:disabled,
.btn-confirm:hover:disabled,
.btn-reject:disabled,
.btn-reject:hover:disabled,
.popup-submit:disabled,
.popup-submit:hover:disabled,
.popup-submit.confirm:disabled,
.popup-submit.confirm:hover:disabled,
.popup-submit.reject:disabled,
.popup-submit.reject:hover:disabled {
  background: var(--btn-disabled) !important;
  border-color: var(--btn-disabled) !important;
  color: #ffffff !important;
  cursor: not-allowed !important;
  opacity: 1 !important;
  box-shadow: none !important;
  transform: none !important;
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

</style>
</head>

<body>

<main class="main">

    <div class="page-banner">
        <div class="banner-top">
            <div class="banner-icon">
                <svg viewBox="0 0 24 24">
                    <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
            </div>

            <div>
                <div class="banner-title">Confirm Bookings</div>
                <div class="banner-sub">Review and confirm customer appointments</div>
            </div>
        </div>

        <div class="banner-stats">
            <div class="stat-pill stat-pending-pill">
                <div class="stat-label">Pending</div>
                <div class="stat-num"><%= pendingCount %></div>
            </div>

            <div class="stat-pill stat-confirmed-pill">
                <div class="stat-label">Confirmed</div>
                <div class="stat-num"><%= confirmedCount %></div>
            </div>
        </div>
    </div>

    <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="alert alert-error"><%= safe(error) %></div>
    <% } %>

    <div class="section-hdr section-pending">Pending Bookings (<%= pendingCount %>)</div>

    <div class="apt-grid">
        <%
        boolean hasPending = false;

        for (ConfirmBookingRow appointment : appointments) {
            String status = appointment.appointmentStatus == null ? "Pending" : appointment.appointmentStatus;

            if (!"pending".equalsIgnoreCase(status)) {
                continue;
            }

            hasPending = true;
        %>

        <div class="apt-card pending-card">
            <div class="apt-card-top">
                <div class="apt-card-top-left">
                    <div class="apt-cal-icon">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </div>

                    <div>
                        <div class="apt-no"><%= safe(appointment.appointmentNo) %></div>
                        <div class="apt-date"><%= safe(appointment.appointmentDate) %></div>
                    </div>
                </div>

                <span class="status-badge <%= statusClass(status) %>"><%= safe(status) %></span>
            </div>

            <div class="apt-info">
                <div class="apt-row"><strong><%= safe(appointment.customerName) %></strong></div>
                <div class="apt-row muted"><%= safe(appointment.customerPhone) %></div>
                <div class="apt-row muted"><%= safe(appointment.customerEmail) %></div>

                <div class="apt-row sep">
                    <strong><%= safe(appointment.catName) %></strong>
                    <span style="color:var(--text-muted);font-size:0.82rem;">
                        (<%= safe(appointment.breedName) %>)
                    </span>
                </div>

                <div class="apt-row"><%= safe(appointment.appointmentTime) %></div>
            </div>

            <div class="services-label">Main Service:</div>
            <div class="services-pills">
                <% if (appointment.mainServiceNames == null || appointment.mainServiceNames.isEmpty()) { %>
                    <span class="service-pill">No main service</span>
                <% } else {
                    for (String serviceName : appointment.mainServiceNames) {
                %>
                    <span class="service-pill"><%= safe(serviceName) %></span>
                <% 
                    }
                } 
                %>
            </div>

            <% if (appointment.addOnServiceNames != null && !appointment.addOnServiceNames.isEmpty()) { %>
                <div class="services-label">Add-On Services:</div>
                <div class="services-pills">
                    <% for (String serviceName : appointment.addOnServiceNames) { %>
                        <span class="service-pill"><%= safe(serviceName) %></span>
                    <% } %>
                </div>
            <% } %>

            <div class="apt-total">
                Total: RM <%= String.format("%.2f", appointment.totalAmount) %>
            </div>

            <% if (appointment.conditionNotes != null && !appointment.conditionNotes.trim().isEmpty()) { %>
                <div class="notes-box">
                    <strong>Special Notes:</strong> <%= safe(appointment.conditionNotes) %>
                </div>
            <% } %>

            <hr class="apt-divider">

            <div class="apt-actions">
                <button type="button"
                    class="btn btn-reject"
                    data-action="reject"
                    data-id="<%= appointment.appointmentID %>"
                    data-apt="<%= safe(appointment.appointmentNo) %>"
                    data-customer="<%= safe(appointment.customerName) %>"
                    data-cat="<%= safe(appointment.catName) %>"
                    data-date="<%= safe(appointment.appointmentDate) %>"
                    data-time="<%= safe(appointment.appointmentTime) %>"
                    onclick="openBookingPopup(this)">
                    Reject
                </button>

                <button type="button"
                    class="btn btn-confirm"
                    data-action="confirm"
                    data-id="<%= appointment.appointmentID %>"
                    data-apt="<%= safe(appointment.appointmentNo) %>"
                    data-customer="<%= safe(appointment.customerName) %>"
                    data-cat="<%= safe(appointment.catName) %>"
                    data-date="<%= safe(appointment.appointmentDate) %>"
                    data-time="<%= safe(appointment.appointmentTime) %>"
                    onclick="openBookingPopup(this)">
                    Confirm
                </button>
            </div>
        </div>

        <%
        }

        if (!hasPending) {
        %>
            <div class="empty-card">No pending bookings found.</div>
        <% } %>
    </div>

    <div class="section-hdr section-confirmed">Confirmed Bookings (<%= confirmedCount %>)</div>

    <div class="apt-grid">
        <%
        boolean hasConfirmed = false;

        for (ConfirmBookingRow appointment : appointments) {
            String status = appointment.appointmentStatus == null ? "Pending" : appointment.appointmentStatus;

            if (!"confirmed".equalsIgnoreCase(status)) {
                continue;
            }

            hasConfirmed = true;
        %>

        <div class="apt-card confirmed-card">
            <div class="apt-card-top">
                <div class="apt-card-top-left">
                    <div class="apt-cal-icon">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                    </div>

                    <div>
                        <div class="apt-no"><%= safe(appointment.appointmentNo) %></div>
                        <div class="apt-date"><%= safe(appointment.appointmentDate) %></div>
                    </div>
                </div>

                <span class="status-badge <%= statusClass(status) %>"><%= safe(status) %></span>
            </div>

            <div class="apt-info">
                <div class="apt-row"><strong><%= safe(appointment.customerName) %></strong></div>
                <div class="apt-row muted"><%= safe(appointment.customerPhone) %></div>
                <div class="apt-row muted"><%= safe(appointment.customerEmail) %></div>

                <div class="apt-row sep">
                    <strong><%= safe(appointment.catName) %></strong>
                    <span style="color:var(--text-muted);font-size:0.82rem;">
                        (<%= safe(appointment.breedName) %>)
                    </span>
                </div>

                <div class="apt-row"><%= safe(appointment.appointmentTime) %></div>
            </div>

            <div class="services-label">Main Service:</div>
            <div class="services-pills">
                <% if (appointment.mainServiceNames == null || appointment.mainServiceNames.isEmpty()) { %>
                    <span class="service-pill">No main service</span>
                <% } else {
                    for (String serviceName : appointment.mainServiceNames) {
                %>
                    <span class="service-pill"><%= safe(serviceName) %></span>
                <% 
                    }
                } 
                %>
            </div>

            <% if (appointment.addOnServiceNames != null && !appointment.addOnServiceNames.isEmpty()) { %>
                <div class="services-label">Add-On Services:</div>
                <div class="services-pills">
                    <% for (String serviceName : appointment.addOnServiceNames) { %>
                        <span class="service-pill"><%= safe(serviceName) %></span>
                    <% } %>
                </div>
            <% } %>

            <div class="apt-total">
                Total: RM <%= String.format("%.2f", appointment.totalAmount) %>
            </div>

            <hr class="apt-divider">

            <div class="confirmed-notif">
                Booking confirmed.
            </div>

        </div>

        <%
        }

        if (!hasConfirmed) {
        %>
            <div class="empty-card">No confirmed bookings yet.</div>
        <% } %>
    </div>

</main>


<div class="modal-overlay" id="bookingPopup">
    <div class="popup">
        <div class="popup-head">
            <div class="popup-icon confirm" id="popupIcon">
                <svg id="popupIconSvg" viewBox="0 0 24 24">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>

            <div class="popup-title" id="popupTitle">Confirm Booking Approval</div>
        </div>

        <div class="popup-body">
            <div class="popup-question" id="popupQuestion">
                Are you sure you want to approve this booking for:
            </div>

            <div class="popup-booking-box">
                <div class="popup-name" id="popupCustomerName"></div>

                <div class="popup-detail">
                    Appointment No: <span id="popupAppointmentNo"></span><br>
                    Cat: <span id="popupCatName"></span><br>
                    Date: <span id="popupDateTime"></span>
                </div>
            </div>

            <div class="popup-field" id="assignStaffGroup">
                <label for="popupStaffID">Assign Staff <span>*</span></label>
                <select name="staffID" id="popupStaffID" form="bookingActionForm">
                    <option value="">Select staff</option>
                    <%
                    for (StaffOption staff : staffOptions) {
                    %>
                        <option value="<%= staff.staffID %>"><%= safe(staff.staffFullName) %></option>
                    <%
                    }
                    %>
                </select>
                <% if (staffOptions.isEmpty()) { %>
                    <div class="popup-field-hint error">No active staff available for assignment.</div>
                <% } %>
            </div>

            <div class="popup-note confirm" id="popupNote">
                <svg viewBox="0 0 24 24">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>

                <span id="popupNoteText">
                    Booking status will be updated to Confirmed.
                </span>
            </div>
        </div>

        <form action="<%= request.getContextPath() %>/ConfirmBookingController"
              method="post"
              id="bookingActionForm"
              class="popup-footer">

            <input type="hidden" name="appointmentID" id="popupAppointmentID">
            <input type="hidden" name="action" id="popupAction">

            <button type="button" class="popup-cancel" onclick="closeBookingPopup()">
                Cancel
            </button>

            <button type="submit" class="popup-submit confirm" id="popupSubmitBtn">
                Confirm
            </button>
        </form>
    </div>
</div>

<script>
function openBookingPopup(button) {
    const type = button.getAttribute("data-action");
    const appointmentID = button.getAttribute("data-id");
    const appointmentNo = button.getAttribute("data-apt");
    const customerName = button.getAttribute("data-customer");
    const catName = button.getAttribute("data-cat");
    const date = button.getAttribute("data-date");
    const time = button.getAttribute("data-time");

    const popup = document.getElementById("bookingPopup");
    const icon = document.getElementById("popupIcon");
    const iconSvg = document.getElementById("popupIconSvg");
    const title = document.getElementById("popupTitle");
    const question = document.getElementById("popupQuestion");
    const note = document.getElementById("popupNote");
    const noteText = document.getElementById("popupNoteText");
    const submitBtn = document.getElementById("popupSubmitBtn");
    const assignStaffGroup = document.getElementById("assignStaffGroup");
    const staffSelect = document.getElementById("popupStaffID");

    document.getElementById("popupAppointmentID").value = appointmentID;
    document.getElementById("popupAction").value = type;
    document.getElementById("popupAppointmentNo").textContent = appointmentNo;
    document.getElementById("popupCustomerName").textContent = customerName;
    document.getElementById("popupCatName").textContent = catName;
    document.getElementById("popupDateTime").textContent = date + " at " + time;

    if (type === "confirm") {
        icon.className = "popup-icon confirm";
        note.className = "popup-note confirm";
        submitBtn.className = "popup-submit confirm";

        iconSvg.innerHTML = '<polyline points="20 6 9 17 4 12"></polyline>';
        title.textContent = "Confirm Booking";
        question.textContent = "Confirm this booking for:";
        noteText.textContent = "Booking status will be updated to Confirmed.";
        submitBtn.textContent = "Confirm";
        submitBtn.disabled = true;

        assignStaffGroup.style.display = "block";
        staffSelect.disabled = false;
        staffSelect.required = true;
        staffSelect.value = "";
    } else {
        icon.className = "popup-icon reject";
        note.className = "popup-note reject";
        submitBtn.className = "popup-submit reject";

        iconSvg.innerHTML =
            '<line x1="18" y1="6" x2="6" y2="18"></line>' +
            '<line x1="6" y1="6" x2="18" y2="18"></line>';

        title.textContent = "Reject Booking";
        question.textContent = "Are you sure you want to reject this booking for:";
        noteText.textContent = "Booking status will be updated to Cancelled.";
        submitBtn.textContent = "Reject";
        submitBtn.disabled = false;

        assignStaffGroup.style.display = "none";
        staffSelect.disabled = true;
        staffSelect.required = false;
        staffSelect.value = "";
    }

    popup.classList.add("show");
}


function updateConfirmButtonState() {
    const staffSelect = document.getElementById("popupStaffID");
    const action = document.getElementById("popupAction");
    const submitBtn = document.getElementById("popupSubmitBtn");

    if (!staffSelect || !action || !submitBtn) return;

    if (action.value === "confirm") {
        submitBtn.disabled = !staffSelect.value;
    }
}

const popupStaffSelect = document.getElementById("popupStaffID");
if (popupStaffSelect) {
    popupStaffSelect.addEventListener("change", updateConfirmButtonState);
}

function closeBookingPopup() {
    document.getElementById("bookingPopup").classList.remove("show");

    const staffSelect = document.getElementById("popupStaffID");
    if (staffSelect) {
        staffSelect.value = "";
    }

    const submitBtn = document.getElementById("popupSubmitBtn");
    if (submitBtn) {
        submitBtn.disabled = false;
    }
}

document.getElementById("bookingPopup").addEventListener("click", function(event) {
    if (event.target === this) {
        closeBookingPopup();
    }
});

</script>


<jsp:include page="/notification.jsp" />
</body>
</html>