<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Delete Cat</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/catInformation.css?v=button-colors-1" />
<style>

/* Button color alignment */
.back-button {
  display: inline-flex !important;
  align-items: center !important;
  gap: 8px !important;
  background: transparent !important;
  color: #374151 !important;
  border: none !important;
  text-decoration: none !important;
  font-weight: 800 !important;
  padding: 0 !important;
  margin-bottom: 18px !important;
}

.back-button:hover {
  color: #111827 !important;
}

button[name="action"][value="delete"] {
  background: #ef4444 !important;
  color: #ffffff !important;
}

button[name="action"][value="delete"]:hover {
  background: #dc2626 !important;
}

button[name="action"][value="cancel"] {
  background: #b9bfc4 !important;
  color: #ffffff !important;
}

button[name="action"][value="cancel"]:hover {
  background: #a8aeb3 !important;
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

</style>
</head>
<body>

<div class="app-container">

    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/CatListController" class="back-button">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
        </svg>
        Back
    </a>

    <!-- Card -->
    <div class="card">
        <div class="card-header" style="border-bottom:1px solid #fee2e2;">
            <div style="display:flex;align-items:center;gap:16px;">
                <div style="width:48px;height:48px;border-radius:50%;background:#fee2e2;display:flex;align-items:center;justify-content:center;">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2">
                        <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
                        <circle cx="12" cy="9" r="2.5"/>
                    </svg>
                </div>
                <div>
                    <div class="card-title" style="color:#dc2626;">Delete Cat</div>
                    <div class="card-subtitle">Are you sure you want to delete <strong><c:out value="${cat.catName}"/></strong>?</div>
                </div>
            </div>
        </div>

        <div class="card-body">
            <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px;margin-bottom:24px;">
                <p style="color:#991b1b;font-weight:600;">⚠️ This action cannot be undone!</p>
                <p style="color:#6b7280;font-size:14px;margin-top:4px;">
                    Deleting this cat will remove all associated records.
                </p>
            </div>

            <!-- Cat Details -->
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:24px;background:#f9fafb;padding:16px;border-radius:8px;">
                <div>
                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;">Name</div>
                    <div style="font-size:16px;font-weight:700;color:#111827;"><c:out value="${cat.catName}"/></div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;">Breed</div>
                    <div style="font-size:16px;font-weight:700;color:#111827;"><c:out value="${breed.breedName}"/></div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;">Gender</div>
                    <div style="font-size:16px;font-weight:700;color:#111827;">
                        <c:out value="${cat.gender}"/>
                    </div>
                </div>
                <div>
                    <div style="font-size:11px;font-weight:700;color:#9ca3af;text-transform:uppercase;">Owner</div>
                    <div style="font-size:16px;font-weight:700;color:#111827;"><c:out value="${cust.custFullName}"/></div>
                </div>
            </div>

            <!-- Action Buttons -->
            <form action="${pageContext.request.contextPath}/CatDeleteController" method="post">
                <input type="hidden" name="catID" value="${cat.catID}" />
                <div style="display:flex;gap:12px;">
                    <button type="submit" name="action" value="delete" 
                            style="flex:1;padding:12px 24px;border-radius:8px;border:none;font-weight:600;font-size:14px;font-family:'Nunito',sans-serif;cursor:pointer;background:#ef4444;color:white;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:inline;vertical-align:middle;margin-right:6px;">
                            <path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/>
                            <line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>
                        </svg>
                        Delete
                    </button>
                    <button type="submit" name="action" value="cancel"
                            style="flex:1;padding:12px 24px;border-radius:8px;border:none;font-weight:600;font-size:14px;font-family:'Nunito',sans-serif;cursor:pointer;background:#b9bfc4;color:white;">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>


<%@ include file="/notification.jsp" %>
</body>
</html>