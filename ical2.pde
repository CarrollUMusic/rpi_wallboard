/**
 * Wrapper class for VEVENT-Structures in a ical file
 * @author guru
 */

public class ICalEvent implements Comparable {
    private Date start;
    private Date end;
    private String summary;

    /**
     * Empty contstuctor;
     */
    public ICalEvent() {
    }
   
    /**
     * full contstructor
     */ 
    public ICalEvent( String summary, Date start, Date end ) {
        this.summary = summary;
        this.start = start;
        this.end = end;
    }

    public String getSummary() {
        return this.summary;
    }

    public void setSummary( String summary ) {
        this.summary = summary;
    }

    public Date getStart() {
        return this.start;
    }

    public void setStart( Date start ) {
        this.start = start;
    }

    public Date getEnd() {
        return this.end;
    }

    public void setEnd( Date end ) {
        this.end = end;
    }

    public int getDurInMin() {
        if (start== null || end == null) {
            return 0;
        }

        return (int)(end.getTime() - start.getTime())/60000;
    }
    
    /**
     * compares two ICalEvent objects and compares the start date   
     */
    public int compareTo(Object o) {
        ICalEvent e1 = (ICalEvent)o;
        if (start == null && e1.getStart() != null) return -1;
        if (start == null && e1.getStart() == null) return 0;
        if (start != null && e1.getStart() == null) return 1;

        return start.compareTo( e1.getStart());
    }
}