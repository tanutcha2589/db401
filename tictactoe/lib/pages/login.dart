import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _playername;
  late String _password;
  bool _ready = false;
  
   @override
 void initState() {
   Firebase.initializeApp().whenComplete(() {
     setState(() {
       _ready = true;
     });
   });
   super.initState();
 }

  @override
    Widget build(BuildContext context) {void gotoChallenge() {
    Navigator.pushReplacementNamed(context, 'challenge');
}
    return Scaffold(
  body: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('images/logo.png', height: 100,),
          const SizedBox(height: 48,),
          TextField(
            onChanged: (value) {
              _playername = value;
            },
            keyboardType: TextInputType.name,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Enter your player name',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blueAccent, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 20
              ),
            ),
          ),
          const SizedBox(height: 8,),
          TextField(
            onChanged: (value) {
              _password = value;
            },
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blueAccent, 
                  width: 1
                ),
                borderRadius: BorderRadius.circular(30)
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10, 
                horizontal: 20
              ),
            ),
          ),
          const SizedBox(height: 24,),
          ElevatedButton(
            onPressed: _ready ? () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: '$_playername@tictactoe.com',
                  password: _password
                );
                gotoChallenge();
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.code),
                    duration: const Duration(seconds: 10),
                  )
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 10),
                  )
                );
              }
            } : null, 
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder()
            ),
            child: const Text('Log In'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _ready 
            ? () => Navigator.pushNamed(context, 'register') 
            : null, 
            child: const Text('New Player Click Here!'),
          )
        ],
      ),
    ),
  ),
);
  }
}