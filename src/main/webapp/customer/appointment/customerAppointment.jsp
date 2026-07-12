<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="catBooking.util.DateUtil"%>
<%@ page import="catBooking.bean.AppointmentBean"%>
<%@ page import="catBooking.servlet.customer.CustomerAppointmentController.AppointmentView"%>

<%
List<AppointmentView> appointmentViews = (List<AppointmentView>) request.getAttribute("appointmentViews");
String errorMessage = (String) request.getAttribute("errorMessage");
LocalDate today = LocalDate.now();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Appointments</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/customerAppointment.css?v=nunito-final-appointment-2" />

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>

<body>

	<main class="main">

		<%
		boolean hasAppointments = appointmentViews != null && !appointmentViews.isEmpty();
		boolean hasUpcoming = false;
		boolean hasPast = false;

		if (hasAppointments) {
			for (AppointmentView view : appointmentViews) {
				AppointmentBean appt = view.getAppointment();

				if (isCompletedAppointment(appt)) {
					hasPast = true;
				} else {
					hasUpcoming = true;
				}
			}
		}
		%>

		<div class="header-card">
			<h1 class="page-title">My Appointments</h1>
			<p class="page-subtitle">View your upcoming and past appointments</p>

			<%
			if (hasAppointments) {
			%>
			<div class="appt-filter-row">
				<button type="button" class="appt-filter-btn active" id="filter-upcoming"
					onclick="showAppointmentTab('upcoming')" <%=!hasUpcoming ? "disabled" : ""%>>
					Upcoming Appointments
				</button>
				<button type="button" class="appt-filter-btn" id="filter-past"
					onclick="showAppointmentTab('past')" <%=!hasPast ? "disabled" : ""%>>
					Past Appointments
				</button>
			</div>
			<%
			}
			%>
		</div>

		<%
		if (errorMessage != null) {
		%>
		<div class="error-box">
			<%=errorMessage%>
		</div>
		<%
		}
		%>

		<div class="page">

			<%
			if (!hasAppointments) {
			%>

			<div class="empty-state">
				<h3>No Appointments Yet</h3>
				<p>You do not have any appointments yet.</p>
			</div>

			<%
			} else {
			%>

			<%
			if (hasUpcoming) {
			%>
			<section id="section-upcoming" class="appointment-panel <%=!hasUpcoming ? "is-hidden" : ""%>">
				<h2 class="section-title">Upcoming Appointments</h2>

				<div class="space-y">
					<%
					for (AppointmentView view : appointmentViews) {
						AppointmentBean appt = view.getAppointment();

						if (!isCompletedAppointment(appt)) {
					%>

					<%=renderAppointmentCard(view, false)%>

					<%
						}
					}
					%>
				</div>
			</section>
			<%
			}
			%>

			<%
			if (hasPast) {
			%>
			<section id="section-past" class="appointment-panel <%=hasUpcoming ? "is-hidden" : ""%>">
				<h2 class="section-title">Past Appointments</h2>

				<div class="space-y">
					<%
					for (AppointmentView view : appointmentViews) {
						AppointmentBean appt = view.getAppointment();

						if (isCompletedAppointment(appt)) {
					%>

					<%=renderAppointmentCard(view, true)%>

					<%
						}
					}
					%>
				</div>
			</section>
			<%
			}
			%>

			<%
			}
			%>

		</div>

	</main>

	<div class="overlay" id="modal-details">
		<div class="modal">
			<div class="modal-header-purple">
				<button type="button" class="modal-close-x"
					onclick="closeModal('modal-details')" aria-label="Close details">&times;</button>
				<h2>Appointment Details</h2>
				<p id="details-id"></p>
			</div>

			<div class="modal-body details-modal-body">

				<div>
					<div class="detail-label">Status</div>
					<div id="details-status"></div>
				</div>

				<div class="detail-grid">
					<div>
						<div class="detail-label">Date</div>
						<div class="detail-value" id="details-date"></div>
					</div>

					<div>
						<div class="detail-label">Time</div>
						<div class="detail-value" id="details-time"></div>
					</div>

					<div>
						<div class="detail-label">Current Weight</div>
						<div class="detail-value" id="details-weight"></div>
					</div>
				</div>

				<div>
					<div class="detail-label">Cat</div>
					<div class="pill-group" id="details-cats"></div>
				</div>

				<div>
					<div class="detail-label">Services</div>
					<div class="details-services-list" id="details-services"></div>
				</div>

				<div class="details-total-row">
					<span>Total Amount</span>
					<span id="details-total"></span>
				</div>
			</div>
		</div>
	</div>

	<script>
