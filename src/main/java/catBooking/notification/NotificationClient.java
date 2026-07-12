package catBooking.notification;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Client for the optional booking-confirmation notification microservice.
 *
 * Configure the cloud endpoint with:
 *   NOTIFICATION_BOOKING_CONFIRMED_URL=https://your-service.example/api/notifications/booking-confirmed
 *
 * If no endpoint is configured, booking confirmation still succeeds and the
 * notification call is skipped.
 */
public class NotificationClient {

    private final HttpClient httpClient;
    private final String notificationUrl;

    public NotificationClient() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(3))
                .build();
        this.notificationUrl = firstNonBlank(
                System.getenv("NOTIFICATION_BOOKING_CONFIRMED_URL"),
                System.getProperty("notification.booking.confirmed.url"));
    }

    public void sendBookingConfirmedEmail(BookingConfirmationEmailPayload payload) {
        if (isBlank(notificationUrl)) {
            System.out.println("Booking notification service is not configured; email notification was skipped.");
            return;
        }

        try {
            String json = toJson(payload);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(notificationUrl))
                    .timeout(Duration.ofSeconds(8))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(json))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                System.err.println("Notification service returned HTTP " + response.statusCode());
            }
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid notification service URL: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Notification service is unreachable: " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("Notification request was interrupted.");
        }
    }

    private String toJson(BookingConfirmationEmailPayload payload) {
        return "{"
                + field("appointmentNo", payload.getAppointmentNo()) + ","
                + field("customerName", payload.getCustomerName()) + ","
                + field("customerEmail", payload.getCustomerEmail()) + ","
                + field("catName", payload.getCatName()) + ","
                + field("appointmentDate", payload.getAppointmentDate()) + ","
                + field("appointmentTime", payload.getAppointmentTime()) + ","
                + "\"services\":" + stringArray(payload.getServices()) + ","
                + "\"totalAmount\":" + amount(payload.getTotalAmount()) + ","
                + field("assignedStaffName", payload.getAssignedStaffName())
                + "}";
    }

    private String field(String name, String value) {
        return "\"" + name + "\":\"" + escape(value) + "\"";
    }

    private String stringArray(List<String> values) {
        if (values == null) {
            return "[]";
        }

        return values.stream()
                .map(value -> "\"" + escape(value) + "\"")
                .collect(Collectors.joining(",", "[", "]"));
    }

    private String amount(BigDecimal value) {
        return value == null ? "0.00" : value.toPlainString();
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (!isBlank(value)) {
                return value.trim();
            }
        }
        return null;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
