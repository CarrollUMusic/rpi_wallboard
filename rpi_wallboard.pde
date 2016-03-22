import java.io.InputStream;
import net.fortuna.ical4j.data.*;
import net.fortuna.ical4j.util.*;
import net.fortuna.ical4j.model.*;
import net.fortuna.ical4j.model.component.*;
import java.util.Date;
import java.util.Set;
import java.util.Iterator;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TreeSet;
import java.net.URL;

// USER EDITED INFO - change these
final String host = "pioneer.carrollu.edu"; // your FTP server
final String username = "xxxxxxx";
final String password = "xxxxxxx"; // warning: this is so not secure. hmm, alternative?
final String remotePath = "faculty/jmatthys1/slideshow"; // path to slideshow folder
// address to your Google Calendar ICal (found in Calendar Settings online)
final String calendarLink = "https://calendar.google.com/calendar/ical/339ff54rb1ao3r68l3b0h82nm8%40group.calendar.google.com/public/basic.ics";
final int IMAGESECS = 25; // number of seconds each image appears
final int EVENTSECS = 15; // number of seconds each event appears
final int FUTURE_CUTOFF = 42; // how far into the future to look for events (in days)
final String yourMessage = "Music at Carroll";

FileTransferClient ftp;
Set events;
Object[] myarray;

String comingEvent = "";
SimpleDateFormat df = new SimpleDateFormat("EEEEE, MMMMM d\nh:mm a");
SimpleDateFormat dateOnly = new SimpleDateFormat("EEEE, MMMMM d\n");
Calendar today, future;
int currentDay = -1;
int index = 0;
int imageindex = 0;
PImage image;
PFont font, carrollFont;
float screenRatio;
float imageX, imageY = 0;
int scaledImageWidth, scaledImageHeight = 0;
String[] imageList;
final int FRAMERATE = 1;

void setup()
{
  connectToFTP();
  size(displayWidth, displayHeight);
  screenRatio = displayWidth*1.0/displayHeight;
  smooth();
  noCursor();
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
  if (image==null) nextImage();
  else image(image, width/2, height/2, scaledImageWidth, scaledImageHeight);
  fill(0, 160);
  stroke(0);
  rect(0, height-200, 820, height);
  if (0 == frameCount%(EVENTSECS*FRAMERATE))  comingEvent = nextEvent();
  if (0 == frameCount%(IMAGESECS*FRAMERATE)) nextImage();
  fill(0);
  textAlign(LEFT);
  textFont(carrollFont);
  text(yourMessage, 48, height-80);
  textAlign(RIGHT);
  textFont(font);
  text("UPCOMING EVENTS", width-50, 80);
  text(comingEvent, width-50, 180);
  fill(255);
  textAlign(LEFT);
  textFont(carrollFont);
  text(yourMessage, 50, height-78);
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
  int searchesLeft = myarray.length;
  do
  {
    searchesLeft--;
    index = (index + 1)%myarray.length;
    e = (ICalEvent)myarray[index];
  } 
  // keep searching if event is past or after future date (42 days)
  while (e.getStart().before(today.getTime()) || e.getStart().after(future.getTime()) || searchesLeft < 0);
  if (searchesLeft < 0) return ""; // no results found
  String dateTime = df.format(e.getStart());
  Calendar eventHour = Calendar.getInstance();
  eventHour.setTime(e.getStart());
  if (eventHour.get(Calendar.HOUR) == 0 && eventHour.get(Calendar.MINUTE) == 0)
  {
    dateTime = dateOnly.format(e.getStart());
  }
  return e.getSummary()+"\n"+e.getLocation()+"\n"+dateTime;
}

void nextImage()
{
  try {
    ftp.downloadFile("/tmp/tmpimage.jpg", imageList[int(random(imageList.length))]);
    image = loadImage("/tmp/tmpimage.jpg");
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
  catch (Exception e) {
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

void connectToFTP()
{
  try {
    ftp = new FileTransferClient();
    ftp.setRemoteHost(host);
    ftp.setUserName(username);
    ftp.setPassword(password);
    ftp.connect();
    ftp.changeDirectory(remotePath);
    ftp.getAdvancedFTPSettings().setConnectMode(FTPConnectMode.PASV);
    String[] files = ftp.directoryNameList(".", true);
    imageList = new String[files.length];
    for (int i = 0; i < files.length; i++)
    {
      String[] dirInfo = split(files[i], ' ');
      imageList[i] = dirInfo[dirInfo.length-1];
    }
  } 
  catch (Exception e)
  {
    println (e);
  }
}

void keyPressed()
{
  loadCalendar();
}