const appointments = [
<%
if (appointmentViews != null) {
	for (int i = 0; i < appointmentViews.size(); i++) {
		AppointmentView view = appointmentViews.get(i);
		AppointmentBean appt = view.getAppointment();
%>
{
	id: "<%=escapeJs(String.valueOf(appt.getAppointmentID()))%>",
	no: "<%=escapeJs(appt.getAppointmentNo())%>",
	date: "<%=escapeJs(appointmentDateDisplay(appt))%>",
	time: "<%=escapeJs(appt.getAppointmentTime())%>",
	status: "<%=escapeJs(appt.getAppointmentStatus() != null ? appt.getAppointmentStatus().toLowerCase() : "pending")%>",
	catName: "<%=escapeJs(view.getCatName())%>",
	total: <%=appt.getTotalAmount()%>,
	weight: "<%=escapeJs(appt.getWeightDisplay())%>",

	services: [
	<%
		List<String> serviceNames = view.getServiceNames();
		for (int j = 0; j < serviceNames.size(); j++) {
	%>
		"<%=escapeJs(serviceNames.get(j))%>"<%=j < serviceNames.size() - 1 ? "," : ""%>
	<%
		}
	%>
	],

	mainServices: [
	<%
		List<String> mainServiceNames = view.getMainServiceNames();
		for (int j = 0; j < mainServiceNames.size(); j++) {
	%>
		"<%=escapeJs(mainServiceNames.get(j))%>"<%=j < mainServiceNames.size() - 1 ? "," : ""%>
	<%
		}
	%>
	],

	addOnServices: [
	<%
		List<String> addOnServiceNames = view.getAddOnServiceNames();
		for (int j = 0; j < addOnServiceNames.size(); j++) {
	%>
		"<%=escapeJs(addOnServiceNames.get(j))%>"<%=j < addOnServiceNames.size() - 1 ? "," : ""%>
	<%
		}
	%>
	]
}<%=i < appointmentViews.size() - 1 ? "," : ""%>
<%
	}
}
%>
];

function formatDate(dateStr) {
	if (!dateStr) {
		return "";
	}

	return dateStr.split(" ")[0];
}

function badgeHTML(status) {
	if (status === "confirmed") {
		return '<span class="badge badge-confirmed">Confirmed</span>';
	}

	if (status === "completed") {
		return '<span class="badge badge-completed">Completed</span>';
	}

	if (status === "cancelled") {
		return '<span class="badge badge-cancelled">Cancelled</span>';
	}

	return '<span class="badge badge-pending">Pending</span>';
}

