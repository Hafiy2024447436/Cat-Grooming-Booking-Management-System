<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="catBooking.dao.DashboardDAO" %>

<%
String userName = (String) session.getAttribute("userName");
String userRole = (String) session.getAttribute("userRole");

if (userRole == null || (!userRole.equalsIgnoreCase("staff") && !userRole.equalsIgnoreCase("owner"))) {
    response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
    return;
}

DashboardDAO.DashboardStats stats = (DashboardDAO.DashboardStats) request.getAttribute("stats");
List<DashboardDAO.RecentAppointmentRow> recentAppointments =
        (List<DashboardDAO.RecentAppointmentRow>) request.getAttribute("recentAppointments");

if (stats == null) {
    response.sendRedirect(request.getContextPath() + "/DashboardController");
    return;
}
if (recentAppointments == null) recentAppointments = new ArrayList<>();

String displayRole = userRole.substring(0, 1).toUpperCase() + userRole.substring(1).toLowerCase();
String today = new SimpleDateFormat("dd MMM yyyy").format(new java.util.Date());
boolean isOwner = userRole.equalsIgnoreCase("owner");

Object userIDObj = session.getAttribute("userID");
String userID = userIDObj != null ? String.valueOf(userIDObj) : "";
String dashboardPhotoUrl = "";
if (userID != null && !userID.trim().isEmpty()) {
    dashboardPhotoUrl = request.getContextPath() + "/StaffPhotoController?id=" + userID + "&v=" + System.currentTimeMillis();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%= displayRole %> Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

:root {
  --purple-900: #4a355b;
  --purple-800: #5c476e;
  --purple-700: #6f5288;
  --purple-600: #7a5ba6;
  --purple-500: #8b6bb5;
  --purple-200: #e6dcf0;
  --purple-100: #eee7f3;
  --purple-50: #f8f4fb;

  --blue-100: #dbeafe;
  --blue-600: #2563eb;
  --orange-100: #ffedd5;
  --orange-600: #ea580c;
  --green-100: #dcfce7;
  --green-600: #16a34a;
  --pink-100: #fce7f3;
  --pink-600: #db2777;
  --red-100: #fee2e2;
  --red-600: #dc2626;

  --page-bg: linear-gradient(160deg, #f5f3ff 0%, #fdf4ff 42%, #eff6ff 100%);
  --card-bg: #ffffff;
  --hero-bg: linear-gradient(135deg, rgba(255,255,255,0.92) 0%, rgba(249,244,255,0.95) 100%);

  --border: #e3dce9;
  --border-soft: #ebe6ef;
  --gray-50: #f8f9fb;
  --gray-100: #f2f3f5;
  --gray-200: #e5e7eb;
  --gray-300: #d1d5db;
  --gray-500: #6b7280;
  --gray-600: #4b5563;
  --gray-700: #374151;
  --gray-900: #111827;
  --white: #ffffff;
}

html,
body,
button,
input,
select,
textarea,
table {
  font-family: 'Nunito', sans-serif !important;
}

html,
body {
  width: 100%;
  min-height: 100%;
}

body {
  min-height: 100vh;
  background: var(--page-bg);
  color: var(--gray-900);
  font-size: 16px;
  font-weight: 600;
  overflow-x: hidden;
}

.dashboard-page {
  position: relative;
  width: min(100%, 1200px);
  margin: 0 auto;
  padding: 36px 24px 56px;
}

.dashboard-page::before,
.dashboard-page::after {
  content: "";
  position: absolute;
  border-radius: 999px;
  z-index: 0;
  pointer-events: none;
  filter: blur(14px);
  opacity: 0.55;
}

.dashboard-page::before {
  width: 220px;
  height: 220px;
  top: 10px;
  right: 40px;
  background: rgba(217, 193, 255, 0.26);
}

.dashboard-page::after {
  width: 180px;
  height: 180px;
  bottom: 40px;
  left: 20px;
  background: rgba(191, 219, 254, 0.24);
}

.dashboard-page > * {
  position: relative;
  z-index: 1;
}

/* Hero */
.dashboard-hero {
  position: relative;
  overflow: hidden;
  background: var(--hero-bg);
  border: 1px solid #dfd4e7;
  border-radius: 24px;
  padding: 30px 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px;
  box-shadow: 0 14px 34px rgba(74, 53, 91, 0.09);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.dashboard-hero::before,
.dashboard-hero::after {
  content: "";
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
}

.dashboard-hero::before {
  width: 210px;
  height: 210px;
  top: -100px;
  right: -55px;
  background: radial-gradient(circle, rgba(139,107,181,0.18) 0%, rgba(139,107,181,0) 72%);
}

.dashboard-hero::after {
  width: 180px;
  height: 180px;
  bottom: -100px;
  left: -65px;
  background: radial-gradient(circle, rgba(96,165,250,0.14) 0%, rgba(96,165,250,0) 72%);
}

.hero-copy {
  max-width: 780px;
}

.hero-top {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  margin-bottom: 10px;
}

.role-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(122, 91, 166, 0.12);
  color: var(--purple-900);
  border: 1px solid rgba(122, 91, 166, 0.18);
  font-size: 14px;
  font-weight: 800;
}

.role-chip .dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--purple-600);
  box-shadow: 0 0 0 4px rgba(122, 91, 166, 0.15);
}

