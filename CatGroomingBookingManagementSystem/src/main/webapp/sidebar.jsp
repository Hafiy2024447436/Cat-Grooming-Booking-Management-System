<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>Meowy Groom</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/sidebar.css?v=sidebar-photo-display-final" />
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>
<body>

<%
    String userRole = (String) session.getAttribute("userRole");
    String userName = (String) session.getAttribute("userName");
    Object userIDObj = session.getAttribute("userID");
    String userID = userIDObj != null ? String.valueOf(userIDObj) : "";

    if (userRole == null) {
        response.sendRedirect("loginPage.jsp");
        return;
    }

    String photoController = "";
    if ("customer".equalsIgnoreCase(userRole)) {
        photoController = request.getContextPath() + "/CustomerPhotoController?id=" + userID;
    } else if ("staff".equalsIgnoreCase(userRole) || "owner".equalsIgnoreCase(userRole)) {
        photoController = request.getContextPath() + "/StaffPhotoController?id=" + userID;
    }

    String sidebarPhotoUrl = "";
    if (photoController != null && !photoController.trim().isEmpty() && userID != null && !userID.trim().isEmpty()) {
        sidebarPhotoUrl = photoController + (photoController.contains("?") ? "&" : "?") + "v=" + System.currentTimeMillis();
    }
%>

<div class="topbar">
  <div class="topbar-logo">
    <img src="<%= request.getContextPath() %>/images/meowy logo.JPG" alt="Meowy Groom logo" />
  </div>
  <h1>Meowy Groom</h1>
</div>

<aside>
  <div class="sidebar-header">
    <div class="sidebar-account-icon" aria-hidden="true" style="position:relative;width:50px;height:50px;min-width:50px;min-height:50px;border-radius:50%;overflow:hidden;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
      <% if (sidebarPhotoUrl != null && !sidebarPhotoUrl.trim().isEmpty()) { %>
        <img
          id="sidebarAccountPhoto"
          class="sidebar-account-photo sidebar-photo-visible"
          style="position:absolute;inset:0;width:100% !important;height:100% !important;max-width:100% !important;max-height:100% !important;object-fit:cover;object-position:center;border-radius:50%;display:block;"
          src="<%= sidebarPhotoUrl %>"
          alt="Account photo"
          onerror="showSidebarPhotoFallback();"
          onload="showSidebarPhotoImage();"
        />
      <% } %>

      <span id="sidebarAccountFallback" class="sidebar-account-fallback <%= (sidebarPhotoUrl != null && !sidebarPhotoUrl.trim().isEmpty()) ? "sidebar-fallback-hidden" : "sidebar-fallback-visible" %>">
        <svg viewBox="0 0 24 24">
          <circle cx="12" cy="8" r="4"></circle>
          <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"></path>
        </svg>
      </span>
    </div>

    <span class="sidebar-title" id="sidebarTitle">My Account</span>
  </div>

  <nav id="navMenu"></nav>

  <div class="logout-area">
    <button class="logout-btn" onclick="handleLogout()">
      <svg viewBox="0 0 24 24">
        <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
        <polyline points="16 17 21 12 16 7"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      Log Out
    </button>
  </div>
</aside>

<div class="content-area">
	<iframe id="contentFrame" src="about:blank" title="Page content" onload="syncActiveFromIframe()"></iframe>
</div>

