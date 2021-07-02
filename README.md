# Black and White Web Server

This is an example project no 12 (_12-WebServer_) for Raspberry 3A/3B/3B+ (from _C:\Ultibo\Core\examples\12-WebServer\RPi3_) that does exactly the same as original demo (i.e. building the simplest web server in Ultibo). Except that this clone is:

1. Setting console window to entire screen using `CONSOLE_POSITION_FULLSCREEN` added in [Ultibo core 1.2.073](https://ultibo.org/forum/viewtopic.php?f=4&t=172) and thus effectively getting rid of Ultibo's border and title
2. Making console window all black with white texts using [`Console` unit methods](https://ultibo.org/wiki/Unit_Console)

Otherwise it is 1:1 example web server from example project no 12.

This project should be used exactly as all other Ultibo projects, i.e.:

1. Clone this repository to any folder
2. Copy _BWWebServer.elf_ and _kernel7.img_ files to any FAT32-formatted SD card
3. Go to _c:\Ultibo\Core\firmware\RPi3_ folder (if you have Lazarus IDE)
4. Get Raspberry Pi 3 firmware files from their [GitHub repository](https://github.com/raspberrypi/firmware) otherwise.
5. Copy _armstub32-rpi3.bin_, _bootcode.bin_, _fixup.dat_ and _start.elf_ to SD card
6. Put that card into Raspberry Pi 3B+ and power it up.

This project was build for my Raspberry Pi 3B+. Should work under other platforms, but I can't guarantee that. And for sure you should copy [firmware files](https://github.com/raspberrypi/firmware) corresponding to your platform in this case.

More details in [this blog article](https://onezeronull.com/2021/07/02/border-less-full-screen-console-app-in-ultibo/) or in [Ultibo FAQ](https://ultibo.org/faq/).
