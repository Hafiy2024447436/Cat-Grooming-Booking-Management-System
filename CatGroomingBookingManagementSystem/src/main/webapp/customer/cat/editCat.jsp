<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="catBooking.bean.CatBean, catBooking.bean.BreedBean, catBooking.bean.CustomerBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Cat</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editCatCustomer.css?v=color-standard-1" />
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

    String catName       = cat.getCatName()        != null ? cat.getCatName()        : "";
    String gender        = cat.getGender()          != null ? cat.getGender()          : "Not specified";
    String dob           = cat.getDateOfBirth()     != null ? cat.getDateOfBirthDisplay() : "Not specified";
    String condNotes     = cat.getConditionNotes()  != null ? cat.getConditionNotes()  : "";
    String breedName     = (breed != null)           ? breed.getBreedName()            : "Unknown";
    String ownerName     = (cust  != null)           ? cust.getCustFullName()          : "Unknown";
    String age           = cat.calculateAgeDisplay();
    String errorMsg      = (String) request.getAttribute("errorMsg");
%>

<main class="main">
  <div class="edit-cat-page">

    <div class="page-heading">
      <h1 class="page-title">Edit Cat Information</h1>
      <p class="page-subtitle">Update <%= catName %>'s profile</p>
    </div>

    <% if (errorMsg != null) { %>
      <div class="error-message"><%= errorMsg %></div>
    <% } %>

    <form class="form-card" action="${pageContext.request.contextPath}/EditCatController" method="post" enctype="multipart/form-data" data-disable-validation="true" novalidate>
      <input type="hidden" name="catID" value="<%= cat.getCatID() %>" />

      <div class="form-header">
        <div class="avatar-wrapper">
          <div class="cat-avatar">
            <img src="${pageContext.request.contextPath}/CatPhotoController?id=<%= cat.getCatID() %>"
                 alt="<%= catName %>"
                 id="photoPreview"
                 onerror="this.style.display='none'; document.getElementById('avatarFallback').style.display='flex';" />
            <div class="avatar-fallback" id="avatarFallback">
              <svg viewBox="0 0 80 80" aria-hidden="true">
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

          <label class="avatar-overlay" title="Change cat photo">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
              <circle cx="12" cy="13" r="4"/>
            </svg>
            <input type="file" name="catPhoto" accept="image/*" onchange="previewPhoto(this)" />
          </label>
        </div>

        <div class="header-text">
          <h2><%= catName %></h2>
          <p>Hover the photo to change cat photo</p>
        </div>
      </div>

      <div class="form-grid">
        <div class="full-width">
          <label>Cat Name <span>*</span></label>
          <input type="text" name="catName" value="<%= catName %>" required>
        </div>

        <div>
          <label>Breed</label>
          <div class="owner-read-only">
            <span class="readonly-value"><%= breedName %></span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>

        <div>
          <label>Gender</label>
          <div class="owner-read-only">
            <span class="readonly-value"><%= gender %></span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>

        <div>
          <label>Date of Birth</label>
          <div class="owner-read-only">
            <span class="readonly-value"><%= dob %></span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>

        <div>
          <label>Age</label>
          <div class="owner-read-only">
            <span class="readonly-value"><%= age %></span>
          </div>
        </div>

        <div class="full-width">
          <label>Condition Notes</label>
          <textarea name="conditionNotes" placeholder="Any special care instructions, allergies, or behavioral notes..." rows="4"><%= condNotes %></textarea>
        </div>

        <div class="full-width">
          <label>Owner</label>
          <div class="owner-read-only">
            <span class="readonly-value"><%= ownerName %></span>
            <span class="readonly-note">(Cannot be changed)</span>
          </div>
        </div>
      </div>

      <div class="button-group">
        <button type="button" class="btn btn-cancel"
                onclick="window.location.href='${pageContext.request.contextPath}/CustomerCatController'">
          Cancel
        </button>
        <button type="submit" class="btn btn-save">Save</button>
      </div>
    </form>
  </div>
</main>

<script>
  function previewPhoto(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        var preview = document.getElementById('photoPreview');
        var fallback = document.getElementById('avatarFallback');
        if (preview) {
          preview.src = e.target.result;
          preview.style.display = 'block';
        }
        if (fallback) fallback.style.display = 'none';
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
</script>


  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>
