import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'screens/home_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubTaskAdapter());
  
  // Now we can run the app
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo List",
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}