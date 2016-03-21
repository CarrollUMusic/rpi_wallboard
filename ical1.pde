/**
 * ICal Parser class that parses an ics file and exports the events in a 
 * HashSet.
 *
 * @author guru
 */
public class ICal { 
    private Set events = new TreeSet();

    /**
     * parses a ical file. calendar is the filename containing the ical data.
     */
    public void parse( InputStream in ) {
        try {
            CalendarBuilder cb = new CalendarBuilder();
            net.fortuna.ical4j.model.Calendar cal = cb.build( in );
            parseEvents( cal );
        } catch ( java.io.IOException ioe ) {
            throw new ICalException( "error while loading ics file", ioe );
        } catch ( net.fortuna.ical4j.data.ParserException pe ) {
            throw new ICalException( "Error while parsing ics file", pe );
        }
    }

    /**
     * parses a ical file. calendar is the filename containing the ical data.
     */
    public void parse( String calendar ) {
        try {
            net.fortuna.ical4j.model.Calendar cal = Calendars.load( calendar );
            parseEvents( cal );
        } catch ( java.io.IOException ioe ) {
            throw new ICalException( "error while loading ics file", ioe );
        } catch ( net.fortuna.ical4j.data.ParserException pe ) {
            throw new ICalException( "Error while parsing ics file", pe );
        }
    }

    private void parseEvents( net.fortuna.ical4j.model.Calendar cal ) {
        for (Iterator i = cal.getComponents("VEVENT").iterator(); i.hasNext();) {
            VEvent component = (VEvent) i.next();
            ICalEvent e = new ICalEvent( component.getSummary().getValue(), 
                    component.getStartDate().getDate(), 
                    component.getEndDate(true).getDate(),
                    component.getLocation().getValue());
            events.add(e);                
        }
    }


    /**
     * clear the events Set
     */
    public void clear() {
        events = new TreeSet();
    }
    
    public Set getEvents() {
        return events;
    }
}