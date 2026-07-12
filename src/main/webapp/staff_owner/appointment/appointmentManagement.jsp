<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.dao.StaffAppointmentDAO.AppointmentRow"%>

<%!
private String js(String value) {
    if (value == null) return "";
    return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("'", "\\'")
                .replace("\r", "")
                .replace("\n", "\\n")
                .replace("</", "<\\/");
}

private String statusLower(String status) {
    if (status == null) return "pending";
    return status.trim().toLowerCase();
}

private String statusLabel(String status) {
    if (status == null) return "Pending";

    String s = status.trim().toLowerCase();

    if ("confirmed".equals(s)) return "Confirmed";
    if ("completed".equals(s)) return "Completed";
    if ("cancelled".equals(s)) return "Cancelled";

    return "Pending";
}

private String weightDisplay(Double weight) {
    if (weight == null || weight <= 0) {
        return "Not recorded yet";
    }
    return String.format("%.2f kg", weight);
}

private String weightValue(Double weight) {
    if (weight == null || weight <= 0) {
        return "";
    }
    return String.format("%.2f", weight);
}
%>

<%
List<AppointmentRow> appointments =
        (List<AppointmentRow>) request.getAttribute("appointments");

if (appointments == null) {
    appointments = new java.util.ArrayList<>();
}

int pendingCount = 0;
int confirmedCount = 0;
int completedCount = 0;
int cancelledCount = 0;
int totalCount = appointments.size();

for (AppointmentRow row : appointments) {
    String s = statusLower(row.appointmentStatus);

    if ("pending".equals(s)) {
        pendingCount++;
    } else if ("confirmed".equals(s)) {
        confirmedCount++;
    } else if ("completed".equals(s)) {
        completedCount++;
    } else if ("cancelled".equals(s)) {
        cancelledCount++;
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Appointment Management</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap"
      rel="stylesheet">

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Nunito', sans-serif;
    background: linear-gradient(
        160deg,
        #f5f3ff 0%,
        #fdf4ff 42%,
        #eff6ff 100%
    );
    color: #111827;
    min-height: 100vh;
}

.page-wrapper {
    padding: 34px 24px 46px;
}

.page-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 24px;
}

.header-icon {
    width: 58px;
    height: 58px;
    border-radius: 16px;
    background: linear-gradient(135deg, #8b5cf6, #ec4899);
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
}

.header-icon svg {
    width: 28px;
    height: 28px;
}

.page-title {
    font-size: 26px;
    font-weight: 900;
    color: #111827;
}

.page-subtitle {
    margin-top: 3px;
    color: #6b7280;
    font-size: 15px;
    font-weight: 600;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(5, minmax(145px, 1fr));
    gap: 14px;
    margin-bottom: 24px;
}

.stat-card {
    border-radius: 14px;
    padding: 17px 18px;
    border: 2px solid;
    font-family: inherit;
    text-align: left;
    cursor: pointer;
    transition: transform 0.15s ease, box-shadow 0.15s ease;
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 96px;
}

.stat-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
}

.stat-card.active-filter {
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.14), 0 8px 20px rgba(15, 23, 42, 0.08);
}

.stat-label {
    font-size: 13px;
    font-weight: 800;
    margin-bottom: 8px;
}

.stat-value {
    font-size: 31px;
    font-weight: 900;
}

.stat-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.stat-icon svg {
    width: 26px;
    height: 26px;
}

.stat-card.all {
    background: #f5f3ff;
    border-color: #c4b5fd;
}

.stat-card.all .stat-label,
.stat-card.all .stat-value {
    color: #6d28d9;
}

.stat-card.all .stat-icon {
    background: #ede9fe;
    color: #7c3aed;
}


.stat-card.pending {
    background: #fff7ed;
    border-color: #fb923c;
}

.stat-card.pending .stat-label,
.stat-card.pending .stat-value {
    color: #c2410c;
}

.stat-card.pending .stat-icon {
    background: #ffedd5;
    color: #ea580c;
}

.stat-card.confirmed {
    background: #eff6ff;
    border-color: #93c5fd;
}

.stat-card.confirmed .stat-label,
.stat-card.confirmed .stat-value {
    color: #1d4ed8;
}

