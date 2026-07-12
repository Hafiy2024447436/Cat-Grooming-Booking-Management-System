package catBooking.bean;

import java.util.ArrayList;
import java.util.List;

public class InvoiceBean {
    private int appointmentID;
    private String invoiceNo;
    private String appointmentDate;
    private String appointmentTime;
    private String appointmentStatus;
    private String catName;
    private String staffFullName;
    private String serviceName;
    private double servicePrice;
    private double totalAmount;
    private int custID;
    private String custFullName;
    private String custEmail;
    private List<ServiceLine> services = new ArrayList<>();
    private List<ServiceLine> mainServices = new ArrayList<>();
    private List<ServiceLine> addOnServices = new ArrayList<>();

    public InvoiceBean() {}

    public static class ServiceLine {
        private int serviceID;
        private String serviceName;
        private String category;
        private double price;

        public int getServiceID() { return serviceID; }
        public void setServiceID(int serviceID) { this.serviceID = serviceID; }

        public String getServiceName() { return serviceName; }
        public void setServiceName(String serviceName) { this.serviceName = serviceName; }

        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }

        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
    }

    public int getAppointmentID() { return appointmentID; }
    public void setAppointmentID(int appointmentID) { this.appointmentID = appointmentID; }

    public String getInvoiceNo() { return invoiceNo; }
    public void setInvoiceNo(String invoiceNo) { this.invoiceNo = invoiceNo; }

    public String getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(String appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getAppointmentStatus() { return appointmentStatus; }
    public void setAppointmentStatus(String appointmentStatus) { this.appointmentStatus = appointmentStatus; }

    public String getCatName() { return catName; }
    public void setCatName(String catName) { this.catName = catName; }

    public String getStaffFullName() { return staffFullName; }
    public void setStaffFullName(String staffFullName) { this.staffFullName = staffFullName; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public double getServicePrice() { return servicePrice; }
    public void setServicePrice(double servicePrice) { this.servicePrice = servicePrice; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public int getCustID() { return custID; }
    public void setCustID(int custID) { this.custID = custID; }

    public String getCustFullName() { return custFullName; }
    public void setCustFullName(String custFullName) { this.custFullName = custFullName; }

    public String getCustEmail() { return custEmail; }
    public void setCustEmail(String custEmail) { this.custEmail = custEmail; }

    public List<ServiceLine> getServices() { return services; }
    public void setServices(List<ServiceLine> services) { this.services = services; }

    public List<ServiceLine> getMainServices() { return mainServices; }
    public void setMainServices(List<ServiceLine> mainServices) { this.mainServices = mainServices; }

    public List<ServiceLine> getAddOnServices() { return addOnServices; }
    public void setAddOnServices(List<ServiceLine> addOnServices) { this.addOnServices = addOnServices; }
}
