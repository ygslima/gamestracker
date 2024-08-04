import 'package:flutter/cupertino.dart';
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
  TextEditingController emailController = TextEditingController();
  Text mensagemEmail = Text("");
  Text mensagemSenha = Text("");
  Text mensagemUser = Text("");

  void requestEmailSingnup(){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Email Request"),
              content: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Insira seu Email"),
                  ),
                  mensagemEmail

                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                    emailController.clear();
                    mensagemEmail = Text("");
                    setState((){
                    });
                  },
                ),
                TextButton(
                  child: Text("Continuar"),
                  onPressed: () async{
                    if(emailController.text == ""){
                      mensagemEmail = Text("Insira um email valido", style: TextStyle(color: Colors.red),);
                      setState(() {
                        
                      });

                    }
                    else{
                      mensagemEmail = Text("");
                      emailController.clear();
                      Navigator.pop(context);
                      await TelaController.registerUser(userController.text, emailController.text, passwController.text);
                      setState(){

                      }
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Games Tracker APP"), backgroundColor: Colors.blueGrey,),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              mensagemUser,
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
              mensagemSenha,
              Divider(thickness: 10, height: 10, color: Colors.transparent,),

              //LOGIN BUTTON
              TextButton(
                onPressed: () async{
                  
                  Text result = await TelaController.loginAuth(context, userController.text, passwController.text);
                  setState(() {
                    mensagemSenha = result;
                  });
                },
                child: Text("Login", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
              Divider(thickness: 10, height: 10, color: Colors.transparent,),

              //SIGNIN BUTTON
              TextButton(
                onPressed: () async{
                  bool valid = true;
                  if(userController.text == "" || await TelaController.checkExistingUser(userController.text) == true){
                    if(userController.text == "" ){
                      mensagemUser = Text("Insira um Usuario valido", style: TextStyle(color: Colors.red),);
                    }
                    else{
                      mensagemUser = Text("Nome de usuario nao disponivel", style: TextStyle(color: Colors.red),);
                    }
                    valid = false;
                  }
                  else{
                    mensagemUser = Text("");
                  }
                  if(passwController.text.length < 4){
                    mensagemSenha = Text("Insira uma senha com mais de 4 digitos", style: TextStyle(color: Colors.red),);
                    valid = false;
                  }
                  else{
                    mensagemSenha = Text("");
                  }
                  if(valid){
                    print("valido");
                    requestEmailSingnup();
                  }

                  setState(() {

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
                    mensagemSenha = result;
                  });
                },
                child: Text("Entrar sem Login", style: TextStyle(color: Colors.black),),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
              
              
            ]
          ),
        ),
      )
    );
  }
}