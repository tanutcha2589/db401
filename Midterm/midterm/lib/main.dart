import 'package:flutter/material.dart';

void main() {
  runApp(const MyPanel());
}
class MyPanel extends StatelessWidget {
  const MyPanel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold
        )
      )
    ),
      home: const MyHomePage(title: ''),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage ({super.key, required this.title});
    final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//funtion Counter
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {     
      _counter++;
    });
  }
  void decrement(){
    setState(() {
      _counter--;
      });
    }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold
        )
      )
    ),
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg.webp'), fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                 padding: EdgeInsets.all(0)),
           
             const SizedBox(height: 30),
              ElevatedButton(
                child:const Text('+'),
                onPressed:() => {
                  _incrementCounter()
                },
              ),
               Text(
              '$_counter'
              
              //style: Theme.of(context).textTheme.headline4,
            ),
                const SizedBox(height: 10),
                
              ElevatedButton(
                child:const Text("-"),
                
                onPressed: ()=> {decrement() 
                },
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}

