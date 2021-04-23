![](display/demo_1.gif)
<h1> Demo 1</h1>
<br />
![](display/demo_2.gif)
<h1> Demo 2</h1>

Requirements

	• Setup Geofencing area
	• Detect geofencing status based on wifi network and geographic point
	• Display status on app for inside or outside geofence area
	• Host source code privately on GitHub
	• Create readme with instructions
	• Grant access to engineering@setel.my

Flutter packages

	• wifi_info_flutter (getWifiName/getWifiBSSID)
	• geofencing / flutter_geofence
	• Geolocator (calculate the distance towards geofence location)
	• Flutter_local_notifications (notifying user of entering geofencing location)
	• Google_maps_flutter
	
ToDos 
Main function: 

	• Create geofence streams to listen to the current user location and triggers an alert whenever user is in targeted vicinities (500m) 
	• UI should display if the user is inside or outside the vicinities 
	• Set a few locations (petronas stations) to be targeted vicinities 
	• If user is connected to the vicinity wifi then consider the user to be inside the zone 
	• Ensure that alert still triggers when app is not running 

Additional functions: 

	• Display Google map in app UI  
	• Mark user location in realtime 


Locations: 
<br />
<b>Petronas Ara Damansara</b>
<br />
Coordinates - lat 3.1234, long 101.5755

<b>Petronas Alam Sutera</b>
<br />
Coordinates - lat 3.052591, long 101.6527169

<b>Petronas Axis shah alam</b>
<br />
Coordinates - lat 3.0270851, long 101.5420121

<b>Petronas Bandar Baru Salak Tinggi</b>
<br />
Coordinates - lat 2.806143, long 101.7163006

