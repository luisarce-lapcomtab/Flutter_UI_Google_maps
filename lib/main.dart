import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green[600],
          height: 45,
          textTheme: ButtonTextTheme.primary,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng currentLocation = LatLng(-2.142869, -79.923845);
  TextEditingController locationController = TextEditingController();
  GoogleMapController _mapController;
  LatLng get initialPos => currentLocation;
  bool buscando = false;
  String header = "";

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    locationController.text = placemark[0].name;
    setState(() {
      header = placemark[0].name.toString();
    });
  }

  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onCameraMove(CameraPosition position) async {
    setState(() {});
    buscando = false;
    currentLocation = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentLocation, zoom: 15.7),
            minMaxZoomPreference: MinMaxZoomPreference(10.5, 16.8),
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onCameraMove: onCameraMove,
            onMapCreated: onCreated,
            onCameraIdle: () async {
              buscando = true;
              setState(() {});
              getMoveCamera();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buscando == true
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue[600].withOpacity(0.92),
                        ),
                        width: 195,
                        height: 38,
                        child: Center(
                          child: Text(
                            "$header",
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.2),
                          ),
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue[600].withOpacity(0.92)),
                        width: 48,
                        height: 38,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2.6,
                          ),
                        ),
                      ),
                Image.asset(
                  "assets/images/markeruser.png",
                  height: 177,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(
                Icons.share,
                color: Colors.green,
                size: 25,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu,
                color: Colors.green,
                size: 25,
              ),
            ),
          ),
          buscando == true
              ? Positioned(
                  bottom: 0,
                  right: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        mini: true,
                        onPressed: getUserLocation,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.gps_fixed,
                          color: Colors.green,
                          size: 28,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green[600].withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            )),
                        child: Center(
                          child: Text(
                            "Conviértete en un mensajero!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 22, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                child: TextField(
                                  enabled: false,
                                  controller: locationController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.drive_eta, size: 20)),
                                ),
                              ),
                              Container(
                                height: 40,
                                child: TextField(
                                  onTap: () {},
                                  enabled: false,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.location_on, size: 20),
                                      hintText: " Destination",
                                      hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Container(
                                height: 40,
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.attach_money, size: 21),
                                      hintText: " Offer your fare",
                                      hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Container(
                                height: 40,
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      icon:
                                          Icon(Icons.insert_comment, size: 18),
                                      hintText: " Comment and wishes",
                                      hintStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      "Request a vehicle",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    onPressed: () {}),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      )),
    );
  }
}
