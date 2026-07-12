<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.CatBean"%>
<%@ page import="catBooking.bean.ServiceBean"%>
<%@ page import="catBooking.bean.WeightBasedServiceBean"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Comparator"%>

<%
String appointmentDate = (String) request.getAttribute("appointmentDate");
String appointmentTime = (String) request.getAttribute("appointmentTime");
CatBean cat = (CatBean) request.getAttribute("cat");
List<ServiceBean> mainServices = (List<ServiceBean>) request.getAttribute("mainServices");
List<ServiceBean> addOnServices = (List<ServiceBean>) request.getAttribute("addOnServices");
String errorMessage = (String) request.getAttribute("errorMessage");

List<ServiceBean> kittenServices = new ArrayList<ServiceBean>();

if (mainServices != null) {
    for (ServiceBean service : mainServices) {
        String serviceName = service.getServiceName() != null ? service.getServiceName().trim().toLowerCase() : "";

        if (serviceName.contains("kitten grooming")) {
            kittenServices.add(service);
        }
    }
}

Collections.sort(kittenServices, new Comparator<ServiceBean>() {
    @Override
    public int compare(ServiceBean s1, ServiceBean s2) {
        return Double.compare(s1.getPrice(), s2.getPrice());
    }
});

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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Choose Grooming Services</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/chooseServices.css?v=back-grey-1" />

<link
	href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
</head>

<body>

	<div class="container">

		<div class="header">
			<div class="header-icon" aria-hidden="true">
				<svg viewBox="0 0 24 24">
					<circle cx="6" cy="7" r="3"></circle>
					<circle cx="6" cy="17" r="3"></circle>
					<path d="M8.4 8.9 20 20"></path>
					<path d="M8.4 15.1 20 4"></path>
					<path d="M14.5 5.5h4"></path>
					<path d="M16 7.5h2.5"></path>
				</svg>
			</div>

			<div>
				<h2>Choose Grooming Services</h2>
				<p>Select the grooming services and add-ons for your cat</p>
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

		<div class="appt-card">
			<span class="label">Date:</span>
			<span class="value" id="appt-date"><%=appointmentDate%></span>

			<div class="appt-divider"></div>

			<span class="label">Time:</span>
			<span class="value"><%=appointmentTime%></span>

			<div class="appt-divider"></div>

			<span class="label">Cat:</span>
			<span class="value">
				<%=cat != null ? cat.getCatName() : "Not selected"%>
			</span>
		</div>

		<div class="section-block">
			<div class="section-header">
				<div class="section-icon purple">★</div>
				<h3>Main Grooming Services</h3>
			</div>

			<p class="section-note purple">
				<strong>All services include:</strong> Bath &amp; Dry with Normal Shampoo, Nail Clipping, Eye Cleaning, and Basic Ear Cleaning.
			</p>

			<div class="service-list">
				<%
				if (mainServices == null || mainServices.isEmpty()) {
				%>

				<div class="empty-services">No main grooming services found.</div>

				<%
				} else {
					boolean kittenRendered = false;

					for (ServiceBean service : mainServices) {
						String serviceName = service.getServiceName() != null ? service.getServiceName().trim() : "";
						boolean isKittenService = serviceName.toLowerCase().contains("kitten grooming");

						if (isKittenService) {
							if (kittenRendered) {
								continue;
							}

							kittenRendered = true;
							ServiceBean firstKitten = !kittenServices.isEmpty() ? kittenServices.get(0) : service;
				%>

				<div class="service-card main-service kitten-service-card"
					data-id=""
					data-name="<%=firstKitten.getServiceName()%>"
					data-price="0"
					data-is-kitten="true"
					onclick="toggleService(this, 'main')">

					<div class="checkbox"></div>

					<div class="service-body">
						<div class="service-title-row">
							<div>
								<div class="service-name"><%=firstKitten.getServiceName()%></div>
								<div class="service-desc">
									<%=firstKitten.getDescription() != null ? firstKitten.getDescription() : ""%>
								</div>
							</div>
						</div>

						<div class="weight-options" onclick="event.stopPropagation();">
							<p class="weight-title">Select kitten weight range:</p>

							<%
							for (ServiceBean kittenService : kittenServices) {
								String weightRange = "Weight option";

								if (kittenService instanceof WeightBasedServiceBean) {
									String rangeValue = ((WeightBasedServiceBean) kittenService).getWeightRange();
									if (rangeValue != null && !rangeValue.trim().isEmpty()) {
										weightRange = rangeValue.trim();
									}
								}
							%>

							<label class="weight-option">
								<input type="radio"
									name="kittenWeightService"
									value="<%=kittenService.getServiceID()%>"
									data-id="<%=kittenService.getServiceID()%>"
									data-name="<%=kittenService.getServiceName()%>"
									data-price="<%=kittenService.getPrice()%>"
									data-weight-range="<%=weightRange%>"
									onchange="selectKittenWeight(this)">
								<span class="weight-label"><%=weightRange%></span>
								<span class="weight-price">RM <%=String.format("%.2f", kittenService.getPrice())%></span>
							</label>

							<%
							}
							%>
						</div>
					</div>
				</div>

				<%
							continue;
						}
				%>

				<div class="service-card main-service"
					data-id="<%=service.getServiceID()%>"
					data-name="<%=service.getServiceName()%>"
					data-price="<%=service.getPrice()%>"
					data-is-kitten="false"
					onclick="toggleService(this, 'main')">

					<div class="checkbox"></div>

					<div class="service-body">
						<div class="service-title-row">
							<div>
								<div class="service-name"><%=service.getServiceName()%></div>
								<div class="service-desc">
									<%=service.getDescription() != null ? service.getDescription() : ""%>
								</div>
							</div>

							<div class="service-price">
								RM <%=String.format("%.2f", service.getPrice())%>
							</div>
						</div>
					</div>
				</div>

				<%
					}
				}
				%>
			</div>
		</div>

		<div class="section-block">
			<div class="section-header">
				<div class="section-icon blue">+</div>
				<h3>Add-On Services (Optional)</h3>
			</div>


			<div class="service-list">
				<%
				if (addOnServices == null || addOnServices.isEmpty()) {
				%>

				<div class="empty-services">No add-on services found.</div>

				<%
				} else {
					for (ServiceBean service : addOnServices) {
				%>

				<div class="service-card addon"
					data-id="<%=service.getServiceID()%>"
					data-name="<%=service.getServiceName()%>"
					data-price="<%=service.getPrice()%>"
					onclick="toggleService(this, 'addon')">

					<div class="checkbox"></div>

					<div class="service-body">
						<div class="service-title-row">
							<div>
								<div class="service-name"><%=service.getServiceName()%></div>
								<div class="service-desc">
									<%=service.getDescription() != null ? service.getDescription() : ""%>
								</div>
							</div>

							<div class="service-price">
								RM <%=String.format("%.2f", service.getPrice())%>
							</div>
						</div>
					</div>
				</div>

				<%
					}
				}
				%>
			</div>
		</div>

		<div class="total-bar" id="total-bar">
			<span>Estimated Total</span>
			<span class="total-amount" id="total-amount">RM 0.00</span>
		</div>

		<div class="actions">
			<button type="button" class="btn btn-back" onclick="goBack()">
				Back
			</button>

			<button type="button" class="btn btn-confirm" id="btn-confirm"
				disabled onclick="continueBooking()">
				Continue Booking
			</button>
		</div>

	</div>

	<script>
