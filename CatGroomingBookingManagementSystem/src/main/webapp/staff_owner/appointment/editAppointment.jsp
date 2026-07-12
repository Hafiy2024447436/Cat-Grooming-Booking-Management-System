<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="catBooking.bean.ServiceBean"%>
<%@ page import="catBooking.bean.WeightBasedServiceBean"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.AppointmentEditRow"%>

<%!
private String safe(String value) {
    return value == null ? "" : value;
}

private String html(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}

private boolean isChecked(List<Integer> ids, int serviceID) {
    return ids != null && ids.contains(serviceID);
}

private boolean isBooked(List<String> bookedTimes, String time) {
    if (bookedTimes == null || time == null) {
        return false;
    }

    for (String booked : bookedTimes) {
        if (time.equals(booked)) {
            return true;
        }
    }

    return false;
}

private String errorText(String error) {
    if (error == null || error.trim().isEmpty()) return "";

    if ("noService".equals(error)) return "Please select one main service before saving.";
    if ("noTime".equals(error)) return "Please select an available time slot.";
    if ("invalidDate".equals(error)) return "Please choose a valid appointment date.";
    if ("timeBooked".equals(error)) return "This time slot has already been booked. Please choose another time.";
    if ("updateFailed".equals(error)) return "Failed to update appointment. Please check the form.";

    return "Something went wrong. Please try again.";
}
%>

<%
AppointmentEditRow appt = (AppointmentEditRow) request.getAttribute("appt");
List<ServiceBean> mainServices = (List<ServiceBean>) request.getAttribute("mainServices");
List<ServiceBean> addOnServices = (List<ServiceBean>) request.getAttribute("addOnServices");
List<Integer> currentServiceIDs = (List<Integer>) request.getAttribute("currentServiceIDs");
List<String> bookedTimes = (List<String>) request.getAttribute("bookedTimes");
String selectedDate = (String) request.getAttribute("selectedDate");
String selectedDateISO = (String) request.getAttribute("selectedDateISO");
String errorMessage = (String) request.getAttribute("errorMessage");

if (appt == null) {
    response.sendRedirect(request.getContextPath() + "/StaffAppointmentController");
    return;
}

if (mainServices == null) mainServices = new ArrayList<ServiceBean>();
if (addOnServices == null) addOnServices = new ArrayList<ServiceBean>();
if (currentServiceIDs == null) currentServiceIDs = new ArrayList<Integer>();
if (bookedTimes == null) bookedTimes = new ArrayList<String>();
if (selectedDate == null || selectedDate.trim().isEmpty()) selectedDate = safe(appt.appointmentDate);
if (selectedDateISO == null || selectedDateISO.trim().isEmpty()) selectedDateISO = safe(appt.appointmentDateISO);

List<ServiceBean> normalMainServices = new ArrayList<ServiceBean>();
Map<String, List<ServiceBean>> weightGroups = new LinkedHashMap<String, List<ServiceBean>>();
Map<String, String> weightGroupDescriptions = new LinkedHashMap<String, String>();

for (ServiceBean service : mainServices) {
    if (service instanceof WeightBasedServiceBean) {
        String key = service.getServiceName();
        if (!weightGroups.containsKey(key)) {
            weightGroups.put(key, new ArrayList<ServiceBean>());
            weightGroupDescriptions.put(key, service.getDescription());
        }
        weightGroups.get(key).add(service);
    } else {
        normalMainServices.add(service);
    }
}

