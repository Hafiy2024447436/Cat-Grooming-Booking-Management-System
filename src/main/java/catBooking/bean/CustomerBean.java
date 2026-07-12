package catBooking.bean;

import java.io.Serializable;

public class CustomerBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int custID;
    private String custUsername;
    private String custPassword;
    private String custFullName;
    private String custPhoneNumber;
    private String custEmail;
    private byte[] custProfilePhoto;
    private String custStatus;
    private boolean loggedIn = false;

    public CustomerBean() {}

    public int getCustID() { return custID; }
    public void setCustID(int custID) { this.custID = custID; }

    public String getCustUsername() { return custUsername; }
    public void setCustUsername(String custUsername) { this.custUsername = custUsername; }

    public String getCustPassword() { return custPassword; }
    public void setCustPassword(String custPassword) { this.custPassword = custPassword; }

    public String getCustFullName() { return custFullName; }
    public void setCustFullName(String custFullName) { this.custFullName = custFullName; }

    public String getCustPhoneNumber() { return custPhoneNumber; }
    public void setCustPhoneNumber(String custPhoneNumber) { this.custPhoneNumber = custPhoneNumber; }

    public String getCustEmail() { return custEmail; }
    public void setCustEmail(String custEmail) { this.custEmail = custEmail; }

    public byte[] getCustProfilePhoto() { return custProfilePhoto; }
    public void setCustProfilePhoto(byte[] custProfilePhoto) { this.custProfilePhoto = custProfilePhoto; }

    public String getCustStatus() { return custStatus; }
    public void setCustStatus(String custStatus) { this.custStatus = custStatus; }

    public boolean isLoggedIn() { return loggedIn; }
    public void setLoggedIn(boolean loggedIn) { this.loggedIn = loggedIn; }
}