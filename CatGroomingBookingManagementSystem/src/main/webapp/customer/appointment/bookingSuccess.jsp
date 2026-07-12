<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.AppointmentBean"%>
<%@ page import="catBooking.bean.CatBean"%>
<%@ page import="catBooking.bean.ServiceBean"%>
<%@ page import="catBooking.util.DateUtil"%>

<%
AppointmentBean appt = (AppointmentBean) request.getAttribute("appointment");
CatBean cat = (CatBean) request.getAttribute("cat");
List<ServiceBean> selectedServices = (List<ServiceBean>) request.getAttribute("selectedServices");
List<ServiceBean> mainServices = (List<ServiceBean>) request.getAttribute("mainServices");
List<ServiceBean> addOnServices = (List<ServiceBean>) request.getAttribute("addOnServices");

if (appt == null) {
    response.sendRedirect("CustomerAppointmentController");
    return;
}

if (selectedServices == null) selectedServices = new java.util.ArrayList<>();
if (mainServices == null) mainServices = new java.util.ArrayList<>();
if (addOnServices == null) addOnServices = new java.util.ArrayList<>();

if (mainServices.isEmpty() && addOnServices.isEmpty() && !selectedServices.isEmpty()) {
    for (ServiceBean service : selectedServices) {
        String category = service.getCategory() == null ? "" : service.getCategory().trim().toUpperCase();

        if ("MAIN".equals(category)) {
            mainServices.add(service);
        } else if ("ADDON".equals(category)) {
            addOnServices.add(service);
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Booking Success</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingSuccess.css?v=aligned-success-2" />

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
</head>

<body>

	<div class="page-wrap">

		<div class="success-header">
			<div class="check-circle">✓</div>
			<h1 class="success-title">Booking Successful!</h1>
			<p class="success-sub">Your cat grooming appointment has been submitted</p>
		</div>

		<div class="card">
			<div class="card-title">
				<div class="card-icon" aria-hidden="true">
					<svg viewBox="0 0 24 24">
						<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
						<line x1="16" y1="2" x2="16" y2="6"></line>
						<line x1="8" y1="2" x2="8" y2="6"></line>
						<line x1="3" y1="10" x2="21" y2="10"></line>
					</svg>
				</div>
				Appointment Details
			</div>

			<div class="grid-2">
				<div class="info-box">
					<div class="info-label">Appointment No</div>
					<div class="info-value"><%=appt.getAppointmentNo()%></div>
				</div>

				<div class="info-box">
					<div class="info-label">Status</div>
					<div class="info-value"><%=appt.getAppointmentStatus()%></div>
				</div>
			</div>

			<div class="grid-2">
				<div class="info-box">
					<div class="info-label">Date</div>
					<div class="info-value" id="display-date">
						<%=DateUtil.formatDate(appt.getAppointmentDate())%>
					</div>
				</div>

				<div class="info-box">
					<div class="info-label">Time</div>
					<div class="info-value"><%=appt.getAppointmentTime()%></div>
				</div>
			</div>

			<div class="info-box" style="margin-bottom: 14px;">
				<div class="info-label">Cat</div>

				<div class="cat-tags">
					<span class="cat-tag">
						<%=cat != null ? cat.getCatName() : "Cat ID: " + appt.getCatID()%>
					</span>
				</div>
			</div>

			<div class="info-box">
				<div class="info-label">Services</div>

				<%
				if (selectedServices.isEmpty()) {
				%>

				<div class="service-row">
					No services found.
				</div>

				<%
				} else {
					int count = 1;
				%>

				<%
				if (!mainServices.isEmpty()) {
				%>
				<div style="font-weight:900;color:#7c3aed;margin:10px 0 8px;">
					Main Service
				</div>

				<%
				for (ServiceBean service : mainServices) {
				%>
				<div class="service-row">
					<div class="service-left">
						<div class="service-num"><%=count%></div>

						<div>
							<div class="service-name"><%=service.getServiceName()%></div>
						</div>
					</div>
				</div>
				<%
				count++;
				}
				}
				%>

				<%
				if (!addOnServices.isEmpty()) {
				%>
				<div style="font-weight:900;color:#7c3aed;margin:14px 0 8px;">
					Add-On Services
				</div>

				<%
				for (ServiceBean service : addOnServices) {
				%>
				<div class="service-row">
					<div class="service-left">
						<div class="service-num"><%=count%></div>

						<div>
							<div class="service-name"><%=service.getServiceName()%></div>
						</div>
					</div>
				</div>
				<%
				count++;
				}
				}
				%>

				<%
				}
				%>
			</div>

			<div class="total-box">
				<span class="total-label">Total Amount</span>
				<span class="total-amount">
					RM <%=String.format("%.2f", appt.getTotalAmount())%>
				</span>
			</div>
		</div>

		<div class="btn-close-wrap">
			<a href="CustomerAppointmentController" class="btn-close">
				Close
			</a>
		</div>

	</div>


<%@ include file="/notification.jsp" %>
</body>
</html>