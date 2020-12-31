# Route-Tracker
An iOS app that lets you record/snapshot your location history. (Kinda like the Google Maps feature, but with Apple's MapKit)

<div align="center">
	<img width="30%" src="https://github.com/usjpin/Route-Tracker/blob/master/Screenshots/darkmode.png?raw=true" alt="Dark Mode">
	<img width="30%" src="https://github.com/usjpin/Route-Tracker/blob/master/Screenshots/lightmode.png?raw=true" alt="Light Mode">
</div>
<div align="center">
	<img width="20%" src="https://github.com/usjpin/Route-Tracker/blob/master/Screenshots/dataview1.png?raw=true" alt="Data View 1">
	<img width="20%" src="https://github.com/usjpin/Route-Tracker/blob/master/Screenshots/historyview.png?raw=true" alt="History View">
	<img width="20%" src="https://github.com/usjpin/Route-Tracker/blob/master/Screenshots/dataview2.png?raw=true" alt="Data View 2">
</div>

### Features
- Start recording or take a snapshot anytime anywhere!
- Get a periodic detail (customizable) of your location history as routes on the map.
- Export previous location to Apple Maps/Other third party apps

### Technical
- Uses Swift, Apple's UIKit and MapKit for the User Interface
- Firebase Auth for authentication and user account CRUD
- Firebase Firestore to store location history (in a 3-tiered collection-document format)
