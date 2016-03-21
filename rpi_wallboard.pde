import guru.ical4p.*;
import java.util.Set;
import java.util.Iterator;
import java.text.SimpleDateFormat;
import java.util.Calendar;

Set events;
Object[] myarray;

String comingEvent = "";
final String calendarLink = "https://calendar.google.com/calendar/ical/jwmatthys%40gmail.com/private-f095d7360f89e1c513df6ee1ac2a9e9f/basic.ics";
final String imageRemoteAddress = "https://dl.dropboxusercontent.com/u/29735444/";
SimpleDateFormat df = new SimpleDateFormat("EEEEE, MMMMM dd\nh:mm a");
SimpleDateFormat dateOnly = new SimpleDateFormat("EEEE, MMMMM dd\n");
Calendar today, future;
int currentDay = -1;
int index = 0;
int imageindex = 0;
PImage image;
PFont font, carrollFont;
float screenRatio;
float imageX, imageY = 0;
int scaledImageWidth, scaledImageHeight = 0;
final int FRAMERATE = 1;
final int IMAGESECS = 25;
final int EVENTSECS = 15;
final int NUMIMAGES = 100;
final int FUTURE_CUTOFF = 42; // 6 weeks

void setup()
{
  size(displayWidth, displayHeight);
  screenRatio = displayWidth*1.0/displayHeight;
  smooth();
  font = createFont("Lora-Regular.ttf", 60, true);
  carrollFont = createFont("Lora-Regular.ttf", 96, true);
  imageMode(CENTER);
  nextImage();
  frameRate(FRAMERATE);
  today = Calendar.getInstance();
  future = Calendar.getInstance();
  future.add(Calendar.DATE, FUTURE_CUTOFF);
}

void draw()
{
  // reload calendar every day
  if (frameCount % (3600*FRAMERATE)==0)
  {
    today = Calendar.getInstance();
    future = Calendar.getInstance();
    future.add(Calendar.DATE, FUTURE_CUTOFF);
  }
  if (today.get(Calendar.DAY_OF_MONTH) != currentDay)
  {
    currentDay = today.get(Calendar.DAY_OF_MONTH);
    println("current day of month: "+currentDay);
    loadCalendar();
  }
  if (events==null) loadCalendar();
  background(0);
  image(image, width/2, height/2, scaledImageWidth, scaledImageHeight);
  fill(0, 160);
  stroke(0);
  rect(0, height-200, 820, height);
  if (0 == frameCount%(EVENTSECS*FRAMERATE))  comingEvent = nextEvent();
  if (0 == frameCount%(IMAGESECS*FRAMERATE)) nextImage();
  fill(0);
  textAlign(LEFT);
  textFont(carrollFont);
  text("Music at Carroll", 48, height-80);
  textAlign(RIGHT);
  textFont(font);
  text("UPCOMING EVENTS", width-50, 80);
  text(comingEvent, width-50, 180);
  fill(255);
  textAlign(LEFT);
  textFont(carrollFont);
  text("Music at Carroll", 50, height-78);
  textFont(font);
  textAlign(RIGHT);
  text("UPCOMING EVENTS", width-48, 82);
  text(comingEvent, width-48, 182);
}

String nextEvent()
{
  ICalEvent e;
  try
  {
    e = (ICalEvent)myarray[index];
  } 
  catch (Exception err)
  {
    loadCalendar();
  }
  if (myarray == null) return "";
  do
  {
    index = (index + 1)%myarray.length;
    e = (ICalEvent)myarray[index];
  } 
  // keep searching if event is past or after future date (42 days)
  while (e.getStart().before(today.getTime()) || e.getStart().after(future.getTime()));
  String dateTime = df.format(e.getStart());
  Calendar eventHour = Calendar.getInstance();
  eventHour.setTime(e.getStart());
  if (eventHour.get(Calendar.HOUR) == 0 && eventHour.get(Calendar.MINUTE) == 0)
  {
    dateTime = dateOnly.format(e.getStart());
  }
  return e.getSummary()+"\n"+dateTime;
}

void nextImage()
{
  do
  {
    imageindex = int(random(NUMIMAGES));
    String fn = imageRemoteAddress+ nf(imageindex, 3)+".jpg";
    image = loadImage(fn);
  } 
  while (image==null);
  float imageRatio = image.width*1.0/image.height;
  if (imageRatio >= screenRatio)
  {
    scaledImageWidth = width;
    scaledImageHeight = int(scaledImageWidth / imageRatio);
  } else
  {
    scaledImageHeight = height;
    scaledImageWidth = int(scaledImageHeight * imageRatio);
  }
}

void loadCalendar()
{
  ICal ical = new ICal();
  try
  {
    ical.parse(createInput(calendarLink));
  }
  catch (Exception err) {
    println(err);
  }
  events = ical.getEvents();
  myarray = events.toArray();
  comingEvent = nextEvent();
}

void keyPressed()
{
  loadCalendar();
}