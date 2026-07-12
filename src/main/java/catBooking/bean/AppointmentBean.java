package catBooking.bean;

import java.io.Serializable;
import java.sql.Date;

public class AppointmentBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int appointmentID;
    private String appointmentNo;
    private int catID;
    private int serviceID;
    private Date appointmentDate;
    private String appointmentTime;
    private String appointmentStatus;
    private Double weight;
    private double totalAmount;
    private int staffID;
    private String recordStatus;

    public AppointmentBean() {}

    public int getAppointmentID() {
        return appointmentID;
    }

    public void setAppointmentID(int appointmentID) {
        this.appointmentID = appointmentID;
    }

    public String getAppointmentNo() {
        if (appointmentNo != null && !appointmentNo.trim().isEmpty()) {
            return appointmentNo;
        }

        if (appointmentDate != null && appointmentID > 0) {
            return String.format("APT-%1$ty%1$tm%1$td-%2$04d", appointmentDate, appointmentID);
        }

        if (appointmentID > 0) {
            return String.format("APT-%04d", appointmentID);
        }

        return "";
    }

    public void setAppointmentNo(String appointmentNo) {
        this.appointmentNo = appointmentNo;
    }

    public int getCatID() {
        return catID;
    }

    public void setCatID(int catID) {
        this.catID = catID;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(String appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getAppointmentStatus() {
        return appointmentStatus;
    }

    public void setAppointmentStatus(String appointmentStatus) {
        this.appointmentStatus = appointmentStatus;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getWeightDisplay() {
        if (weight == null || weight <= 0) {
            return "Not recorded yet";
        }
        return String.format("%.2f kg", weight);
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

	public String getRecordStatus() {
		return recordStatus;
	}

	public void setRecordStatus(String recordStatus) {
		this.recordStatus = recordStatus;
	}
    
}
