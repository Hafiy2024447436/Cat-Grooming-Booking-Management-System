<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
private String toastEscape(String value) {
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

private String friendlyToastMessage(String value) {
    if (value == null || value.trim().isEmpty()) {
        return "Something went wrong. Please try again.";
    }

    String key = value.trim();

    if ("fullNameInvalid".equalsIgnoreCase(key)) return "Full name can only contain letters, spaces, hyphens, and apostrophes.";
    if ("phoneInvalid".equalsIgnoreCase(key)) return "Phone number must be 10-11 digits.";
    if ("emailInvalid".equalsIgnoreCase(key)) return "Please enter a valid email address.";
    if ("invalidPassword".equalsIgnoreCase(key)) return "Password must be at least 8 characters.";
    if ("passwordMismatch".equalsIgnoreCase(key)) return "Passwords do not match.";
    if ("failed".equalsIgnoreCase(key)) return "Action failed. Please try again.";
    if ("exception".equalsIgnoreCase(key)) return "Unable to process request. Please try again.";
    if ("deleteFailed".equalsIgnoreCase(key)) return "Delete failed. Please try again.";
    if ("databaseError".equalsIgnoreCase(key)) return "Database error. Please try again.";
    if ("invalidCatID".equalsIgnoreCase(key) || "missingCatID".equalsIgnoreCase(key)) return "Invalid cat record. Please try again.";
    if ("editLocked".equalsIgnoreCase(key)) return "Only pending appointments can be edited.";
    if ("statusLocked".equalsIgnoreCase(key)) return "Completed and cancelled appointment statuses cannot be changed.";
    if ("invalidStatus".equalsIgnoreCase(key)) return "This status change is not allowed.";
    if ("weightRequired".equalsIgnoreCase(key)) return "Please enter the cat weight before confirming this booking.";

    return key.replace("_", " ");
}
%>

<%
String toastType = request.getParameter("notifType");
String toastMsg = request.getParameter("notifMsg");

if (toastMsg == null || toastMsg.trim().isEmpty()) {
    String success = request.getParameter("success");
    String deleteParam = request.getParameter("delete");
    String message = request.getParameter("message");
    String registered = request.getParameter("registered");
    String errorParam = request.getParameter("error");

    Object successAttr = request.getAttribute("successMessage");
    Object errorAttr = request.getAttribute("errorMessage");
    Object genericErrorAttr = request.getAttribute("error");

    if (errorAttr != null && "Invalid username or password.".equals(errorAttr.toString().trim())) {
        errorAttr = null;
    }

    if (genericErrorAttr != null && "Invalid username or password.".equals(genericErrorAttr.toString().trim())) {
        genericErrorAttr = null;
    }

    if ("registered".equalsIgnoreCase(success)) {
        toastType = "create";
        toastMsg = "Account registered successfully. Please log in.";
    } else if ("success".equalsIgnoreCase(registered)) {
        toastType = "create";
        toastMsg = "Staff account registered successfully. Temporary password has been sent.";
    } else if ("true".equalsIgnoreCase(success)) {
        toastType = "create";
        toastMsg = "Action completed successfully.";
    } else if ("created".equalsIgnoreCase(success) || "added".equalsIgnoreCase(success)) {
        toastType = "create";
        toastMsg = "Record created successfully.";
    } else if ("updated".equalsIgnoreCase(success)) {
        toastType = "update";
        toastMsg = "Record updated successfully.";
    } else if ("statusUpdated".equalsIgnoreCase(success)) {
        toastType = "update";
        toastMsg = "Appointment status updated successfully.";
    } else if ("deleted".equalsIgnoreCase(success) || "success".equalsIgnoreCase(deleteParam)) {
        toastType = "delete";
        toastMsg = "Record deleted successfully.";
    } else if ("failed".equalsIgnoreCase(deleteParam)) {
        toastType = "error";
        toastMsg = "Delete failed. Please try again.";
    } else if (message != null && !message.trim().isEmpty()) {
        toastType = "update";
        toastMsg = message;
    } else if (successAttr != null && !successAttr.toString().trim().isEmpty()) {
        toastType = "update";
        toastMsg = successAttr.toString();
    } else if (errorAttr != null && !errorAttr.toString().trim().isEmpty()) {
        toastType = "error";
        toastMsg = errorAttr.toString();
    } else if (genericErrorAttr != null && !genericErrorAttr.toString().trim().isEmpty()) {
        toastType = "error";
        toastMsg = genericErrorAttr.toString();
    } else if (errorParam != null && !errorParam.trim().isEmpty()) {
        toastType = "error";
        toastMsg = friendlyToastMessage(errorParam);
    }
}

if (toastType == null || toastType.trim().isEmpty()) {
    toastType = "update";
}

if (toastMsg != null && !toastMsg.trim().isEmpty()) {
    String typeClass = "system-toast-update";
    String icon = "✓";
    String title = "Updated";

    if ("create".equalsIgnoreCase(toastType) || "register".equalsIgnoreCase(toastType)) {
        typeClass = "system-toast-create";
        icon = "+";
        title = "Success";
    } else if ("confirm".equalsIgnoreCase(toastType)) {
        typeClass = "system-toast-confirm";
        icon = "✓";
        title = "Confirmed";
    } else if ("reject".equalsIgnoreCase(toastType)) {
        typeClass = "system-toast-reject";
        icon = "×";
        title = "Rejected";
    } else if ("delete".equalsIgnoreCase(toastType)) {
        typeClass = "system-toast-delete";
        icon = "!";
        title = "Deleted";
    } else if ("error".equalsIgnoreCase(toastType) || "failed".equalsIgnoreCase(toastType)) {
        typeClass = "system-toast-error";
        icon = "×";
        title = "Error";
    }
%>

<style>
.system-toast-wrap {
    position: fixed;
    top: 22px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 99999;
    width: min(92%, 520px);
    pointer-events: none;
}

.system-toast {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 15px 18px;
    border-radius: 14px;
    border: 1.5px solid;
    box-shadow: 0 18px 40px rgba(15, 23, 42, 0.16);
    font-family: 'Nunito', sans-serif !important;
    animation: systemToastDrop 0.28s ease both;
    pointer-events: auto;
}

.system-toast-icon {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex: 0 0 28px;
    font-size: 15px;
    font-weight: 900;
    line-height: 1;
}

.system-toast-content strong {
    display: block;
    font-size: 0.95rem;
    font-weight: 900;
    line-height: 1.15;
    margin-bottom: 3px;
}

.system-toast-content span {
    display: block;
    font-size: 0.88rem;
    font-weight: 700;
    line-height: 1.4;
}

.system-toast-create {
    background: #f0fdf4;
    border-color: #5cb85c;
    color: #166534;
}

.system-toast-create .system-toast-icon {
    background: #dcfce7;
    color: #16a34a;
}

.system-toast-update,
.system-toast-confirm {
    background: #eff6ff;
    border-color: #3b82f6;
    color: #1d4ed8;
}

.system-toast-update .system-toast-icon,
.system-toast-confirm .system-toast-icon {
    background: #dbeafe;
    color: #2563eb;
}

.system-toast-delete,
.system-toast-reject,
.system-toast-error {
    background: #fef2f2;
    border-color: #ef4444;
    color: #991b1b;
}

.system-toast-delete .system-toast-icon,
.system-toast-reject .system-toast-icon,
.system-toast-error .system-toast-icon {
    background: #fee2e2;
    color: #dc2626;
}

.system-toast.hide {
    animation: systemToastOut 0.25s ease both;
}

@keyframes systemToastDrop {
    from {
        opacity: 0;
        transform: translateY(-16px) scale(0.98);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@keyframes systemToastOut {
    from {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
    to {
        opacity: 0;
        transform: translateY(-12px) scale(0.98);
    }
}
</style>

<div class="system-toast-wrap" id="systemToastWrap">
    <div class="system-toast <%= typeClass %>" id="systemToast">
        <div class="system-toast-icon"><%= icon %></div>
        <div class="system-toast-content">
            <strong><%= title %></strong>
            <span><%= toastEscape(toastMsg) %></span>
        </div>
    </div>
</div>

<script>
(function () {
    var toast = document.getElementById("systemToast");
    if (!toast) return;

    window.setTimeout(function () {
        toast.classList.add("hide");
    }, 3600);

    window.setTimeout(function () {
        var wrap = document.getElementById("systemToastWrap");
        if (wrap && wrap.parentNode) {
            wrap.parentNode.removeChild(wrap);
        }
    }, 3950);

    try {
        var url = new URL(window.location.href);
        ["notifType", "notifMsg", "success", "delete", "message", "registered", "error"].forEach(function (key) {
            url.searchParams.delete(key);
        });

        window.history.replaceState(
            {},
            document.title,
            url.pathname + (url.searchParams.toString() ? "?" + url.searchParams.toString() : "") + url.hash
        );
    } catch (e) {
        // Ignore old browser history cleanup issue
    }
})();
</script>
<% } %>