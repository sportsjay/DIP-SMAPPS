import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polylines = LinkedHashSet<Polyline>();

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;
  Location location = new Location();
  LocationData curruntloc;
  bool selected = false;

  //add list of icons to set on the market
  var listicon = ["1","1","t","t","t","t","t","t","t","t","t","t","t","t",];

  //add list of market to set on the Map

  List<Future<BitmapDescriptor>> lmarket = [
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp1.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/dp.png'),
  ];

  //add list of Places to set on the Map by using a pin
  // Replace all the details when to finalise
// Place is represented by object 'Places' contain 'name','desc', 'Lat','Lon','Image'
  List<Placee> initplace = [
    new Placee("The Hive",1.343235, 103.682792, "assets/assets1.jpg", "The Hive",
        "The Hive."),
    new Placee("Lee Kong Chian Lecture Theatre", 1.342636, 103.682327, "assets/assets2.jpg", "Location 2",
        "Lee Kong Chian Lecture Theatre Lv 2"),
    new Placee("The Photonics Institute", 1.342980, 103.680120, "assets/assets3.jpg", "Location 3",
        "Photonics Lv1"),
    new Placee("Rolls-Royce",1.342261, 103.680608, "assets/assets4.jpg", "Location 4",
        "Rolls-Royce LvB1"),
    new Placee("LTA-1", 1.347313, 103.680379, "assets/assets5.jpg", "Location 5",
        "LTA-Lecture Hall"),
    new Placee("Ntu Fine Food", 1.342437, 103.682472, "assets/assets6.jpg", "Location 6",
        "Nearest canteen for Triple E"),
    new Placee("Triple-E Office", 1.343252, 103.680980, "assets/assets7.jpg", "Location 7",
        "Admins office "),
    new Placee("Satellite Center",1.343135, 103.680977, "assets/assets8.jpg", "Location 8",
        "Sate center"),
    new Placee("TR 61-69", 1.343403, 103.681238, "assets/assets9.jpg", "Location 9",
        "You can Find Tr 61-69 Here"),
    new Placee("LT 23", 1.342949, 103.681699, "assets/assets10.jpg", "Location 10",
        "Lecture Hall 23"),
  ];

  Placee pll = new Placee("", 0, 0, "", "", "");

  //Request Permission
  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/dp.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
// Add market to Map on start of App
      _markers.add(Marker(
        markerId: MarkerId("55"),
        position: LatLng(1.348597, 103.682333),
        infoWindow: InfoWindow(
          title: "Reference",
          snippet: "My local ref",
        ),
        icon: _markerIcon,
      ));

// Add marker to Map on start of App from list of place
//the number of market depend to the number of Initial places

      initplace.forEach((element) async {
        var ab = initplace.indexOf(element).toString();
        BitmapDescriptor bb;
        await lmarket[initplace.indexOf(element)].then((value) => bb = value);
        _markers.add(Marker(
          onTap: () {
            print("lkc");
            // on Market Tap show the image and description of the place on th bottom of page
            showdetail(element);
            // createAlertDialog(context);
          },
          markerId: MarkerId(ab),
          position: LatLng(element.lat, element.lon),
          infoWindow: InfoWindow(
            title: element.name,
            snippet: element.desc,
            onTap: () {
              showdetail(element);

              print("lkc");
              // createAlertDialog(context);
            },
          ),
          icon: bb,
        ));
      });
    });
  }

  void _showEEE1() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(1.343187, 103.680875),
      zoom: 17.5,
      tilt: 45,
    )));
  }

// on Searched Place Tap or Market tap navigate to place and draw routr between current place and this place
  void _showEEE2(Placee p) async {

    // get Current  place latlng
    //curruntloc = await location.getLocation();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(p.lat, p.lon),
      zoom: 17.5,
      tilt: 45,
    )));
  }


  @override
  void initState() {
    _getLocationPermission();

    // ignore: unnecessary_statements
    (pll.name.isEmpty) ? print("ff") : print(pll.name);
    super.initState();

    _setMarkerIcon();
  }

