package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.BreedBean;
import catBooking.bean.CatBean;
import catBooking.bean.CustomerBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import jakarta.servlet.http.Part;
import java.util.ArrayList;
import java.util.List;

public class CustomerCatDAO {

    private static final String SELECT_CATS_BY_CUSTOMER =
        "SELECT c.catID, c.catName, c.custID, c.breedID, c.dateOfBirth " +
        "FROM Cat c " +
        "WHERE c.custID = ? AND COALESCE(c.catStatus, 'Active') = 'Active'";

    private static final String SELECT_BREEDS_BY_CUSTOMER =
        "SELECT b.breedID, b.breedName " +
        "FROM Breed b JOIN Cat c ON b.breedID = c.breedID " +
        "WHERE c.custID = ? AND COALESCE(c.catStatus, 'Active') = 'Active'";

    private static final String SELECT_CUSTS_BY_CUSTOMER =
        "SELECT cu.custID, cu.custFullName " +
        "FROM Customer cu JOIN Cat c ON cu.custID = c.custID " +
        "WHERE c.custID = ? AND COALESCE(c.catStatus, 'Active') = 'Active'";

    private static final String SELECT_ALL_BREEDS =
        "SELECT breedID, breedName FROM Breed ORDER BY breedName";

    private static final String INSERT_CAT =
        "INSERT INTO Cat (catID, catName, dateOfBirth, gender, conditionNotes, catPhoto, custID, breedID, catStatus) " +
        "VALUES (nextval('catid_seq'), ?, ?, ?, ?, ?, ?, ?, 'Active')";

    private static final String SELECT_CAT_BY_ID =
        "SELECT catID, catName, gender, conditionNotes, custID, breedID, dateOfBirth " +
        "FROM Cat " +
        "WHERE catID = ? AND COALESCE(catStatus, 'Active') = 'Active'";

    private static final String SELECT_BREED_BY_ID =
        "SELECT breedID, breedName FROM Breed WHERE breedID = ?";

    private static final String SELECT_CUST_BY_ID =
        "SELECT custID, custFullName FROM Customer WHERE custID = ?";

    private static final String UPDATE_CAT_PROFILE =
        "UPDATE Cat SET catName = ?, conditionNotes = ? " +
        "WHERE catID = ? AND COALESCE(catStatus, 'Active') = 'Active'";

    private static final String UPDATE_CAT_PROFILE_WITH_PHOTO =
        "UPDATE Cat SET catName = ?, conditionNotes = ?, catPhoto = ? " +
        "WHERE catID = ? AND COALESCE(catStatus, 'Active') = 'Active'";

    public static List<CatBean> getCatsByCustomer(int custID) {
        List<CatBean> cats = new ArrayList<>();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_CATS_BY_CUSTOMER)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CatBean cat = new CatBean();
                    cat.setCatID(rs.getInt("catID"));
                    cat.setCatName(rs.getString("catName"));
                    cat.setDateOfBirth(rs.getDate("dateOfBirth"));
                    cat.setCustID(rs.getInt("custID"));
                    cat.setBreedID(rs.getInt("breedID"));
                    cats.add(cat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cats;
    }

    public static List<BreedBean> getBreedsByCat(int custID) {
        List<BreedBean> breeds = new ArrayList<>();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_BREEDS_BY_CUSTOMER)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BreedBean b = new BreedBean();
                    b.setBreedID(rs.getInt("breedID"));
                    b.setBreedName(rs.getString("breedName"));
                    breeds.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return breeds;
    }

    public static List<CustomerBean> getCustByCat(int custID) {
        List<CustomerBean> custs = new ArrayList<>();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_CUSTS_BY_CUSTOMER)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerBean cust = new CustomerBean();
                    cust.setCustID(rs.getInt("custID"));
                    cust.setCustFullName(rs.getString("custFullName"));
                    custs.add(cust);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return custs;
    }

    public static List<BreedBean> getAllBreeds() {
        List<BreedBean> breeds = new ArrayList<>();

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_ALL_BREEDS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BreedBean b = new BreedBean();
                b.setBreedID(rs.getInt("breedID"));
                b.setBreedName(rs.getString("breedName"));
                breeds.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return breeds;
    }

    public static boolean insertCat(CatBean cat) {
        return insertCat(cat, null);
    }

    public static boolean insertCat(CatBean cat, Part photoPart) {
        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_CAT)) {

            ps.setString(1, cat.getCatName());
            ps.setDate(2, cat.getDateOfBirth());
            ps.setString(3, cat.getGender());
            ps.setString(4, cat.getConditionNotes());

            if (photoPart != null && photoPart.getSize() > 0) {
                ps.setBinaryStream(5, photoPart.getInputStream(), photoPart.getSize());
            } else {
                ps.setNull(5, Types.BINARY);
            }

            ps.setInt(6, cat.getCustID());
            ps.setInt(7, cat.getBreedID());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static CatBean getCatByID(int catID) {
        CatBean cat = null;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_CAT_BY_ID)) {

            ps.setInt(1, catID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cat = new CatBean();
                    cat.setCatID(rs.getInt("catID"));
                    cat.setCatName(rs.getString("catName"));
                    cat.setDateOfBirth(rs.getDate("dateOfBirth"));
                    cat.setGender(rs.getString("gender"));
                    cat.setConditionNotes(rs.getString("conditionNotes"));
                    cat.setCustID(rs.getInt("custID"));
                    cat.setBreedID(rs.getInt("breedID"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cat;
    }

    public static BreedBean getBreedByID(int breedID) {
        BreedBean breed = null;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_BREED_BY_ID)) {

            ps.setInt(1, breedID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    breed = new BreedBean();
                    breed.setBreedID(rs.getInt("breedID"));
                    breed.setBreedName(rs.getString("breedName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return breed;
    }

    public static CustomerBean getCustByID(int custID) {
        CustomerBean cust = null;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_CUST_BY_ID)) {

            ps.setInt(1, custID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cust = new CustomerBean();
                    cust.setCustID(rs.getInt("custID"));
                    cust.setCustFullName(rs.getString("custFullName"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cust;
    }

    public static boolean updateProfile(CatBean cat) throws SQLException {
        return updateProfile(cat, null);
    }

    public static boolean updateProfile(CatBean cat, Part photoPart) throws SQLException {
        boolean hasNewPhoto = photoPart != null && photoPart.getSize() > 0;
        String sql = hasNewPhoto ? UPDATE_CAT_PROFILE_WITH_PHOTO : UPDATE_CAT_PROFILE;

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, cat.getCatName());
            ps.setString(2, cat.getConditionNotes());

            if (hasNewPhoto) {
                try {
                    ps.setBinaryStream(3, photoPart.getInputStream(), photoPart.getSize());
                } catch (Exception e) {
                    throw new SQLException("Unable to read uploaded cat photo.", e);
                }
                ps.setInt(4, cat.getCatID());
            } else {
                ps.setInt(3, cat.getCatID());
            }

            return ps.executeUpdate() > 0;
        }
    }
}