<script>
  const APP_CONTEXT = '<%= request.getContextPath() %>';
  const SIDEBAR_PHOTO_URL = '<%= sidebarPhotoUrl %>';

  function showSidebarPhotoFallback() {
    var photo = document.getElementById('sidebarAccountPhoto');
    var fallback = document.getElementById('sidebarAccountFallback');

    if (photo) {
      photo.classList.remove('sidebar-photo-visible');
      photo.classList.add('sidebar-photo-hidden');
    }

    if (fallback) {
      fallback.classList.remove('sidebar-fallback-hidden');
      fallback.classList.add('sidebar-fallback-visible');
    }
  }

  function showSidebarPhotoImage() {
    var photo = document.getElementById('sidebarAccountPhoto');
    var fallback = document.getElementById('sidebarAccountFallback');

    if (photo) {
      photo.classList.remove('sidebar-photo-hidden');
      photo.classList.add('sidebar-photo-visible');
    }

    if (fallback) {
      fallback.classList.remove('sidebar-fallback-visible');
      fallback.classList.add('sidebar-fallback-hidden');
    }
  }

  const ICONS = {
    dashboard: '<svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>',
    plus: '<svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>',
    user: '<svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>',
    users: '<svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87"/><path d="M16 3.13a4 4 0 010 7.75"/></svg>',
    cat: '<svg class="cat-face-icon" viewBox="0 0 80 80"><path d="M14 27C12 19 12 9 14 6c7 2 15 9 20 15a29 29 0 0 1 12 0C51 15 59 8 66 6c2 3 2 13 0 21 3 5 5 10 5 16 0 16-14 27-31 27S9 59 9 43c0-6 2-11 5-16z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/><circle cx="28" cy="37" r="3.4" fill="currentColor" stroke="none"/><circle cx="52" cy="37" r="3.4" fill="currentColor" stroke="none"/><path d="M36 45c1.2 2 2.5 3 4 3s2.8-1 4-3" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/><path d="M40 41v7" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/><path d="M34 41h12" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/><path d="M12 43h13M13 50h13M55 43h13M54 50h13" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round"/></svg>',
    grooming: '<svg viewBox="0 0 24 24"><circle cx="6" cy="7" r="3"/><circle cx="6" cy="17" r="3"/><path d="M8.4 8.9 20 20"/><path d="M8.4 15.1 20 4"/><path d="M14.5 5.5h4"/><path d="M16 7.5h2.5"/></svg>',
    calendar: '<svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>',
    calendarClock: '<svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect x="3" y="4" width="18" height="17" rx="2"/><path d="M3 10h18"/><circle cx="17" cy="17" r="4"/><path d="M17 15v2l1.5 1"/></svg>',
    creditcard: '<svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>',
    star: '<svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>',
    trending: '<svg viewBox="0 0 24 24"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>',
    chevron: '<svg class="chevron" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"/></svg>'
  };

  const MENUS = {
    customer: [
      { id:'dashboard', label:'Dashboard', icon:'dashboard', href: APP_CONTEXT + '/CustomerDashboardController' },
      { id:'my-profile', label:'Profile', icon:'user', href: APP_CONTEXT + '/CustomerProfileController' },
      { id:'my-cats', label:'Cat Information', icon:'cat', href: APP_CONTEXT + '/CustomerCatController' },
      { id:'service-info', label:'Services', icon:'grooming', href: APP_CONTEXT + '/ServiceListController' },
      { id:'book-appointment', label:'Book Appointment', icon:'calendarClock', href: APP_CONTEXT + '/CheckAvailabilityController' },
      { id:'my-appointments', label:'Appointments', icon:'calendar', href: APP_CONTEXT + '/CustomerAppointmentController' },
      { id:'my-invoices', label:'Invoices', icon:'creditcard', href: APP_CONTEXT + '/CustomerInvoiceController' }
    ],

    staff: [
      { id:'dashboard', label:'Dashboard', icon:'dashboard', href: APP_CONTEXT + '/DashboardController' },
      { id:'user-info', label:'Profile', icon:'users', href: APP_CONTEXT + '/StaffController' },
      { id:'cat-info', label:'Cat Information', icon:'cat', href: APP_CONTEXT + '/CatListController' },
      { id:'service-info', label:'Services', icon:'grooming', href: APP_CONTEXT + '/ServiceListController' },
      { id:'appointment', label:'Appointments', icon:'calendar', href: APP_CONTEXT + '/StaffAppointmentController' },
      { id:'approve-bookings', label:'Confirm Bookings', icon:'star', href: APP_CONTEXT + '/ConfirmBookingController' },
      { id:'payment', label:'Invoices', icon:'creditcard', href: APP_CONTEXT + '/MainInvoiceController' }
    ],

    owner: [
      { id:'dashboard', label:'Dashboard', icon:'dashboard', href: APP_CONTEXT + '/DashboardController' },
      {
        id:'user-info',
        label:'Profile',
        icon:'users',
        href: APP_CONTEXT + '/OwnerController',
        children: [
          { id:'register-staff', label:'Register Staff', icon:'plus', href: APP_CONTEXT + '/RegisterStaffController' }
        ]
      },
      { id:'cat-info', label:'Cat Information', icon:'cat', href: APP_CONTEXT + '/CatListController' },
      { id:'service-info', label:'Services', icon:'grooming', href: APP_CONTEXT + '/ManageServicesController' },
      { id:'appointment', label:'Appointments', icon:'calendar', href: APP_CONTEXT + '/StaffAppointmentController' },
      { id:'approve-bookings', label:'Confirm Bookings', icon:'star', href: APP_CONTEXT + '/ConfirmBookingController' },
      { id:'payment', label:'Invoices', icon:'creditcard', href: APP_CONTEXT + '/MainInvoiceController' },
      { id:'sales-report', label:'Sales Report', icon:'trending', href: APP_CONTEXT + '/SalesReportController' }
    ]
  };

  const TITLES = {
    customer: 'My Account',
    staff: 'Staff Account',
    owner: 'Owner Account'
  };

  var role = '<%= session.getAttribute("userRole") %>';
  var activePage = '';
  var openDropdown = '';

  function navigate(id, href) {
    activePage = id;
    document.getElementById('contentFrame').src = href;

    var parentId = findParentId(id);
    if (parentId) {
      openDropdown = parentId;
    }

    renderNav();
  }

  function findParentId(childId) {
    var items = MENUS[role] || [];

    for (var i = 0; i < items.length; i++) {
      if (items[i].children) {
        for (var j = 0; j < items[i].children.length; j++) {
          if (items[i].children[j].id === childId) {
            return items[i].id;
          }
        }
      }
    }

    return '';
  }

  function hasActiveChild(item) {
    if (!item.children) {
      return false;
    }

    for (var i = 0; i < item.children.length; i++) {
      if (item.children[i].id === activePage) {
        return true;
      }
    }

    return false;
  }

  function navigateParent(id, href) {
    var frame = document.getElementById('contentFrame');

    activePage = id;

    if (openDropdown === id) {
      openDropdown = '';
    } else {
      openDropdown = id;
    }

    if (frame && href) {
      frame.src = href;
    }

    renderNav();
  }

  function renderNav() {
    var items = MENUS[role] || [];
    var html = '';

    for (var i = 0; i < items.length; i++) {
      var item = items[i];

      if (item.children && item.children.length > 0) {
        var isOpen = openDropdown === item.id;
        var isActive = activePage === item.id || hasActiveChild(item);

        html += '<div class="nav-group' + (isOpen ? ' open' : '') + '">';
        html += '<button class="nav-item nav-parent' + (isActive ? ' active' : '') + '" onclick="navigateParent(\'' + item.id + '\', \'' + item.href + '\')">';
        html += '<span class="nav-parent-left">';
        html += (ICONS[item.icon] || '');
        html += '<span>' + item.label + '</span>';
        html += '</span>';
        html += ICONS.chevron;
        html += '</button>';
        html += '<div class="submenu">';

        for (var c = 0; c < item.children.length; c++) {
          var child = item.children[c];
          var childActive = activePage === child.id ? ' active' : '';

          html += '<button class="nav-subitem' + childActive + '" onclick="navigate(\'' + child.id + '\', \'' + child.href + '\')">';
          html += (ICONS[child.icon] || '');
          html += '<span>' + child.label + '</span>';
          html += '</button>';
        }

        html += '</div>';
        html += '</div>';
      } else {
        var activeClass = activePage === item.id ? ' active' : '';

        html += '<button class="nav-item' + activeClass + '" onclick="navigate(\'' + item.id + '\', \'' + item.href + '\')">';
        html += (ICONS[item.icon] || '');
        html += '<span>' + item.label + '</span>';
        html += '</button>';
      }
    }

    document.getElementById('navMenu').innerHTML = html;
    document.getElementById('sidebarTitle').textContent = TITLES[role];
  }

  function refreshSidebarPhoto() {
    if (!SIDEBAR_PHOTO_URL) {
      return;
    }

    var photo = document.getElementById('sidebarAccountPhoto');
    var fallback = document.getElementById('sidebarAccountFallback');

    if (!photo) {
      return;
    }

    photo.onerror = function() {
      photo.style.display = 'none';
      if (fallback) {
        fallback.style.display = 'flex';
      }
    };

    photo.onload = function() {
      photo.style.display = 'block';
      if (fallback) {
        fallback.style.display = 'none';
      }
    };

    photo.src = SIDEBAR_PHOTO_URL + (SIDEBAR_PHOTO_URL.indexOf('?') !== -1 ? '&' : '?') + 'v=' + new Date().getTime();
  }

  function handleLogout() {
    if (confirm('Are you sure you want to log out?')) {
      window.location.href = APP_CONTEXT + '/LogoutController';
    }
  }

  function syncActiveFromIframe() {
      refreshSidebarPhoto();

	  var frame = document.getElementById('contentFrame');
	  var framePath = '';

	  try {
	    framePath = frame.contentWindow.location.pathname;
	  } catch (e) {
	    return;
	  }

	  if (!framePath || framePath === 'blank') {
	    return;
	  }

	  var items = MENUS[role] || [];

	  for (var i = 0; i < items.length; i++) {
	    if (isSamePage(framePath, items[i].href)) {
	      activePage = items[i].id;

	      if (!items[i].children || items[i].children.length === 0) {
	        openDropdown = '';
	      }

	      renderNav();
	      return;
	    }

	    if (items[i].children) {
	      for (var j = 0; j < items[i].children.length; j++) {
	        if (isSamePage(framePath, items[i].children[j].href)) {
	          activePage = items[i].children[j].id;
	          openDropdown = items[i].id;
	          renderNav();
	          return;
	        }
	      }
	    }
	  }
	}

	function isSamePage(framePath, href) {
	  var link = document.createElement('a');
	  link.href = href;

	  return framePath === link.pathname;
	}
	
  (function init() {
    var items = MENUS[role] || [];

    if (items.length) {
      activePage = items[0].id;
      document.getElementById('contentFrame').src = items[0].href;
    }

    renderNav();
  })();
</script>


<%@ include file="/notification.jsp" %>
</body>
</html>