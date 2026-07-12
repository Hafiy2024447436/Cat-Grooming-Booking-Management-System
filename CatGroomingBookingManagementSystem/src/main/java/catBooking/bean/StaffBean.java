package catBooking.bean;

import java.io.Serializable;

public class StaffBean implements Serializable{

	private static final long serialVersionUID = 1L;
	private int staffID; 
	private String staffUsername; 
	private String staffPassword;
	private String staffFullName;
	private String staffPhoneNumber;
	private String staffEmail;
	private String staffAddress;
	private String staffRole;
	private byte[] staffProfilePhoto;
	private String staffStatus;
	private String createdByOwner;
	private int ownerID;
	private boolean loggedIn = false;
	
	public StaffBean() {}

	//getter and setter
	public int getStaffID() {
		return staffID;
	}

	public void setStaffID(int staffID) {
		this.staffID = staffID;
	}

	public String getStaffUsername() {
		return staffUsername;
	}

	public void setStaffUsername(String staffUsername) {
		this.staffUsername = staffUsername;
	}

	public String getStaffPassword() {
		return staffPassword;
	}

	public void setStaffPassword(String staffPassword) {
		this.staffPassword = staffPassword;
	}

	public String getStaffFullName() {
		return staffFullName;
	}

	public void setStaffFullName(String staffFullName) {
		this.staffFullName = staffFullName;
	}

	public String getStaffPhoneNumber() {
		return staffPhoneNumber;
	}

	public void setStaffPhoneNumber(String staffPhoneNumber) {
		this.staffPhoneNumber = staffPhoneNumber;
	}

	public String getStaffEmail() {
		return staffEmail;
	}

	public void setStaffEmail(String staffEmail) {
		this.staffEmail = staffEmail;
	}

	public String getStaffAddress() {
		return staffAddress;
	}

	public void setStaffAddress(String staffAddress) {
		this.staffAddress = staffAddress;
	}

	public String getStaffRole() {
		return staffRole;
	}

	public void setStaffRole(String staffRole) {
		this.staffRole = staffRole;
	}

	public byte[] getStaffProfilePhoto() {
		return staffProfilePhoto;
	}

	public void setStaffProfilePhoto(byte[] staffProfilePhoto) {
		this.staffProfilePhoto = staffProfilePhoto;
	}
	
	public String getStaffStatus() {
	    return staffStatus;
	}

	public void setStaffStatus(String staffStatus) {
	    this.staffStatus = staffStatus;
	}
	
	public String getCreatedByOwner() {
	    return createdByOwner;
	}

	public void setCreatedByOwner(String createdByOwner) {
	    this.createdByOwner = createdByOwner;
	}

	public int getOwnerID() {
		return ownerID;
	}

	public void setOwnerID(int ownerID) {
		this.ownerID = ownerID;
	}

	public boolean isLoggedIn() {
		return loggedIn;
	}
	public void setLoggedIn(boolean loggedIn) {
		this.loggedIn = loggedIn;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
}