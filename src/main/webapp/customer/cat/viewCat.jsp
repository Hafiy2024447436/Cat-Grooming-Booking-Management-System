<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="catBooking.bean.CatBean, catBooking.bean.BreedBean, catBooking.bean.CustomerBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>View Cat</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewCatCustomer.css?v=no-owner-pill-1" />
</head>
<body>

<%
    CatBean cat = (CatBean) request.getAttribute("cat");
    BreedBean breed = (BreedBean) request.getAttribute("breed");
    CustomerBean cust = (CustomerBean) request.getAttribute("cust");

    if (cat == null) {
        response.sendRedirect(request.getContextPath() + "/CustomerCatController");
        return;
    }

    String catName      = cat.getCatName();
    String age          = cat.calculateAgeDisplay();
    String gender       = cat.getGender()         != null ? cat.getGender()         : "Not specified";
    String notes        = cat.getConditionNotes()  != null ? cat.getConditionNotes()  : "No condition notes recorded";
    String breedName    = (breed != null)           ? breed.getBreedName()            : "Unknown";
    String ownerName    = (cust  != null)           ? cust.getCustFullName()          : "Unknown";
    String dob          = cat.getDateOfBirth()     != null ? cat.getDateOfBirthDisplay() : "Not specified";
%>

<!-- SVG symbol defs -->
<svg xmlns="http://www.w3.org/2000/svg" style="display:none">
  <symbol id="ico-cat" viewBox="0 0 80 80">
    <path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/>
    <circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/>
    <circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/>
    <path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
    <path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
    <path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
    <path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
  </symbol>
  <symbol id="ico-user" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
  </symbol>
  <symbol id="ico-users" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
  </symbol>
  <symbol id="ico-calendar" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>
  </symbol>
  <symbol id="ico-file" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
    <polyline points="14 2 14 8 20 8"/>
    <line x1="16" y1="13" x2="8" y2="13"/>
    <line x1="16" y1="17" x2="8" y2="17"/>
  </symbol>
  <symbol id="ico-arrow-left" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
  </symbol>
</svg>

<main class="main">

  <!-- Page heading -->
  <div class="page-heading">
    <h1 class="page-title">Cat Information</h1>
    <p class="page-subtitle">Manage your cat profiles and information</p>
  </div>

  <!-- Back link -->
  <button class="back-link" onclick="window.location.href='${pageContext.request.contextPath}/CustomerCatController'">
    <svg><use href="#ico-arrow-left" /></svg>
    Back
  </button>

  <!-- Profile card -->
  <div class="profile-card">

    <!-- Hero row: photo + name + breed + owner pill -->
    <div class="hero-row">
      <div class="cat-avatar-placeholder">
        
          <img src="${pageContext.request.contextPath}/CatPhotoController?id=<%= cat.getCatID() %>"
               alt="<%= catName %>"
               class="cat-avatar"
               onerror="this.style.display='none'; document.getElementById('catDefaultIcon').style.display='flex';" />
          <div class="cat-default-icon" id="catDefaultIcon" style="display:none;">
            <svg><use href="#ico-cat" /></svg>
          </div>
</div>
      <div class="hero-info">
        <span class="hero-name"><%= catName %></span>
        <span class="hero-breed"><%= breedName %></span>
</div>
    </div>

    <!-- Info grid -->
    <div class="info-grid">

      <!-- Age -->
      <div class="info-field">
        <span class="field-label">
          <svg><use href="#ico-calendar"/></svg>Age
        </span>
        <div class="field-value"><%= age %></div>
      </div>

      <!-- Gender -->
      <div class="info-field">
        <span class="field-label">
          <svg><use href="#ico-users"/></svg>Gender
        </span>
        <div class="field-value"><%= gender %></div>
      </div>

      <!-- Date of Birth -->
      <div class="info-field">
        <span class="field-label">
          <svg><use href="#ico-calendar"/></svg>Date of Birth
        </span>
        <div class="field-value"><%= dob %></div>
      </div>

      <!-- Breed -->
      <div class="info-field">
        <span class="field-label">
          <svg class="cat-label-icon"><use href="#ico-cat"/></svg>Breed
        </span>
        <div class="field-value"><%= breedName %></div>
      </div>

      <!-- Owner -->
      <div class="info-field full">
        <span class="field-label">
          <svg><use href="#ico-user"/></svg>Owner
        </span>
        <div class="field-value"><%= ownerName %></div>
      </div>

      <!-- Condition Notes -->
      <div class="info-field full">
        <span class="field-label">
          <svg><use href="#ico-file"/></svg>Condition Notes
        </span>
        <div class="field-value notes"><%= notes %></div>
      </div>

    </div><!-- /info-grid -->
  </div><!-- /profile-card -->

</main>


</body>
</html>
