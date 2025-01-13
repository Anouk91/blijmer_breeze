import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(this.day, {super.key});
  final String day;

  State<SchedulePage> createState() => _SchedulePageState();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
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
                      Container(
                          color: HexColor.fromHex(location["color"]),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                              child: Text(
                                location["location"],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
                              ))),
                      SizedBox(
                          width: textWidth * 0.85,
                          child: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text('${location["description"]}\n', style: const TextStyle(fontSize: 16)))),
                      ...location["events"].map((event) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Text('${event["start"]} ',
                                        style:
                                            const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                                    const Text('  '),
                                    Text('${event["end"]} ',
                                        style:
                                            const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                                  ])),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: HexColor.fromHex(location["color"]), width: 2),
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: HexColor.fromHex(location["color"]))),
                                      Text(event["description"]),
                                      if (event["subscribe"] != null)
                                        if (event["subscribe"].startsWith("https"))
                                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text("Reserveren via: "),
                                            InkWell(
                                              child: const Text(
                                                'dit formulier',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                              onTap: () => launchUrlString(event["subscribe"]),
                                            )
                                          ])
                                        else
                                          Text(
                                            "${'Reserveren via: ${event["subscribe"]}'}",
                                            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                          )
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
