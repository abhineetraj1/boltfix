import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:boltfix/storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:boltfix/variables.dart';

void main() {
  runApp(const MyApp());
}
var cart=[];
var location = "";
var info;
var services = [
  {"name":"Brake services", "image":"assets/brake_services.png","description":"Brake services include inspecting and replacing brake pads, rotors, and calipers, as well as checking and topping off brake fluid. Proper brake maintenance ensures safe stopping power and overall vehicle safety.","price":200},
  {"name":"Cooling system repair", "image":"assets/cooling_system_service.png","description":"Cooling system services involve inspecting the radiator, hoses, and water pump, as well as flushing old coolant and replacing it with fresh fluid. This prevents overheating and maintains engine temperature.","price":500},
  {"name":"Electrical system repair", "image":"assets/electrical_system_repair.png","description":"This service addresses issues with the vehicle's electrical components, including the battery, alternator, starter, and wiring. Maintaining the electrical system is vital for reliable operation of lights, ignition, and other electrical features.","price":700},
  {"name":"Engine diagnostics", "image":"assets/engine_diagnostics.png","description":"This service uses advanced diagnostic tools to read error codes from the vehicle's computer system. It helps identify underlying engine problems, allowing for timely repairs and efficient performance.","price":1200},
  {"name":"Exhaust system repair", "image":"assets/exhaust_system_repairs.png","description":"Exhaust system repairs include fixing or replacing components like mufflers, pipes, and catalytic converters. A well-functioning exhaust system reduces emissions and ensures efficient engine operation.","price":400},
  {"name":"Oil change", "image":"assets/oil_change.png","description":"Regular oil changes involve draining old engine oil and replacing it with fresh oil, along with a new oil filter. This service is essential for reducing engine wear and maintaining optimal performance.","price":400},
  {"name":"Suspension repair", "image":"assets/suspension_repairs.png","description":"Suspension repairs focus on components like shocks, struts, and springs. Proper suspension maintenance improves ride quality, handling, and tire wear, ensuring a comfortable driving experience.","price":800},
  {"name":"Tire service", "image":"assets/tire_services.png","description":"Tire services encompass tire rotation (to promote even wear), balancing (to ensure smooth driving), and replacement when tires are worn or damaged. These services enhance traction, handling, and fuel efficiency.","price":1200},
  {"name":"Transmission service", "image":"assets/transmission_services.png","description":"Transmission services involve checking and changing transmission fluid, as well as inspecting and repairing components. This is crucial for smooth shifting and overall vehicle operation.","price":2000},
  {"name":"Wheel alignment", "image":"assets/wheel_alignment.png","description":"Wheel alignment services adjust the angles of the wheels to ensure they are perpendicular to the ground and parallel to each other. Proper alignment improves tire wear, handling, and fuel efficiency.","price":600},
  {"name":"Battery replacement", "image":"assets/battery_replacement.png","description":"Battery replacement involves removing the old battery and installing a new one. This service is crucial for ensuring reliable starting and powering of electrical systems in the vehicle.","price":800},
  {"name":"Fuel system cleaning", "image":"assets/fuel_system_cleaning.png","description":"Fuel system cleaning involves removing deposits from fuel injectors and intake valves, ensuring optimal fuel flow and combustion efficiency. This service helps improve engine performance and fuel economy.","price":900},
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Index(),
    );
  }
}

class Index extends StatefulWidget {
  const Index({super.key});
  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    super.initState();
    isDateStored().then((value) {
      if (value) Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Services()),);});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/icon.png", width: 150, height: 150),
                  Text("Boltfix", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green)), 
                  Text("Bike repair and maintenance services", style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              )),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => Accounts()),);
              }, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.black), child: const Text("Get Started"),),
            ),
          ],
        ),
      ),
    );
  }
}

