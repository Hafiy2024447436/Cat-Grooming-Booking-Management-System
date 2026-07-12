<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.CatBean"%>
<%@ page import="catBooking.servlet.customer.BookingSummaryController.ServiceItem"%>

<%
String appointmentDate = (String) request.getAttribute("appointmentDate");
String appointmentTime = (String) request.getAttribute("appointmentTime");
String serviceID = (String) request.getAttribute("serviceID");
String totalAmount = (String) request.getAttribute("totalAmount");
String weightInfo = (String) request.getAttribute("weightInfo");
String errorMessage = request.getParameter("error");

CatBean cat = (CatBean) request.getAttribute("cat");
List<ServiceItem> selectedServices = (List<ServiceItem>) request.getAttribute("selectedServices");
List<ServiceItem> selectedMainServices = (List<ServiceItem>) request.getAttribute("selectedMainServices");
List<ServiceItem> selectedAddOnServices = (List<ServiceItem>) request.getAttribute("selectedAddOnServices");

if (selectedServices == null) selectedServices = new java.util.ArrayList<>();
if (selectedMainServices == null) selectedMainServices = new java.util.ArrayList<>();
if (selectedAddOnServices == null) selectedAddOnServices = new java.util.ArrayList<>();

if (selectedMainServices.isEmpty() && selectedAddOnServices.isEmpty() && !selectedServices.isEmpty()) {
    for (ServiceItem service : selectedServices) {
        String category = service.getCategory() == null ? "" : service.getCategory().trim().toUpperCase();

        if ("MAIN".equals(category)) {
            selectedMainServices.add(service);
        } else if ("ADDON".equals(category)) {
            selectedAddOnServices.add(service);
        }
    }
}

if (appointmentDate == null) appointmentDate = "";
if (appointmentTime == null) appointmentTime = "";
if (serviceID == null) serviceID = "";
if (totalAmount == null) totalAmount = "0.00";
if (weightInfo == null) weightInfo = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Booking Summary</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookingSummary.css?v=back-grey-1" />

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
</head>

<body>

	<div class="container">

		<div class="page-header">
			<div class="header-icon">✓</div>
			<div>
				<h2>Booking Summary</h2>
				<p>Review your booking details before confirming</p>
			</div>
		</div>

		<%
		if (errorMessage != null) {
		%>
		<div class="error-box">
			Unable to confirm booking. Please try again.
		</div>
		<%
		}
		%>

		<div class="card purple-grad">
			<div class="card-title">
				<div class="card-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<rect x="3" y="4" width="18" height="18" rx="2"/>
						<line x1="16" y1="2" x2="16" y2="6"/>
						<line x1="8" y1="2" x2="8" y2="6"/>
						<line x1="3" y1="10" x2="21" y2="10"/>
					</svg>
				</div>
				Appointment Details
			</div>

			<div class="dt-grid">
				<div class="dt-box">
					<div class="dt-label">Date</div>
					<div class="dt-value" id="display-date"><%=appointmentDate%></div>
				</div>

				<div class="dt-box">
					<div class="dt-label">Time</div>
					<div class="dt-value"><%=appointmentTime%></div>
				</div>
			</div>

			<div class="cat-box">
				<div class="dt-label">Cat</div>

				<span class="cat-tag">
					<%
					if (cat != null) {
					%>
						<%=cat.getCatName()%>
					<%
					} else {
					%>
						Cat ID: <%=request.getParameter("catID")%>
					<%
					}
					%>
				</span>
			</div>
		</div>

		<div class="card">
			<div class="card-title">
				<div class="card-icon">
					<svg viewBox="0 0 24 24" aria-hidden="true">
						<circle cx="6" cy="7" r="3"/>
						<circle cx="6" cy="17" r="3"/>
						<path d="M8.4 8.9 20 20"/>
						<path d="M8.4 15.1 20 4"/>
						<path d="M14.5 5.5h4"/>
						<path d="M16 7.5h2.5"/>
					</svg>
				</div>
				Selected Services
			</div>

			<div id="services-list">
				<%
				if (selectedServices == null || selectedServices.isEmpty()) {
				%>

				<p style="color: #6b7280; font-weight: 700;">
					No services selected.
				</p>

				<%
				} else {
					int count = 1;
				%>

				<%
				if (!selectedMainServices.isEmpty()) {
				%>
				<div style="font-weight:900;color:#7c3aed;margin:10px 0 8px;">
					Main Service
				</div>

				<%
				for (ServiceItem service : selectedMainServices) {
				%>
				<div class="service-item">
					<div class="service-left">
						<div class="service-num"><%=count%></div>

						<div>
							<div class="service-name"><%=service.getName()%></div>
						</div>
					</div>

					<div class="service-price">
						RM <%=String.format("%.2f", service.getPrice())%>
					</div>
				</div>
				<%
				count++;
				}
				}
				%>

				<%
				if (!selectedAddOnServices.isEmpty()) {
				%>
				<div style="font-weight:900;color:#7c3aed;margin:14px 0 8px;">
					Add-On Services
				</div>

				<%
				for (ServiceItem service : selectedAddOnServices) {
				%>
				<div class="service-item">
					<div class="service-left">
						<div class="service-num"><%=count%></div>

						<div>
							<div class="service-name"><%=service.getName()%></div>
						</div>
					</div>

					<div class="service-price">
						RM <%=String.format("%.2f", service.getPrice())%>
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

			<div class="total-row">
				<span class="total-label">Total Amount</span>

				<span class="total-amount">
					RM <%=String.format("%.2f", Double.parseDouble(totalAmount))%>
				</span>
			</div>
		</div>

		<div class="notice-card">
			<div class="notice-icon">i</div>

			<div class="notice-text">
				<strong>Important Notice:</strong>
				<p style="margin-top: 0.25rem;">
					Please arrive 10 minutes before your scheduled appointment time.
					Cancellations must be made at least 24 hours in advance.
				</p>
			</div>
		</div>

		<form action="${pageContext.request.contextPath}/BookingSummaryController" method="post">
			<input type="hidden" name="appointmentDate" value="<%=appointmentDate%>">
			<input type="hidden" name="appointmentTime" value="<%=appointmentTime%>">
			<input type="hidden" name="catID"
				value="<%=cat != null ? cat.getCatID() : request.getParameter("catID")%>">
			<input type="hidden" name="serviceID" value="<%=serviceID%>">
			<input type="hidden" name="totalAmount" value="<%=totalAmount%>">
			<input type="hidden" name="weightInfo" value="<%=weightInfo%>">

			<div class="action-row">
				<button type="button" class="btn btn-back" onclick="goBack()">
					Back
				</button>

				<button type="submit" class="btn btn-confirm">
					Confirm Booking
				</button>
			</div>
		</form>

	</div>

<script>
const appointmentDate = "<%=appointmentDate%>";
const appointmentTime = "<%=appointmentTime%>";
const catID = "<%=cat != null ? cat.getCatID() : request.getParameter("catID")%>";
const serviceID = "<%=serviceID%>";
const totalAmount = "<%=totalAmount%>";
const weightInfo = "<%=weightInfo%>";

function formatDateLabel() {
	const dateElement = document.getElementById("display-date");

	if (!appointmentDate) {
		return;
	}

	dateElement.textContent = appointmentDate;
}

function goBack() {
	const params = new URLSearchParams({
		date: appointmentDate,
		time: appointmentTime,
		catID: catID
	});

	window.location.href = "ChooseServicesController?" + params.toString();
}

formatDateLabel();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>