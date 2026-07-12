<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="catBooking.servlet.staff.SalesReportController.TransactionRow"%>

<%
Boolean showReportObj = (Boolean) request.getAttribute("showReport");
boolean showReport = showReportObj != null && showReportObj;

String selectedPeriod = (String) request.getAttribute("selectedPeriod");
String reportTitle = (String) request.getAttribute("reportTitle");
String labelHeader = (String) request.getAttribute("labelHeader");

List<TransactionRow> rows = (List<TransactionRow>) request.getAttribute("rows");

Integer totalTransactionsObj = (Integer) request.getAttribute("totalTransactions");
Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
Double averageValueObj = (Double) request.getAttribute("averageValue");

int totalTransactions = totalTransactionsObj != null ? totalTransactionsObj : 0;
double totalRevenue = totalRevenueObj != null ? totalRevenueObj : 0.0;
double averageValue = averageValueObj != null ? averageValueObj : 0.0;

if (selectedPeriod == null || selectedPeriod.trim().isEmpty()) {
    selectedPeriod = "monthly";
}

if (reportTitle == null) {
    reportTitle = "";
}

if (labelHeader == null || labelHeader.trim().isEmpty()) {
    labelHeader = "Time";
}

int currentYear = LocalDate.now().getYear();
int currentMonth = LocalDate.now().getMonthValue();
String today = LocalDate.now().toString();

boolean dailyActive = "daily".equalsIgnoreCase(selectedPeriod);
boolean monthlyActive = "monthly".equalsIgnoreCase(selectedPeriod);
boolean yearlyActive = "yearly".equalsIgnoreCase(selectedPeriod);
boolean customActive = "custom".equalsIgnoreCase(selectedPeriod);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Sales Report</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/salesReport.css?v=button-colors-1">
<style>

/* Button color alignment */
:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

.btn-green,
button.btn-green {
  background: var(--btn-green) !important;
  color: #ffffff !important;
  border-color: var(--btn-green) !important;
}

.btn-green:hover,
button.btn-green:hover {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
}

.btn-white,
button.btn-white {
  background: var(--btn-grey) !important;
  color: #ffffff !important;
  border-color: var(--btn-grey) !important;
}

.btn-white:hover,
button.btn-white:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
}