String[] timeSlots = {"09:00", "10:00", "11:00", "12:00", "14:00", "15:00", "16:00", "17:00"};
String paramError = errorText(request.getParameter("error"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Appointment</title>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/editAppointment.css?v=aligned-3">
<style>
/* Requested: editAppointment bottom cancel button */
.action-row .btn-cancel {
    order: 1 !important;
    background: #ef4444 !important;
    border-color: #ef4444 !important;
    color: #ffffff !important;
}

.action-row .btn-cancel:hover {
    background: #dc2626 !important;
    border-color: #dc2626 !important;
    color: #ffffff !important;
}

.action-row .btn-save {
    order: 2 !important;
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
    <div class="page-shell">
        <div class="page-heading">
            <div>
                <h1>Edit Appointment</h1>
                <p>Update date, time, and selected grooming services for pending appointment only.</p>
            </div>
        </div>

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
            <div class="alert"><%=html(errorMessage)%></div>
        <% } %>

        <% if (!paramError.isEmpty()) { %>
            <div class="alert"><%=html(paramError)%></div>
        <% } %>

        <form class="edit-card" method="post" action="<%=request.getContextPath()%>/EditAppointmentController" id="editAppointmentForm" data-disable-validation="true" novalidate>
            <input type="hidden" name="appointmentID" value="<%=appt.appointmentID%>">
            <input type="hidden" name="serviceIDs" id="serviceIDs" value="">
            <input type="hidden" name="totalAmount" id="totalAmountInput" value="<%=String.format("%.2f", appt.totalAmount)%>">

            <section class="section appointment-info-section">
                <div class="section-head">
                    <span class="section-dot purple"></span>
                    <h2>Appointment Information</h2>
                </div>

                <div class="info-grid">
<div class="info-box">
                        <span class="info-label">Customer</span>
                        <strong><%=html(appt.customerName)%></strong>
                    </div>
                    <div class="info-box">
                        <span class="info-label">Cat</span>
                        <strong><%=html(appt.catName)%></strong>
                    </div>
                    <div class="info-box">
                        <span class="info-label">Current Status</span>
                        <strong><%=html(appt.appointmentStatus)%></strong>
                    </div>
                </div>

                <% if (appt.conditionNotes != null && !appt.conditionNotes.trim().isEmpty()) { %>
                    <div class="note-box">
                        <strong>Cat Notes:</strong> <%=html(appt.conditionNotes)%>
                    </div>
                <% } %>
            </section>

            <section class="section schedule-section">
                <div class="section-head">
                    <span class="section-dot blue"></span>
                    <h2>Date & Time</h2>
                </div>

                <div class="date-row">
                    <div class="date-field">
                        <label for="appointmentDate">Date</label>
                        <input type="date"
                               id="appointmentDate"
                               name="appointmentDate"
                               value="<%=html(selectedDateISO)%>"
                               required>
                    </div>
                    <button type="button" class="btn-check-time" onclick="checkTimes()">Check Times</button>
                </div>

                <div class="selected-date-text">
                    Selected date: <strong><%=html(selectedDate)%></strong>
                </div>

                <div class="time-block">
                    <label class="time-title">Time</label>
                    <div class="time-grid">
                        <% for (String slot : timeSlots) {
                            boolean booked = isBooked(bookedTimes, slot);
                            boolean selected = slot.equals(appt.appointmentTime);
                        %>
                            <label class="time-slot <%=selected ? "selected" : ""%> <%=booked ? "booked" : ""%>">
                                <input type="radio"
                                       name="appointmentTime"
                                       value="<%=slot%>"
                                       <%=selected ? "checked" : ""%>
                                       <%=booked ? "disabled" : ""%>>
                                <span class="slot-time"><%=slot%></span>
                                <% if (booked) { %>
                                    <span class="booked-label">Booked</span>
                                <% } %>
                            </label>
                        <% } %>
                    </div>
                </div>
            </section>

            <section class="section services-section">
                <div class="section-head">
                    <span class="section-dot purple"></span>
                    <h2>Main Service</h2>
                </div>
                <p class="section-desc">Choose one main grooming service.</p>

                <div class="service-list main-list">
                    <% for (ServiceBean service : normalMainServices) {
                        boolean selected = isChecked(currentServiceIDs, service.getServiceID());
                    %>
                        <label class="service-card <%=selected ? "selected" : ""%>" data-service-card>
                            <input type="radio"
                                   name="mainService"
                                   class="main-service-input"
                                   value="<%=service.getServiceID()%>"
                                   data-price="<%=service.getPrice()%>"
                                   <%=selected ? "checked" : ""%>>
                            <span class="fake-check"></span>
                            <span class="service-body">
                                <span class="service-top">
                                    <strong><%=html(service.getServiceName())%></strong>
                                    <b>RM <%=String.format("%.2f", service.getPrice())%></b>
                                </span>
                                <% if (service.getDescription() != null && !service.getDescription().trim().isEmpty()) { %>
                                    <span class="service-desc-text"><%=html(service.getDescription())%></span>
                                <% } %>
                            </span>
                        </label>
                    <% } %>

                    <% int groupIndex = 0;
                    for (Map.Entry<String, List<ServiceBean>> entry : weightGroups.entrySet()) {
                        String groupName = entry.getKey();
                        List<ServiceBean> options = entry.getValue();
                        String groupDescription = weightGroupDescriptions.get(groupName);
                        boolean groupSelected = false;

                        for (ServiceBean option : options) {
                            if (isChecked(currentServiceIDs, option.getServiceID())) {
                                groupSelected = true;
                                break;
                            }
                        }
                    %>
                        <div class="weight-service-card <%=groupSelected ? "selected" : ""%>" data-weight-card data-group="<%=groupIndex%>">
                            <label class="weight-card-head">
                                <input type="radio"
                                       name="mainService"
                                       class="main-service-input weight-main-input"
                                       value="weight-group-<%=groupIndex%>"
                                       data-group="<%=groupIndex%>"
                                       <%=groupSelected ? "checked" : ""%>>
                                <span class="fake-check"></span>
                                <span class="service-body">
                                    <span class="service-top">
                                        <strong><%=html(groupName)%></strong>
                                    </span>
                                    <% if (groupDescription != null && !groupDescription.trim().isEmpty()) { %>
                                        <span class="service-desc-text"><%=html(groupDescription)%></span>
                                    <% } %>
                                </span>
                            </label>

                            <div class="weight-area">
                                <div class="weight-title">Select kitten weight range:</div>
                                <div class="weight-options">
                                    <% for (ServiceBean option : options) {
                                        WeightBasedServiceBean weightOption = (WeightBasedServiceBean) option;
                                        boolean optionSelected = isChecked(currentServiceIDs, option.getServiceID());
                                    %>
                                        <label class="weight-option <%=optionSelected ? "selected" : ""%>">
                                            <input type="radio"
                                                   name="weightChoice_<%=groupIndex%>"
                                                   class="weight-service-radio"
                                                   value="<%=option.getServiceID()%>"
                                                   data-price="<%=option.getPrice()%>"
                                                   data-group="<%=groupIndex%>"
                                                   <%=optionSelected ? "checked" : ""%>>
                                            <span class="weight-label"><%=html(weightOption.getWeightRange())%></span>
                                            <span class="weight-price">RM <%=String.format("%.2f", option.getPrice())%></span>
                                        </label>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% groupIndex++; } %>
                </div>
            </section>

            <section class="section services-section">
                <div class="section-head">
                    <span class="section-dot blue"></span>
                    <h2>Add-On Services</h2>
                </div>
                <p class="section-desc">You may select more than one add-on service.</p>

                <div class="service-list addon-list">
                    <% for (ServiceBean service : addOnServices) {
                        boolean selected = isChecked(currentServiceIDs, service.getServiceID());
                    %>
                        <label class="service-card addon <%=selected ? "selected" : ""%>" data-service-card>
                            <input type="checkbox"
                                   name="addOnService"
                                   class="addon-service-input"
                                   value="<%=service.getServiceID()%>"
                                   data-price="<%=service.getPrice()%>"
                                   <%=selected ? "checked" : ""%>>
                            <span class="fake-check"></span>
                            <span class="service-body">
                                <span class="service-top">
                                    <strong><%=html(service.getServiceName())%></strong>
                                    <b>RM <%=String.format("%.2f", service.getPrice())%></b>
                                </span>
                                <% if (service.getDescription() != null && !service.getDescription().trim().isEmpty()) { %>
                                    <span class="service-desc-text"><%=html(service.getDescription())%></span>
                                <% } %>
                            </span>
                        </label>
                    <% } %>
                </div>
            </section>

            <div class="total-bar">
                <span>Total Amount</span>
                <strong id="totalDisplay">RM <%=String.format("%.2f", appt.totalAmount)%></strong>
            </div>

            <div class="action-row">
                <a href="<%=request.getContextPath()%>/StaffAppointmentController" class="btn btn-cancel">Cancel</a>
                <button type="submit" class="btn btn-save">Save</button>
            </div>
        </form>
    </div>
</main>

<script>
function checkTimes() {
    const date = document.getElementById('appointmentDate').value;

    if (!date) {
        alert('Please choose a date first.');
        return;
    }

    window.location.href = '<%=request.getContextPath()%>/EditAppointmentController?appointmentID=<%=appt.appointmentID%>&date=' + encodeURIComponent(date);
}

function updateServiceCardState() {
    document.querySelectorAll('[data-service-card]').forEach(function(card) {
        const input = card.querySelector('input');
        card.classList.toggle('selected', input && input.checked);
    });

    document.querySelectorAll('[data-weight-card]').forEach(function(card) {
        const input = card.querySelector('.weight-main-input');
        const selected = input && input.checked;
        card.classList.toggle('selected', selected);

        if (!selected) {
            card.querySelectorAll('.weight-service-radio').forEach(function(radio) {
                radio.checked = false;
            });
            card.querySelectorAll('.weight-option').forEach(function(option) {
                option.classList.remove('selected');
            });
        }
    });

    document.querySelectorAll('.weight-option').forEach(function(option) {
        const input = option.querySelector('input');
        option.classList.toggle('selected', input && input.checked);
    });
}

function collectSelectedServices() {
    const ids = [];
    let total = 0;

    const checkedMain = document.querySelector('.main-service-input:checked');

    if (checkedMain) {
        if (checkedMain.classList.contains('weight-main-input')) {
            const group = checkedMain.dataset.group;
            const weightRadio = document.querySelector('.weight-service-radio[data-group="' + group + '"]:checked');

            if (weightRadio) {
                ids.push(weightRadio.value);
                total += parseFloat(weightRadio.dataset.price || '0');
            }
        } else {
            ids.push(checkedMain.value);
            total += parseFloat(checkedMain.dataset.price || '0');
        }
    }

    document.querySelectorAll('.addon-service-input:checked').forEach(function(input) {
        ids.push(input.value);
        total += parseFloat(input.dataset.price || '0');
    });

    document.getElementById('serviceIDs').value = ids.join(',');
    document.getElementById('totalAmountInput').value = total.toFixed(2);
    document.getElementById('totalDisplay').textContent = 'RM ' + total.toFixed(2);
}

function bindServiceEvents() {
    document.querySelectorAll('.main-service-input').forEach(function(input) {
        input.addEventListener('change', function() {
            updateServiceCardState();
            collectSelectedServices();
        });
    });

    document.querySelectorAll('.weight-service-radio').forEach(function(input) {
        input.addEventListener('change', function() {
            const group = input.dataset.group;
            const main = document.querySelector('.weight-main-input[data-group="' + group + '"]');

            if (main) {
                main.checked = true;
            }

            updateServiceCardState();
            collectSelectedServices();
        });
    });

    document.querySelectorAll('.addon-service-input').forEach(function(input) {
        input.addEventListener('change', function() {
            updateServiceCardState();
            collectSelectedServices();
        });
    });

    document.querySelectorAll('.time-slot input').forEach(function(input) {
        input.addEventListener('change', function() {
            document.querySelectorAll('.time-slot').forEach(function(slot) {
                slot.classList.remove('selected');
            });

            if (input.checked) {
                input.closest('.time-slot').classList.add('selected');
            }
        });
    });
}

document.getElementById('editAppointmentForm').addEventListener('submit', function(e) {
    collectSelectedServices();

    const checkedMain = document.querySelector('.main-service-input:checked');
    const checkedTime = document.querySelector('input[name="appointmentTime"]:checked');

    if (!checkedMain) {
        e.preventDefault();
        alert('Please choose one main service.');
        return;
    }

    if (checkedMain.classList.contains('weight-main-input')) {
        const group = checkedMain.dataset.group;
        const selectedWeight = document.querySelector('.weight-service-radio[data-group="' + group + '"]:checked');

        if (!selectedWeight) {
            e.preventDefault();
            alert('Please select kitten weight range.');
            return;
        }
    }

    if (!checkedTime) {
        e.preventDefault();
        alert('Please select an available time slot.');
    }
});

bindServiceEvents();
updateServiceCardState();
collectSelectedServices();
</script>


  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>