// Show the detail of place on the bottom of page with image and text
  showdetail(Placee p) {
    setState(() {
      pll = p;
      selected = true;
      // print(pll.name);
    });
  }


 /* _setPolylines() {
    List<LatLng> polylineLatLongs = List<LatLng>();
    polylineLatLongs.add(LatLng(1.342636, 103.682327));
    polylineLatLongs.add(LatLng(1.342437, 103.682472));
    _polylines.add(
      Polyline(
        polylineId: PolylineId("0"),
        points: polylineLatLongs,
        color: Colors.blue,
        width: 6,
      ),
    );
  }
  setpolyline(Placee pll){
    switch(pll.name){
      case "Lee Kong Chian Lecture Theatre":
        _setPolylines();
        selected = false;
        break;
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DIP EE05',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch2(pll),
              ).then((value) => setState(() {
                pll = value;
                print(value.name);
                print(pll.name);
                selected = true;
                _showEEE2(pll);
              })

                //pll = value
              );
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              polylines: _polylines,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(1.343187, 103.680875),
                zoom: 17.5,
                tilt: 45,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: new Container(
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(initplace.length, (index) {
                        //mainAxisSize: MainAxisSize.min,

                        return IconButton(
                            icon: Image.asset(listicon[index]),
                            onPressed: () => _showEEE2(initplace[index]));
                      })),
                )),
            (selected)
                ? Align(
                alignment: Alignment.bottomCenter,
                child: new Container(
                    height: 100,
                    width: 270,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      new BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(children: [
                      Container(
                        //  height: 100,
                        width: 150,
                        decoration: new BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(pll.imagee),
                              fit: BoxFit.fill),
                          color: Colors.white,
                          borderRadius:
                          new BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      Container(
                        //  height: 100,
                          width: 120,
                          //  height: 100,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "  ${pll.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("  ${pll.text}"),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selected = false;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ))),
                              Align(alignment: Alignment.bottomLeft,
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          //setpolyline(pll);
                                        });

                                      },
                                      child: Icon(
                                        Icons.directions,
                                        color: Colors.blue,
                                      ))),
                            ],
                          ))
                    ])))
                : Container(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          mini: true,
          child: Icon(Icons.home),
          onPressed: () {
            _showEEE1();
          }),
    );
  }
}

// Place class or object
class Placee {
  String name;
  String desc;
  double lon, lat;
  String imagee;
  String text;

  Placee(this.name, this.lat, this.lon, this.imagee, this.desc, this.text);
}

//SearchDelegate used for searche place
class DataSearch2 extends SearchDelegate<Placee> {
  DataSearch2(Placee pppp) {
    pppp = this.selectepalace;
  }

  Placee prr;

//List of initial place scoped
  final List<Placee> pr = [
    new Placee("The Hive",1.343235, 103.682792, "assets/assets1.jpg", "Location 1",
        "The Hive."),
    new Placee("Lee Kong Chian Lecture Theatre", 1.342636, 103.682327, "assets/assets2.jpg", "Location 2",
        "Lee Kong Chian Lecture Theatre Lv 2"),
    new Placee("The Photonics Institute", 1.342980, 103.680120, "assets/assets3.jpg", "Location 3",
        "Photonics Lv1"),
    new Placee("Rolls-Royce",1.342261, 103.680608, "assets/assets4.jpg", "Location 4",
        "Rolls-Royce LvB1"),
    new Placee("LTA-1", 1.347313, 103.680379, "assets/assets5.jpg", "Location 5",
        "LTA-Lecture Hall"),
    new Placee("Ntu Fine Food", 1.342437, 103.682472, "assets/assets6.jpg", "Location 6",
        "Nearest canteen for Triple E"),
    new Placee("Triple-E Office", 1.343252, 103.680980, "assets/assets7.png", "Location 7",
        "Admins office "),
    new Placee("Satellite Center",1.343135, 103.680977, "assets/assets8.jpg", "Location 8",
        "Sate center"),
    new Placee("TR 61-69", 1.343403, 103.681238, "assets/assets9.jpg", "Location 9",
        "You can Find Tr 61-69 Here"),
    new Placee("LT 23", 1.342949, 103.681699, "assets/assets10.jpg", "Location 10",
        "Lecture Hall 23"),
  ];

//List of initial place if search input = ""

  final List<Placee> recentPlaces = [
    new Placee("The Hive", 1.343235, 103.682792, "assets/assets1.jpg",
        "Location 1", "The Hive located"),
    new Placee("Lee Kong Chian Lecture Theatre",  1.342636, 103.682327, "assets/assets2.jpg",
        "Location 2", "Lee Kong Chian Lecture Theatre Lv 2"),
    new Placee("The Photonics Institute", 1.342980, 103.680120, "assets/assets3.jpg", "Location 3",
        "Photonics Lv1"),
    new Placee("Rolls-Royce", 1.342261, 103.680608, "assets/assets4.jpg", "Location 1",
        "Rolls-Royce LvB1"),
    new Placee("LtA-1", 1.347313, 103.680379, "assets/assets5.jpg", "Location 1",
        "LTA-Lecture Hall"),
    new Placee("Ntu Fine Food",  1.342437, 103.682472, "assets/assets6.jpg", "Location 1",
        "Nearest canteen for Triple E"),
    new Placee("Triple-E Office",  1.343252, 103.680980, "assets/assets7.jpg", "Location 1",
        "Admins office"),
    new Placee("Satellite Center", 1.343135, 103.680977, "assets/assets8.jpg", "Location 1",
        "Sate center"),
    new Placee("TR 61-69",  1.343403, 103.681238, "assets/assets9.jpg", "Location 1",
        "You can Find Tr 61-69 Here"),
    new Placee("LT 23",1.342949, 103.681699, "assets/assets10.jpg", "Location 1",
        "Lecture Hall 23"),
  ];
  Placee selectepalace;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Placee> suggestionList = query.isEmpty
        ? recentPlaces
        : pr.where((p) => p.name.startsWith(query)).toList();

    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: ListTile(
            // return the selected place and close the search area
            onTap: () {
              this.selectepalace = suggestionList[index];

              close(context, selectepalace);

              return this.selectepalace;
            },

            leading: Container(
              height: 80,
              width: 80,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(suggestionList[index].imagee),
                  fit: BoxFit.fill,
                ),
                // color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(10)),
              ),
            ),
            // leading: Icon(Icons.location_city),
            title: RichText(
                text: TextSpan(
                    text: suggestionList[index].name.substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].name.substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ])),
          )),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Scaffold(
        body: Center(child: Text('No location found!')
        )
    );
  }
}