package catBooking.notification;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class BookingConfirmationEmailPayload {
	private String appointmentNo;
	private String customerName;
	private String customerEmail;
	private String catName;
	private String appointmentDate;
	private String appointmentTime;
	private List<String> services = new ArrayList<>();
	private BigDecimal totalAmount;
	private String assignedStaffName;

	public String getAppointmentNo() {
		return appointmentNo;
	}

	public void setAppointmentNo(String appointmentNo) {
		this.appointmentNo = appointmentNo;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerEmail() {
		return customerEmail;
	}

	public void setCustomerEmail(String customerEmail) {
		this.customerEmail = customerEmail;
	}

	public String getCatName() {
		return catName;
	}

	public void setCatName(String catName) {
		this.catName = catName;
	}

	public String getAppointmentDate() {
		return appointmentDate;
	}

	public void setAppointmentDate(String appointmentDate) {
		this.appointmentDate = appointmentDate;
	}

	public String getAppointmentTime() {
		return appointmentTime;
	}

	public void setAppointmentTime(String appointmentTime) {
		this.appointmentTime = appointmentTime;
	}

	public List<String> getServices() {
		return services;
	}

	public void setServices(List<String> services) {
		this.services = services;
	}

	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getAssignedStaffName() {
		return assignedStaffName;
	}

	public void setAssignedStaffName(String assignedStaffName) {
		this.assignedStaffName = assignedStaffName;
	}
}