.dashboard-hero h1 {
  font-size: 34px !important;
  font-weight: 900 !important;
  line-height: 1.15 !important;
  letter-spacing: -0.5px;
  color: var(--gray-900) !important;
}

.dashboard-hero p {
  margin-top: 8px;
  color: var(--gray-600);
  font-size: 16px !important;
  font-weight: 700 !important;
  line-height: 1.55;
  max-width: 700px;
}

.date-pill {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  min-width: 150px;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid #dcd1e5;
  color: var(--purple-900);
  padding: 12px 20px;
  border-radius: 999px;
  font-size: 16px;
  font-weight: 900;
  white-space: nowrap;
  box-shadow: 0 8px 20px rgba(74, 53, 91, 0.08);
}

.date-pill svg {
  width: 18px;
  height: 18px;
}

.hero-side {
  display: flex;
  align-items: center;
  gap: 18px;
  flex-shrink: 0;
}

.dashboard-avatar {
  position: relative;
  width: 82px;
  height: 82px;
  min-width: 82px;
  min-height: 82px;
  border-radius: 50%;
  padding: 4px;
  background: linear-gradient(135deg, #8b5fbf 0%, #c084fc 52%, #f0abfc 100%);
  box-shadow: 0 12px 26px rgba(74, 53, 91, 0.16);
}

.dashboard-avatar-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: #ffffff;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 3px solid rgba(255, 255, 255, 0.85);
}

.dashboard-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  display: block;
  border-radius: 50%;
}

.dashboard-avatar-fallback {
  width: 100%;
  height: 100%;
  color: var(--purple-700);
  background: linear-gradient(135deg, #f5f3ff 0%, #fdf4ff 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.dashboard-avatar-fallback svg {
  width: 38px;
  height: 38px;
}

/* Stats */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
  margin-bottom: 22px;
}

.stat-card {
  position: relative;
  overflow: hidden;
  background: linear-gradient(180deg, #ffffff 0%, #fcfbff 100%);
  border: 1px solid var(--border-soft);
  border-radius: 20px;
  padding: 22px;
  min-height: 132px;
  box-shadow: 0 10px 24px rgba(33, 28, 39, 0.06);
  display: grid;
  grid-template-columns: 58px minmax(0, 1fr) auto;
  grid-template-areas:
    "icon label value"
    "icon desc desc";
  column-gap: 16px;
  row-gap: 8px;
  align-items: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
}

.stat-card::before {
  content: "";
  position: absolute;
  inset: 0 auto auto 0;
  width: 100%;
  height: 4px;
  background: linear-gradient(90deg, rgba(122,91,166,0.95) 0%, rgba(217,70,239,0.55) 100%);
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 30px rgba(74, 53, 91, 0.10);
}

.stat-icon {
  grid-area: icon;
  width: 58px;
  height: 58px;
  border-radius: 18px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.6);
}

