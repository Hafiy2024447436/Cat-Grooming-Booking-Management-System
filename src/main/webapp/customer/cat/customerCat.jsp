<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="catBooking.bean.CatBean, catBooking.bean.BreedBean, catBooking.bean.CustomerBean, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Cat Information</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/customerCat.css?v=register-wide-select-1" />
</head>
<body>

<%
	List<CatBean> cats = (List<CatBean>) request.getAttribute("cats");
	List<BreedBean> breeds = (List<BreedBean>) request.getAttribute("breeds");
	List<CustomerBean> custs = (List<CustomerBean>) request.getAttribute("custs");
	List<BreedBean> allBreeds = (List<BreedBean>) request.getAttribute("allBreeds");
%>

  <main class="main">

    <div class="page-header">
      <div>
        <h1 class="page-title">Cat Information</h1>
        <p class="page-subtitle">Manage your cat profiles and information</p>
      </div>
    </div>

    <!-- Register new cat card -->
    <div class="register-card">
      <div class="register-card-head">
        <h2>Register New Cat</h2>
        <p>Select a breed first before registering your cat.</p>
      </div>

      <select class="breed-select" name="selected-breed" onchange="if(this.value) window.location.href=this.value;">
        <option value="" disabled selected>Select breed</option>
        <% if (allBreeds != null) { %>
          <% for (int i = 0; i < allBreeds.size(); i++) { %>
            <option value="${pageContext.request.contextPath}/RegisterCatController?breedID=<%= allBreeds.get(i).getBreedID() %>">
              <%= allBreeds.get(i).getBreedName() %>
            </option>
          <% } } %>
      </select>
    </div>

    <!-- Cat table -->
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
            <th class="details-col">Cat Details</th>
            <th class="owner-col">Owner</th>
            <th class="action-col">Action</th>
          </tr>
        </thead>
        <tbody>
          <% if (cats != null && !cats.isEmpty()) { 
		       for (int i = 0; i < cats.size(); i++) {
		         CatBean cat       = cats.get(i);
		         BreedBean breed   = breeds.get(i);
		         CustomerBean cust = custs.get(i);
		  %>
          <tr>
            <td>
              <div class="cat-photo-frame">
                <img src="${pageContext.request.contextPath}/CatPhotoController?id=<%= cat.getCatID() %>"
                     alt="<%= cat.getCatName() %>"
                     class="cat-avatar"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                <div class="cat-avatar-placeholder" style="display:none;">
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
            </td>
            <td>
              <div class="cat-name"><%= cat.getCatName() %></div>
              <div class="cat-breed"><%= breed.getBreedName() %></div>
              <div class="cat-age"><%= cat.calculateAgeDisplay() %></div>
            </td>
            <td><span class="owner-name"><%= cust.getCustFullName() %></span></td>
            <td>
              <div class="action-btns">
                <a href="${pageContext.request.contextPath}/ViewCatController?catID=<%= cat.getCatID() %>">
                  <button class="action-btn view" title="View">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                    </svg>
                  </button>
                </a>
                <a href="${pageContext.request.contextPath}/EditCatController?catID=<%= cat.getCatID() %>">
                  <button class="action-btn edit" title="Edit">
                    <svg viewBox="0 0 24 24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </button>
                </a>
              </div>
            </td>
          </tr>
          <% } } else { %>
          <tr>
            <td colspan="4">
              <div class="empty-state">
				<h3>No Cats Registered</h3>
              </div>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </main>


<jsp:include page="/notification.jsp" />
</body>
</html>