const appointmentDate = "<%=appointmentDate%>";
const appointmentTime = "<%=appointmentTime%>";
const catID = "<%=cat != null ? cat.getCatID() : ""%>";

function clearKittenWeightSelection() {
    document.querySelectorAll("input[name='kittenWeightService']").forEach(function (radio) {
        radio.checked = false;
    });

    document.querySelectorAll(".weight-option").forEach(function (option) {
        option.classList.remove("selected-weight");
    });
}

function selectKittenWeight(radio) {
    document.querySelectorAll(".weight-option").forEach(function (option) {
        option.classList.remove("selected-weight");
    });

    const option = radio.closest(".weight-option");
    if (option) {
        option.classList.add("selected-weight");
    }

    updateTotal();
}

function toggleService(card, type) {
    if (type === "main") {
        const alreadySelected = card.classList.contains("selected-purple");

        document.querySelectorAll(".main-service").forEach(function (mainCard) {
            mainCard.classList.remove("selected-purple");
            const check = mainCard.querySelector(".checkbox");
            if (check) {
                check.textContent = "";
            }
        });

        clearKittenWeightSelection();

        if (!alreadySelected) {
            card.classList.add("selected-purple");
            const check = card.querySelector(".checkbox");
            if (check) {
                check.textContent = "✓";
            }
        }
    }

    if (type === "addon") {
        const check = card.querySelector(".checkbox");

        if (card.classList.contains("selected-blue")) {
            card.classList.remove("selected-blue");
            if (check) {
                check.textContent = "";
            }
        } else {
            card.classList.add("selected-blue");
            if (check) {
                check.textContent = "✓";
            }
        }
    }

    updateTotal();
}

