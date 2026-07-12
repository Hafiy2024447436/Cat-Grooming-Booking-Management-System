package catBooking.bean;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;

import catBooking.util.DateUtil;

public class CatBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int catID;
    private String catName;
    private Date dateOfBirth;
    private String gender;
    private String conditionNotes;
    private byte[] catPhoto;
    private int custID;
    private int breedID;

    public CatBean() {}

    public int getCatID() {
        return catID;
    }

    public void setCatID(int catID) {
        this.catID = catID;
    }

    public String getCatName() {
        return catName;
    }

    public void setCatName(String catName) {
        this.catName = catName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    // This allows old servlet code that passes String to still work
    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = DateUtil.parseDate(dateOfBirth);
    }

    public String getDateOfBirthDisplay() {
        return DateUtil.formatDate(dateOfBirth);
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getConditionNotes() {
        return conditionNotes;
    }

    public void setConditionNotes(String conditionNotes) {
        this.conditionNotes = conditionNotes;
    }

    public byte[] getCatPhoto() {
        return catPhoto;
    }

    public void setCatPhoto(byte[] catPhoto) {
        this.catPhoto = catPhoto;
    }

    public int getCustID() {
        return custID;
    }

    public void setCustID(int custID) {
        this.custID = custID;
    }

    public int getBreedID() {
        return breedID;
    }

    public void setBreedID(int breedID) {
        this.breedID = breedID;
    }

    public String calculateAgeDisplay() {
        if (dateOfBirth == null) {
            return "Not specified";
        }

        try {
            LocalDate dob = dateOfBirth.toLocalDate();
            Period p = Period.between(dob, LocalDate.now());

            int years = p.getYears();
            int months = p.getMonths();

            if (years == 0 && months == 0) {
                return "Less than a month";
            }

            if (years == 0) {
                return months + (months == 1 ? " month" : " months");
            }

            if (months == 0) {
                return years + (years == 1 ? " year" : " years");
            }

            return years + (years == 1 ? " year" : " years") + " " +
                   months + (months == 1 ? " month" : " months");

        } catch (Exception e) {
            e.printStackTrace();
            return "Invalid date";
        }
    }
    
    public String getAgeDisplay() {
        return calculateAgeDisplay();
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }
}