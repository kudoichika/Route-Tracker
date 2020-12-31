# Route-Tracker
An iOS app that lets you record/snapshot your location history. (Kinda like the Google Maps feature, but with Apple's MapKit)

![Dark Mode](https://github.com/usjpin/Route-Tracker/blob/master/demo/darkmode.png?raw=true) | ![Light Mode](https://github.com/usjpin/Route-Tracker/blob/master/demo/lightmode.png?raw=true)
![Data View 1](https://github.com/usjpin/Route-Tracker/blob/master/demo/dataview1.png?raw=true) | ![History View](https://github.com/usjpin/Route-Tracker/blob/master/demo/historyview.png?raw=true) | ![Data View 2](https://github.com/usjpin/Route-Tracker/blob/master/demo/dataview2.png?raw=true)

### Features
- Start recording or take a snapshot anytime anywhere!
- Get a periodic detail (customizable) of your location history as routes on the map.
- Export previous location to Apple Maps/Other third party apps

### Technical
- Uses Swift, Apple's UIKit and MapKit for the User Interface
- Firebase Auth for authentication and user account CRUD
- Firebase Firestore to store location history (in a 3-tiered collection-document format)