.stat-card.confirmed .stat-icon {
    background: #bfdbfe;
    color: #2563eb;
}

.stat-card.completed {
    background: #ecfdf5;
    border-color: #86efac;
}

.stat-card.completed .stat-label,
.stat-card.completed .stat-value {
    color: #047857;
}

.stat-card.completed .stat-icon {
    background: #bbf7d0;
    color: #15803d;
}

.stat-card.cancelled {
    background: #fef2f2;
    border-color: #fca5a5;
}

.stat-card.cancelled .stat-label,
.stat-card.cancelled .stat-value {
    color: #dc2626;
}

.stat-card.cancelled .stat-icon {
    background: #fecaca;
    color: #dc2626;
}


.card {
    background: #ffffff;
    border-radius: 18px;
    padding: 24px;
    box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
}

.card-title {
    font-size: 22px;
    font-weight: 900;
    color: #111827;
    margin-bottom: 24px;
}

.apt-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.apt-item {
    border: 1.5px solid #e5e7eb;
    border-radius: 14px;
    padding: 16px 18px;
    display: grid;
    grid-template-columns: 1fr auto auto;
    align-items: center;
    gap: 18px;
    background: #ffffff;
}

.apt-item:hover {
    border-color: #c4b5fd;
    box-shadow: 0 8px 20px rgba(124, 58, 237, 0.08);
}

.left {
    display: flex;
    align-items: center;
    gap: 14px;
}

.status-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.status-icon svg {
    width: 25px;
    height: 25px;
}

.status-icon.pending {
    background: #ffedd5;
    color: #ea580c;
}

.status-icon.confirmed {
    background: #dbeafe;
    color: #2563eb;
}

.status-icon.completed {
    background: #dcfce7;
    color: #16a34a;
}

.status-icon.cancelled {
    background: #fee2e2;
    color: #dc2626;
}

.apt-info h4 {
    font-size: 18px;
    font-weight: 900;
    color: #111827;
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 13px;
    font-weight: 900;
}

.badge svg {
    width: 14px;
    height: 14px;
}

.badge.pending {
    background: #ffedd5;
    color: #c2410c;
}

.badge.confirmed {
    background: #dbeafe;
    color: #1d4ed8;
}

.badge.completed {
    background: #dcfce7;
    color: #166534;
}

.badge.cancelled {
    background: #fee2e2;
    color: #dc2626;
}

.meta {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 8px;
    color: #6b7280;
    font-size: 14px;
    font-weight: 700;
}

.meta svg {
    width: 17px;
    height: 17px;
    color: #6b7280;
}

.sep {
    width: 1px;
    height: 16px;
    background: #d1d5db;
}

.weight-meta {
    color: #374151;
}

.weight-meta.missing {
    color: #9ca3af;
}

.apt-amount {
    font-size: 21px;
    font-weight: 900;
    color: #7c3aed;
    white-space: nowrap;
}

.apt-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.apt-actions button {
    border: none;
    border-radius: 10px;
    cursor: pointer;
    font-family: inherit;
    font-weight: 900;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    transition: 0.15s ease;
}

.apt-actions svg {
    width: 18px;
    height: 18px;
    fill: none;
    stroke: currentColor;
}

.act-btn {
    width: 34px;
    height: 34px;
    padding: 0;
    border-radius: 8px;
    border: none !important;
    background: transparent;
}

.act-btn svg {
    width: 21px;
    height: 21px;
    stroke-width: 2.3;
}

.act-btn.view {
    color: #3b82f6;
}

.act-btn.view:hover {
    background: #dbeafe;
}

.act-btn.edit {
    color: #9333ea;
}

.act-btn.edit:hover {
    background: #f3e8ff;
}

.act-btn.edit.disabled-edit {
    opacity: 0.55;
    cursor: not-allowed;
    background: transparent !important;
    color: #9ca3af !important;
}

.act-btn.del {
    color: #ef4444;
    border: none !important;
    outline: none !important;
    box-shadow: none !important;
}

.act-btn.del:hover {
    background: #fee2e2;
}

.status-form {
    display: inline-flex;
    align-items: center;
}

