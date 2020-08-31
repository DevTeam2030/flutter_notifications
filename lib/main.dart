
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup

Future<void> _scheduleNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var scheduledNotificationDateTime =
  DateTime.now().add(Duration(seconds: 5));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'secondary_icon',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);
  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails(sound: 'slow_spring_board.aiff');
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

void showNotification( ) async {

  // var android = AndroidNotificationDetails(
  //     'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
  //     priority: Priority.High, importance: Importance.Max);
  var android=new AndroidNotificationDetails(
      "${DateTime.now()}",
      "loes",
      "removed",
      // icon: 'secondary_icon',
      priority: Priority.High,
      importance: Importance.Max,
      playSound: true);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);


  final response = await http.get(
        'https://itloes.com/m/api/removeFromWishlist?product_id=1&client_id=1');
    if (response.statusCode == 200) {

      final convert = jsonDecode(response.body) as Map;

      print(response.body);
      print('-----------------------------------------');
      print(convert['result']['status'].toString()) ;
      print('-----------------------------------------');
      if (convert['result']['status'] == 'fail') {

        FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
        var android1 = AndroidInitializationSettings('@mipmap/ic_launcher');

        var iOS1 = IOSInitializationSettings();
        var initSetttings = InitializationSettings(android1, iOS1);
        flp.initialize(initSetttings,
          onSelectNotification: onSelectNotification,);

        // flp.show(0, 'l', 'lllllll', platform,
        //     payload: 'l ----------');

        await flp.periodicallyShow(0, 'leso',
            'removed', RepeatInterval.EveryMinute, platform);





      } else {
        print("no messgae");
      }
    }




}
void showNotification2( ) async {

  // var android = AndroidNotificationDetails(
  //     'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
  //     priority: Priority.High, importance: Importance.Max);
  var android=new AndroidNotificationDetails(
      "${DateTime.now()}",
      "loes",
      "removed",
      // icon: 'secondary_icon',
      priority: Priority.High,
      importance: Importance.Max,
      playSound: true);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android, iOS);


  final response = await http.get(
      'https://itloes.com/m/api/removeFromWishlist?product_id=1&client_id=1');
  if (response.statusCode == 200) {

    final convert = jsonDecode(response.body) as Map;

    print(response.body);
    print('-----------------------------------------');
    print(convert['result']['status'].toString()) ;
    print('-----------------------------------------');
    if (convert['result']['status'] == 'fail') {

      FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
      var android1 = AndroidInitializationSettings('@mipmap/ic_launcher');

      var iOS1 = IOSInitializationSettings();
      var initSetttings = InitializationSettings(android1, iOS1);
      flp.initialize(initSetttings,
        onSelectNotification: onSelectNotification,);

      flp.show(0, 'l', 'lllllll', platform,
          payload: 'l ----------');






    } else {
      print("no messgae");
    }
  }




}


Future onSelectNotification(payload) async {

  var obj=json.decode(payload);
  print("payload $obj");

  Future.delayed(Duration(seconds: 1),(){

   print('on select');

//      if(obj["type"]=="true"){
//        navigatorKey.currentState.push(
//            MaterialPageRoute(builder: (context) => OrderDetails())
//        );
//      }
//      else if(obj["type"]=="6"){
//        navigatorKey.currentState.push(
//            MaterialPageRoute(builder: (context) => RateProvider())
//        );
//      }else{
//        navigatorKey.currentState.push(
//            MaterialPageRoute(builder: (context) => Notifications())
//        );
//      }



  });

}


Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Workmanager.initialize(callbackDispatcher, isInDebugMode: false); //to true if still in testing lev turn it to false whenever you are launching the app
  // await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     frequency: Duration(seconds: 5),//when should it check the link
  //     initialDelay: Duration(seconds: 5),//duration before showing the notification
  //     constraints: Constraints(
  //       networkType: NetworkType.connected,
  //     ));

  // showNotification();
  runApp(MyApp());
}







void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    // showNotification();
    // _scheduleNotification();

    return Future.value(true);
  });
}



class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showNotification();
    showNotification2();
    // _scheduleNotification();
    // loading();


  }
  loading()async{
    WidgetsFlutterBinding.ensureInitialized();
    await Workmanager.initialize(callbackDispatcher, isInDebugMode: true); //to true
    // if still in testing lev turn it to false whenever you are launching the app
    await Workmanager.registerPeriodicTask("5", '',
        existingWorkPolicy: ExistingWorkPolicy.keep,
        frequency: Duration(seconds: 5),//when should it check the link
        initialDelay: Duration(seconds: 5),//duration before showing the notification
        constraints: Constraints(
          networkType: NetworkType.connected,
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter notification',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: First(),);
  }
}

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Testing push notification")
          ,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Text("Flutter push notification without firebase with background fetch feature")
                ),
              ),
            ),

            RaisedButton(
              child: Text('second'),
              onPressed: (){

                // Navigator.of(context).push(
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => Second()
                //     )
                // );

              },
            )
          ],
        )
    );
  }
}








