import 'package:bijlmer_breeze/schedule.dart';
import 'package:bijlmer_breeze/map.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bijlmer Breeze',
      home: MyHomePage(title: 'Bijlmer Freeze edition 2025'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = [
      const SchedulePage("25-01-2025"),
      const SchedulePage("26-01-2025"),
      const MapPage(),
    ];

    final List<Tab> tabs = [
      const Tab(
        icon: Icon(Icons.event),
        text: '25 januari',
      ),
      const Tab(
        icon: Icon(Icons.event),
        text: '26 januari',
      ),
      const Tab(
        icon: Icon(Icons.map_outlined),
        text: 'Kaart',
      ),
    ];

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) => true,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: listWidgets,
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.grey[200],
            height: 85,
            // alignment: AlignmentDirectional.topStart,
            child: TabBar(
              indicatorColor: Colors.transparent,
              tabs: tabs,
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ));
  }
}