function getSelectedKittenWeight() {
    return document.querySelector("input[name='kittenWeightService']:checked");
}

function getSelectedServices() {
    const selectedServices = [];

    const selectedMain = document.querySelector(".main-service.selected-purple");

    if (selectedMain) {
        if (selectedMain.dataset.isKitten === "true") {
            const selectedWeight = getSelectedKittenWeight();

            if (selectedWeight) {
                selectedServices.push({
                    id: selectedWeight.dataset.id,
                    name: selectedWeight.dataset.name,
                    price: parseFloat(selectedWeight.dataset.price || "0"),
                    type: "main",
                    weightRange: selectedWeight.dataset.weightRange || ""
                });
            }
        } else {
            selectedServices.push({
                id: selectedMain.dataset.id,
                name: selectedMain.dataset.name,
                price: parseFloat(selectedMain.dataset.price || "0"),
                type: "main"
            });
        }
    }

    document.querySelectorAll(".addon.selected-blue").forEach(function (addonCard) {
        selectedServices.push({
            id: addonCard.dataset.id,
            name: addonCard.dataset.name,
            price: parseFloat(addonCard.dataset.price || "0"),
            type: "addon"
        });
    });

    return selectedServices;
}

function hasValidMainSelection() {
    const selectedMain = document.querySelector(".main-service.selected-purple");

    if (!selectedMain) {
        return false;
    }

    if (selectedMain.dataset.isKitten === "true") {
        return getSelectedKittenWeight() !== null;
    }

    return true;
}

function updateTotal() {
    const selectedServices = getSelectedServices();

    let total = 0;

    selectedServices.forEach(function (service) {
        total += service.price;
    });

    const totalBar = document.getElementById("total-bar");
    const totalAmount = document.getElementById("total-amount");
    const confirmButton = document.getElementById("btn-confirm");

    if (selectedServices.length > 0) {
        totalBar.style.display = "flex";
        totalAmount.textContent = "RM " + total.toFixed(2);
    } else {
        totalBar.style.display = "none";
        totalAmount.textContent = "RM 0.00";
    }

    confirmButton.disabled = !hasValidMainSelection();
}

function continueBooking() {
    const selectedMain = document.querySelector(".main-service.selected-purple");

    if (!selectedMain) {
        alert("Please select one main grooming service.");
        return;
    }

    if (selectedMain.dataset.isKitten === "true" && !getSelectedKittenWeight()) {
        alert("Please select the kitten weight range.");
        return;
    }

    const selectedServices = getSelectedServices();

    let total = 0;
    selectedServices.forEach(function (service) {
        total += service.price;
    });

    const serviceID = selectedServices.map(function (service) {
        return service.id;
    }).join(",");

    const selectedKittenWeight = getSelectedKittenWeight();

    const params = new URLSearchParams({
        date: appointmentDate,
        time: appointmentTime,
        catID: catID,
        serviceID: serviceID,
        totalAmount: total.toFixed(2)
    });

    if (selectedKittenWeight) {
        params.set("weightInfo", selectedKittenWeight.dataset.weightRange || "");
    }

    window.location.href = "BookingSummaryController?" + params.toString();
}

function goBack() {
    const params = new URLSearchParams({
        date: appointmentDate,
        time: appointmentTime
    });

    window.location.href = "SelectCatController?" + params.toString();
}

function parseServerDate(dateStr) {
    if (!dateStr) {
        return null;
    }

    const parts = dateStr.split("-");

    if (parts.length !== 3) {
        return null;
    }

    const day = parts[0];
    const monthText = parts[1].toUpperCase();
    const year = parts[2];

    const months = {
        JAN: "01",
        FEB: "02",
        MAR: "03",
        APR: "04",
        MAY: "05",
        JUN: "06",
        JUL: "07",
        AUG: "08",
        SEP: "09",
        OCT: "10",
        NOV: "11",
        DEC: "12"
    };

    const month = months[monthText];

    if (!month) {
        return null;
    }

    return new Date(year + "-" + month + "-" + day + "T00:00:00");
}

function formatDateLabel() {
    const dateElement = document.getElementById("appt-date");

    if (!dateElement || !appointmentDate) {
        return;
    }

    const parsedDate = parseServerDate(appointmentDate);

    if (!parsedDate) {
        dateElement.textContent = appointmentDate;
        return;
    }

    dateElement.textContent = appointmentDate;
}

document.addEventListener("DOMContentLoaded", function () {
    updateTotal();
    formatDateLabel();
});
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>