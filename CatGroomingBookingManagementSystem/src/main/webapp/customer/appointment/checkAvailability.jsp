<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.util.DateUtil"%>

<%
String selectedDateFromServlet = (String) request.getAttribute("selectedDate");
List<String> bookedTimes = (List<String>) request.getAttribute("bookedTimes");
String errorMessage = (String) request.getAttribute("errorMessage");

if (selectedDateFromServlet == null) {
	selectedDateFromServlet = "";
}

String jsDate = "";
if (!selectedDateFromServlet.isEmpty()) {
	java.sql.Date parsedDate = DateUtil.parseDate(selectedDateFromServlet);
	if (parsedDate != null) {
		jsDate = parsedDate.toLocalDate().toString();
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Check Availability</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/checkAvailability.css?v=color-standard-1" />

<link
	href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
</head>

<body>

	<div class="container">

		<div class="page-header">
			<div class="header-icon" aria-hidden="true">
				<svg viewBox="0 0 24 24" class="calendar-icon">
					<rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
					<line x1="16" y1="2" x2="16" y2="6"></line>
					<line x1="8" y1="2" x2="8" y2="6"></line>
					<line x1="3" y1="10" x2="21" y2="10"></line>
				</svg>
			</div>

			<div>
				<h2>Check Availability</h2>
				<p>Select an available date and time for your grooming session</p>
			</div>
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

		<div class="two-col">

			<div class="card">
				<div class="cal-header">
					<h3>Select Date</h3>

					<div class="month-nav">
						<button type="button" class="nav-btn" onclick="prevMonth()">
							&lt;
						</button>

						<span class="month-label" id="month-label"></span>

						<button type="button" class="nav-btn" onclick="nextMonth()">
							&gt;
						</button>
					</div>
				</div>

				<div class="cal-grid" id="cal-grid"></div>

				<div class="selected-banner" id="selected-banner">
					<span id="selected-date-text"></span>
				</div>
			</div>

			<div class="card">
				<div class="time-header">
					<h3>Select Time</h3>
				</div>

				<div class="time-empty" id="time-empty">
					<p>Please select a date first</p>
				</div>

				<div id="time-slots-section" style="display: none;">
					<p class="slots-label" id="slots-label"></p>

					<div class="slots-grid" id="slots-grid"></div>

					<div class="time-selected-banner" id="time-selected-banner">
						<span id="time-selected-text"></span>
					</div>
				</div>
			</div>

		</div>

		<div class="action-row">
			<button type="button" class="btn btn-continue" id="continue-btn"
				onclick="handleContinue()" disabled>
				Continue
			</button>
		</div>

	</div>

<script>
const monthNames = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
];

const dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

const timeSlots = [
	{ value: "09:00", label: "09:00" },
	{ value: "10:00", label: "10:00" },
	{ value: "11:00", label: "11:00" },
	{ value: "12:00", label: "12:00" },
	{ value: "14:00", label: "14:00" },
	{ value: "15:00", label: "15:00" },
	{ value: "16:00", label: "16:00" },
	{ value: "17:00", label: "17:00" }
];

const bookedTimes = [
	<%
	if (bookedTimes != null) {
		for (int i = 0; i < bookedTimes.size(); i++) {
			String time = bookedTimes.get(i);
	%>
	"<%=time%>"<%=i < bookedTimes.size() - 1 ? "," : ""%>
	<%
		}
	}
	%>
];

let selectedDate = "<%=jsDate%>";
let selectedDateForServer = "<%=selectedDateFromServlet%>";
let selectedTime = "";
let selectedTimeLabel = "";

const monthAbbr = [
	"JAN", "FEB", "MAR", "APR", "MAY", "JUN",
	"JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
];

let currentMonth = selectedDate
	? new Date(selectedDate + "T00:00:00")
	: new Date();

currentMonth.setDate(1);

function toServerDate(dateStr) {
	const parts = dateStr.split("-");
	const year = parts[0];
	const month = parts[1];
	const day = parts[2];

	return day + "-" + monthAbbr[parseInt(month, 10) - 1] + "-" + year;
}

function renderCalendar() {
	const year = currentMonth.getFullYear();
	const month = currentMonth.getMonth();

	document.getElementById("month-label").textContent =
		monthNames[month] + " " + year;

	const grid = document.getElementById("cal-grid");
	grid.innerHTML = "";

	dayNames.forEach(function (day) {
		const el = document.createElement("div");
		el.className = "day-name";
		el.textContent = day;
		grid.appendChild(el);
	});

	const firstDay = new Date(year, month, 1).getDay();

	for (let i = 0; i < firstDay; i++) {
		const el = document.createElement("div");
		el.className = "day-cell empty";
		grid.appendChild(el);
	}

	const today = new Date();
	today.setHours(0, 0, 0, 0);

	const daysInMonth = new Date(year, month + 1, 0).getDate();

	for (let day = 1; day <= daysInMonth; day++) {
		const date = new Date(year, month, day);

		const dateStr =
			year + "-" +
			String(month + 1).padStart(2, "0") + "-" +
			String(day).padStart(2, "0");

		const isPast = date < today;
		const isToday = date.toDateString() === today.toDateString();
		const isSelected = selectedDate === dateStr;

		const btn = document.createElement("button");
		btn.type = "button";

		btn.className = "day-cell"
			+ (isSelected ? " selected" : "")
			+ (isPast ? " past" : "")
			+ (isToday ? " today" : "");

		btn.textContent = day;
		btn.disabled = isPast;

		if (!isPast) {
			btn.addEventListener("click", function () {
				selectedTime = "";
				selectedTimeLabel = "";

				window.location.href =
					"CheckAvailabilityController?date=" + encodeURIComponent(toServerDate(dateStr));
			});
		}

		grid.appendChild(btn);
	}
}

function renderSelectedDate() {
	const banner = document.getElementById("selected-banner");

	if (!selectedDate || !selectedDateForServer) {
		banner.classList.remove("show");
		return;
	}

	banner.classList.add("show");

	document.getElementById("selected-date-text").textContent =
		"Selected: " + selectedDateForServer;
}

function renderSlots() {
	if (!selectedDate || !selectedDateForServer) {
		document.getElementById("time-empty").style.display = "block";
		document.getElementById("time-slots-section").style.display = "none";
		return;
	}

	document.getElementById("time-empty").style.display = "none";
	document.getElementById("time-slots-section").style.display = "block";

	document.getElementById("slots-label").textContent =
		"Available time slots for " + selectedDateForServer;

	const grid = document.getElementById("slots-grid");
	grid.innerHTML = "";

	timeSlots.forEach(function (slot) {
		const isBooked = bookedTimes.includes(slot.value);
		const isSelected = selectedTime === slot.value;

		const btn = document.createElement("button");
		btn.type = "button";

		btn.className = "slot-btn"
			+ (isSelected ? " selected-slot" : "")
			+ (isBooked ? " booked" : "");

		btn.disabled = isBooked;

		btn.innerHTML =
			"<span class='slot-time'>" + slot.label + "</span>"
			+ (isBooked ? "<span class='booked-label'>Booked</span>" : "");

		if (!isBooked) {
			btn.addEventListener("click", function () {
				selectTime(slot.value, slot.label);
			});
		}

		grid.appendChild(btn);
	});
}

function selectTime(timeValue, timeLabel) {
	selectedTime = timeValue;
	selectedTimeLabel = timeLabel;

	renderSlots();

	const banner = document.getElementById("time-selected-banner");
	banner.classList.add("show");

	document.getElementById("time-selected-text").textContent =
		"Time selected: " + selectedTimeLabel;

	updateContinueButton();
}

function updateContinueButton() {
	const continueBtn = document.getElementById("continue-btn");

	continueBtn.disabled = !(selectedDateForServer && selectedTime);
}

function prevMonth() {
	currentMonth = new Date(
		currentMonth.getFullYear(),
		currentMonth.getMonth() - 1,
		1
	);

	renderCalendar();
}

function nextMonth() {
	currentMonth = new Date(
		currentMonth.getFullYear(),
		currentMonth.getMonth() + 1,
		1
	);

	renderCalendar();
}

function handleContinue() {
	if (!selectedDateForServer || !selectedTime) {
		alert("Please select both date and time.");
		updateContinueButton();
		return;
	}

	const params = new URLSearchParams({
		date: selectedDateForServer,
		time: selectedTime
	});

	window.location.href = "SelectCatController?" + params.toString();
}

renderCalendar();
renderSelectedDate();
renderSlots();
updateContinueButton();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>