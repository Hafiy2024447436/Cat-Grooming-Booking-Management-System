package catBooking.util;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.Locale;

public class DateUtil {

    private static final DateTimeFormatter DD_MON_YYYY_FORMAT =
            new DateTimeFormatterBuilder()
                    .parseCaseInsensitive()
                    .appendPattern("dd-MMM-yyyy")
                    .toFormatter(Locale.ENGLISH);

    private static final DateTimeFormatter YYYY_MM_DD_FORMAT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public static Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }

        String clean = dateStr.trim();

        try {
            LocalDate localDate;

            if (clean.matches("\\d{4}-\\d{2}-\\d{2}")) {
                localDate = LocalDate.parse(clean, YYYY_MM_DD_FORMAT);
            } else {
                localDate = LocalDate.parse(
                        clean.toUpperCase(Locale.ENGLISH),
                        DD_MON_YYYY_FORMAT
                );
            }

            return Date.valueOf(localDate);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }

        return date.toLocalDate()
                .format(DD_MON_YYYY_FORMAT)
                .toUpperCase(Locale.ENGLISH);
    }
}
