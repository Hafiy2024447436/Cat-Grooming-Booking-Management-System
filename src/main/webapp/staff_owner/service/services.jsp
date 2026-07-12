<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.ServiceBean"%>
<%@ page import="catBooking.bean.FurBasedServiceBean"%>
<%@ page import="catBooking.bean.WeightBasedServiceBean"%>

<%!
private String js(String value) {
    if (value == null) {
        return "";
    }

    return value
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("'", "\\'")
            .replace("\r", "")
            .replace("\n", "\\n")
            .replace("</", "<\\/");
}

private String normal(String value) {
    return value == null ? "" : value.trim();
}
%>

<%
List<ServiceBean> serviceList = (List<ServiceBean>) request.getAttribute("serviceList");
if (serviceList == null) {
    serviceList = new java.util.ArrayList<>();
}

String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Manage Services</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>

<style>
*, *::before, *::after {
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
    padding: 2rem;
}

.container {
    max-width: 1100px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.page-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    flex-wrap: wrap;
}

.page-header-left {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.page-header .icon {
    width: 56px;
    height: 56px;
    background: linear-gradient(135deg, #8b5cf6, #ec4899);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.page-header .icon svg {
    width: 28px;
    height: 28px;
    stroke: #fff;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

.page-header h2 {
    font-size: 1.5rem;
    font-weight: 800;
    color: #111827;
}

.page-header p {
    color: #6b7280;
    font-size: .9rem;
    margin-top: .25rem;
}

.btn-create {
    display: flex;
    align-items: center;
    gap: .5rem;
    background: linear-gradient(135deg, #8b5cf6, #ec4899);
    color: #fff;
    border: none;
    padding: .75rem 1.25rem;
    border-radius: 10px;
    font-weight: 800;
    font-size: .9rem;
    cursor: pointer;
    font-family: inherit;
}

.btn-create:hover {
    opacity: .92;
}

.btn-create svg {
    width: 16px;
    height: 16px;
    stroke: #fff;
    fill: none;
    stroke-width: 2.5;
}

.card {
    background: #fff;
    border-radius: 14px;
    padding: 1.5rem;
    box-shadow: 0 1px 3px rgba(0,0,0,.06);
}

.section-title {
    font-size: 1.05rem;
    font-weight: 900;
    color: #111827;
    margin-bottom: 1rem;
    display: flex;
    align-items: center;
    gap: .5rem;
}

.section-title .dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
}

.section-title.main .dot {
    background: #8b5cf6;
}

.section-title.addon .dot {
    background: #3b82f6;
}

.svc-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1rem;
}

.svc-card {
    border: 1.5px solid #e5e7eb;
    border-radius: 12px;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: .55rem;
    background: #fff;
}

.svc-name {
    font-weight: 900;
    font-size: .98rem;
    color: #111827;
}

.svc-tag {
    display: inline-block;
    font-size: .72rem;
    font-weight: 800;
    padding: .18rem .55rem;
    border-radius: 999px;
    margin-top: .2rem;
}

.svc-tag.short {
    background: #ede9fe;
    color: #6d28d9;
}

.svc-tag.long {
    background: #fce7f3;
    color: #be185d;
}

.svc-tag.weight {
    background: #dbeafe;
    color: #1d4ed8;
}

.svc-tag.addon {
    background: #e0f2fe;
    color: #0369a1;
}

.svc-tag.main {
    background: #f5f3ff;
    color: #6d28d9;
}

.svc-desc {
    color: #6b7280;
    font-size: .84rem;
    line-height: 1.45;
}

.svc-price {
    font-size: 1.12rem;
    font-weight: 900;
    color: #111827;
    margin-top: .25rem;
}

.svc-actions {
    display: flex;
    gap: .5rem;
    margin-top: .5rem;
}

.btn-edit,
.btn-del {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: .35rem;
    padding: .55rem;
    border-radius: 8px;
    font-size: .82rem;
    font-weight: 800;
    cursor: pointer;
    border: none;
    font-family: inherit;
}

.btn-edit {
    flex: 0 0 36px;
    width: 36px;
    height: 36px;
    padding: 0;
    background: transparent;
    color: #7c3aed;
}

.btn-edit:hover {
    background: #f3e8ff;
}

.btn-del {
    flex: 1;
    background: #fef2f2;
    color: #dc2626;
}

.btn-del:hover {
    background: #fee2e2;
}

.btn-edit svg,
.btn-del svg {
    width: 14px;
    height: 14px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
}

.empty-note {
    color: #9ca3af;
    font-size: .85rem;
    padding: 1rem 0;
    font-weight: 700;
}

/* Modal */
.overlay {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,.55);
    backdrop-filter: blur(3px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 200;
    padding: 1rem;
}

.overlay.open {
    display: flex;
}

.modal {
    background: #fff;
    border-radius: 16px;
    width: 100%;
    max-width: 560px;
    max-height: 88vh;
    overflow-y: auto;
    padding: 1.5rem;
}

.modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.25rem;
}

.modal-title {
    font-size: 1.25rem;
    font-weight: 900;
    color: #111827;
}

.btn-x {
    background: transparent;
    border: none;
    cursor: pointer;
    color: #111827;
    padding: .25rem;
    box-shadow: none;
}

.btn-x:hover {
    background: transparent;
    color: #111827;
    opacity: .7;
}

.btn-x svg {
    width: 22px;
    height: 22px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
}

.form-group {
    margin-bottom: 1rem;
}

.form-label {
    display: block;
    font-size: .86rem;
    font-weight: 800;
    color: #374151;
    margin-bottom: .45rem;
}

.form-group input[type="text"],
.form-group input[type="number"],
.form-group textarea {
    width: 100%;
    padding: .75rem .9rem;
    border: 1.5px solid #e5e7eb;
    border-radius: 9px;
    font-size: .92rem;
    font-family: inherit;
    color: #111827;
}

.form-group textarea {
    resize: vertical;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #8b5cf6;
}

.toggle-row {
    display: flex;
    gap: .7rem;
    margin-bottom: 1.1rem;
}

.toggle-btn {
    flex: 1;
    padding: .7rem;
    border-radius: 9px;
    border: 1.5px solid #e5e7eb;
    background: #fff;
    font-weight: 900;
    font-size: .92rem;
    cursor: pointer;
    color: #6b7280;
    font-family: inherit;
    text-align: center;
}

.toggle-btn.active {
    border-color: #8b5cf6;
    background: #f5f3ff;
    color: #6d28d9;
}

.two-col {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: .8rem;
}

.weight-row {
    display: flex;
    gap: .5rem;
    align-items: flex-end;
    margin-bottom: .6rem;
}

.weight-row .form-group {
    flex: 1;
    margin-bottom: 0;
}

.btn-remove-row {
    background: #fef2f2;
    color: #dc2626;
    border: none;
    border-radius: 8px;
    width: 38px;
    height: 38px;
    cursor: pointer;
    flex-shrink: 0;
    font-size: 1.1rem;
    font-weight: 900;
}

.btn-add-row {
    display: flex;
    align-items: center;
    gap: .4rem;
    background: #f5f3ff;
    color: #6d28d9;
    border: none;
    padding: .55rem .9rem;
    border-radius: 8px;
    font-size: .84rem;
    font-weight: 900;
    cursor: pointer;
    font-family: inherit;
    margin-top: .2rem;
}

.btn-add-row svg {
    width: 14px;
    height: 14px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2.5;
}

.form-actions {
    display: flex;
    gap: .7rem;
    margin-top: 1.25rem;
}

.btn-save {
    flex: 1;
    background: linear-gradient(135deg, #8b5cf6, #ec4899);
    color: #fff;
    border: none;
    padding: .8rem;
    border-radius: 10px;
    font-weight: 900;
    font-size: .92rem;
    cursor: pointer;
    font-family: inherit;
}

.btn-cancel-sm {
    flex: 1;
    background: #f3f4f6;
    color: #374151;
    border: none;
    padding: .8rem;
    border-radius: 10px;
    font-weight: 900;
    font-size: .92rem;
    cursor: pointer;
    font-family: inherit;
}

/* User requested service UI fixes */
.btn-create,
.btn-save {
    background: #5cb85c !important;
    color: #ffffff !important;
}

.btn-create:hover,
.btn-save:hover {
    background: #16a34a !important;
    opacity: 1 !important;
}

.form-actions {
    display: flex;
    gap: .7rem;
    margin-top: 1.25rem;
}

.form-actions .btn-cancel-sm {
    order: 1;
}

.form-actions .btn-save {
    order: 2;
}

.btn-cancel-sm {
    background: #b9bfc4 !important;
    color: #ffffff !important;
}

.btn-cancel-sm:hover {
    background: #a8aeb3 !important;
}

.svc-card {
    position: relative;
}

.svc-card-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: .8rem;
}

.svc-card-main {
    min-width: 0;
}

.svc-top-actions {
    display: flex;
    align-items: center;
    gap: .35rem;
    flex-shrink: 0;
}

.svc-top-actions .btn-edit,
.svc-top-actions .btn-del {
    flex: 0 0 34px;
    width: 34px;
    height: 34px;
    padding: 0;
    border-radius: 9px;
    background: transparent;
}

.svc-top-actions .btn-edit {
    color: #7c3aed;
}

.svc-top-actions .btn-edit:hover {
    background: #f3e8ff;
}

.svc-top-actions .btn-del {
    color: #ef4444;
}

.svc-top-actions .btn-del:hover {
    background: #fee2e2;
}

.svc-top-actions svg {
    width: 17px;
    height: 17px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
}

.svc-price {
    margin-top: .35rem;
}

.fur-create-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: .9rem;
}

