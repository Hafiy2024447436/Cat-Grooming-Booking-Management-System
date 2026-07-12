<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="catBooking.bean.ServiceBean"%>
<%@ page import="catBooking.bean.FurBasedServiceBean"%>
<%@ page import="catBooking.bean.WeightBasedServiceBean"%>

<%!
private String html(String value) {
    if (value == null) {
        return "";
    }

    return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
}

private String normal(String value) {
    return value == null ? "" : value.trim();
}

private boolean isMain(ServiceBean service) {
    return service != null && "MAIN".equalsIgnoreCase(normal(service.getCategory()));
}

private boolean isAddon(ServiceBean service) {
    return service != null && "ADDON".equalsIgnoreCase(normal(service.getCategory()));
}

private String serviceBadge(ServiceBean service) {
    if (service instanceof FurBasedServiceBean) {
        String furType = normal(((FurBasedServiceBean) service).getFurType());

        if ("SHORT".equalsIgnoreCase(furType)) {
            return "<span class=\"svc-tag short\">Short Hair</span>";
        }

        if ("LONG".equalsIgnoreCase(furType)) {
            return "<span class=\"svc-tag long\">Long Hair</span>";
        }

        if (!furType.isEmpty()) {
            return "<span class=\"svc-tag main-service\">" + html(furType) + "</span>";
        }
    }

    if (service instanceof WeightBasedServiceBean) {
        String weightRange = normal(((WeightBasedServiceBean) service).getWeightRange());

        if (!weightRange.isEmpty()) {
            return "<span class=\"svc-tag weight\">" + html(weightRange) + "</span>";
        }

        return "<span class=\"svc-tag weight\">Weight Based</span>";
    }

    if (isAddon(service)) {
        return "<span class=\"svc-tag addon\">Add-On</span>";
    }

    return "<span class=\"svc-tag main-service\">Main</span>";
}
%>

<%
List<ServiceBean> serviceList = (List<ServiceBean>) request.getAttribute("serviceList");

if (serviceList == null) {
    serviceList = new ArrayList<>();
}

List<ServiceBean> mainServices = new ArrayList<>();
List<ServiceBean> addonServices = new ArrayList<>();

for (ServiceBean service : serviceList) {
    if (isMain(service)) {
        mainServices.add(service);
    } else if (isAddon(service)) {
        addonServices.add(service);
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Services</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet"/>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/viewServices.css?v=button-colors-2" />
<style>

:root {
  --btn-green: #5cb85c;
  --btn-green-hover: #16a34a;
  --btn-red: #ef4444;
  --btn-red-hover: #dc2626;
  --btn-grey: #b9bfc4;
  --btn-grey-hover: #a8aeb3;
  --btn-disabled: #d1d5db;
}

/* Top back/close alignment */
.back-link,
.back-button,
.view-back,
.top-back {
  display: inline-flex !important;
  align-items: center !important;
  gap: 8px !important;
  background: transparent !important;
  color: #374151 !important;
  border: none !important;
  text-decoration: none !important;
  font-size: 0.98rem !important;
  font-weight: 800 !important;
  padding: 0 !important;
  transition: color .15s ease, transform .15s ease !important;
}

.back-link:hover,
.back-button:hover,
.view-back:hover,
.top-back:hover {
  color: #111827 !important;
  transform: translateX(-2px) !important;
}

.back-link svg,
.back-button svg,
.view-back svg,
.top-back svg {
  width: 20px !important;
  height: 20px !important;
  fill: none !important;
  stroke: currentColor !important;
  stroke-width: 2.4 !important;
  stroke-linecap: round !important;
  stroke-linejoin: round !important;
}

/* Bottom back buttons are grey */
.btn-back,
.back-bottom,
.bottom-back {
  background: var(--btn-grey) !important;
  border-color: var(--btn-grey) !important;
  color: #ffffff !important;
}

.btn-back:hover,
.back-bottom:hover,
.bottom-back:hover {
  background: var(--btn-grey-hover) !important;
  border-color: var(--btn-grey-hover) !important;
  color: #ffffff !important;
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

<main class="main">
    <div class="container">

        <div class="page-header">
            <div class="page-header-left">
                <div>
                    <h2>Services</h2>
                    <p>View available grooming services and add-ons.</p>
                </div>
            </div>
        </div>

        <section class="card">
            <div class="section-title main-title">
                <span class="dot"></span>
                Main Service
            </div>

            <% if (mainServices.isEmpty()) { %>
                <div class="empty-note">No main services available.</div>
            <% } else { %>
                <div class="svc-grid">
                    <% for (ServiceBean service : mainServices) { %>
                        <article class="svc-card">
                            <div class="svc-top">
                                <div>
                                    <h3 class="svc-name"><%= html(service.getServiceName()) %></h3>
                                    <div class="svc-tags">
                                        <%= serviceBadge(service) %>
                                    </div>
                                </div>
                                <div class="svc-price">RM <%= String.format("%.2f", service.getPrice()) %></div>
                            </div>

                            <p class="svc-desc"><%= html(service.getDescription()) %></p>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>

        <section class="card">
            <div class="section-title addon-title">
                <span class="dot"></span>
                Add-On Services
            </div>

            <% if (addonServices.isEmpty()) { %>
                <div class="empty-note">No add-on services available.</div>
            <% } else { %>
                <div class="svc-grid">
                    <% for (ServiceBean service : addonServices) { %>
                        <article class="svc-card">
                            <div class="svc-top">
                                <div>
                                    <h3 class="svc-name"><%= html(service.getServiceName()) %></h3>
                                    <div class="svc-tags">
                                        <%= serviceBadge(service) %>
                                    </div>
                                </div>
                                <div class="svc-price">RM <%= String.format("%.2f", service.getPrice()) %></div>
                            </div>

                            <p class="svc-desc"><%= html(service.getDescription()) %></p>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>

    </div>
</main>

</body>
</html>
