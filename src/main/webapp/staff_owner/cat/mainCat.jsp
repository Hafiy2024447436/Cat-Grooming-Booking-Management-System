<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List"%>
<%@ page import="catBooking.bean.CatBean"%>
<%@ page import="catBooking.bean.BreedBean"%>
<%@ page import="catBooking.bean.CustomerBean"%>

<%
List<CatBean> cats = (List<CatBean>) request.getAttribute("cats");
List<BreedBean> breeds = (List<BreedBean>) request.getAttribute("breeds");
List<CustomerBean> custs = (List<CustomerBean>) request.getAttribute("custs");

if (cats == null) cats = new java.util.ArrayList<>();
if (breeds == null) breeds = new java.util.ArrayList<>();
if (custs == null) custs = new java.util.ArrayList<>();

String search = request.getParameter("search");
if (search == null) search = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cat Information</title>

<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mainCat.css?v=size-delete-popup-1" />

<style>
  /* Empty cat list message */
  .empty-state {
    padding: 44px 20px !important;
    text-align: center !important;
  }

  .empty-state h3 {
    font-size: 1.08rem !important;
    font-weight: 900 !important;
    color: #111827 !important;
    margin-top: 8px !important;
  }

  .empty-state p {
    color: #6b7280 !important;
    font-size: 0.9rem !important;
    font-weight: 700 !important;
    margin-top: 4px !important;
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
  <div class="page-header">
    <div>
      <h1 class="page-title">Cat Information</h1>
      <p class="page-subtitle">Manage your cat profiles and information</p>
    </div>
  </div>

  <c:if test="${not empty param.error}">
    <div class="alert-error">Failed to process request. Please try again.</div>
  </c:if>

  <div class="search-card">
    <div class="search-card-head">
      <h2>Find Cat</h2>
      <p>Search registered cats by name or breed.</p>
    </div>

    <form action="${pageContext.request.contextPath}/CatListController" method="get" class="search-form">
      <span class="search-icon" aria-hidden="true">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="11" cy="11" r="8"></circle>
          <path d="m21 21-4.35-4.35"></path>
        </svg>
      </span>
      <input type="text" name="search" class="search-input" placeholder="Search by cat name or breed..." value="<%= search %>">
    </form>
  </div>

  <div class="table-card">
    <div class="table-card-head">
      <div>
        <h2>My Cats</h2>
        <p>View and manage your registered cats.</p>
      </div>
    </div>

    <table class="cat-table">
      <thead>
        <tr>
          <th class="photo-col">Cat Photo</th>
          <th>Cat Details</th>
          <th>Owner</th>
          <th class="action-col">Action</th>
        </tr>
      </thead>
      <tbody>
        <% if (cats != null && !cats.isEmpty()) {
             for (int i = 0; i < cats.size(); i++) {
               CatBean cat = cats.get(i);
               BreedBean breed = (breeds != null && i < breeds.size()) ? breeds.get(i) : null;
               CustomerBean cust = (custs != null && i < custs.size()) ? custs.get(i) : null;

               String breedName = (breed != null && breed.getBreedName() != null && !breed.getBreedName().trim().isEmpty())
                       ? breed.getBreedName() : "Not specified";
               String ownerName = (cust != null && cust.getCustFullName() != null && !cust.getCustFullName().trim().isEmpty())
                       ? cust.getCustFullName() : "Not assigned";
        %>
        <tr>
          <td>
            <div class="cat-photo-frame">
              
                <img src="${pageContext.request.contextPath}/CatPhotoController?id=<%= cat.getCatID() %>"
                     alt="<%= cat.getCatName() %>"
                     class="cat-avatar"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                <div class="cat-avatar-placeholder" style="display:none;">
                  <svg viewBox="0 0 80 80" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="6" stroke-linecap="round" stroke-linejoin="round">
                    
                    <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z"/>
                    <circle cx="28" cy="37" r="3.4"/>
                    <circle cx="52" cy="37" r="3.4"/>
                    <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3"/>
                    <path d="M40 41v7"/>
                    <path d="M34 41h12"/>
                    <path d="M12 43h13M13 50h13M55 43h13M54 50h13"/>
                  </svg>
                </div>
            </div>
          </td>

          <td>
            <div class="cat-name"><%= cat.getCatName() %></div>
            <div class="cat-breed"><%= breedName %></div>
            <div class="cat-age"><%= cat.calculateAgeDisplay() %></div>
          </td>

          <td><span class="owner-name"><%= ownerName %></span></td>

          <td>
            <div class="action-btns">
              <a href="${pageContext.request.contextPath}/CatViewController?id=<%= cat.getCatID() %>" class="action-btn view btn-view" title="View">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
              </a>

              <a href="${pageContext.request.contextPath}/CatEditController?id=<%= cat.getCatID() %>" class="action-btn edit btn-edit" title="Edit">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
              </a>

              <button type="button" class="action-btn delete btn-delete" title="Delete"
                      data-catid="<%= cat.getCatID() %>"
                      data-catname="<%= cat.getCatName() %>"
                      onclick="openDeletePopup(this)">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M3 6h18"/>
                  <path d="M8 6V4h8v2"/>
                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/>
                  <line x1="10" y1="11" x2="10" y2="17"/>
                  <line x1="14" y1="11" x2="14" y2="17"/>
                </svg>
              </button>
            </div>
          </td>
        </tr>
        <% }
           } else { %>
        <tr>
          <td colspan="4">
            <div class="empty-state">
              <div class="empty-icon">🐱</div>
              <h3>No Cats Registered</h3>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</main>

<div id="deletePopup" class="delete-overlay">
  <div class="delete-modal">
    <div class="delete-header">
      <div class="delete-icon">
        <svg viewBox="0 0 24 24">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
          <line x1="12" y1="9" x2="12" y2="13"></line>
          <line x1="12" y1="17" x2="12.01" y2="17"></line>
        </svg>
      </div>

      <h3>Delete Cat</h3>
    </div>

    <p>
      Are you sure you want to delete cat
      <strong id="deleteCatName">this cat</strong>? This action cannot be undone.
    </p>

    <form action="${pageContext.request.contextPath}/CatDeleteController" method="post">
      <input type="hidden" name="catID" id="deleteCatID">
      <input type="hidden" name="action" value="delete">

      <div class="delete-actions">
        <button type="button" class="btn-cancel-delete" onclick="closeDeletePopup()">Cancel</button>
        <button type="submit" class="btn-confirm-delete">Delete</button>
      </div>
    </form>
  </div>
</div>

<script>
function openDeletePopup(button) {
  const catID = button.getAttribute("data-catid");
  const catName = button.getAttribute("data-catname");

  document.getElementById("deleteCatID").value = catID;
  document.getElementById("deleteCatName").textContent = catName || "this cat";
  document.getElementById("deletePopup").classList.add("open");
}

function closeDeletePopup() {
  document.getElementById("deletePopup").classList.remove("open");
}

document.getElementById("deletePopup").addEventListener("click", function(event) {
  if (event.target === this) {
    closeDeletePopup();
  }
});
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>
