import 'dart:async';

import 'package:alarm_app/Screen/Add_Alarm.dart';
import 'package:alarm_app/model/alarm_model.dart';
import 'package:alarm_app/provider/provier.dart';
import 'package:alarm_app/screen/alarms_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool value = false;
  AlarmModel? preFilledModel;

  @override
  void initState() {
    super.initState();
    context.read<AlarmProvider>().inituilize(context);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    context.read<AlarmProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(DateFormat('dd-MM-yyyy hh:mm:ss a').format(DateTime.now())),
      ),
      body: AlarmsListWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlarm(
                preFilledModel: preFilledModel,
              ),
            ),
          );
        },
        label: Text("Create"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
