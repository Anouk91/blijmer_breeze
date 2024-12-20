import 'dart:convert';

import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(this.day, {super.key});
  final String day;

  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List jsonResult = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/schema_freeze_25.json");
    setState(() {
      jsonResult = jsonDecode(data); //latest Dart
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Axis direction = screenWidth > 1000 ? Axis.horizontal : Axis.vertical;
    double textWidth = screenWidth > 1000 ? screenWidth / 2 : screenWidth;
    List locations = jsonResult.isEmpty
        ? []
        : (widget.day == "26-01-2025" ? jsonResult[0]["locations"] : jsonResult[1]["locations"]);

    return jsonResult.isEmpty
        ? const Text("Loading...")
        : SingleChildScrollView(
            child: Flex(
                direction: direction,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                ...locations.map((location) {
                  return Column(
                    children: [
                      Text(
                        location["location"],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.lightBlue[900]),
                      ),
                      SizedBox(
                          width: textWidth * 0.85,
                          child: Text('${location["description"]}\n', style: const TextStyle(fontSize: 14))),
                      ...location["events"].map((event) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Text('${event["start"]}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                    const Text('  '),
                                    Text('${event["end"]}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                  ])),
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: Colors.lightBlue, width: 2),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                                width: textWidth * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${event["title"]} ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.lightBlue[900])),
                                      Text(event["description"]),
                                    ],
                                  ),
                                ),
                              )
                            ]));
                      }).toList(),
                    ],
                  );
                }),

                // SizedBox(
                //     height: 100,
                //     width: 100,
                //     child: ListTile(
                //         // title: Text(event["title"]),
                //         // subtitle: Text(event["description"]),
                //         ))
              ]));
  }
}