.fur-create-card {
    border: 1.5px solid #e5e7eb;
    border-radius: 12px;
    padding: 1rem;
    background: #fbfaff;
}

.fur-create-title {
    font-weight: 900;
    color: #6d28d9;
    margin-bottom: .75rem;
}

.toggle-btn:disabled,
.toggle-btn.disabled {
    cursor: not-allowed;
    opacity: .55;
    background: #f3f4f6;
    color: #6b7280;
}

.toggle-btn.active:disabled {
    opacity: 1;
    border-color: #8b5cf6;
    background: #f5f3ff;
    color: #6d28d9;
}

.svc-tag.short {
    text-transform: capitalize;
}

.svc-tag.long {
    text-transform: capitalize;
}


/* Delete button back to long bottom button */
.svc-delete-row {
    margin-top: .85rem;
}

.btn-del-wide {
    width: 100%;
    min-height: 42px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: .45rem;
    border: none;
    border-radius: 10px;
    background: #fef2f2;
    color: #ef4444;
    font-family: inherit;
    font-size: .9rem;
    font-weight: 900;
    cursor: pointer;
    transition: background .18s ease, transform .18s ease;
}

.btn-del-wide:hover {
    background: #fee2e2;
    transform: translateY(-1px);
}

.btn-del-wide svg {
    width: 18px;
    height: 18px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

/* Delete popup same style as appointmentManagement.jsp */
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

.btn-cancel-delete {
    background: #ffffff;
    color: #374151;
    border: 1px solid #cbd5e1;
}

.btn-cancel-delete:hover {
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


:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-red: #ef4444;
  --btn-red-hover: #dc2626;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

/* Services page buttons */
.btn-create,
.btn-save {
  background: var(--btn-green) !important;
  border-color: var(--btn-green) !important;
  color: #ffffff !important;
}

.btn-create:hover,
.btn-save:hover {
  background: var(--btn-green-hover) !important;
  border-color: var(--btn-green-hover) !important;
  color: #ffffff !important;
}

.btn-cancel-sm {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.btn-cancel-sm:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
  color: #ffffff !important;
}

.btn-x {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  color: #111827 !important;
}

.btn-x:hover {
  background: transparent !important;
  border: none !important;
  color: #111827 !important;
  opacity: .7 !important;
}

.btn-confirm-delete,
.btn-del-wide {
  background: var(--btn-red) !important;
  border-color: var(--btn-red) !important;
  color: #ffffff !important;
}

.btn-confirm-delete:hover,
.btn-del-wide:hover {
  background: var(--btn-red-hover) !important;
  border-color: var(--btn-red-hover) !important;
  color: #ffffff !important;
}

.btn-cancel-delete {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.btn-cancel-delete:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
  color: #ffffff !important;
}

.form-actions {
  display: flex !important;
  gap: 14px !important;
}

.form-actions .btn-cancel-sm {
  order: 1 !important;
}

.form-actions .btn-save {
  order: 2 !important;
}

button:disabled,
.toggle-btn:disabled {
  background: var(--btn-disabled) !important;
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

    <div class="page-header">
        <div class="page-header-left">
<div>
                <h2>Manage Services</h2>
                <p>Create, edit, and hide grooming services</p>
            </div>
        </div>

        <button class="btn-create" onclick="openCreateModal()">
            <svg viewBox="0 0 24 24">
                <line x1="12" y1="5" x2="12" y2="19"/>
                <line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Create Service
        </button>
    </div>

    <div class="card">
        <div class="section-title main">
            <span class="dot"></span>
            Main Service
        </div>

        <div class="svc-grid" id="mainGrid"></div>
        <div class="empty-note" id="mainEmpty" style="display:none">
            No main services yet.
        </div>
    </div>

    <div class="card">
        <div class="section-title addon">
            <span class="dot"></span>
            Add-On Services
        </div>

        <div class="svc-grid" id="addonGrid"></div>
        <div class="empty-note" id="addonEmpty" style="display:none">
            No add-on services yet.
        </div>
    </div>

</div>

<!-- Create Service Modal -->
<div class="overlay" id="createOverlay">
    <div class="modal">

        <div class="modal-header">
            <span class="modal-title">Create Service</span>

            <button class="btn-x" onclick="closeModal('createOverlay')">
                <svg viewBox="0 0 24 24">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>

        <div class="toggle-row">
            <button type="button" class="toggle-btn active" id="catMainBtn" onclick="setCategory('MAIN')">
                Main Service
            </button>

            <button type="button" class="toggle-btn" id="catAddonBtn" onclick="setCategory('ADDON')">
                Add-On
            </button>
        </div>

        <div id="mainTypeToggle" class="toggle-row">
            <button type="button" class="toggle-btn" id="typeFurBtn" onclick="setMainType('FUR')">
                Fur Type Service
            </button>

            <button type="button" class="toggle-btn" id="typeWeightBtn" onclick="setMainType('WEIGHT')">
                Weight Service
            </button>
        </div>

        <div class="form-group">
            <label class="form-label">Service Name</label>
            <input type="text" id="createName" placeholder="e.g. Full Grooming" />
        </div>

        <div class="form-group">
            <label class="form-label">Description</label>
            <textarea id="createDesc" rows="3" placeholder="Enter service description"></textarea>
        </div>

        <div id="plainFields">
            <div class="form-group">
                <label class="form-label">Price (RM)</label>
                <input type="number" id="mainPrice" min="0" step="0.01" value="0" />
            </div>
        </div>

        <div id="furFields" style="display:none">
            <div class="fur-create-grid">
                <div class="fur-create-card">
                    <div class="fur-create-title">Short Hair Service</div>

                    <div class="form-group">
                        <label class="form-label">Service Name</label>
                        <input type="text" id="shortServiceName" placeholder="e.g. Adult Short Hair Grooming" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea id="shortDescription" rows="2" placeholder="Enter short hair service description"></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Price (RM)</label>
                        <input type="number" id="priceShort" min="0" step="0.01" value="0" />
                    </div>
                </div>

                <div class="fur-create-card">
                    <div class="fur-create-title">Long Hair Service</div>

                    <div class="form-group">
                        <label class="form-label">Service Name</label>
                        <input type="text" id="longServiceName" placeholder="e.g. Adult Long Hair Grooming" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea id="longDescription" rows="2" placeholder="Enter long hair service description"></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Price (RM)</label>
                        <input type="number" id="priceLong" min="0" step="0.01" value="0" />
                    </div>
                </div>
            </div>
        </div>

        <div id="weightFields" style="display:none">
            <label class="form-label">Range Type & Prices</label>

            <div id="weightRows"></div>

            <button type="button" class="btn-add-row" onclick="addWeightRow()">
                <svg viewBox="0 0 24 24">
                    <line x1="12" y1="5" x2="12" y2="19"/>
                    <line x1="5" y1="12" x2="19" y2="12"/>
                </svg>
                Add Range Type
            </button>
        </div>

        <div id="addonFields" style="display:none" class="form-group">
            <label class="form-label">Price (RM)</label>
            <input type="number" id="addonPrice" min="0" step="0.01" value="0" />
        </div>

        <div class="form-actions">
            <button class="btn-cancel-sm" onclick="closeModal('createOverlay')">Cancel</button>
            <button class="btn-save" onclick="submitCreate()">Create Service</button>
        </div>

    </div>
</div>

<!-- Edit Service Modal -->
<div class="overlay" id="editOverlay">
    <div class="modal">

        <div class="modal-header">
            <span class="modal-title">Edit Service</span>

            <button class="btn-x" onclick="closeModal('editOverlay')">
                <svg viewBox="0 0 24 24">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
            </button>
        </div>

        <div class="form-group">
            <label class="form-label">Service Name</label>
            <input type="text" id="editName" />
        </div>

        <div class="form-group">
            <label class="form-label">Description</label>
            <textarea id="editDesc" rows="3"></textarea>
        </div>

        <div class="form-group" id="editServiceTypeWrap" style="display:none">
            <label class="form-label">Service Type</label>
            <input type="text" id="editServiceTypeDisplay" readonly style="background:#f9fafb;cursor:not-allowed;" />
        </div>

        <div class="form-group" id="editFurTypeWrap" style="display:none">
            <label class="form-label">Fur Type</label>

            <div class="toggle-row" style="margin-bottom:0">
                <button type="button" class="toggle-btn" id="editFurShortBtn" onclick="setEditFurType('SHORT')">
                    Short Hair Type
                </button>

                <button type="button" class="toggle-btn" id="editFurLongBtn" onclick="setEditFurType('LONG')">
                    Long Hair Type
                </button>
            </div>
        </div>

        <div class="form-group" id="editWeightRangeWrap" style="display:none">
            <label class="form-label">Range Type</label>
            <input type="text" id="editWeightRange" placeholder="e.g. ≤ 1.5 kg / 1.6 - 4.0 kg / ≥ 5.0 kg" />
        </div>

        <div class="form-group">
            <label class="form-label">Price (RM)</label>
            <input type="number" id="editPrice" min="0" step="0.01" />
        </div>

        <div class="form-actions">
            <button class="btn-cancel-sm" onclick="closeModal('editOverlay')">Cancel</button>
            <button class="btn-save" onclick="submitEdit()">Save</button>
        </div>

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

            <h3>Delete Service</h3>
        </div>

        <p>
            Are you sure you want to delete service
            <strong id="deleteServiceName"></strong>? This action cannot be undone.
        </p>

        <div class="delete-actions">
            <button type="button" class="btn-cancel-delete" onclick="closeDeleteModal()">Cancel</button>
            <button type="button" class="btn-confirm-delete" onclick="confirmDeleteService()">Delete</button>
        </div>
    </div>
</div>

<script>
const CTX = "<%=ctx%>";

const services = [
<%
for (int i = 0; i < serviceList.size(); i++) {
    ServiceBean s = serviceList.get(i);

    String category = normal(s.getCategory()).toUpperCase().replace("-", "");
    String furType = "";
    String weightRange = "";

    if (s instanceof FurBasedServiceBean) {
        furType = normal(((FurBasedServiceBean) s).getFurType()).toUpperCase();
    } else if (s instanceof WeightBasedServiceBean) {
        weightRange = normal(((WeightBasedServiceBean) s).getWeightRange());
    }
%>
    {
        id: "<%=s.getServiceID()%>",
        name: "<%=js(s.getServiceName())%>",
        description: "<%=js(s.getDescription())%>",
        category: "<%=js(category)%>",
        price: <%=s.getPrice()%>,
        furType: "<%=js(furType)%>",
        weightRange: "<%=js(weightRange)%>"
    }<%=i < serviceList.size() - 1 ? "," : ""%>
<%
}
%>
];

let currentCategory = "MAIN";
let currentMainType = "PLAIN";
let editFurTypeValue = "";
let editingService = null;
let deletingServiceId = null;
let weightRowCount = 0;

function escapeHtml(str) {
    return String(str == null ? "" : str)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function tagForService(svc) {
    if (svc.furType === "SHORT") {
        return '<span class="svc-tag short">Fur Type Service • Short Hair</span>';
    }

    if (svc.furType === "LONG") {
        return '<span class="svc-tag long">Fur Type Service • Long Hair</span>';
    }

    if (svc.weightRange && svc.weightRange.trim() !== "") {
        return '<span class="svc-tag weight">Weight Service • ' + escapeHtml(svc.weightRange) + '</span>';
    }

    if (svc.category === "ADDON") {
        return '<span class="svc-tag addon">Add-On Service</span>';
    }

    return '<span class="svc-tag main">Main Service</span>';
}

function buildCard(svc) {
    return `
        <div class="svc-card">
            <div class="svc-card-head">
                <div class="svc-card-main">
                    <div class="svc-name">${escapeHtml(svc.name)}</div>
                    ${tagForService(svc)}
                </div>

                <div class="svc-top-actions">
                    <button class="btn-edit" onclick="openEditModal('${svc.id}')" title="Edit">
                        <svg viewBox="0 0 24 24">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="svc-desc">${escapeHtml(svc.description)}</div>

            <div class="svc-price">RM ${Number(svc.price).toFixed(2)}</div>

            <div class="svc-delete-row">
                <button class="btn-del-wide" onclick="openDeleteModal('${svc.id}')" title="Delete">
                    <svg viewBox="0 0 24 24">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6l-1 14H6L5 6"/>
                        <path d="M10 11v6"/>
                        <path d="M14 11v6"/>
                        <path d="M9 6V4h6v2"/>
                    </svg>
                    Delete
                </button>
            </div>
        </div>
    `;
}

function renderAll() {
    const mainList = services.filter(s => s.category === "MAIN");
    const addonList = services.filter(s => s.category === "ADDON");

    document.getElementById("mainGrid").innerHTML = mainList.map(buildCard).join("");
    document.getElementById("addonGrid").innerHTML = addonList.map(buildCard).join("");

    document.getElementById("mainEmpty").style.display = mainList.length ? "none" : "block";
    document.getElementById("addonEmpty").style.display = addonList.length ? "none" : "block";
}

function openCreateModal() {
    currentCategory = "MAIN";
    currentMainType = "PLAIN";

    document.getElementById("createName").value = "";
    document.getElementById("createDesc").value = "";
    document.getElementById("mainPrice").value = "0";

    document.getElementById("shortServiceName").value = "";
    document.getElementById("shortDescription").value = "";
    document.getElementById("priceShort").value = "0";

    document.getElementById("longServiceName").value = "";
    document.getElementById("longDescription").value = "";
    document.getElementById("priceLong").value = "0";

    document.getElementById("addonPrice").value = "0";
    document.getElementById("weightRows").innerHTML = "";

    weightRowCount = 0;
    addWeightRow();

    setCategory("MAIN");

    document.getElementById("createOverlay").classList.add("open");
}

function setCategory(category) {
    currentCategory = category;

    document.getElementById("catMainBtn").classList.toggle("active", category === "MAIN");
    document.getElementById("catAddonBtn").classList.toggle("active", category === "ADDON");

    document.getElementById("mainTypeToggle").style.display = category === "MAIN" ? "flex" : "none";
    document.getElementById("addonFields").style.display = category === "ADDON" ? "block" : "none";

    if (category === "MAIN") {
        setMainType("PLAIN");
    } else {
        document.getElementById("plainFields").style.display = "none";
        document.getElementById("furFields").style.display = "none";
        document.getElementById("weightFields").style.display = "none";
        document.getElementById("createName").closest(".form-group").style.display = "block";
        document.getElementById("createDesc").closest(".form-group").style.display = "block";
    }
}

function setMainType(type) {
    currentMainType = type;

    document.getElementById("typeFurBtn").classList.toggle("active", type === "FUR");
    document.getElementById("typeWeightBtn").classList.toggle("active", type === "WEIGHT");

    document.getElementById("plainFields").style.display = type === "PLAIN" ? "block" : "none";
    document.getElementById("furFields").style.display = type === "FUR" ? "block" : "none";
    document.getElementById("weightFields").style.display = type === "WEIGHT" ? "block" : "none";

    const useCommonName = type !== "FUR";

    document.getElementById("createName").closest(".form-group").style.display = useCommonName ? "block" : "none";
    document.getElementById("createDesc").closest(".form-group").style.display = useCommonName ? "block" : "none";
}

function addWeightRow() {
    weightRowCount++;

    const id = weightRowCount;
    const div = document.createElement("div");

    div.className = "weight-row";
    div.id = "weightRow" + id;

    div.innerHTML = `
        <div class="form-group">
            <label class="form-label">Range Type</label>
            <input type="text" class="wr-range" placeholder="e.g. ≤ 1.5 kg" />
        </div>

        <div class="form-group">
            <label class="form-label">Price (RM)</label>
            <input type="number" class="wr-price" min="0" step="0.01" value="0" />
        </div>

        <button type="button" class="btn-remove-row" onclick="removeWeightRow(${id})">&times;</button>
    `;

    document.getElementById("weightRows").appendChild(div);
}

function removeWeightRow(id) {
    const el = document.getElementById("weightRow" + id);

    if (el && document.querySelectorAll(".weight-row").length > 1) {
        el.remove();
    }
}

function submitCreate() {
    const params = new URLSearchParams();

    if (currentCategory === "ADDON") {
        const name = document.getElementById("createName").value.trim();
        const desc = document.getElementById("createDesc").value.trim();
        const price = parseFloat(document.getElementById("addonPrice").value) || 0;

        if (!name || !desc || price <= 0) {
            alert("Please fill in add-on service name, description, and valid price.");
            return;
        }

        params.append("action", "addAddon");
        params.append("serviceName", name);
        params.append("description", desc);
        params.append("price", price);

    } else if (currentMainType === "PLAIN") {
        const name = document.getElementById("createName").value.trim();
        const desc = document.getElementById("createDesc").value.trim();
        const price = parseFloat(document.getElementById("mainPrice").value) || 0;

        if (!name || !desc || price <= 0) {
            alert("Please fill in main service name, description, and valid price.");
            return;
        }

        params.append("action", "addMainPlain");
        params.append("serviceName", name);
        params.append("description", desc);
        params.append("price", price);

    } else if (currentMainType === "FUR") {
        const shortName = document.getElementById("shortServiceName").value.trim();
        const shortDesc = document.getElementById("shortDescription").value.trim();
        const priceShort = parseFloat(document.getElementById("priceShort").value) || 0;

        const longName = document.getElementById("longServiceName").value.trim();
        const longDesc = document.getElementById("longDescription").value.trim();
        const priceLong = parseFloat(document.getElementById("priceLong").value) || 0;

        if (!shortName || !shortDesc || !longName || !longDesc || priceShort <= 0 || priceLong <= 0) {
            alert("Please fill in both short hair and long hair service details.");
            return;
        }

        params.append("action", "addFur");
        params.append("shortServiceName", shortName);
        params.append("shortDescription", shortDesc);
        params.append("priceShort", priceShort);
        params.append("longServiceName", longName);
        params.append("longDescription", longDesc);
        params.append("priceLong", priceLong);

    } else {
        const name = document.getElementById("createName").value.trim();
        const desc = document.getElementById("createDesc").value.trim();

        if (!name || !desc) {
            alert("Please fill in service name and description.");
            return;
        }

        const rangeInputs = document.querySelectorAll(".wr-range");
        const priceInputs = document.querySelectorAll(".wr-price");

        let valid = true;

        params.append("action", "addWeight");
        params.append("serviceName", name);
        params.append("description", desc);

        rangeInputs.forEach((el, index) => {
            const range = el.value.trim();
            const price = parseFloat(priceInputs[index].value) || 0;

            if (!range || price <= 0) {
                valid = false;
            }

            params.append("weightRange", range);
            params.append("weightPrice", price);
        });

        if (!valid) {
            alert("Please fill in every range type and valid price.");
            return;
        }
    }

    fetch(CTX + "/ManageServicesController", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params
    })
    .then(res => res.text())
    .then(result => {
        if (result.trim() === "success") {
            window.location.href = CTX + "/ManageServicesController?notifType=create&notifMsg=Service%20created%20successfully.";
        } else {
            alert("Failed to create service. Please try again.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("Error creating service.");
    });
}

function openEditModal(id) {
    editingService = services.find(s => s.id === id);

    if (!editingService) {
        return;
    }

    document.getElementById("editName").value = editingService.name;
    document.getElementById("editDesc").value = editingService.description;
    document.getElementById("editPrice").value = editingService.price;

    const isFur = editingService.furType === "SHORT" || editingService.furType === "LONG";
    const isWeight = editingService.weightRange && editingService.weightRange.trim() !== "";

    document.getElementById("editServiceTypeWrap").style.display = "block";
    document.getElementById("editFurTypeWrap").style.display = isFur ? "block" : "none";
    document.getElementById("editWeightRangeWrap").style.display = isWeight ? "block" : "none";

    document.getElementById("editFurShortBtn").disabled = isFur;
    document.getElementById("editFurLongBtn").disabled = isFur;

    if (isFur) {
        document.getElementById("editServiceTypeDisplay").value = "Fur Type Service";
        setEditFurType(editingService.furType);
        document.getElementById("editWeightRange").value = "";

    } else if (isWeight) {
        document.getElementById("editServiceTypeDisplay").value = "Weight Service";
        document.getElementById("editWeightRange").value = editingService.weightRange;
        editFurTypeValue = "";

    } else if (editingService.category === "ADDON") {
        document.getElementById("editServiceTypeDisplay").value = "Add-On Service";
        document.getElementById("editWeightRange").value = "";
        editFurTypeValue = "";

    } else {
        document.getElementById("editServiceTypeDisplay").value = "Main Service";
        document.getElementById("editWeightRange").value = "";
        editFurTypeValue = "";
    }

    document.getElementById("editOverlay").classList.add("open");
}

function setEditFurType(type) {
    editFurTypeValue = type;

    document.getElementById("editFurShortBtn").classList.toggle("active", type === "SHORT");
    document.getElementById("editFurLongBtn").classList.toggle("active", type === "LONG");
}

function submitEdit() {
    if (!editingService) {
        return;
    }

    const name = document.getElementById("editName").value.trim();
    const desc = document.getElementById("editDesc").value.trim();
    const price = parseFloat(document.getElementById("editPrice").value) || 0;

    if (!name || !desc || price <= 0) {
        alert("Please fill in all fields and enter a valid price.");
        return;
    }

    const params = new URLSearchParams();

    params.append("action", "edit");
    params.append("serviceID", editingService.id);
    params.append("serviceName", name);
    params.append("description", desc);
    params.append("price", price);

    const isFur = editingService.furType === "SHORT" || editingService.furType === "LONG";
    const isWeight = editingService.weightRange && editingService.weightRange.trim() !== "";

    if (isFur) {
        params.append("furType", editingService.furType);

    } else if (isWeight) {
        const weightRange = document.getElementById("editWeightRange").value.trim();

        if (!weightRange) {
            alert("Please enter range type.");
            return;
        }

        params.append("weightRange", weightRange);
    }

    fetch(CTX + "/ManageServicesController", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params
    })
    .then(res => res.text())
    .then(result => {
        if (result.trim() === "success") {
            window.location.href = CTX + "/ManageServicesController?notifType=update&notifMsg=Service%20updated%20successfully.";
        } else {
            alert("Failed to save changes. Please try again.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("Error saving service.");
    });
}

function openDeleteModal(id) {
    const svc = services.find(s => s.id === id);
    const name = svc ? svc.name : "this service";

    deletingServiceId = id;
    document.getElementById("deleteServiceName").textContent = name;
    document.getElementById("deleteOverlay").classList.add("open");
}

function closeDeleteModal() {
    document.getElementById("deleteOverlay").classList.remove("open");
    deletingServiceId = null;
}

function confirmDeleteService() {
    if (!deletingServiceId) {
        return;
    }

    const params = new URLSearchParams();

    params.append("action", "delete");
    params.append("serviceID", deletingServiceId);

    fetch(CTX + "/ManageServicesController", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params
    })
    .then(res => res.text())
    .then(result => {
        const status = result.trim();

        if (status === "success") {
            window.location.href = CTX + "/ManageServicesController?notifType=delete&notifMsg=Service%20deleted%20successfully.";
        } else if (status === "inUse") {
            window.location.href = CTX + "/ManageServicesController?notifType=error&notifMsg="
                + encodeURIComponent("This service cannot be deleted because there are still appointments using it.");
        } else {
            window.location.href = CTX + "/ManageServicesController?notifType=error&notifMsg="
                + encodeURIComponent("Failed to delete service. Please try again.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("Error deleting service.");
    });
}

document.getElementById("deleteOverlay").addEventListener("click", function(event) {
    if (event.target.id === "deleteOverlay") {
        closeDeleteModal();
    }
});

function closeModal(id) {
    document.getElementById(id).classList.remove("open");
}

renderAll();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>