button:disabled,
.btn:disabled {
  background: var(--btn-disabled) !important;
  color: #6b7280 !important;
  cursor: not-allowed !important;
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

<div class="container">

    <div class="header">
        <div class="icon">$</div>

        <div>
            <h1>Sales Report</h1>

            <% if (showReport) { %>
                <p><%=reportTitle%></p>
            <% } %>
        </div>
    </div>

    <% if (!showReport) { %>

        <form action="<%=request.getContextPath()%>/SalesReportController" method="get">
            <input type="hidden" name="action" value="generate">
            <input type="hidden" name="period" id="period" value="<%=selectedPeriod%>">

            <div class="card">
                <div class="filter-title">
                    <span class="filter-icon">▽</span>
                    <span>Select Report Period</span>
                </div>

                <div class="period-grid">
                    <div class="period-option <%=dailyActive ? "active" : ""%>"
                         id="daily-option"
                         onclick="selectPeriod('daily')">
                        <span>▣</span>
                        <span>Daily</span>
                    </div>

                    <div class="period-option <%=monthlyActive ? "active" : ""%>"
                         id="monthly-option"
                         onclick="selectPeriod('monthly')">
                        <span>▣</span>
                        <span>Monthly</span>
                    </div>

                    <div class="period-option <%=yearlyActive ? "active" : ""%>"
                         id="yearly-option"
                         onclick="selectPeriod('yearly')">
                        <span>▣</span>
                        <span>Yearly</span>
                    </div>

                    <div class="period-option <%=customActive ? "active" : ""%>"
                         id="custom-option"
                         onclick="selectPeriod('custom')">
                        <span>▽</span>
                        <span>Custom</span>
                    </div>
                </div>

                <div class="form-panel"
                     id="daily-panel"
                     style="<%=dailyActive ? "" : "display:none;"%>">
                    <div class="form-title">Select Date</div>

                    <div class="form-grid">
                        <div class="field">
                            <label>Date</label>
                            <input type="date" name="selectedDate" value="<%=today%>">
                        </div>
                    </div>
                </div>

                <div class="form-panel"
                     id="monthly-panel"
                     style="<%=monthlyActive ? "" : "display:none;"%>">
                    <div class="form-title">Select Month and Year</div>

                    <div class="form-grid">
                        <div class="field">
                            <label>Month</label>

                            <select name="selectedMonth">
                                <option value="1" <%=currentMonth == 1 ? "selected" : ""%>>January</option>
                                <option value="2" <%=currentMonth == 2 ? "selected" : ""%>>February</option>
                                <option value="3" <%=currentMonth == 3 ? "selected" : ""%>>March</option>
                                <option value="4" <%=currentMonth == 4 ? "selected" : ""%>>April</option>
                                <option value="5" <%=currentMonth == 5 ? "selected" : ""%>>May</option>
                                <option value="6" <%=currentMonth == 6 ? "selected" : ""%>>June</option>
                                <option value="7" <%=currentMonth == 7 ? "selected" : ""%>>July</option>
                                <option value="8" <%=currentMonth == 8 ? "selected" : ""%>>August</option>
                                <option value="9" <%=currentMonth == 9 ? "selected" : ""%>>September</option>
                                <option value="10" <%=currentMonth == 10 ? "selected" : ""%>>October</option>
                                <option value="11" <%=currentMonth == 11 ? "selected" : ""%>>November</option>
                                <option value="12" <%=currentMonth == 12 ? "selected" : ""%>>December</option>
                            </select>
                        </div>

                        <div class="field">
                            <label>Year</label>

                            <select name="selectedYear">
                                <% for (int y = currentYear - 5; y <= currentYear + 2; y++) { %>
                                    <option value="<%=y%>" <%=y == currentYear ? "selected" : ""%>>
                                        <%=y%>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-panel"
                     id="yearly-panel"
                     style="<%=yearlyActive ? "" : "display:none;"%>">
                    <div class="form-title">Select Year</div>

                    <div class="form-grid">
                        <div class="field">
                            <label>Year</label>

                            <select name="selectedYear">
                                <% for (int y = currentYear - 5; y <= currentYear + 2; y++) { %>
                                    <option value="<%=y%>" <%=y == currentYear ? "selected" : ""%>>
                                        <%=y%>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-panel"
                     id="custom-panel"
                     style="<%=customActive ? "" : "display:none;"%>">
                    <div class="form-title">Select Custom Date Range</div>

                    <div class="form-grid">
                        <div class="field">
                            <label>Start Date</label>
                            <input type="date" name="startDate" value="<%=today%>">
                        </div>

                        <div class="field">
                            <label>End Date</label>
                            <input type="date" name="endDate" value="<%=today%>">
                        </div>
                    </div>
                </div>
            </div>

            <div class="actions" style="margin-top: 20px;">
                <button type="submit" class="btn btn-green">Generate Report</button>
            </div>
        </form>

    <% } else { %>

        <div class="card report-card">
            <div class="table-title">
                <span class="table-icon">↗</span>
                <span>Transaction Details</span>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th><%=labelHeader%></th>
                            <th>Transactions</th>
                            <th>Revenue</th>
                            <th>Avg. Value</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% if (rows == null || rows.isEmpty()) { %>
                            <tr>
                                <td colspan="4">
                                    <div class="empty">No transactions found for this period.</div>
                                </td>
                            </tr>
                        <% } else { %>

                            <% for (TransactionRow row : rows) { %>
                                <tr>
                                    <td><%=row.getLabel()%></td>
                                    <td><%=row.getTransactions()%></td>
                                    <td>RM <%=String.format("%.2f", row.getRevenue())%></td>
                                    <td>RM <%=String.format("%.2f", row.getAverageValue())%></td>
                                </tr>
                            <% } %>

                            <tr class="total-row">
                                <td>Total</td>
                                <td><%=totalTransactions%></td>
                                <td>RM <%=String.format("%.2f", totalRevenue)%></td>
                                <td>RM <%=String.format("%.2f", averageValue)%></td>
                            </tr>

                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="actions" style="margin-top: 20px;">
            <button type="button" class="btn btn-white" onclick="window.print()">
                Download PDF
            </button>

            <button type="button"
                    class="btn btn-green"
                    onclick="window.location.href='<%=request.getContextPath()%>/SalesReportController'">
                Change Filter
            </button>
        </div>

    <% } %>

</div>

<script>
function selectPeriod(period) {
    document.getElementById("period").value = period;

    const periods = ["daily", "monthly", "yearly", "custom"];

    periods.forEach(function(item) {
        const option = document.getElementById(item + "-option");
        const panel = document.getElementById(item + "-panel");

        option.classList.remove("active");
        panel.style.display = "none";

        const fields = panel.querySelectorAll("input, select");
        fields.forEach(function(field) {
            field.disabled = true;
        });
    });

    const selectedOption = document.getElementById(period + "-option");
    const selectedPanel = document.getElementById(period + "-panel");

    selectedOption.classList.add("active");
    selectedPanel.style.display = "block";

    const selectedFields = selectedPanel.querySelectorAll("input, select");
    selectedFields.forEach(function(field) {
        field.disabled = false;
    });
}

document.addEventListener("DOMContentLoaded", function() {
    selectPeriod("<%=selectedPeriod%>");
});
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>