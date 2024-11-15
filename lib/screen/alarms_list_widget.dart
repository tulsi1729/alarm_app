import 'package:alarm_app/model/alarm_model.dart';
import 'package:alarm_app/provider/provier.dart';
import 'package:alarm_app/screen/add_alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmsListWidget extends StatefulWidget {
  final bool isEditMode;

  const AlarmsListWidget({
    super.key,
    this.isEditMode = false,
  });

  @override
  State<AlarmsListWidget> createState() => _AlarmsListWidgetState();
}

class _AlarmsListWidgetState extends State<AlarmsListWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(
      builder: (context, alarmProvider, child) {
        List<AlarmModel> alarms = alarmProvider.alarms;
        return ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (_, index) {
            return AlarmListTileWidget(
              alarmModel: alarms[index],
            );
          },
        );
      },
    );
  }
}

class AlarmListTileWidget extends StatelessWidget {
  const AlarmListTileWidget({
    super.key,
    required this.alarmModel,
  });
  final AlarmModel alarmModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alarmModel.dateTime.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(alarmModel.label),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddAlarm(
                            isEditMode: true,
                            preFilledModel: alarmModel,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      context.read<AlarmProvider>().deleteAlarm(alarmModel.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
