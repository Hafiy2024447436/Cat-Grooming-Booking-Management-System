package catBooking.servlet.staff;

import catBooking.bean.AppointmentBean;
import catBooking.dao.CustAppointmentDAO;
import catBooking.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet("/SalesReportController")
public class SalesReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class TransactionRow {
        private String label;
        private int transactions;
        private double revenue;
        private double averageValue;

        public TransactionRow(String label, int transactions, double revenue, double averageValue) {
            this.label = label;
            this.transactions = transactions;
            this.revenue = revenue;
            this.averageValue = averageValue;
        }

        public String getLabel() {
            return label;
        }

        // Keep this so old JSP using getTime() still works
        public String getTime() {
            return label;
        }

        public int getTransactions() {
            return transactions;
        }

        public double getRevenue() {
            return revenue;
        }

        public double getAverageValue() {
            return averageValue;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            showFilterPage(request, response);
        } else {
            generateReport(request, response);
        }
    }

    private void showFilterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("showReport", false);
        request.setAttribute("selectedPeriod", "monthly");
        request.setAttribute("selectedMonth", String.valueOf(LocalDate.now().getMonthValue()));
        request.setAttribute("selectedYear", String.valueOf(LocalDate.now().getYear()));

        request.getRequestDispatcher("/staff_owner/salesReport.jsp").forward(request, response);
    }

    private void generateReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String selectedPeriod = request.getParameter("period");

        if (selectedPeriod == null || selectedPeriod.trim().isEmpty()) {
            selectedPeriod = "monthly";
        }

        LocalDate now = LocalDate.now();
        LocalDate startLocalDate;
        LocalDate endLocalDate;
        String reportTitle;

        if ("daily".equalsIgnoreCase(selectedPeriod)) {
            selectedPeriod = "daily";

            String selectedDate = request.getParameter("selectedDate");

            if (selectedDate == null || selectedDate.trim().isEmpty()) {
                selectedDate = now.toString();
            }

            startLocalDate = LocalDate.parse(selectedDate);
            endLocalDate = startLocalDate;
            reportTitle = formatDisplayDate(startLocalDate);

        } else if ("yearly".equalsIgnoreCase(selectedPeriod)) {
            selectedPeriod = "yearly";

            String selectedYear = request.getParameter("selectedYear");

            if (selectedYear == null || selectedYear.trim().isEmpty()) {
                selectedYear = request.getParameter("yearOnly");
            }

            if (selectedYear == null || selectedYear.trim().isEmpty()) {
                selectedYear = String.valueOf(now.getYear());
            }

            int year = Integer.parseInt(selectedYear);

            startLocalDate = LocalDate.of(year, 1, 1);
            endLocalDate = LocalDate.of(year, 12, 31);
            reportTitle = String.valueOf(year);

        } else if ("custom".equalsIgnoreCase(selectedPeriod)) {
            selectedPeriod = "custom";

            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");

            if (startDateParam == null || startDateParam.trim().isEmpty()) {
                startDateParam = now.withDayOfMonth(1).toString();
            }

            if (endDateParam == null || endDateParam.trim().isEmpty()) {
                endDateParam = now.toString();
            }

            startLocalDate = LocalDate.parse(startDateParam);
            endLocalDate = LocalDate.parse(endDateParam);

            reportTitle = formatDisplayDate(startLocalDate) + " - " + formatDisplayDate(endLocalDate);

        } else {
            selectedPeriod = "monthly";

            String selectedMonth = request.getParameter("selectedMonth");
            String selectedYear = request.getParameter("selectedYear");

            if (selectedMonth == null || selectedMonth.trim().isEmpty()) {
                selectedMonth = String.valueOf(now.getMonthValue());
            }

            if (selectedYear == null || selectedYear.trim().isEmpty()) {
                selectedYear = String.valueOf(now.getYear());
            }

            YearMonth yearMonth = YearMonth.of(
                    Integer.parseInt(selectedYear),
                    Integer.parseInt(selectedMonth)
            );

            startLocalDate = yearMonth.atDay(1);
            endLocalDate = yearMonth.atEndOfMonth();

            reportTitle = yearMonth.getMonth().name().substring(0, 1)
                    + yearMonth.getMonth().name().substring(1).toLowerCase()
                    + " "
                    + selectedYear;
        }

        String startDate = DateUtil.formatDate(Date.valueOf(startLocalDate));
        String endDate = DateUtil.formatDate(Date.valueOf(endLocalDate));

        CustAppointmentDAO dao = new CustAppointmentDAO();
        List<AppointmentBean> appointments = dao.getAppointmentsByDateRange(startDate, endDate);

        List<TransactionRow> rows = buildTransactionRows(
                appointments,
                selectedPeriod,
                startLocalDate,
                endLocalDate
        );

        int totalTransactions = 0;
        double totalRevenue = 0.0;

        for (TransactionRow row : rows) {
            totalTransactions += row.getTransactions();
            totalRevenue += row.getRevenue();
        }

        double averageValue = totalTransactions > 0 ? totalRevenue / totalTransactions : 0.0;

        String labelHeader;

        if ("daily".equalsIgnoreCase(selectedPeriod)) {
            labelHeader = "Time";
        } else if ("yearly".equalsIgnoreCase(selectedPeriod)) {
            labelHeader = "Month";
        } else {
            labelHeader = "Date";
        }

        request.setAttribute("showReport", true);
        request.setAttribute("selectedPeriod", selectedPeriod);
        request.setAttribute("reportTitle", reportTitle);
        request.setAttribute("rows", rows);
        request.setAttribute("totalTransactions", totalTransactions);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("averageValue", averageValue);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("labelHeader", labelHeader);

        request.getRequestDispatcher("/staff_owner/salesReport.jsp").forward(request, response);
    }

    private List<TransactionRow> buildTransactionRows(List<AppointmentBean> appointments,
                                                      String selectedPeriod,
                                                      LocalDate startDate,
                                                      LocalDate endDate) {

        if ("daily".equalsIgnoreCase(selectedPeriod)) {
            return buildDailyRows(appointments);
        }

        if ("yearly".equalsIgnoreCase(selectedPeriod)) {
            return buildYearlyRows(appointments, startDate.getYear());
        }

        return buildDateRows(appointments, startDate, endDate);
    }

    private List<TransactionRow> buildDailyRows(List<AppointmentBean> appointments) {
        List<TransactionRow> rows = new ArrayList<>();

        String[] times = {
                "09:00",
                "10:00",
                "11:00",
                "13:00",
                "14:00",
                "15:00",
                "16:00",
                "17:00"
        };

        for (String time : times) {
            int count = 0;
            double revenue = 0.0;

            for (AppointmentBean appt : appointments) {
                if (isCancelled(appt)) {
                    continue;
                }

                if (appt.getAppointmentTime() != null
                        && appt.getAppointmentTime().trim().equals(time)) {
                    count++;
                    revenue += appt.getTotalAmount();
                }
            }

            if (count > 0) {
                rows.add(new TransactionRow(time, count, revenue, revenue / count));
            }
        }

        return rows;
    }

    private List<TransactionRow> buildDateRows(List<AppointmentBean> appointments,
                                               LocalDate startDate,
                                               LocalDate endDate) {

        List<TransactionRow> rows = new ArrayList<>();

        LocalDate date = startDate;

        while (!date.isAfter(endDate)) {
            int count = 0;
            double revenue = 0.0;

            for (AppointmentBean appt : appointments) {
                if (isCancelled(appt)) {
                    continue;
                }

                LocalDate apptDate = parseAppointmentDate(appt.getAppointmentDate());

                if (apptDate != null && apptDate.equals(date)) {
                    count++;
                    revenue += appt.getTotalAmount();
                }
            }

            if (count > 0) {
                rows.add(new TransactionRow(formatDisplayDate(date), count, revenue, revenue / count));
            }

            date = date.plusDays(1);
        }

        return rows;
    }

    private List<TransactionRow> buildYearlyRows(List<AppointmentBean> appointments, int year) {
        List<TransactionRow> rows = new ArrayList<>();

        for (int monthNo = 1; monthNo <= 12; monthNo++) {
            int count = 0;
            double revenue = 0.0;

            for (AppointmentBean appt : appointments) {
                if (isCancelled(appt)) {
                    continue;
                }

                LocalDate apptDate = parseAppointmentDate(appt.getAppointmentDate());

                if (apptDate != null
                        && apptDate.getYear() == year
                        && apptDate.getMonthValue() == monthNo) {
                    count++;
                    revenue += appt.getTotalAmount();
                }
            }

            if (count > 0) {
                Month month = Month.of(monthNo);
                String label = month.name().substring(0, 1)
                        + month.name().substring(1).toLowerCase()
                        + " "
                        + year;

                rows.add(new TransactionRow(label, count, revenue, revenue / count));
            }
        }

        return rows;
    }

    private boolean isCancelled(AppointmentBean appt) {
        return appt.getAppointmentStatus() != null
                && "cancelled".equalsIgnoreCase(appt.getAppointmentStatus().trim());
    }

    private LocalDate parseAppointmentDate(Date date) {
        if (date == null) {
            return null;
        }

        return date.toLocalDate();
    }

    private String formatDisplayDate(LocalDate date) {
        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("dd-MMM-yyyy", Locale.ENGLISH);

        return date.format(formatter).toUpperCase(Locale.ENGLISH);
    }
}