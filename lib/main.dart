import 'package:flutter/material.dart';
import 'package:compasstools/compasstools.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as prefix0;

//void main(){
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_){
//    runApp(MyApp());
//  });
//}

void main() => runApp(MyApp());
//void main() async {
//  ///
//  /// Force the layout to Portrait mode
//  ///
//  await SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);
//
//  runApp(new MyApp());
//}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _haveSensor;
  String sensorType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDeviceSensors();
  }

  Future<void> checkDeviceSensors()async{
    int haveSensor;

    try{
      haveSensor = await Compasstools.checkSensors;

      switch(haveSensor){
        case 0: {
          sensorType="No sensors for compass!";
        }
        break;

        case 1: {
          sensorType="AcceleroMeter + MagnetoMeter";
        }
        break;
        case 2: {
          sensorType="Gyroscope";
        }
        break;
        default: {
          sensorType="Error";
        }
        break;

      }
    }on Exception{

    }

    if(!mounted) return;
    setState(() {
      _haveSensor =haveSensor;
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
//                height: MediaQuery.of(context).size.height,
//                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg.jpg"),fit:BoxFit.cover)
                ),
              ),
              BackdropFilter(
                filter: prefix0.ImageFilter.blur(sigmaX: 4,sigmaY: 4),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6)
                  ),
                ),
              ),
//              Image.asset("img/bgcompas.jpg"),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  StreamBuilder(
                    stream: Compasstools.azimuthStream,
                    builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child:
                                RotationTransition(
                                  turns: AlwaysStoppedAnimation(
                                      -snapshot.data/360
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset("assets/comp.png"),
                                      Padding(
                                        padding: const EdgeInsets.all(38.0),
                                        child: Container(
                                          width: 54.0,
                                          height: 54.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0),
                                            image: DecorationImage(
                                                image: AssetImage("assets/kaba.png"),
                                                fit: BoxFit.cover
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(top:98.0),
//                                  child: Center(child: Image.asset("assets/kaba.png")),
//                                ),
                          ),
                        );
                      }
                      else
                        return Text("Error in stream",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey
                          ),);
                    },
                  ),
                  Text("Arah Kiblat "
//                      +sensorType
                      ,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900]
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
