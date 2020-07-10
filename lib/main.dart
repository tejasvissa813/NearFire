import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer _timer;
  int _start = 7;
  bool _pushed = false;
  void startTimer(BuildContext context){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec, (Timer timer) => setState(
            () {
          if(_start < 1){
            if(!_pushed) {
              _pushed = true;
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            }
            timer.cancel();
          }
          else{
            print('$_start');
            _start = _start - 1;
          }
        }
    )
    );
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    startTimer(context);
    return Container(
      child: Material(
        color: Colors.black,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.language, size: 150, color: Colors.deepOrange),
                Center(
                    child: Text("Fire Safety", style: TextStyle(color: Colors.deepOrange, fontSize: 48.0))
                )
              ],
            )
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static List<int> references = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text('Your Devices'),
            leading: IconButton(icon: Icon(Icons.camera), onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => QRReader()))
            }),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.settings), onPressed: null),
              IconButton(icon: Icon(Icons.search), onPressed: null),
            ],
          ),
          body: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              if(index % 2 == 1){
                return Container(
                  height: 50,
                  color: Colors.white,
                  child: DecoratedBox(
                    decoration:
                  ),
                );
              }
              else{
                return Divider(
                  height: 5,
                );
              }
            },
          )
      ),
    );
  }
}

class QRReader extends StatefulWidget {
  @override
  _QRReaderState createState() => _QRReaderState();
}

class _QRReaderState extends State<QRReader> {
  CameraController controller;
  @override
  void initState(){
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}

