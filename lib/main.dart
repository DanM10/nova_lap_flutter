import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NovaLap',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1D4ED8)),
        ),
      home: const MyHomePage(title: 'Welcome Page'),
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
    return Scaffold(
      body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                  'images/portrait_background.jpg',
                  fit: BoxFit.cover
              ),
            ),

            Positioned.fill(
              child: Container(
                  color: Colors.black.withValues(alpha: 0.5)
              ),
            ),

            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/logo_white.png',
                        width: 200,
                      ),

                      SizedBox(height: 20),

                      Text(
                        'NovaLap',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1D4ED8),
                          foregroundColor: Colors.white,

                          minimumSize: Size(200, 50),

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8)
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home())
                          );
                        },
                        child: Text(
                          'Enter',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ]
                )
            )
          ]
      ),
    );
  }
}