function openDetails(id) {
	const appt = appointments.find(item => item.id === id);

	if (!appt) {
		return;
	}

	document.getElementById("details-id").textContent = appt.no;
	document.getElementById("details-status").innerHTML = badgeHTML(appt.status);
	document.getElementById("details-date").textContent = formatDate(appt.date);
	document.getElementById("details-time").textContent = appt.time;
	document.getElementById("details-weight").textContent = appt.weight;
	document.getElementById("details-cats").innerHTML =
		'<span class="pill pill-purple">' + escapeHtml(appt.catName) + '</span>';

	let detailHtml = "";

	if (appt.mainServices && appt.mainServices.length > 0) {
		detailHtml += '<div class="service-heading">Main Service</div>';

		detailHtml += appt.mainServices.map(service =>
			'<div class="service-row">' + escapeHtml(service) + '</div>'
		).join("");
	}

	if (appt.addOnServices && appt.addOnServices.length > 0) {
		detailHtml += '<div class="service-heading add-on-heading">Add-On Services</div>';

		detailHtml += appt.addOnServices.map(service =>
			'<div class="service-row">' + escapeHtml(service) + '</div>'
		).join("");
	}

	if (!detailHtml && appt.services && appt.services.length > 0) {
		detailHtml += appt.services.map(service =>
			'<div class="service-row">' + escapeHtml(service) + '</div>'
		).join("");
	}

	if (!detailHtml) {
		detailHtml = '<div class="service-row">No service</div>';
	}

	document.getElementById("details-services").innerHTML = detailHtml;
	document.getElementById("details-total").textContent =
		"RM " + Number(appt.total).toFixed(2);

	document.getElementById("modal-details").classList.add("open");
}

function closeModal(id) {
	document.getElementById(id).classList.remove("open");
}

