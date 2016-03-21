/**
 * RuntimeException for the ical4p package.
 */
public class ICalException extends RuntimeException {
    public ICalException() {
        super();
    }

    public ICalException(String message) {
        super(message);
    }

    public ICalException(Throwable t) {
        super(t.getMessage(), t);
    }

    public ICalException(String message, Throwable t) {
        super(message + "; initial cause: " + t.getMessage(), t);
    }
}