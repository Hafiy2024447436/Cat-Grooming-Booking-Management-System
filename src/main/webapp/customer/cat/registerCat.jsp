<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="catBooking.bean.BreedBean, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Register Cat</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/registerCatCustomer.css?v=native-calendar-1" /></head>
<body>

<%
    String breedIDParam = request.getParameter("breedID");
    List<BreedBean> allBreeds = (List<BreedBean>) request.getAttribute("allBreeds");
    String errorMsg   = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
%>

<main class="main">
  <div class="register-cat-page">

    <div class="page-header">
      <div>
        <h1 class="page-title">Cat Information</h1>
        <p class="page-subtitle">Manage your cat profiles and information</p>
      </div>
    </div>

    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>

    <form class="form-card" id="registerCatForm" action="${pageContext.request.contextPath}/RegisterCatController" method="post" enctype="multipart/form-data" data-disable-validation="true" novalidate>
      <input type="hidden" name="breedID" value="<%= breedIDParam != null ? breedIDParam : "" %>" />

      <div class="form-header">
        <div class="avatar-wrapper">
          <div class="cat-avatar">
            <img id="photoPreview" alt="Cat photo preview" />
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

          <label class="avatar-overlay" title="Upload cat photo">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
              <circle cx="12" cy="13" r="4"/>
            </svg>
            <input type="file" name="catPhoto" accept="image/*" onchange="previewPhoto(this)" />
          </label>
        </div>

        <div class="header-text">
          <h2>Register New Cat</h2>
          <p>Hover the photo to upload cat photo</p>
        </div>
      </div>

      <div class="form-grid">
        <div class="form-group full-width">
          <label>Cat Name <span>*</span></label>
          <input type="text" name="catName" id="catName" placeholder="Enter cat's name" required />
        </div>

        <div class="form-group">
          <label>Date of Birth <span>*</span></label>
          <input type="date" name="dateOfBirth" id="dateOfBirth" required />
        </div>

        <div class="form-group">
          <label>Gender</label>
          <select name="gender">
            <option value="">Select gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
          </select>
        </div>

        <div class="form-group full-width">
          <label>Condition Notes</label>
          <textarea name="conditionNotes" placeholder="Any special care instructions, allergies, or behavioral notes..."></textarea>
        </div>
      </div>

      <div class="btn-row">
        <button type="button" class="btn btn-cancel"
                onclick="window.location.href='${pageContext.request.contextPath}/CustomerCatController'">
          Cancel
        </button>
        <button type="submit" class="btn btn-register" id="registerCatBtn" disabled>Register Cat</button>
      </div>
    </form>
  </div>
</main>

<button class="help-btn">?</button>

<script>
  var dateInput = document.getElementById("dateOfBirth");
  if (dateInput) {
    dateInput.max = new Date().toISOString().split("T")[0];
  }

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


  function validateRegisterCatForm() {
    var form = document.getElementById('registerCatForm');
    var catName = document.getElementById('catName');
    var dateOfBirth = document.getElementById('dateOfBirth');
    var submitBtn = document.getElementById('registerCatBtn');

    if (!form || !catName || !dateOfBirth || !submitBtn) return true;

    var nameValid = catName.value.trim().length > 0;
    var dateValid = dateOfBirth.value.trim().length > 0;

    if (dateValid) {
      var selectedDate = new Date(dateOfBirth.value);
      var today = new Date();
      today.setHours(0, 0, 0, 0);
      dateValid = selectedDate <= today;
    }

    submitBtn.disabled = !(nameValid && dateValid);
    return !submitBtn.disabled;
  }

  document.addEventListener('DOMContentLoaded', function() {
    var catName = document.getElementById('catName');
    var dateOfBirth = document.getElementById('dateOfBirth');
    var form = document.getElementById('registerCatForm');

    if (catName) catName.addEventListener('input', validateRegisterCatForm);
    if (dateOfBirth) dateOfBirth.addEventListener('change', validateRegisterCatForm);
    if (form) {
      form.addEventListener('submit', function(e) {
        if (!validateRegisterCatForm()) {
          e.preventDefault();
          if (catName && catName.value.trim().length === 0) catName.focus();
          else if (dateOfBirth) dateOfBirth.focus();
        }
      });
    }

    validateRegisterCatForm();
  });

</script>


  <script src="${pageContext.request.contextPath}/js/formValidation.js"></script>

<%@ include file="/notification.jsp" %>
</body>
</html>
