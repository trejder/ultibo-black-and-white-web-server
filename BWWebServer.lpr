program BWWebServer;

{$mode objfpc}{$H+}

{ Example 12 Web Server                                                        }
{                                                                              }
{  This example demonstrates how to create a simple web server using the HTTP  }
{  listener class. Ultibo includes both client and server classes for HTTP     }
{  which can be used to interact with your devices in numerous ways.           }
{                                                                              }
{  To compile the example select Run, Compile (or Run, Build) from the menu.   }
{                                                                              }
{  Once compiled copy the kernel7.img file to an SD card along with the        }
{  firmware files and use it to boot your Raspberry Pi.                        }
{                                                                              }
{  Raspberry Pi 3B/3B+/3A+ version                                             }
{   What's the difference? See Project, Project Options, Config and Target.    }

{Declare some units used by this example.}
uses
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  Console,
  Framebuffer,
  BCM2837,
  MMC,             {Include the MMC/SD unit for access to the SD card}
  BCM2710,         {And the driver for the Raspberry Pi SD host}
  SysUtils,
  HTTP,            {Include the HTTP unit for the server classes}
  Winsock2,        {Include the Winsock2 unit so we can get the IP address}
  FileSystem,      {Include the File system so we have some files to serve up}
  FATFS,           {Plus the FAT file system unit}
  SMSC95XX,        {And the drivers for the Raspberry Pi network adapter}
  LAN78XX,
  DWCOTG,          {As well as the driver for the Raspberry Pi USB host}
  Shell,           {Add the Shell unit just for some fun}
  ShellFilesystem, {Plus the File system shell commands}
  RemoteShell;     {And the RemoteShell unit so we can Telnet to our Pi}

{A window handle and some others.}
var
 h: TWindowHandle;
 c: PConsoleDevice;
 IPAddress:String;
 HTTPListener:THTTPListener;
 HTTPFolder:THTTPFolder;
 Winsock2TCPClient:TWinsock2TCPClient;

begin
 {Create our window}
 c := ConsoleDeviceGetDefault;
 h := ConsoleWindowCreate(c, CONSOLE_POSITION_FULLSCREEN, true);

 {Change colors}
 ConsoleDeviceClear(c, COLOR_BLACK);
 ConsoleWindowSetBackcolor(h, COLOR_BLACK);
 ConsoleWindowSetForecolor(h, COLOR_WHITE);

 {Output the message}
 ConsoleWindowWriteLn(h, 'Welcome to Black and White Web Server');
 ConsoleWindowWriteLn(h, '-------------------------------------');
 ConsoleWindowWriteLn(h, '');

 {Create a Winsock2TCPClient so that we can get some local information}
 Winsock2TCPClient:=TWinsock2TCPClient.Create;

 {Print our host name on the screen}
 ConsoleWindowWriteLn(h,'Host name is ' + Winsock2TCPClient.LocalHost);

 {Get our local IP address which may be invalid at this point}
 IPAddress:=Winsock2TCPClient.LocalAddress;

 {Check the local IP address}
 if (IPAddress = '') or (IPAddress = '0.0.0.0') or (IPAddress = '255.255.255.255') then
  begin
   ConsoleWindowWriteLn(h,'IP address is ' + IPAddress);
   ConsoleWindowWriteLn(h,'Waiting for a valid IP address, make sure the network is connected');

   {Wait until we have an IP address}
   while (IPAddress = '') or (IPAddress = '0.0.0.0') or (IPAddress = '255.255.255.255') do
    begin
     {Sleep a bit}
     Sleep(1000);

     {Get the address again}
     IPAddress:=Winsock2TCPClient.LocalAddress;
    end;
  end;

 {Print our IP address on the screen}
 ConsoleWindowWriteLn(h,'IP address is ' + IPAddress);
 ConsoleWindowWriteLn(h,'');

 {Let's create a www folder on C:\ for our web server}
 if DirectoryExists('C:\') and not(DirectoryExists('C:\www')) then
  begin
   {Create the folder, if you want to create it on your SD card first and copy
    some files into it then the example will be able to serve them up to your browser.}
   ConsoleWindowWriteLn(h,'Creating folder C:\www');
   CreateDir('C:\www');
  end;

 {First create the HTTP listener}
 ConsoleWindowWriteLn(h,'Creating HTTP listener');
 HTTPListener:=THTTPListener.Create;

 {And set it to active so it listens}
 ConsoleWindowWriteLn(h,'Setting listener to active');
 HTTPListener.Active:=True;

 {We need to create a HTTP folder object which will define the folder to serve}
 ConsoleWindowWriteLn(h,'Creating HTTP folder / for C:\www');
 HTTPFolder:=THTTPFolder.Create;
 HTTPFolder.Name:='/';
 HTTPFolder.Folder:='C:\www';

 {And register it with the HTTP listener}
 ConsoleWindowWriteLn(h,'Registering HTTP folder');
 HTTPListener.RegisterDocument('',HTTPFolder);

 {Should be ok to go, report the URL}
 ConsoleWindowWriteLn(h,'');
 ConsoleWindowWriteLn(h,'Web Server ready, point your browser to http://' + Winsock2TCPClient.LocalAddress + '/');

 {Free the Winsock2TCPClient object}
 Winsock2TCPClient.Free;

 {Now, you might have noticed that we included the Shell and RemoteShell units
  above, these should have registered themselves and started a Telnet server so
  if you open up a telnet program like PuTTY and telnet (not SSH) to the IP address
  shown for the web server you should get a connection, have fun.}

 {Halt the thread, the web server will still be available}
 ThreadHalt(0);
end.

