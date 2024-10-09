import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

var storage = new FlutterSecureStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Index(),
    );
  }
}

var services = [
  {"name":"Brake services", "image":"assets/brake_services.png","description":"Brake services include inspecting and replacing brake pads, rotors, and calipers, as well as checking and topping off brake fluid. Proper brake maintenance ensures safe stopping power and overall vehicle safety."},
  {"name":"Cooling system repair", "image":"assets/cooling_system_service.png","description":"Cooling system services involve inspecting the radiator, hoses, and water pump, as well as flushing old coolant and replacing it with fresh fluid. This prevents overheating and maintains engine temperature."},
  {"name":"Electrical system repair", "image":"assets/electrical_system_repair.png","description":"This service addresses issues with the vehicle's electrical components, including the battery, alternator, starter, and wiring. Maintaining the electrical system is vital for reliable operation of lights, ignition, and other electrical features."},
  {"name":"Engine diagnostics", "image":"assets/engine_diagnostics.png","description":"This service uses advanced diagnostic tools to read error codes from the vehicle's computer system. It helps identify underlying engine problems, allowing for timely repairs and efficient performance."},
  {"name":"Exhaust system repair", "image":"assets/exhaust_system_repairs.png","description":"Exhaust system repairs include fixing or replacing components like mufflers, pipes, and catalytic converters. A well-functioning exhaust system reduces emissions and ensures efficient engine operation."},
  {"name":"Oil change", "image":"assets/oil_change.png","description":"Regular oil changes involve draining old engine oil and replacing it with fresh oil, along with a new oil filter. This service is essential for reducing engine wear and maintaining optimal performance."},
  {"name":"Suspension repair", "image":"assets/suspension_repairs.png","description":"Suspension repairs focus on components like shocks, struts, and springs. Proper suspension maintenance improves ride quality, handling, and tire wear, ensuring a comfortable driving experience."},
  {"name":"Tire service", "image":"assets/tire_services.png","description":"Tire services encompass tire rotation (to promote even wear), balancing (to ensure smooth driving), and replacement when tires are worn or damaged. These services enhance traction, handling, and fuel efficiency."},
  {"name":"Transmission service", "image":"assets/transmission_services.png","description":"Transmission services involve checking and changing transmission fluid, as well as inspecting and repairing components. This is crucial for smooth shifting and overall vehicle operation."},
];

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Car Service Station", style: TextStyle(color: Colors.white, fontSize: 25),),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return PersonalDetails();
                }));
              }, icon: Icon(Icons.menu))
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                color: Colors.green[900],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                color: Colors.green[900],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                    color: Colors.white
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      SizedBox(height: 100,),
                      Container(
                        height: 370,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for(var x in services) Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(
                                    blurRadius: 10,
                                    blurStyle: BlurStyle.outer
                                  )]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(x["image"].toString(), height: 250,),
                                      Text(x["name"].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      ElevatedButton(onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return Details(name: x["name"].toString());
                                        }));
                                      }, child: Text("details"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String name;
  const Details({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    var details;
    for (var i in services) if (i["name"] == name) {
      details = i;
      break;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(details["name"]),
              SizedBox(width: 10,),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
              }, icon: Icon(Icons.close)),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
              ),
              child: SizedBox(
                height: 20,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[900]
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30))
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          Image.asset(details["image"], height: 250,),
                          SizedBox(height: 30,),
                          Text(details["description"], style: TextStyle(fontSize: 20),),
                          ElevatedButton(onPressed: () {
                            Future Book() async{
                              var userData = await storage.readAll();
                              var err=false;
                              if (userData.length == 6) {
                                for (var a in userData.keys) {
                                  if (userData[a].toString().replaceAll(" ", "") == "") {
                                    err = true;
                                    break;
                                  }
                                }
                                if (!err) {
                                  BookService(context, userData, details["name"]);
                                  successMessage(context);
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return PersonalDetails();
                                  }));
                                  Alert(context, "Incomplete credentials", "Save your information", "Okay");
                                }
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return PersonalDetails();}));
                                Alert(context, "Incomplete credentials", "Save your information", "Okay");
                              }
                            }
                            Book();
                          }, child: Text("Book"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.black),)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Personal details"),
              SizedBox(width: 10,),
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return Index();}));
              }, icon: Icon(Icons.close)),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
              ),
              child: SizedBox(
                height: 20,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[900]
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30))
                  ),
                  child: const SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          TextInputWidget(type: "name",),
                          SizedBox(height: 20,),
                          TextInputWidget(type: "email",),
                          SizedBox(height: 20,),
                          TextInputWidget(type: "phone_number",),
                          SizedBox(height: 20,),
                          TextInputWidget(type: "address",),
                          SizedBox(height: 20,),
                          TextInputWidget(type: "car_model",),
                          SizedBox(height: 20,),
                          TextInputWidget(type: "car_registeration_number",),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}


class TextInputWidget extends StatefulWidget {
  final String type;
  const TextInputWidget({super.key, required this.type});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  var edtx = new TextEditingController();
  var value="";
  var vbl = false;

  fetchDetials() async{
    var value = await storage.read(key: widget.type);
    if (value != null) {
      edtx.text = value;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetials();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width*0.8,
          child: TextField(
            onChanged: (v) {
              setState(() {
                value = v;
                vbl=true;
              });
            },
            controller: edtx,
            decoration: InputDecoration(
              hintText: "Enter your "+ widget.type
            ),
          ),
        ),
        Visibility(
          visible: vbl,
          child: IconButton(onPressed: () {
            Future setDetails() async{
              await storage.write(key: widget.type, value: edtx.text);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return PersonalDetails();}));
            }
            setDetails();
          }, icon: Icon(Icons.check)),
        )
      ],
    );
  }
}

Alert(context, title, message, buttonText) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: title.length > 0 ? Text(title) : null,
      content: Text(message),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text(buttonText)),
      ],
    );
  });
}

successMessage(context) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Your booking is confirmed", style: TextStyle(fontSize: 20),),
          Icon(Icons.verified, size: 120,color: Colors.green[800],),
          SizedBox(height: 20,),
          TextButton(onPressed: () {Navigator.of(context).pop();}, child: Text("Awesome", style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold, color: Colors.black),)),
        ],
      ),
    );
  });
}

BookService(context, userData, serviceType) async{
  Map<String,String> data = {"status": "unchecked",};
  for (var i in userData.keys) if (i != null) data[i.toString()] = userData[i].toString();
  data["service"] = serviceType;
  http.post(
    Uri.parse("http://10.0.2.2:5000/add_data"),
    body: data,
  );
}