.stat-icon svg {
  width: 26px;
  height: 26px;
}

.stat-card h3 {
  grid-area: label;
  color: var(--gray-700);
  font-size: 16px !important;
  font-weight: 900 !important;
  line-height: 1.25;
}

.stat-card h2 {
  grid-area: value;
  color: var(--purple-700);
  font-size: 34px !important;
  font-weight: 900 !important;
  line-height: 1;
  text-align: right;
  letter-spacing: -0.4px;
}

.stat-card small {
  grid-area: desc;
  display: block;
  color: var(--gray-500);
  font-size: 14px !important;
  font-weight: 700 !important;
  line-height: 1.45;
}

.stat-card.appointments .stat-icon {
  background: linear-gradient(135deg, #ede9fe 0%, #f3e8ff 100%);
  color: var(--purple-700);
}

.stat-card.pending .stat-icon {
  background: linear-gradient(135deg, #ffedd5 0%, #fff7ed 100%);
  color: var(--orange-600);
}

.stat-card.cats .stat-icon {
  background: linear-gradient(135deg, #fce7f3 0%, #fdf2f8 100%);
  color: var(--pink-600);
}

.stat-card.customers .stat-icon {
  background: linear-gradient(135deg, #dbeafe 0%, #eff6ff 100%);
  color: var(--blue-600);
}

.stat-card.staff .stat-icon {
  background: linear-gradient(135deg, #dcfce7 0%, #f0fdf4 100%);
  color: var(--green-600);
}

.stat-card.revenue .stat-icon {
  background: linear-gradient(135deg, #ede9fe 0%, #faf5ff 100%);
  color: var(--purple-600);
}

/* Content layout */
.dashboard-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 22px;
  align-items: start;
}

.panel {
  min-width: 0;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid var(--border-soft);
  border-radius: 22px;
  padding: 24px;
  box-shadow: 0 10px 24px rgba(33, 28, 39, 0.06);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.section-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 14px;
  margin-bottom: 18px;
}

.panel-title {
  font-size: 26px !important;
  font-weight: 900 !important;
  line-height: 1.2 !important;
  color: var(--gray-900) !important;
}

.section-subtitle {
  margin-top: 6px;
  color: var(--gray-500);
  font-size: 14px;
  font-weight: 700;
}

.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 999px;
  background: #f6f1fb;
  border: 1px solid #e9dff3;
  color: var(--purple-700);
  font-size: 13px;
  font-weight: 800;
  white-space: nowrap;
}

/* Table */
.table-wrap {
  width: 100%;
  overflow: hidden;
  border: 1px solid var(--border);
  border-radius: 16px;
  background: var(--white);
}

table {
  width: 100%;
  table-layout: fixed;
  border-collapse: collapse;
  background: var(--white);
}

th {
  text-align: left;
  background: linear-gradient(180deg, #fbf9fd 0%, #f5f2f8 100%);
  color: var(--gray-500);
  padding: 14px 16px;
  font-size: 13px !important;
  font-weight: 900 !important;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  border-bottom: 1px solid var(--gray-200);
}

td {
  padding: 15px 16px;
  border-bottom: 1px solid #eee9f1;
  color: var(--gray-900);
  font-size: 15px !important;
  font-weight: 700 !important;
  line-height: 1.35;
  vertical-align: middle;
  overflow-wrap: anywhere;
}

th:nth-child(1),
td:nth-child(1) { width: 19%; }
th:nth-child(2),
td:nth-child(2) { width: 25%; }
th:nth-child(3),
td:nth-child(3) { width: 13%; }
th:nth-child(4),
td:nth-child(4) { width: 16%; }
th:nth-child(5),
td:nth-child(5) { width: 11%; }
th:nth-child(6),
td:nth-child(6) { width: 16%; }

td:first-child {
  font-size: 15px !important;
  font-weight: 900 !important;
  white-space: nowrap;
  color: #1f2937;
}

td:nth-child(4),
td:nth-child(5),
td:nth-child(6) {
  white-space: nowrap;
}

tbody tr {
  transition: background 0.15s ease, transform 0.15s ease;
}

tbody tr:hover {
  background: #fcfaff;
}

tr:last-child td {
  border-bottom: none;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 110px;
  padding: 8px 14px;
  border-radius: 999px;
  font-size: 13px !important;
  font-weight: 900 !important;
  line-height: 1.15;
  white-space: nowrap;
}

.status-badge.pending {
  background: #fef3c7;
  color: #a85408;
}

.status-badge.confirmed {
  background: #dbeafe;
  color: #2563eb;
}

.status-badge.completed {
  background: #dcfce7;
  color: #15803d;
}

.status-badge.cancelled {
  background: #fee2e2;
  color: #dc2626;
}

.status-badge.other {
  background: var(--purple-100);
  color: var(--purple-700);
}

.empty {
  text-align: center;
  color: var(--gray-500);
  padding: 32px !important;
  font-weight: 800 !important;
}

/* Insights */
.insight-stack {
  display: grid;
  gap: 18px;
}

@media (min-width: 980px) {
  .dashboard-content > aside.panel {
    display: block;
  }

  .dashboard-content > aside.panel .insight-stack {
    grid-template-columns: 1fr 1fr;
    align-items: start;
  }
}

/* owner-insight-grid-fix */


.insight-card {
  background: linear-gradient(180deg, #faf7fd 0%, #f6f1fb 100%);
  border: 1px solid #e5dbef;
  border-left: 5px solid var(--purple-600);
  border-radius: 18px;
  padding: 18px 20px;
  color: #44364f;
  font-size: 15px !important;
  font-weight: 700 !important;
  line-height: 1.7;
}

.insight-card b {
  color: var(--purple-900);
  font-weight: 900;
}

.bar-list {
  display: grid;
  gap: 13px;
}

.bar-row {
  background: #fcfbff;
  border: 1px solid #eee7f6;
  border-radius: 14px;
  padding: 12px 14px;
  display: grid;
  gap: 8px;
}

.bar-label {
  display: flex;
  justify-content: space-between;
  gap: 14px;
  color: var(--gray-700);
  font-size: 14px;
  font-weight: 800;
}

.bar-bg {
  height: 10px;
  background: #ece5f4;
  border-radius: 999px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--purple-600) 0%, #a855f7 100%);
  border-radius: 999px;
}

.task-list {
  display: grid;
  gap: 14px;
}

.task {
  background: linear-gradient(180deg, #ffffff 0%, #faf7fd 100%);
  border: 1px solid #eadff2;
  border-radius: 18px;
  padding: 17px 18px;
  display: grid;
  grid-template-columns: 44px 1fr;
  gap: 14px;
  align-items: start;
  box-shadow: 0 6px 18px rgba(74, 53, 91, 0.05);
}

.task-icon {
  width: 44px;
  height: 44px;
  border-radius: 14px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ede9fe 0%, #f3e8ff 100%);
  color: var(--purple-700);
}

.task-icon svg {
  width: 20px;
  height: 20px;
}

.task b {
  display: block;
  color: var(--gray-900);
  font-size: 16px;
  font-weight: 900;
  margin-bottom: 4px;
}

.task p {
  color: var(--gray-500);
  font-size: 14px;
  font-weight: 700;
  line-height: 1.5;
}

.quick-note {
  padding: 12px 14px;
  border-radius: 14px;
  background: #fff9ed;
  border: 1px solid #fde3b0;
  color: #9a5c00;
  font-size: 13px;
  font-weight: 800;
  margin-top: 2px;
}

/* Responsive */
@media (max-width: 1024px) {
  .dashboard-content {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 860px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }

  .dashboard-hero {
    flex-direction: column;
    align-items: flex-start;
  }

  .hero-side {
    width: 100%;
    justify-content: space-between;
  }

  .date-pill {
    width: 100%;
  }

  .table-wrap {
    overflow-x: auto;
  }

  table {
    min-width: 760px;
    table-layout: auto;
  }

  th,
  td {
    white-space: nowrap;
  }
}

@media (max-width: 640px) {
  .dashboard-page {
    padding: 28px 16px 46px;
  }

  .dashboard-hero,
  .panel {
    padding: 20px;
  }

  .dashboard-hero h1 {
    font-size: 28px !important;
  }

  .hero-top {
    margin-bottom: 8px;
  }

  .stat-card {
    grid-template-columns: 52px minmax(0, 1fr);
    grid-template-areas:
      "icon label"
      "icon desc"
      "value value";
    row-gap: 10px;
  }

  .stat-card h2 {
    text-align: left;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
  }
}

/* ===== FINAL FORCE FIX: dashboard appointment full width ===== */
.dashboard-content {
  display: flex !important;
  flex-direction: column !important;
  grid-template-columns: none !important;
  width: 100% !important;
  gap: 22px !important;
}

.dashboard-content > .panel,
.dashboard-content > aside.panel {
  width: 100% !important;
  max-width: 100% !important;
  grid-column: 1 / -1 !important;
}

.dashboard-content > aside.panel {
  margin-top: 0 !important;
}

.dashboard-content > aside.panel .insight-stack {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  gap: 18px !important;
}

.table-wrap {
  width: 100% !important;
  overflow-x: auto !important;
  overflow-y: hidden !important;
}

.table-wrap table {
  width: 100% !important;
  min-width: 1020px !important;
  table-layout: fixed !important;
}

.table-wrap th,
.table-wrap td {
  box-sizing: border-box !important;
  vertical-align: middle !important;
}

.table-wrap th:nth-child(1),
.table-wrap td:nth-child(1) {
  width: 19% !important;
  white-space: nowrap !important;
}

.table-wrap th:nth-child(2),
.table-wrap td:nth-child(2) {
  width: 26% !important;
  white-space: normal !important;
  word-break: normal !important;
  overflow-wrap: break-word !important;
  line-height: 1.35 !important;
}

.table-wrap th:nth-child(3),
.table-wrap td:nth-child(3) {
  width: 13% !important;
  white-space: nowrap !important;
}

.table-wrap th:nth-child(4),
.table-wrap td:nth-child(4) {
  width: 16% !important;
  white-space: nowrap !important;
}

.table-wrap th:nth-child(5),
.table-wrap td:nth-child(5) {
  width: 10% !important;
  white-space: nowrap !important;
}

.table-wrap th:nth-child(6),
.table-wrap td:nth-child(6) {
  width: 16% !important;
  white-space: nowrap !important;
  overflow: visible !important;
}

.status-badge {
  min-width: 112px !important;
}

@media (max-width: 980px) {
  .dashboard-content > aside.panel .insight-stack {
    grid-template-columns: 1fr !important;
  }
}

</style>
</head>
<body>

<div class="dashboard-page">

    <section class="dashboard-hero">
        <div class="hero-copy">
            <div class="hero-top">
                <span class="role-chip"><span class="dot"></span><%= displayRole %> Workspace</span>
            </div>
            <h1>Welcome back, <%= userName != null ? userName : displayRole %></h1>
            <p>Here is your dashboard overview for today. Monitor appointments, check important updates, and keep track of daily grooming activities more easily.</p>
        </div>
        <div class="hero-side">
            <div class="dashboard-avatar" aria-label="Account photo">
                <div class="dashboard-avatar-inner">
                    <% if (dashboardPhotoUrl != null && !dashboardPhotoUrl.trim().isEmpty()) { %>
                        <img id="dashboardAccountPhoto"
                             src="<%= dashboardPhotoUrl %>"
                             alt="Account photo"
                             onerror="this.style.display='none'; document.getElementById('dashboardAvatarFallback').style.display='flex';"
                             onload="this.style.display='block'; document.getElementById('dashboardAvatarFallback').style.display='none';">
                    <% } %>
                    <span id="dashboardAvatarFallback" class="dashboard-avatar-fallback"<%= (dashboardPhotoUrl != null && !dashboardPhotoUrl.trim().isEmpty()) ? " style=\"display:none;\"" : "" %>>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="8" r="4"></circle>
                            <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"></path>
                        </svg>
                    </span>
                </div>
            </div>

            <div class="date-pill">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="3"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <%= today %>
            </div>
        </div>
    </section>

    <section class="stats-grid">
        <div class="stat-card appointments">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="3"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
            </span>
            <h3>Today's Appointments</h3>
            <h2><%= stats.todayAppointments %></h2>
            <small>Appointments scheduled for today</small>
        </div>

        <div class="stat-card pending">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 16 14"></polyline>
                </svg>
            </span>
            <h3>Pending Bookings</h3>
            <h2><%= stats.pendingBookings %></h2>
            <small>Bookings waiting for confirmation</small>
        </div>

        <div class="stat-card cats">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 5c-3.8 0-7 3-7 6.8 0 4.5 3.1 7.2 7 7.2s7-2.7 7-7.2C19 8 15.8 5 12 5z"></path>
                    <path d="M8.5 6.4 7 3.8 5.2 6.7"></path>
                    <path d="M15.5 6.4 17 3.8l1.8 2.9"></path>
                    <circle cx="9.5" cy="12" r=".8" fill="currentColor" stroke="none"></circle>
                    <circle cx="14.5" cy="12" r=".8" fill="currentColor" stroke="none"></circle>
                    <path d="M10 15c.8.7 3.2.7 4 0"></path>
                </svg>
            </span>
            <h3>Total Cats</h3>
            <h2><%= stats.totalCats %></h2>
            <small>Registered cats in the system</small>
        </div>

        <% if (isOwner) { %>
        <div class="stat-card customers">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </span>
            <h3>Total Customers</h3>
            <h2><%= stats.totalCustomers %></h2>
            <small>Registered customer accounts</small>
        </div>

        <div class="stat-card staff">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </span>
            <h3>Total Staff</h3>
            <h2><%= stats.totalStaff %></h2>
            <small>Active staff accounts</small>
        </div>

        <div class="stat-card revenue">
            <span class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="1" x2="12" y2="23"></line>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7H14.5a3.5 3.5 0 0 1 0 7H6"></path>
                </svg>
            </span>
            <h3>Monthly Revenue</h3>
            <h2>RM <%= String.format("%.2f", stats.monthRevenue) %></h2>
            <small>Completed appointments this month</small>
        </div>
        <% } %>
    </section>

    <section class="dashboard-content">
        <div class="panel">
            <div class="section-header">
                <div>
                    <h2 class="panel-title">Recent Appointments</h2>
                    <div class="section-subtitle">Latest bookings and grooming activity overview</div>
                </div>
                <span class="section-tag"><%= recentAppointments.size() %> record<%= recentAppointments.size() == 1 ? "" : "s" %></span>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Customer</th>
                            <th>Cat</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (recentAppointments.isEmpty()) { %>
                        <tr><td colspan="6" class="empty">No recent appointments found.</td></tr>
                    <% } else { %>
                        <% for (DashboardDAO.RecentAppointmentRow row : recentAppointments) {
                            String statusClass = "other";
                            if (row.appointmentStatus != null) {
                                if (row.appointmentStatus.equalsIgnoreCase("Pending")) statusClass = "pending";
                                else if (row.appointmentStatus.equalsIgnoreCase("Confirmed")) statusClass = "confirmed";
                                else if (row.appointmentStatus.equalsIgnoreCase("Completed")) statusClass = "completed";
                                else if (row.appointmentStatus.equalsIgnoreCase("Cancelled")) statusClass = "cancelled";
                            }
                        %>
                        <tr>
                            <td><%= row.appointmentNo %></td>
                            <td><%= row.custFullName %></td>
                            <td><%= row.catName %></td>
                            <td><%= row.appointmentDate %></td>
                            <td><%= row.appointmentTime %></td>
                            <td><span class="status-badge <%= statusClass %>"><%= row.appointmentStatus %></span></td>
                        </tr>
                        <% } %>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <aside class="panel">
            <% if (isOwner) { %>
                <div class="section-header">
                    <div>
                        <h2 class="panel-title">Business Insight</h2>
                        <div class="section-subtitle">Quick summary and weekly revenue performance</div>
                    </div>
                    <span class="section-tag">Owner view</span>
                </div>

                <div class="insight-stack">
                    <div class="insight-card">
                        This month revenue is <b>RM <%= String.format("%.2f", stats.monthRevenue) %></b>.
                        There are <b><%= stats.pendingBookings %></b> pending bookings,
                        <b><%= stats.totalCustomers %></b> customers, and
                        <b><%= stats.totalStaff %></b> staff members registered.
                    </div>

                    <div>
                        <div class="section-subtitle" style="margin-bottom: 12px;">Last 7 Days Revenue</div>
                        <div class="bar-list">
                        <%
                        if (stats.last7Days != null && !stats.last7Days.isEmpty()) {
                            double max = 1;
                            for (DashboardDAO.DayRevenue d : stats.last7Days) {
                                if (d.amount > max) max = d.amount;
                            }
                            for (DashboardDAO.DayRevenue d : stats.last7Days) {
                                int percent = (int)((d.amount / max) * 100);
                        %>
                            <div class="bar-row">
                                <div class="bar-label">
                                    <span><%= d.label %></span>
                                    <span>RM <%= String.format("%.2f", d.amount) %></span>
                                </div>
                                <div class="bar-bg">
                                    <div class="bar-fill" style="width:<%= percent %>%"></div>
                                </div>
                            </div>
                        <%
                            }
                        } else {
                        %>
                            <div class="empty">No revenue data found.</div>
                        <%
                        }
                        %>
                        </div>
                    </div>
                </div>
            <% } else { %>
                <div class="section-header">
                    <div>
                        <h2 class="panel-title">Today’s Work Summary</h2>
                        <div class="section-subtitle">Important reminders and quick daily overview for staff</div>
                    </div>
                    <span class="section-tag">Staff view</span>
                </div>

                <div class="task-list">
                    <div class="task">
                        <span class="task-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="3"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </span>
                        <div>
                            <b>Appointments Today</b>
                            <p>You have <%= stats.todayAppointments %> grooming appointments scheduled today.</p>
                        </div>
                    </div>
                    <div class="task">
                        <span class="task-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </span>
                        <div>
                            <b>Pending Bookings</b>
                            <p>There are <%= stats.pendingBookings %> bookings waiting to be checked or confirmed.</p>
                        </div>
                    </div>
                    <div class="task">
                        <span class="task-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 20h9"></path>
                                <path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"></path>
                            </svg>
                        </span>
                        <div>
                            <b>Daily Reminder</b>
                            <p>Update appointment status after each grooming session is completed.</p>
                        </div>
                    </div>
                </div>

                <div class="quick-note">Tip: Keep appointment status updated so the dashboard and reports always stay accurate.</div>
            <% } %>
        </aside>
    </section>

</div>

<%@ include file="/notification.jsp" %>
</body>
</html>
