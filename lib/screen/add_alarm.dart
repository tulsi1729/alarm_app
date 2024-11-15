import 'dart:developer' as dev;
import 'package:alarm_app/model/alarm_model.dart';
import 'package:alarm_app/provider/provier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddAlarm extends StatefulWidget {
  final bool isEditMode;
  final AlarmModel? preFilledModel;

  const AddAlarm({
    super.key,
    this.isEditMode = false,
    required this.preFilledModel,
  });

  @override
  State<AddAlarm> createState() => AddAlaramState();
}

class AddAlaramState extends State<AddAlarm> {
  final labelController = TextEditingController();
  String? selectedDateTimeString;
  bool repeat = false;
  DateTime? selectedDateTime;
  DateTime? now;
  String? name;
  int? milliseconds;

  String formatedDateTime(DateTime dateTime) {
    String formateDateTime = DateFormat('d-MM-yyyy hh:mm a').format(dateTime);
    dev.log(formateDateTime, name: "formatedDate");
    return formateDateTime;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      now = DateTime.now();
      selectedDateTimeString = widget.preFilledModel!.dateTime;
      labelController.text = widget.preFilledModel!.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.isEditMode ? "Edit Alarm" : "Add Alarm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CupertinoDatePicker(
                initialDateTime: widget.preFilledModel?.dateTime == null
                    ? null
                    : DateFormat('dd-MM-yyyy hh:mm a')
                        .parse(widget.preFilledModel!.dateTime),
                showDayOfWeek: true,
                minimumDate: now,
                dateOrder: DatePickerDateOrder.dmy,
                onDateTimeChanged: (value) {
                  setState(() {
                    selectedDateTimeString =
                        DateFormat('dd-MM-yyyy hh:mm a').format(value);
                    milliseconds = value.microsecondsSinceEpoch;
                    selectedDateTime = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CupertinoTextField(
                controller: labelController,
                placeholder: "Add Label",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.isEditMode) {
                if (widget.preFilledModel != null) {
                  AlarmModel newModel = AlarmModel(
                    label: labelController.text,
                    dateTime: selectedDateTimeString!,
                    id: widget.preFilledModel!.id,
                  );

                  context
                      .read<AlarmProvider>()
                      .editAlarm(widget.preFilledModel!.id, newModel);
                }
              } else {
                if (selectedDateTime != null) {
                  context.read<AlarmProvider>().createAlarm(
                        label: labelController.text,
                        dateTimeString: selectedDateTimeString!,
                        dateTime: selectedDateTime!,
                      );
                }
              }

              context.read<AlarmProvider>().setData();

              Navigator.pop(context);
            },
            child: Text(widget.isEditMode ? "Edit Alarm" : "Set Alarm"),
          ),
        ],
      ),
    );
  }
}
