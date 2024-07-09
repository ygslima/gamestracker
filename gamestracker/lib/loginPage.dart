import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Games Tracker APP"), backgroundColor: Colors.blueGrey,),
      body: Center(
        child: Column(
          children: [
            Text("LOGIN"),
            TextField(
              controller: userController,
              onChanged: (value) {
                userController.text = value;
              },
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Usuario"),
            ),
            Divider(height: 10, thickness: 10, color: Colors.transparent,),
            TextField(
              controller: passwController,
              onChanged: (value) {
                passwController.text = value;
              },
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Senha"),
              obscureText: true,
            ),
            Divider(thickness: 10, height: 10, color: Colors.transparent,),
            TextButton(
              onPressed: () {
                
              },
              child: Text("Login", style: TextStyle(color: Colors.black),),
              style: TextButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}