class Accounts extends StatefulWidget {
  const Accounts({super.key});
  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var _mobileNumber;
  String err = '';
  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });
    initMobileNumberState();
  }
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
    } else {
      try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
    } catch (e) {
      err= e.toString();
    }
    }
    if (!mounted) return;
    setState(() {
      phone.text = _mobileNumber ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Boltfix",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                          fillColor: Colors.white,
                          labelText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        readOnly: true,
                        controller: phone,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                          fillColor: Colors.white,
                          labelText: "Enter phone number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: () {
                        StoreData(name.text, phone.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Services()),
                        );
                      }, style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ), child: Text("Continue")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: cart.isNotEmpty ? FloatingActionButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartItem()));
        }, 
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.shopping_cart),
        ) : null,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Boltfix", style: TextStyle(fontSize: 30)),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings()));
              }, icon: Icon(Icons.settings)),
            ],
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.green,
        body: SizedBox(
          height: MediaQuery.of(context).size.height*0.8,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 450,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10),
                    children: [
                      for (var i in services) Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 89, 89, 89),
                              blurStyle: BlurStyle.outer,
                              blurRadius: 10,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(i["image"].toString(), height: 210, width: 210,),
                              Align(alignment: Alignment.centerLeft, child: Text(i["name"].toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))),
                              Text(i["description"].toString(), style: TextStyle(fontSize: 14, color: Colors.black)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(alignment: Alignment.centerLeft, child: Text("₹${i["price"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))),
                                  ElevatedButton(onPressed: () {
                                    if (!cart.contains(i["name"].toString())) {
                                      cart.add(i["name"].toString());
                                    } else {
                                      cart.remove(i["name"].toString());
                                    }
                                    setState(() {});
                                  }, style: !cart.contains(i["name"].toString()) ? ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white) : ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shadowColor: Colors.black), child: !cart.contains(i["name"].toString()) ? Text("Add") : Text("Added"),),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Services()));
              }, icon: Icon(Icons.arrow_back)),
              Text("Cart"),
            ],
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: location == "" ? null : FloatingActionButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleInfo()));
        },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.arrow_forward),
        ),
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 89, 89, 89),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var i in cart) Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Text(i, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                              Row(
                                children: [
                                  Text("₹${services.firstWhere((element) => element["name"] == i)["price"]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                                  IconButton(onPressed: () {
                                    cart.remove(i);
                                    setState(() {});
                                  }, icon: Icon(Icons.delete), style: IconButton.styleFrom(foregroundColor: Colors.red),),
                                ],
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 89, 89, 89),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cost of repair", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("₹ ${cartTotal()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("GST", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("₹ ${(cartTotal() as int) * 0.18}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total cost", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("₹ ${(cartTotal() as int) * 1.18}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 89, 89, 89),
                      blurStyle: BlurStyle.outer,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.95,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          location == "" ? ElevatedButton(onPressed: () {
                            f1() async {
                              if (await _determinePosition()) setState(() {});
                            }
                            f1();
                          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), child: Text("Fetch current location"),) : Text("Current location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          location == "" ? Text("") : IconButton(onPressed: () {}, icon: Icon(Icons.location_on), style: IconButton.styleFrom(foregroundColor: Colors.black),),
                        ],
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        floatingActionButton: FloatingActionButton(onPressed: () async{
          final storage = FlutterSecureStorage();
          await storage.deleteAll();
          cart.clear();
          info = null;
          location = "";
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Index()));
        }, 
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(Icons.logout),
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Services()));
              }, icon: Icon(Icons.arrow_back)),
              Text("Settings"),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: Text("Name", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                    future: FlutterSecureStorage().read(key: 'name'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data.toString(), style: TextStyle(fontSize: 20, color: Colors.white));
                      } else {
                        return Text("No name found", style: TextStyle(fontSize: 20, color: Colors.white));
                      }
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Align(alignment: Alignment.centerLeft, child: Text("Phone number", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                    future: FlutterSecureStorage().read(key: 'phone'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return Text(snapshot.data.toString(), style: TextStyle(fontSize: 20, color: Colors.white));
                      } else {
                        return Text("No phone number found", style: TextStyle(fontSize: 20, color: Colors.white));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({super.key});

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  File? _image;
  var additional = TextEditingController();
  var bikeName = TextEditingController();
  var bikeModel = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() {_image = File(pickedFile.path);});
  }
  
  setInfo() {
    if (info != null) {
      bikeName.text = info["brand"] ?? "";
      bikeModel.text = info["model"] ?? "";
      additional.text = info["additionalInfo"] ?? "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartItem()));
              }, icon: Icon(Icons.arrow_back)),
              Text("Vehicle Info"),
            ],
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: info != null ? SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.7,
          child: Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              info["isBike"] == "yes" ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 89, 89, 89),
                        blurStyle: BlurStyle.outer,
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Confirm your bike details", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                            labelText: "Bike name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          controller: bikeName,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                            labelText: "Bike model name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          controller: bikeModel,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                            labelText: "Additional information",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          controller: additional,
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: () async {
                          if (await PostOrder()) {
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => Services()));
                           cart.clear();
                           info=null;
                           msgBox(context, "Success", "Your service has been booked successfully. We will contact you soon.");
                          } else msgBox(context, "Error", "Something went wrong. Please try again later.");
                        }, child: Text("Book service"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
                      ],
                    ),
                  ),
                ),
              ) : Text("Bike not found", style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ))),
        ) : _image == null && info == null ? SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.9,
          child: Center(
            child: ElevatedButton(onPressed: () async {
              await _pickImage();
              if (_image != null) {
                var res = await _uploadImage(XFile(_image!.path));
                if (res != false) {
                  setState(() {
                    info = jsonDecode(res);
                    setInfo();
                  });
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleInfo()));
                }
              }
            }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), child: Text("Upload image"),),
          ),
        ) : SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.9,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Analysing image...", style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  if (permission == LocationPermission.deniedForever) return false;
  var l = await Geolocator.getCurrentPosition();
  location = "https://www.google.com/maps/search/?q=${l.latitude},${l.longitude}";
  return true;
}

cartTotal() {
  int total = 0;
  for (var i in cart) for (var x in services) {
    if (x["name"] == i) total = total + (x["price"] as int);
  }
  return total;
}

_uploadImage(XFile imageFile) async {
  var uri = Uri.parse(url+'/upload');
  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image',imageFile.path,));
  var response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  }
  return false;
}

msgBox(context, title, message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}