.status-select {
    min-width: 116px;
    height: 34px;
    border: 1.5px solid #d1d5db;
    border-radius: 10px;
    background: #ffffff;
    color: #374151;
    padding: 0 30px 0 11px;
    font-family: 'Nunito', sans-serif;
    font-size: 13px;
    font-weight: 900;
    cursor: pointer;
    outline: none;
}

.status-select:focus {
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.12);
}

.status-select.pending {
    background: #fff7ed;
    border-color: #fb923c;
    color: #c2410c;
}

.status-select.confirmed {
    background: #eff6ff;
    border-color: #93c5fd;
    color: #1d4ed8;
}

.status-select.completed {
    background: #ecfdf5;
    border-color: #86efac;
    color: #166534;
}

.status-select.cancelled,
.status-select:disabled {
    background: #f3f4f6;
    border-color: #d1d5db;
    color: #9ca3af;
    cursor: not-allowed;
}

.empty-box {
    color: #6b7280;
    font-weight: 800;
    text-align: center;
    padding: 40px;
    background: #f9fafb;
    border-radius: 14px;
}

.alert {
    margin-bottom: 18px;
    padding: 14px 18px;
    border-radius: 12px;
    font-weight: 900;
}

.alert.success {
    background: #dcfce7;
    color: #166534;
}

.alert.error {
    background: #fee2e2;
    color: #991b1b;
}

.delete-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.52);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 999;
    padding: 20px;
}

.delete-overlay.open {
    display: flex;
}

.delete-modal {
    width: 500px;
    max-width: 92%;
    background: #ffffff;
    border-radius: 14px;
    padding: 26px 28px;
    box-shadow: 0 22px 54px rgba(0, 0, 0, 0.22);
}

.delete-header {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
}

.delete-icon {
    width: 54px;
    height: 54px;
    background: #fee2e2;
    color: #ef4444;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.delete-icon svg {
    width: 27px;
    height: 27px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

.delete-modal h3 {
    font-size: 21px;
    font-weight: 900;
    color: #111827;
    margin: 0;
    line-height: 1.2;
}

.delete-modal p {
    color: #6b7280;
    font-size: 16px;
    font-weight: 600;
    line-height: 1.5;
    margin: 0;
}

.delete-modal p strong {
    color: #4b5563;
    font-weight: 800;
}

.delete-actions {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
    margin-top: 24px;
}

.delete-actions button {
    height: 44px;
    border-radius: 9px;
    font-family: inherit;
    font-size: 15px;
    font-weight: 900;
    cursor: pointer;
    transition: background 0.18s, border-color 0.18s;
}

.btn-cancel {
    background: #ffffff;
    color: #374151;
    border: 1px solid #cbd5e1;
}

.btn-cancel:hover {
    background: #f9fafb;
}

.btn-confirm-delete {
    background: #ef4444;
    color: #ffffff;
    border: 1px solid #ef4444;
}

.btn-confirm-delete:hover {
    background: #dc2626;
    border-color: #dc2626;
}

.complete-overlay {
    position: fixed;
    inset: 0;
    background: rgba(17, 24, 39, 0.6);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.complete-overlay.open {
    display: flex;
}

.complete-modal {
    background: #ffffff;
    width: 460px;
    max-width: 92%;
    border-radius: 20px;
    padding: 28px;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25);
}

.complete-modal h3 {
    font-size: 24px;
    font-weight: 900;
    margin-bottom: 8px;
    color: #111827;
}

.complete-modal p {
    color: #6b7280;
    font-weight: 700;
    line-height: 1.5;
    margin-bottom: 18px;
}

.complete-info-box {
    background: #f5f3ff;
    border: 1.5px solid #ddd6fe;
    border-radius: 12px;
    padding: 14px;
    margin-bottom: 18px;
    font-weight: 900;
    color: #4c1d95;
}

.complete-field {
    margin-bottom: 18px;
}

.complete-field label {
    display: block;
    font-size: 14px;
    font-weight: 900;
    color: #374151;
    margin-bottom: 8px;
}

.complete-field input {
    width: 100%;
    border: 1.5px solid #d1d5db;
    border-radius: 12px;
    padding: 13px 14px;
    font-family: 'Nunito', sans-serif;
    font-size: 15px;
    font-weight: 800;
    outline: none;
}

.complete-field input:focus {
    border-color: #7c3aed;
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.12);
}

