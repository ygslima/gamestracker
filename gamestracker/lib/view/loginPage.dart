import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../controller/telaController.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwController = TextEditingController();
  String mensagem = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Games Tracker APP"), backgroundColor: Colors.blueGrey,),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
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

              //LOGIN BUTTON
              TextButton(
                onPressed: () async{
                  String result = await TelaController.loginAuth(context, userController.text, passwController.text);
                  
                  setState(() {
                    mensagem = result;
                  });
                },
                child: Text("Login", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
              Divider(thickness: 10, height: 10, color: Colors.transparent,),

              //SIGNIN BUTTON
              TextButton(
                onPressed: () async{
                  String result = await TelaController.registerUser(userController.text, passwController.text);

                  setState(() {
                    mensagem = result;
                  });
                  
                },
                child: Text("Registrar", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green)
              ),
              Divider(thickness: 10, height: 10, color: Colors.transparent,),
              Text(mensagem)
              
            ],

            mainAxisAlignment: MainAxisAlignment.center
            ,
          ),
        ),
      )
    );
  }
}