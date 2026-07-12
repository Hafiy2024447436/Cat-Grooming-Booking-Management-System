package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.bean.CustomerBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

import jakarta.servlet.http.Part;

public class StaffCatDAO {

    private List<BreedBean> lastBreeds = new ArrayList<>();
    private List<CustomerBean> lastCustomers = new ArrayList<>();

    public List<BreedBean> getLastBreeds() {
        return lastBreeds;
    }

    public List<CustomerBean> getLastCustomers() {
        return lastCustomers;
    }

    public List<CatBean> getAllCats() throws SQLException {
        List<CatBean> cats = new ArrayList<>();
        lastBreeds = new ArrayList<>();
        lastCustomers = new ArrayList<>();

        String sql =
        	    "SELECT c.catID, c.catName, c.dateOfBirth, c.gender, " +
        	    "c.conditionNotes, c.custID, c.breedID, " +
        	    "b.breedName, cu.custFullName " +
        	    "FROM Cat c " +
        	    "LEFT JOIN Breed b ON c.breedID = b.breedID " +
        	    "LEFT JOIN Customer cu ON c.custID = cu.custID " +
        	    "WHERE UPPER(TRIM(COALESCE(c.catStatus, 'Active'))) = 'ACTIVE' " +
        	    "ORDER BY c.catID DESC";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                cats.add(mapCat(rs));
                lastBreeds.add(mapBreed(rs));
                lastCustomers.add(mapCustomer(rs));
            }
        }

        return cats;
    }

    public CatBean getCatById(int catID) throws SQLException {
        lastBreeds = new ArrayList<>();
        lastCustomers = new ArrayList<>();

        String sql =
        	    "SELECT c.catID, c.catName, c.dateOfBirth, c.gender, " +
        	    "c.conditionNotes, c.custID, c.breedID, " +
        	    "b.breedName, cu.custFullName " +
        	    "FROM Cat c " +
        	    "LEFT JOIN Breed b ON c.breedID = b.breedID " +
        	    "LEFT JOIN Customer cu ON c.custID = cu.custID " +
        	    "WHERE c.catID = ? " +
        	    "AND UPPER(TRIM(COALESCE(c.catStatus, 'Active'))) = 'ACTIVE'";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, catID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lastBreeds.add(mapBreed(rs));
                    lastCustomers.add(mapCustomer(rs));
                    return mapCat(rs);
                }
            }
        }

        return null;
    }

    public List<CatBean> searchCats(String searchTerm) throws SQLException {
        List<CatBean> cats = new ArrayList<>();
        lastBreeds = new ArrayList<>();
        lastCustomers = new ArrayList<>();

        String sql =
        	    "SELECT c.catID, c.catName, c.dateOfBirth, c.gender, " +
        	    "c.conditionNotes, c.custID, c.breedID, " +
        	    "b.breedName, cu.custFullName " +
        	    "FROM Cat c " +
        	    "LEFT JOIN Breed b ON c.breedID = b.breedID " +
        	    "LEFT JOIN Customer cu ON c.custID = cu.custID " +
        	    "WHERE UPPER(TRIM(COALESCE(c.catStatus, 'Active'))) = 'ACTIVE' " +
        	    "AND (LOWER(c.catName) LIKE ? " +
        	    "OR LOWER(b.breedName) LIKE ? " +
        	    "OR LOWER(cu.custFullName) LIKE ?) " +
        	    "ORDER BY c.catID DESC";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + searchTerm.toLowerCase() + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cats.add(mapCat(rs));
                    lastBreeds.add(mapBreed(rs));
                    lastCustomers.add(mapCustomer(rs));
                }
            }
        }

        return cats;
    }

    public boolean addCat(CatBean cat) throws SQLException {
        return addCat(cat, null);
    }

    public boolean addCat(CatBean cat, Part photoPart) throws SQLException {
        String sql =
            "INSERT INTO Cat (catID, catName, dateOfBirth, gender, " +
            "conditionNotes, catPhoto, custID, breedID) " +
            "VALUES (nextval('catid_seq'), ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cat.getCatName());
            ps.setDate(2, cat.getDateOfBirth());
            ps.setString(3, cat.getGender());
            ps.setString(4, cat.getConditionNotes());

            if (photoPart != null && photoPart.getSize() > 0) {
                try {
                    ps.setBinaryStream(5, photoPart.getInputStream(), photoPart.getSize());
                } catch (Exception e) {
                    throw new SQLException("Unable to read uploaded cat photo.", e);
                }
            } else {
                ps.setNull(5, Types.BINARY);
            }

            ps.setInt(6, cat.getCustID());
            ps.setInt(7, cat.getBreedID());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateCat(CatBean cat) throws SQLException {
        return updateCat(cat, null);
    }

    public boolean updateCat(CatBean cat, Part photoPart) throws SQLException {
        boolean hasNewPhoto = photoPart != null && photoPart.getSize() > 0;

        String sql = hasNewPhoto
            ? "UPDATE Cat SET catName = ?, dateOfBirth = ?, gender = ?, conditionNotes = ?, catPhoto = ?, breedID = ? WHERE catID = ?"
            : "UPDATE Cat SET catName = ?, dateOfBirth = ?, gender = ?, conditionNotes = ?, breedID = ? WHERE catID = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cat.getCatName());
            ps.setDate(2, cat.getDateOfBirth());
            ps.setString(3, cat.getGender());
            ps.setString(4, cat.getConditionNotes());

            if (hasNewPhoto) {
                try {
                    ps.setBinaryStream(5, photoPart.getInputStream(), photoPart.getSize());
                } catch (Exception e) {
                    throw new SQLException("Unable to read uploaded cat photo.", e);
                }
                ps.setInt(6, cat.getBreedID());
                ps.setInt(7, cat.getCatID());
            } else {
                ps.setInt(5, cat.getBreedID());
                ps.setInt(6, cat.getCatID());
            }

            return ps.executeUpdate() > 0;
        }
    }

    public boolean hasPendingOrConfirmedAppointments(int catID) throws SQLException {
        String sql =
            "SELECT 1 FROM Appointment " +
            "WHERE catID = ? " +
            "AND UPPER(TRIM(appointmentStatus)) IN ('PENDING', 'CONFIRMED') " +
            "AND (recordStatus IS NULL OR UPPER(TRIM(recordStatus)) = 'ACTIVE') " +
            "LIMIT 1";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, catID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean deleteCat(int catID) throws SQLException {
        String sql =
            "UPDATE Cat " +
            "SET catStatus = 'Inactive' " +
            "WHERE catID = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, catID);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<BreedBean> getAllBreeds() throws SQLException {
        List<BreedBean> breeds = new ArrayList<>();

        String sql = "SELECT breedID, breedName FROM Breed ORDER BY breedName";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BreedBean breed = new BreedBean();
                breed.setBreedID(rs.getInt("breedID"));
                breed.setBreedName(rs.getString("breedName"));
                breeds.add(breed);
            }
        }

        return breeds;
    }

    public List<CustomerBean> getAllCustomers() throws SQLException {
        List<CustomerBean> customers = new ArrayList<>();

        String sql =
            "SELECT custID, custFullName " +
            "FROM Customer " +
            "ORDER BY custFullName";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CustomerBean customer = new CustomerBean();
                customer.setCustID(rs.getInt("custID"));
                customer.setCustFullName(rs.getString("custFullName"));
                customers.add(customer);
            }
        }

        return customers;
    }

    public BreedBean getBreedById(int breedID) throws SQLException {
        String sql = "SELECT breedID, breedName FROM Breed WHERE breedID = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, breedID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BreedBean breed = new BreedBean();
                    breed.setBreedID(rs.getInt("breedID"));
                    breed.setBreedName(rs.getString("breedName"));
                    return breed;
                }
            }
        }

        return null;
    }

    public CustomerBean getCustomerById(int custID) throws SQLException {
        String sql = "SELECT custID, custFullName FROM Customer WHERE custID = ?";

        try (Connection conn = ConnectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomerBean customer = new CustomerBean();
                    customer.setCustID(rs.getInt("custID"));
                    customer.setCustFullName(rs.getString("custFullName"));
                    return customer;
                }
            }
        }

        return null;
    }

    private CatBean mapCat(ResultSet rs) throws SQLException {
        CatBean cat = new CatBean();
        cat.setCatID(rs.getInt("catID"));
        cat.setCatName(rs.getString("catName"));
        cat.setDateOfBirth(rs.getDate("dateOfBirth"));
        cat.setGender(rs.getString("gender"));
        cat.setConditionNotes(rs.getString("conditionNotes"));
        cat.setCustID(rs.getInt("custID"));
        cat.setBreedID(rs.getInt("breedID"));
        return cat;
    }

    private BreedBean mapBreed(ResultSet rs) throws SQLException {
        BreedBean breed = new BreedBean();
        breed.setBreedID(rs.getInt("breedID"));
        breed.setBreedName(rs.getString("breedName"));
        return breed;
    }

    private CustomerBean mapCustomer(ResultSet rs) throws SQLException {
        CustomerBean customer = new CustomerBean();
        customer.setCustID(rs.getInt("custID"));
        customer.setCustFullName(rs.getString("custFullName"));
        return customer;
    }
}
