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
  Text mensagem = Text("");

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
              Divider(height: 20, thickness: 10, color: Colors.transparent,),
              TextField(
                controller: userController,
                onChanged: (value) {
                  userController.text = value;
                },
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Usuario"),
              ),
              Divider(height: 20, thickness: 10, color: Colors.transparent,),
              TextField(
                controller: passwController,
                onChanged: (value) {
                  passwController.text = value;
                },
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Senha"),
                obscureText: true,
              ),
              Divider(thickness: 10, height: 10, color: Colors.transparent,),
              mensagem,
              Divider(thickness: 10, height: 10, color: Colors.transparent,),

              //LOGIN BUTTON
              TextButton(
                onPressed: () async{
                  Text result = await TelaController.loginAuth(context, userController.text, passwController.text);
                  
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
                  Text result = await TelaController.registerUser(userController.text, passwController.text);

                  setState(() {
                    mensagem = result;
                  });
                  
                },
                child: Text("Registrar", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green)
              ),
              Divider(thickness: 10, height: 10, color: Colors.transparent,),

              //GUEST BUTTON  
              TextButton(
                onPressed: () {
                  Text result = TelaController.guestLogin(context);
                  setState(() {
                    mensagem = result;
                  });
                },
                child: Text("Entrar sem Login", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
              
              
            ],

            mainAxisAlignment: MainAxisAlignment.center
            ,
          ),
        ),
      )
    );
  }
}