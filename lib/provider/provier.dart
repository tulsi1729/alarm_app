import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:alarm_app/model/alarm_model.dart';
import 'package:alarm_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmProvider extends ChangeNotifier {
  late SharedPreferences preferences;

  List<AlarmModel> alarms = [];

  List<String> listofstring = [];

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  late BuildContext context;

  createAlarm({
    required String label,
    required String dateTimeString,
    required DateTime dateTime,
  }) {
    Random random = Random();
    int randomNumber = random.nextInt(100);

    alarms.add(AlarmModel(
      label: label,
      dateTime: dateTimeString,
      id: randomNumber,
    ));
    secduleNotification(dateTime, randomNumber);

    notifyListeners();
  }

  void deleteAlarm(int id) {
    alarms.removeWhere((model) => model.id == id);
    cancelNotification(id);
    setData();
  }

  void editAlarm(int oldModelId, AlarmModel newModel) {
    int index = alarms.indexWhere((model) => model.id == oldModelId);

    if (index == -1) {
      print("Model not found");
      return;
    }

    alarms.removeAt(index);
    cancelNotification(newModel.id);

    alarms.insert(index, newModel);

    DateTime date = DateFormat('dd-MM-yyyy HH:mm').parse(newModel.dateTime);
    secduleNotification(date, newModel.id);
    notifyListeners();
  }

  void getData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? cominglist = preferences.getStringList("data");

    if (cominglist == null) {
    } else {
      alarms =
          cominglist.map((e) => AlarmModel.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }

  void setData() {
    listofstring = alarms.map((e) => json.encode(e.toJson())).toList();
    preferences.setStringList("data", listofstring);

    notifyListeners();
  }

  void inituilize(con) async {
    context = con;
    var androidInitilize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = const DarwinInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin!.show(
        0, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  void secduleNotification(DateTime datetim, int randomnumber) async {
    dev.log("id is $randomnumber time is $datetim schedule ");
    int newtime =
        datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    await flutterLocalNotificationsPlugin!.zonedSchedule(
        randomnumber,
        'Alarm Clock',
        DateFormat().format(DateTime.now()),
        tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newtime)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'you_can_name_it_whatever', 'flutterfcm',
                channelDescription: 'your channel description',
                sound: RawResourceAndroidNotificationSound('alarm_music'),
                autoCancel: false,
                playSound: true,
                priority: Priority.max)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(int notificationid) async {
    dev.log("id is $notificationid cansel ");

    await flutterLocalNotificationsPlugin!.cancel(notificationid);
  }
}
