import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'iEarn Auto Earning',
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       primarySwatch: Colors.blue,
       scaffoldBackgroundColor: Colors.grey[100],
       appBarTheme: AppBarTheme(
         backgroundColor: Colors.white,
         elevation: 0,
         iconTheme: IconThemeData(color: Colors.black),
         titleTextStyle: TextStyle(
           color: Colors.black,
           fontSize: 18,
           fontWeight: FontWeight.w500,
         ),
       ),
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           backgroundColor: Colors.red,
           foregroundColor: Colors.white,
           elevation: 0,
           padding: EdgeInsets.symmetric(vertical: 16),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
       ),
       textButtonTheme: TextButtonThemeData(
         style: TextButton.styleFrom(
           padding: EdgeInsets.symmetric(vertical: 16),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
       ),
       inputDecorationTheme: InputDecorationTheme(
         border: OutlineInputBorder(),
         contentPadding: EdgeInsets.symmetric(horizontal: 16),
       ),
     ),
     home: const WelcomeScreen(),
   );
 }
}