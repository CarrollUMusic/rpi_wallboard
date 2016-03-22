# Arts Calendar Wallboard for Raspberry Pi

Photo slideshow and coming events display

### Features
* slideshow of user selected photos
* selects events from Google Calendar
* reads photos from FTP server
* user-configurable slideshow speed

### Setup
* Create a Google Calendar with your events. Under Calendar Settings, make the
calendar public and copy down the Public ICal address of the calendar.
* Create a unique folder in an FTP file server (for instance, a web storage or
university drive). Take note of the server address and the path to the new folder.
* Copy your slideshow images into the new folder. You may use any common image type. Do not put anything in the folder except image files. Try to avoid extremely large photos (over 5Mb).
* Download and unzip Processing 3.0.2 from http://processing.org
* Clone this repository: ```git clone https://github.com/jwmatthys/rpi_wallboard```
* Launch Processing and open ```rpi_wallboard.pde```
* Edit the first few lines of the file to include your calendar and FTP information.
* Start the slideshow with Sketch -> Present (or CTRL-Shift-R). Press ESC to stop.