.complete-actions {
    display: flex;
    gap: 12px;
}

.complete-actions button {
    flex: 1;
    border: none;
    border-radius: 12px;
    padding: 13px;
    font-family: inherit;
    font-weight: 900;
    cursor: pointer;
}

.complete-actions .btn-cancel {
    background: #b9bfc4;
    color: #ffffff;
}

.complete-actions .btn-cancel:hover {
    background: #a8aeb3;
}

.btn-save-complete {
    background: #5cb85c;
    color: #ffffff;
}

.btn-save-complete:hover {
    background: #16a34a;
}

@media (max-width: 1200px) {
    .stats-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (max-width: 850px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .apt-item {
        grid-template-columns: 1fr;
    }

    .apt-amount {
        justify-self: flex-start;
    }

    .apt-actions {
        flex-wrap: wrap;
    }
}

@media (max-width: 560px) {
    .stats-grid {
        grid-template-columns: 1fr;
    }
}



/* Match ownerManagement.jsp font style */
body,
button,
input,
select,
textarea {
    font-family: 'Nunito', sans-serif !important;
}

.page-title {
    font-size: 24px !important;
    font-weight: 800 !important;
    letter-spacing: 0 !important;
}

.page-subtitle {
    font-size: 14px !important;
    font-weight: 600 !important;
}

.stat-label,
.filter-title,
.apt-card-title,
.apt-meta,
.apt-customer,
.apt-info,
.status-select,
.act-btn,
.delete-modal,
.complete-modal {
    font-family: 'Nunito', sans-serif !important;
}

.stat-label,
.apt-meta,
.apt-sub,
.apt-small,
.apt-info .meta {
    font-weight: 600 !important;
}

.stat-number,
.stat-count,
.apt-no,
.appointment-no,
.section-title,
.card-title {
    font-weight: 800 !important;
}

.status-badge,
.badge,
.status-select,
.act-btn {
    font-weight: 700 !important;
}

.all-appointments-title,
.list-title,
.appointments-title {
    font-weight: 800 !important;
}



/* ===== UI alignment: match customer appointment card style ===== */
body{background:linear-gradient(160deg,#f5f3ff 0%,#fdf4ff 42%,#eff6ff 100%)!important;color:#1f1b2d!important;font-family:'Nunito',sans-serif!important}.page-wrapper{max-width:1080px;margin:0 auto;padding:32px 16px 64px!important}.page-header{background:#fff;border-radius:18px;padding:26px 30px;box-shadow:0 4px 16px rgba(0,0,0,.08);margin-bottom:24px;border:1px solid #eee7f7}.header-icon{display:none!important}.page-title{font-size:2rem!important;font-weight:900!important;line-height:1.15!important;color:#1f1b2d!important;letter-spacing:-.35px}.page-subtitle{font-size:1rem!important;font-weight:600!important;color:#6b7280!important;margin-top:6px!important}.stat-card{border-radius:18px!important;border:1px solid #eee7f7!important;box-shadow:0 4px 16px rgba(0,0,0,.06)!important;background:#fff!important}.list-card{border-radius:18px!important;box-shadow:0 4px 16px rgba(0,0,0,.08)!important;border:1px solid #eee7f7!important}.card-title{font-size:1.5rem!important;font-weight:900!important;color:#1f1b2d!important}.apt-item{background:#fff!important;border-radius:14px!important;padding:22px 26px!important;box-shadow:0 2px 12px rgba(0,0,0,.05)!important;border:1px solid #f0edf8!important;align-items:center!important}.apt-item:hover{box-shadow:0 8px 24px rgba(124,58,237,.12)!important;transform:translateY(-2px)}.apt-info h4{font-size:1.05rem!important;font-weight:700!important;letter-spacing:0!important;color:#111827!important}.badge{gap:5px!important;padding:3px 10px!important;border-radius:999px!important;font-size:.78rem!important;font-weight:700!important;letter-spacing:0!important;text-transform:none!important}.badge svg,.status-icon{display:none!important}.meta{font-size:.86rem!important;font-weight:600!important;color:#6b7280!important;gap:12px!important}.apt-amount{font-size:1.08rem!important;font-weight:700!important;color:#1f1b2d!important}.status-select{font-weight:800!important;border-radius:999px!important}.act-btn{border-radius:10px!important}.act-btn.view{background:#dbeafe!important;color:#2563eb!important}.act-btn.edit{background:#f3e8ff!important;color:#7c3aed!important}.act-btn.del{background:#fee2e2!important;color:#ef4444!important}


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



/* ===== FINAL ALIGNMENT: title, id and status colors ===== */
.page-title {
  font-size: 2rem !important;
  font-weight: 800 !important;
  line-height: 1.2 !important;
  letter-spacing: -0.25px !important;
}
.page-subtitle {
  font-size: 1rem !important;
  font-weight: 600 !important;
}
.card-title {
  font-size: 1.5rem !important;
  font-weight: 800 !important;
}
.apt-info h4,
.apt-no,
.appointment-no {
  font-size: 1.125rem !important;
  font-weight: 700 !important;
}
.badge svg,
.status-icon {
  display: none !important;
}
.badge.pending { background: #ffedd5 !important; color: #c2410c !important; }
.badge.confirmed { background: #dbeafe !important; color: #1d4ed8 !important; }
.badge.completed { background: #dcfce7 !important; color: #166534 !important; }
.badge.cancelled { background: #fee2e2 !important; color: #dc2626 !important; }
.status-select.pending { background: #ffedd5 !important; color: #c2410c !important; }
.status-select.confirmed { background: #dbeafe !important; color: #1d4ed8 !important; }
.status-select.completed { background: #dcfce7 !important; color: #166534 !important; }
.status-select.cancelled,
.status-select:disabled { background: #fee2e2 !important; color: #dc2626 !important; }



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



/* ===== FINAL APPOINTMENT MANAGEMENT POLISH ===== */
.page-title {
  font-size: 1.875rem !important;
  font-weight: 800 !important;
}

.apt-actions {
  gap: 8px !important;
  align-items: center !important;
}

.apt-actions .act-btn {
  width: 38px !important;
  height: 38px !important;
  padding: 0 !important;
  border: none !important;
  border-radius: 10px !important;
  background: transparent !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  transition: background 0.15s ease, transform 0.15s ease !important;
}

.apt-actions .act-btn svg {
  width: 21px !important;
  height: 21px !important;
  fill: none !important;
  stroke: currentColor !important;
}

.apt-actions .act-btn.view { color: #2563eb !important; }
.apt-actions .act-btn.view:hover { background: #eff6ff !important; transform: translateY(-1px); }
.apt-actions .act-btn.edit { color: #7c3aed !important; }
.apt-actions .act-btn.edit:hover { background: #ede9fe !important; transform: translateY(-1px); }
.apt-actions .act-btn.del { color: #ef4444 !important; }
.apt-actions .act-btn.del:hover { background: #fef2f2 !important; transform: translateY(-1px); }
.apt-actions .act-btn.edit.disabled-edit {
  color: #c4b5fd !important;
  cursor: not-allowed !important;
  opacity: 0.65 !important;
}

.badge svg,
.status-icon {
  display: none !important;
}

.badge.pending { background: #ffedd5 !important; color: #c2410c !important; }
.badge.confirmed { background: #dbeafe !important; color: #1d4ed8 !important; }
.badge.completed { background: #dcfce7 !important; color: #166534 !important; }
.badge.cancelled { background: #fee2e2 !important; color: #dc2626 !important; }


/* Completed status stays green */
.stat-card.completed {
    background: #ecfdf5 !important;
    border-color: #86efac !important;
}

.status-select.completed,
.status-select.completed:disabled {
    background: #dcfce7 !important;
    color: #166534 !important;
    border-color: #bbf7d0 !important;
    opacity: 1 !important;
}

/* Keep all appointment status dropdowns the same width */
.status-select {
    width: 150px !important;
    min-width: 150px !important;
    box-sizing: border-box !important;
    text-align: left !important;
    text-align-last: left !important;
}

</style>
</head>

<body>

<div class="page-wrapper">

    <div class="page-header">
        <div class="header-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="3" y="4" width="18" height="18" rx="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
        </div>

        <div>
            <div class="page-title">Appointment Management</div>
            <div class="page-subtitle">View and manage all customer appointments</div>
        </div>
    </div>

    <div class="stats-grid">
        <button type="button" class="stat-card all active-filter" data-filter-card="all" onclick="setFilter('all')">
            <div>
                <div class="stat-label">All</div>
                <div class="stat-value"><%=totalCount%></div>
            </div>
            <div class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                    <path d="M7 8h10"></path>
                    <path d="M7 12h10"></path>
                    <path d="M7 16h6"></path>
                </svg>
            </div>
        </button>

        <button type="button" class="stat-card pending" data-filter-card="pending" onclick="setFilter('pending')">
            <div>
                <div class="stat-label">Pending</div>
                <div class="stat-value"><%=pendingCount%></div>
            </div>
            <div class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="7.5" x2="12" y2="12.5"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
            </div>
        </button>

        <button type="button" class="stat-card confirmed" data-filter-card="confirmed" onclick="setFilter('confirmed')">
            <div>
                <div class="stat-label">Confirmed</div>
                <div class="stat-value"><%=confirmedCount%></div>
            </div>
            <div class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
            </div>
        </button>

        <button type="button" class="stat-card completed" data-filter-card="completed" onclick="setFilter('completed')">
            <div>
                <div class="stat-label">Completed</div>
                <div class="stat-value"><%=completedCount%></div>
            </div>
            <div class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
            </div>
        </button>

        <button type="button" class="stat-card cancelled" data-filter-card="cancelled" onclick="setFilter('cancelled')">
            <div>
                <div class="stat-label">Cancelled</div>
                <div class="stat-value"><%=cancelledCount%></div>
            </div>
            <div class="stat-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
            </div>
        </button>
    </div>

    <div class="card">
        <div class="card-title" id="cardTitle">All Appointments</div>

        <% if ("editLocked".equals(request.getParameter("error"))) { %>
            <div class="alert error">Only pending appointments can be edited.</div>
        <% } else if ("statusLocked".equals(request.getParameter("error"))) { %>
            <div class="alert error">Completed and cancelled appointment statuses cannot be changed.</div>
        <% } else if ("invalidStatus".equals(request.getParameter("error"))) { %>
            <div class="alert error">This status change is not allowed.</div>
        <% } else if ("weightRequired".equals(request.getParameter("error"))) { %>
            <div class="alert error">Please enter the current cat weight before completing this appointment.</div>
        <% } else if ("invalidWeight".equals(request.getParameter("error"))) { %>
            <div class="alert error">Please enter a valid current cat weight.</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="alert error">Action failed. Please try again.</div>
        <% } %>

        <div class="apt-list" id="apt-list"></div>

        <% if (appointments.isEmpty()) { %>
            <div class="empty-box">No appointments found.</div>
        <% } %>
    </div>
</div>

<div class="delete-overlay" id="deleteOverlay">
    <div class="delete-modal">
        <div class="delete-header">
            <div class="delete-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                    <line x1="12" y1="9" x2="12" y2="13"></line>
                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                </svg>
            </div>

            <h3>Delete Appointment</h3>
        </div>

        <p>
            Are you sure you want to delete appointment
            <strong id="deleteAppointmentName"></strong>? This action cannot be undone.
        </p>

        <form method="post" action="<%=request.getContextPath()%>/DeleteAppointmentController">
            <input type="hidden" name="appointmentID" id="deleteAppointmentID">

            <div class="delete-actions">
                <button type="button" class="btn-cancel" onclick="closeDelete()">Cancel</button>
                <button type="submit" class="btn-confirm-delete">Delete</button>
            </div>
        </form>
    </div>
</div>


<div class="complete-overlay" id="completeOverlay">
    <div class="complete-modal">
        <h3>Complete Appointment</h3>
        <p>Enter the cat current weight before marking this appointment as completed.</p>

        <div class="complete-info-box" id="completeAppointmentName"></div>

        <form method="post" action="<%=request.getContextPath()%>/UpdateAppointmentStatusController" onsubmit="return validateCompleteWeight();">
            <input type="hidden" name="appointmentID" id="completeAppointmentID">
            <input type="hidden" name="appointmentStatus" value="Completed">

            <div class="complete-field">
                <label for="completeWeight">Current Weight (kg)</label>
                <input type="number"
                       name="weight"
                       id="completeWeight"
                       min="0.01"
                       max="99.99"
                       step="0.01"
                       placeholder="Example: 3.50"
                       required>
            </div>

            <div class="complete-actions">
                <button type="button" class="btn-cancel" onclick="closeCompleteModal()">Cancel</button>
                <button type="submit" class="btn-save-complete">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
const appointments = [
<%
for (int i = 0; i < appointments.size(); i++) {
    AppointmentRow row = appointments.get(i);
%>
    {
        id: <%=row.appointmentID%>,
        no: "<%=js(row.appointmentNo)%>",
        date: "<%=js(row.appointmentDate)%>",
        time: "<%=js(row.appointmentTime)%>",
        customer: "<%=js(row.customerName)%>",
        status: "<%=statusLower(row.appointmentStatus)%>",
        weight: "<%=js(weightDisplay(row.weight))%>",
        weightValue: "<%=js(weightValue(row.weight))%>",
        total: <%=row.totalAmount%>
    }<%=i < appointments.size() - 1 ? "," : ""%>
<%
}
%>
];

function statusIcon(s) {
    if (s === "pending") {
        return `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="7.5" x2="12" y2="12.5"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>`;
    }

    if (s === "cancelled") {
        return `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>`;
    }

    return `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>`;
}

function statusLabel(s) {
    if (s === "confirmed") return "Confirmed";
    if (s === "completed") return "Completed";
    if (s === "cancelled") return "Cancelled";
    return "Pending";
}

let currentFilter = "all";

function setFilter(status) {
    currentFilter = status || "all";

    document.querySelectorAll("[data-filter-card]").forEach(function(card) {
        card.classList.toggle("active-filter", card.getAttribute("data-filter-card") === currentFilter);
    });

    render();
}

function statusOptions(a) {
    if (a.status === "pending") {
        return `
            <option value="Pending" selected>Pending</option>
            <option value="Cancelled">Cancelled</option>
        `;
    }

    if (a.status === "confirmed") {
        return `
            <option value="Confirmed" selected>Confirmed</option>
            <option value="Completed">Completed</option>
        `;
    }

    if (a.status === "completed") {
        return `<option value="Completed" selected>Completed</option>`;
    }

    return `<option value="Cancelled" selected>Cancelled</option>`;
}

function render() {
    const list = document.getElementById("apt-list");

    if (!list) return;

    const cardTitle = document.getElementById("cardTitle");
    const filteredAppointments = currentFilter === "all"
        ? appointments
        : appointments.filter(function(a) { return a.status === currentFilter; });

    if (cardTitle) {
        cardTitle.textContent = currentFilter === "all"
            ? "All Appointments"
            : statusLabel(currentFilter) + " Appointments";
    }

    if (filteredAppointments.length === 0) {
        const emptyLabel = currentFilter === "all" ? "appointments" : currentFilter + " appointments";
        list.innerHTML = `<div class="empty-box">No ${emptyLabel} found.</div>`;
        return;
    }

    list.innerHTML = filteredAppointments.map(a => {
        const label = statusLabel(a.status);
        const canEdit = a.status === "pending";
        const statusDropdownDisabled = a.status === "cancelled" || a.status === "completed";
        const disabledStatusTitle = statusDropdownDisabled ? 'title="This appointment status cannot be changed"' : '';

        const editButton = canEdit
            ? `
                <button class="act-btn edit"
                        title="Edit appointment"
                        onclick="window.location.href='<%=request.getContextPath()%>/EditAppointmentController?appointmentID=${a.id}'">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                </button>
              `
            : `
                <button class="act-btn edit disabled-edit" disabled title="Only pending appointments can be edited">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                </button>
              `;

        const statusDropdown = `
            <form class="status-form" method="post" action="<%=request.getContextPath()%>/UpdateAppointmentStatusController">
                <input type="hidden" name="appointmentID" value="${a.id}">
                <select class="status-select ${a.status}"
                        name="appointmentStatus"
                        data-old-status="${label}"
                        data-old-value="${a.status}"
                        data-weight-value="${a.weightValue || ''}"
                        onchange="handleStatusChange(this, '${a.no}', '${a.id}')"
                        ${statusDropdownDisabled ? 'disabled' : ''}
                        ${disabledStatusTitle}>
${statusOptions(a)}
                </select>
            </form>
        `;

        return `
            <div class="apt-item">
                <div class="left">
                    <div class="apt-info">
                        <h4>
                            ${a.no}
                            <span class="badge ${a.status}">
                                ${label}
                            </span>
                        </h4>

                        <div class="meta">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2"/>
                                <line x1="16" y1="2" x2="16" y2="6"/>
                                <line x1="8" y1="2" x2="8" y2="6"/>
                                <line x1="3" y1="10" x2="21" y2="10"/>
                            </svg>
                            ${a.date}

                            <span class="sep"></span>

                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"/>
                                <polyline points="12 6 12 12 16 14"/>
                            </svg>
                            ${a.time}

                            <span class="sep"></span>
                            ${a.customer}

                            <span class="sep"></span>
                            <span class="weight-meta ${a.weightValue ? '' : 'missing'}">Weight: ${a.weight}</span>
                        </div>
                    </div>
                </div>

                <div class="apt-amount">RM ${Number(a.total).toFixed(2)}</div>

                <div class="apt-actions">
                    ${statusDropdown}

                    <button class="act-btn view"
                            title="View"
                            onclick="window.location.href='<%=request.getContextPath()%>/ViewAppointmentController?appointmentID=${a.id}'">
                        <svg viewBox="0 0 24 24" style="stroke:currentColor">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>

                    ${editButton}

                    <button class="act-btn del" title="Delete" onclick="openDelete('${a.id}', '${a.no}', '${a.customer}')">
                        <svg viewBox="0 0 24 24" style="stroke:currentColor">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6l-1 14H6L5 6"/>
                            <path d="M10 11v6"/>
                            <path d="M14 11v6"/>
                            <path d="M9 6V4h6v2"/>
                        </svg>
                    </button>
                </div>
            </div>
        `;
    }).join("");
}

let pendingStatusSelect = null;

function handleStatusChange(select, appointmentNo, appointmentID) {
    const newStatus = select.value;
    const oldStatus = select.dataset.oldStatus || "";
    const oldValue = select.dataset.oldValue || "pending";

    if (newStatus === oldStatus) {
        return;
    }

    if (newStatus === "Completed") {
        pendingStatusSelect = select;
        document.getElementById("completeAppointmentID").value = appointmentID;
        document.getElementById("completeAppointmentName").textContent = appointmentNo;
        document.getElementById("completeWeight").value = select.dataset.weightValue || "";
        document.getElementById("completeOverlay").classList.add("open");
        setTimeout(function() {
            document.getElementById("completeWeight").focus();
        }, 80);
        return;
    }

    const confirmChange = confirm("Update " + appointmentNo + " status to " + newStatus + "?");

    if (confirmChange) {
        select.form.submit();
    } else {
        select.value = oldValue.charAt(0).toUpperCase() + oldValue.slice(1);
    }
}

function closeCompleteModal() {
    document.getElementById("completeOverlay").classList.remove("open");

    if (pendingStatusSelect) {
        const oldValue = pendingStatusSelect.dataset.oldValue || "pending";
        pendingStatusSelect.value = oldValue.charAt(0).toUpperCase() + oldValue.slice(1);
        pendingStatusSelect = null;
    }
}

function validateCompleteWeight() {
    const weightInput = document.getElementById("completeWeight");
    const weight = parseFloat(weightInput.value.replace(",", "."));

    if (!weight || weight <= 0 || weight > 99.99) {
        alert("Please enter a valid current cat weight between 0.01 kg and 99.99 kg.");
        weightInput.focus();
        return false;
    }

    weightInput.value = weight.toFixed(2);
    return true;
}

function openDelete(id, appointmentNo, customer) {
    document.getElementById("deleteAppointmentID").value = id;
    document.getElementById("deleteAppointmentName").textContent = appointmentNo + " - " + customer;
    document.getElementById("deleteOverlay").classList.add("open");
}

function closeDelete() {
    document.getElementById("deleteOverlay").classList.remove("open");
}

document.getElementById("completeOverlay").addEventListener("click", function(event) {
    if (event.target === this) {
        closeCompleteModal();
    }
});

render();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>