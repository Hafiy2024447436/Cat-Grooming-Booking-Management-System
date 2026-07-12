package catBooking.dao;

import catBooking.ConnectionManager;
import catBooking.bean.FurBasedServiceBean;
import catBooking.bean.ServiceBean;
import catBooking.bean.WeightBasedServiceBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    private String normalizeCategoryForDb(String category) {
        if (category == null) {
            return "ADDON";
        }

        String clean = category.trim();

        if (clean.equalsIgnoreCase("MAIN")) {
            return "MAIN";
        }

        if (clean.equalsIgnoreCase("ADDON") || clean.equalsIgnoreCase("ADD-ON")
                || clean.equalsIgnoreCase("Add-On")) {
            return "ADDON";
        }

        return clean.toUpperCase();
    }

    private String normalizeFurTypeForDb(String furType) {
        if (furType == null) {
            return "";
        }

        String clean = furType.trim();

        if (clean.equalsIgnoreCase("SHORT")) {
            return "Short";
        }

        if (clean.equalsIgnoreCase("LONG")) {
            return "Long";
        }

        return clean;
    }


    private int getNextServiceID(Connection con) throws SQLException {
        String sql = "SELECT nextval('serviceid_seq') AS nextID";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("nextID");
            }
        }

        return -1;
    }

    private static final String BASE_SELECT =
            "SELECT s.serviceID, s.serviceName, s.category, s.description, s.price, "
          + "f.furType, w.weightRange "
          + "FROM Service s "
          + "LEFT JOIN FurBasedService f ON s.serviceID = f.serviceID "
          + "LEFT JOIN WeightBasedService w ON s.serviceID = w.serviceID ";

    public List<ServiceBean> getAllServices() {
        List<ServiceBean> services = new ArrayList<>();

        String sql = BASE_SELECT
                + "ORDER BY s.serviceID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }

    public List<ServiceBean> getMainGroomingPackages() {
        List<ServiceBean> services = new ArrayList<>();

        String sql = BASE_SELECT
                + "WHERE UPPER(TRIM(s.category)) = 'MAIN' "
                + "ORDER BY s.serviceName, f.furType, w.weightRange, s.serviceID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }

    public List<ServiceBean> getAddOnServices() {
        List<ServiceBean> services = new ArrayList<>();

        String sql = BASE_SELECT
                + "WHERE REPLACE(UPPER(TRIM(s.category)), '-', '') = 'ADDON' "
                + "ORDER BY s.serviceID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }

    public ServiceBean getServiceById(int serviceID) {
        String sql = BASE_SELECT
                + "WHERE s.serviceID = ?";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<ServiceBean> getServicesByIds(String serviceIDs) {
        List<ServiceBean> services = new ArrayList<>();

        if (serviceIDs == null || serviceIDs.trim().isEmpty()) {
            return services;
        }

        String[] ids = serviceIDs.split(",");

        for (String idValue : ids) {
            try {
                int serviceID = Integer.parseInt(idValue.trim());
                ServiceBean service = getServiceById(serviceID);

                if (service != null) {
                    services.add(service);
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        return services;
    }

    public List<ServiceBean> getAllServicesForManagement() {
        List<ServiceBean> services = new ArrayList<>();

        String sql = BASE_SELECT
                + "ORDER BY CASE WHEN UPPER(TRIM(s.category)) = 'MAIN' THEN 1 ELSE 2 END, s.serviceName, f.furType, w.weightRange, s.serviceID";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }

    private ServiceBean mapRow(ResultSet rs) throws SQLException {
        String furType = rs.getString("furType");
        String weightRange = rs.getString("weightRange");

        ServiceBean service;

        if (furType != null && !furType.trim().isEmpty()) {
            FurBasedServiceBean furService = new FurBasedServiceBean();
            furService.setFurType(furType.trim().toUpperCase());
            service = furService;

        } else if (weightRange != null && !weightRange.trim().isEmpty()) {
            WeightBasedServiceBean weightService = new WeightBasedServiceBean();
            weightService.setWeightRange(weightRange.trim());
            service = weightService;

        } else {
            service = new ServiceBean();
        }

        service.setServiceID(rs.getInt("serviceID"));
        service.setServiceName(rs.getString("serviceName"));
        service.setCategory(rs.getString("category"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getDouble("price"));

        return service;
    }

    public boolean addService(ServiceBean service) {
        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            int serviceID = getNextServiceID(con);

            if (serviceID <= 0) {
                con.rollback();
                return false;
            }

            String sql = "INSERT INTO Service "
                    + "(serviceID, serviceName, category, description, price) "
                    + "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                String category = service.getCategory();

                if (category == null || category.trim().isEmpty()) {
                    category = "ADDON";
                }

                ps.setInt(1, serviceID);
                ps.setString(2, service.getServiceName());
                ps.setString(3, normalizeCategoryForDb(category));
                ps.setString(4, service.getDescription());
                ps.setDouble(5, service.getPrice());

                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public boolean addMainFurTypeService(String shortServiceName,
                                         String shortDescription,
                                         double priceShort,
                                         String longServiceName,
                                         String longDescription,
                                         double priceLong) {
        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            int shortServiceID = getNextServiceID(con);
            int longServiceID = getNextServiceID(con);

            if (shortServiceID <= 0 || longServiceID <= 0) {
                con.rollback();
                return false;
            }

            String serviceSql = "INSERT INTO Service "
                    + "(serviceID, serviceName, category, description, price) "
                    + "VALUES (?, ?, 'MAIN', ?, ?)";

            String furSql = "INSERT INTO FurBasedService "
                    + "(serviceID, furType) "
                    + "VALUES (?, ?)";

            try (PreparedStatement psService = con.prepareStatement(serviceSql);
                 PreparedStatement psFur = con.prepareStatement(furSql)) {

                psService.setInt(1, shortServiceID);
                psService.setString(2, shortServiceName);
                psService.setString(3, shortDescription);
                psService.setDouble(4, priceShort);
                psService.executeUpdate();

                psFur.setInt(1, shortServiceID);
                psFur.setString(2, "Short");
                psFur.executeUpdate();

                psService.setInt(1, longServiceID);
                psService.setString(2, longServiceName);
                psService.setString(3, longDescription);
                psService.setDouble(4, priceLong);
                psService.executeUpdate();

                psFur.setInt(1, longServiceID);
                psFur.setString(2, "Long");
                psFur.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public boolean addMainWeightBasedService(String serviceName, String description,
                                             List<String> weightRanges, List<Double> prices) {
        if (weightRanges == null || prices == null || weightRanges.isEmpty()
                || weightRanges.size() != prices.size()) {
            return false;
        }

        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            String serviceSql = "INSERT INTO Service "
                    + "(serviceID, serviceName, category, description, price) "
                    + "VALUES (?, ?, 'MAIN', ?, ?)";

            String weightSql = "INSERT INTO WeightBasedService "
                    + "(serviceID, weightRange) "
                    + "VALUES (?, ?)";

            try (PreparedStatement psService = con.prepareStatement(serviceSql);
                 PreparedStatement psWeight = con.prepareStatement(weightSql)) {

                for (int i = 0; i < weightRanges.size(); i++) {
                    int serviceID = getNextServiceID(con);

                    if (serviceID <= 0) {
                        con.rollback();
                        return false;
                    }

                    psService.setInt(1, serviceID);
                    psService.setString(2, serviceName);
                    psService.setString(3, description);
                    psService.setDouble(4, prices.get(i));
                    psService.executeUpdate();

                    psWeight.setInt(1, serviceID);
                    psWeight.setString(2, weightRanges.get(i));
                    psWeight.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public boolean updateService(ServiceBean service) {
        Connection con = null;

        try {
            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            String serviceSql = "UPDATE Service "
                    + "SET serviceName = ?, description = ?, price = ? "
                    + "WHERE serviceID = ?";

            try (PreparedStatement ps = con.prepareStatement(serviceSql)) {
                ps.setString(1, service.getServiceName());
                ps.setString(2, service.getDescription());
                ps.setDouble(3, service.getPrice());
                ps.setInt(4, service.getServiceID());

                ps.executeUpdate();
            }

            if (service instanceof FurBasedServiceBean) {
                String furType = ((FurBasedServiceBean) service).getFurType();

                deleteWeightBasedService(con, service.getServiceID());
                upsertFurBasedService(con, service.getServiceID(), furType);

            } else if (service instanceof WeightBasedServiceBean) {
                String weightRange = ((WeightBasedServiceBean) service).getWeightRange();

                deleteFurBasedService(con, service.getServiceID());
                upsertWeightBasedService(con, service.getServiceID(), weightRange);

            } else {
                deleteFurBasedService(con, service.getServiceID());
                deleteWeightBasedService(con, service.getServiceID());
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    private void upsertFurBasedService(Connection con, int serviceID, String furType) throws SQLException {
        String updateSql = "UPDATE FurBasedService SET furType = ? WHERE serviceID = ?";

        try (PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setString(1, normalizeFurTypeForDb(furType));
            ps.setInt(2, serviceID);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                return;
            }
        }

        String insertSql = "INSERT INTO FurBasedService (serviceID, furType) VALUES (?, ?)";

        try (PreparedStatement ps = con.prepareStatement(insertSql)) {
            ps.setInt(1, serviceID);
            ps.setString(2, normalizeFurTypeForDb(furType));
            ps.executeUpdate();
        }
    }

    private void upsertWeightBasedService(Connection con, int serviceID, String weightRange) throws SQLException {
        String updateSql = "UPDATE WeightBasedService SET weightRange = ? WHERE serviceID = ?";

        try (PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setString(1, weightRange == null ? "" : weightRange.trim());
            ps.setInt(2, serviceID);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                return;
            }
        }

        String insertSql = "INSERT INTO WeightBasedService (serviceID, weightRange) VALUES (?, ?)";

        try (PreparedStatement ps = con.prepareStatement(insertSql)) {
            ps.setInt(1, serviceID);
            ps.setString(2, weightRange == null ? "" : weightRange.trim());
            ps.executeUpdate();
        }
    }

    private void deleteFurBasedService(Connection con, int serviceID) throws SQLException {
        String sql = "DELETE FROM FurBasedService WHERE serviceID = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            ps.executeUpdate();
        }
    }

    private void deleteWeightBasedService(Connection con, int serviceID) throws SQLException {
        String sql = "DELETE FROM WeightBasedService WHERE serviceID = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            ps.executeUpdate();
        }
    }

    public boolean isServiceUsedInAppointment(int serviceID) {
        String sql = "SELECT COUNT(*) AS total FROM Appointment WHERE serviceID = ?";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, serviceID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt("total") > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean deleteService(int serviceID) {
        Connection con = null;

        try {
            if (isServiceUsedInAppointment(serviceID)) {
                return false;
            }

            con = ConnectionManager.getConnection();
            con.setAutoCommit(false);

            deleteFurBasedService(con, serviceID);
            deleteWeightBasedService(con, serviceID);

            String sql = "DELETE FROM Service WHERE serviceID = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, serviceID);

                int result = ps.executeUpdate();

                con.commit();
                return result > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;

        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}