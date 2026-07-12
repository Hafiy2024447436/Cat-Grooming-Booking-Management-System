<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.CatBean"%>
<%@ page import="catBooking.bean.BreedBean"%>

<%
List<CatBean> cats = (List<CatBean>) request.getAttribute("cats");
String appointmentDate = (String) request.getAttribute("appointmentDate");
String appointmentTime = (String) request.getAttribute("appointmentTime");
String errorMessage = (String) request.getAttribute("errorMessage");

if (appointmentDate == null) {
	appointmentDate = "";
}

if (appointmentTime == null) {
	appointmentTime = "";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Select Your Cat</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/selectCat.css?v=back-grey-1" />
</head>

<body>

	<div class="container">

		<div class="page-header">
			<div class="header-icon" aria-hidden="true">
				<svg class="cat-face-icon" viewBox="0 0 80 80" aria-hidden="true">
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
				<h2>Select Your Cat</h2>
				<p>Choose one cat you want to book for grooming</p>
			</div>
		</div>

		<div class="card appt-card">
			<div class="appt-item">
				<span class="lbl">Date:</span> <span class="val" id="display-date"><%=appointmentDate%></span>
			</div>

			<div class="appt-divider"></div>

			<div class="appt-item">
				<span class="lbl">Time:</span> <span class="val"><%=appointmentTime%></span>
			</div>
		</div>

		<div class="card info-card">
			<div class="info-icon">i</div>
			<div>
				<p>
					<strong>One cat per appointment.</strong> Please select one cat for
					this grooming session.
				</p>
				<p>To book for another cat, please create a separate
					appointment.</p>
			</div>
		</div>

		<%
		if (errorMessage != null) {
		%>
		<div class="card error-card">
			<%=errorMessage%>
		</div>
		<%
		}
		%>

		<%
		if (cats == null || cats.isEmpty()) {
		%>

		<div class="card empty-card">
			<div class="empty-icon" aria-hidden="true">
			<svg class="cat-face-icon" viewBox="0 0 80 80" aria-hidden="true">
                    <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
                    <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                </svg>
		</div>
			<h3>No Cats Registered</h3>
			<p>You need to register at least one cat before booking an
				appointment.</p>
			<a class="btn btn-back"
				href="${pageContext.request.contextPath}/customer/appointment/checkAvailability.jsp?date=<%=appointmentDate%>&time=<%=appointmentTime%>">Back</a>
		</div>

		<%
		} else {
		%>

		<div class="cat-list">
			<%
			for (CatBean cat : cats) {
			%>

			<div class="cat-card"
				onclick="selectCat('<%=cat.getCatID()%>', '<%=cat.getCatName()%>')">
				<div class="cat-radio"></div>

                <div class="cat-avatar">
                    <img src="${pageContext.request.contextPath}/CatPhotoController?id=<%=cat.getCatID()%>"
                         alt="<%=cat.getCatName()%>"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />

                    <div class="cat-avatar-fallback" style="display:none;">
						<svg class="cat-face-icon" viewBox="0 0 80 80" aria-hidden="true">
                    <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
                    <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/>
                    <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                    <path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
                </svg>
					</div>
				</div>

				<div class="cat-info">
					<div class="cat-name"><%=cat.getCatName()%></div>
					<div class="cat-meta">
						<span>ID: <%=cat.getCatID()%></span>

						<%
						if (cat.getBreedID() != 0) {
						%>
						<span>Breed ID: <%=cat.getBreedID()%></span>
						<%
						}
						%>

						<%
						if (cat.getGender() != null) {
						%>
						<span>Gender: <%=cat.getGender()%></span>
						<%
						}
						%>

						<span>Age: <%=cat.calculateAgeDisplay()%></span>
					</div>
				</div>

			</div>

			<%
			}
			%>
		</div>

		<div class="card summary-card" id="summary-card">
			<div class="summary-icon">✓</div>
			<span><strong id="selected-cat-name"></strong> selected for
				grooming</span>
		</div>

		<div class="actions">
			<button type="button" class="btn btn-back" onclick="goBack()">
				Back</button>

			<button type="button" class="btn btn-proceed" id="continue-btn"
				onclick="continueBooking()" disabled>Continue</button>
		</div>

		<%
		}
		%>

	</div>

	<script>
let selectedCatId = "";
let selectedCatName = "";

const appointmentDate = "<%=appointmentDate%>";
const appointmentTime = "<%=appointmentTime%>";

function selectCat(catId, catName) {
	selectedCatId = catId;
	selectedCatName = catName;

	const cards = document.querySelectorAll(".cat-card");

	cards.forEach(card => {
		card.classList.remove("selected");
	});

	event.currentTarget.classList.add("selected");

	document.getElementById("selected-cat-name").textContent = selectedCatName;
	document.getElementById("summary-card").classList.add("show");
	document.getElementById("continue-btn").disabled = false;
}

function continueBooking() {
	if (!selectedCatId) {
		alert("Please select a cat for grooming.");
		return;
	}

	const params = new URLSearchParams({
		date: appointmentDate,
		time: appointmentTime,
		catID: selectedCatId
	});

	window.location.href = "ChooseServicesController?" + params.toString();
}

function goBack() {
	window.location.href = "CheckAvailabilityController?date=" + encodeURIComponent(appointmentDate);
}

function parseServerDate(dateStr) {
	if (!dateStr) return null;

	const parts = dateStr.split("-");
	if (parts.length !== 3) return null;

	const day = parts[0];
	const monthText = parts[1].toUpperCase();
	const year = parts[2];

	const months = {
		JAN: "01", FEB: "02", MAR: "03", APR: "04",
		MAY: "05", JUN: "06", JUL: "07", AUG: "08",
		SEP: "09", OCT: "10", NOV: "11", DEC: "12"
	};

	const month = months[monthText];
	if (!month) return null;

	return new Date(year + "-" + month + "-" + day + "T00:00:00");
}

function formatDateLabel() {
	const dateText = document.getElementById("display-date");

	if (!appointmentDate) {
		return;
	}

	const parsedDate = parseServerDate(appointmentDate);

	if (!parsedDate) {
		dateText.textContent = appointmentDate;
		return;
	}

	dateText.textContent = appointmentDate;
}

formatDateLabel();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>