function escapeHtml(value) {
	return String(value || "")
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;")
		.replace(/\"/g, "&quot;")
		.replace(/'/g, "&#39;");
}

function showAppointmentTab(tab) {
	const upcomingSection = document.getElementById("section-upcoming");
	const pastSection = document.getElementById("section-past");
	const upcomingButton = document.getElementById("filter-upcoming");
	const pastButton = document.getElementById("filter-past");

	if (upcomingSection) {
		upcomingSection.classList.toggle("is-hidden", tab !== "upcoming");
	}

	if (pastSection) {
		pastSection.classList.toggle("is-hidden", tab !== "past");
	}

	if (upcomingButton) {
		upcomingButton.classList.toggle("active", tab === "upcoming");
	}

	if (pastButton) {
		pastButton.classList.toggle("active", tab === "past");
	}
}

document.addEventListener("DOMContentLoaded", () => {
	const upcomingButton = document.getElementById("filter-upcoming");
	const pastButton = document.getElementById("filter-past");

	if (upcomingButton && upcomingButton.disabled && pastButton && !pastButton.disabled) {
		showAppointmentTab("past");
	} else if (upcomingButton && !upcomingButton.disabled) {
		showAppointmentTab("upcoming");
	}
});

document.querySelectorAll(".overlay").forEach(overlay => {
	overlay.addEventListener("click", event => {
		if (event.target === overlay) {
			overlay.classList.remove("open");
		}
	});
});

document.addEventListener("keydown", event => {
	if (event.key === "Escape") {
		closeModal("modal-details");
	}
});
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>

<%!
	public boolean isCompletedAppointment(AppointmentBean appt) {
		if (appt == null || appt.getAppointmentStatus() == null) {
			return false;
		}

		return "completed".equals(appt.getAppointmentStatus().toLowerCase());
	}

	public String appointmentDateDisplay(AppointmentBean appt) {
		if (appt == null || appt.getAppointmentDate() == null) {
			return "";
		}

		return DateUtil.formatDate(appt.getAppointmentDate());
	}

	public String renderAppointmentCard(AppointmentView view, boolean isPast) {
		AppointmentBean appt = view.getAppointment();

		String status = appt.getAppointmentStatus() != null
				? appt.getAppointmentStatus().toLowerCase()
				: "pending";

		String badgeClass = "badge-pending";
		String badgeText = "Pending";

		if ("confirmed".equals(status)) {
			badgeClass = "badge-confirmed";
			badgeText = "Confirmed";
		} else if ("completed".equals(status)) {
			badgeClass = "badge-completed";
			badgeText = "Completed";
		} else if ("cancelled".equals(status)) {
			badgeClass = "badge-cancelled";
			badgeText = "Cancelled";
		}

		StringBuilder services = new StringBuilder();

		if (view.getMainServiceNames() != null && !view.getMainServiceNames().isEmpty()) {
			services.append("<span class=\"pill pill-purple\">Main</span>");

			for (String serviceName : view.getMainServiceNames()) {
				services.append("<span class=\"pill pill-gray\">")
						.append(escapeHtml(serviceName))
						.append("</span>");
			}
		}

		if (view.getAddOnServiceNames() != null && !view.getAddOnServiceNames().isEmpty()) {
			services.append("<span class=\"pill pill-purple\">Add-On</span>");

			for (String serviceName : view.getAddOnServiceNames()) {
				services.append("<span class=\"pill pill-gray\">")
						.append(escapeHtml(serviceName))
						.append("</span>");
			}
		}

		if (services.length() == 0 && view.getServiceNames() != null && !view.getServiceNames().isEmpty()) {
			for (String serviceName : view.getServiceNames()) {
				services.append("<span class=\"pill pill-gray\">")
						.append(escapeHtml(serviceName))
						.append("</span>");
			}
		}

		if (services.length() == 0) {
			services.append("<span class=\"pill pill-gray\">No service</span>");
		}

		return ""
				+ "<div class=\"card " + (isPast ? "past" : "") + "\">"
				+ "<div class=\"card-top\">"
				+ "<div>"
				+ "<div class=\"appt-id-row\">"
				+ "<span class=\"appt-id\">"
				+ escapeHtml(appt.getAppointmentNo())
				+ "</span>"
				+ "<span class=\"badge " + badgeClass + "\">"
				+ badgeText
				+ "</span>"
				+ "</div>"
				+ "<div class=\"meta-row\">"
				+ "Date: "
				+ escapeHtml(appointmentDateDisplay(appt))
				+ "<div class=\"meta-divider\"></div>"
				+ "Time: "
				+ escapeHtml(appt.getAppointmentTime())
				+ "</div>"
				+ "</div>"
				+ "<div class=\"total-amount " + (isPast ? "past" : "") + "\">RM "
				+ String.format("%.2f", appt.getTotalAmount())
				+ "</div>"
				+ "</div>"

				+ "<div class=\"card-section\">"
				+ "<div class=\"section-label\">Cat:</div>"
				+ "<div class=\"pill-group\">"
				+ "<span class=\"pill pill-purple\">"
				+ escapeHtml(view.getCatName())
				+ "</span>"
				+ "</div>"
				+ "</div>"

				+ "<div class=\"card-section\">"
				+ "<div class=\"section-label\">Current Weight:</div>"
				+ "<div class=\"pill-group\">"
				+ "<span class=\"pill pill-gray\">"
				+ escapeHtml(appt.getWeightDisplay())
				+ "</span>"
				+ "</div>"
				+ "</div>"

				+ "<div class=\"card-section\">"
				+ "<div class=\"section-label\">Services:</div>"
				+ "<div class=\"pill-group\">"
				+ services.toString()
				+ "</div>"
				+ "</div>"

				+ "<hr class=\"divider\">"

				+ "<div class=\"action-row\">"
				+ "<button type=\"button\" class=\"btn btn-blue\" onclick=\"openDetails('"
				+ escapeJs(String.valueOf(appt.getAppointmentID()))
				+ "')\">View Details</button>"
				+ "</div>"
				+ "</div>";
	}

	public String escapeHtml(String value) {
		if (value == null) {
			return "";
		}

		return value.replace("&", "&amp;")
				.replace("<", "&lt;")
				.replace(">", "&gt;")
				.replace("\"", "&quot;")
				.replace("'", "&#39;");
	}

	public String escapeJs(String value) {
		if (value == null) {
			return "";
		}

		return value.replace("\\", "\\\\")
				.replace("\"", "\\\"")
				.replace("'", "\\'")
				.replace("\r", "")
				.replace("\n", "");
	}
%>
