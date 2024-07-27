import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  var meds = <String>["Tylenon", "Retinol", "opioids"];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    return Scaffold(
      body: ListView.builder(
        itemCount: appState.meds.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => {
              // Navigator.push(),
            },
            child: ListTile(
              title: Text(appState.meds[index]),
            ),
          );
        }
      ),
    );
  }
}