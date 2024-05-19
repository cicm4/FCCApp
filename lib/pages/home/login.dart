import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fccapp/services/Level_1/authentication_service.dart';
import '../../shared/loading.dart';

class Login extends StatefulWidget {
  final AuthService auth;

  const Login({super.key, required this.auth});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await widget.auth.signInEmailAndPass(
          emailAddress: _emailController.text,
          password: _passwordController.text,
        );
        if (result is String) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error: $result",
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      //shows that there was an error on screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error en el formulario"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Loading()
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.teal.shade600,
                      Colors.green.shade300,
                      Colors.tealAccent.shade400,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 80),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 1000),
                                  child: Text(
                                    "Conectate",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                FadeInUp(
                                  duration: Duration(milliseconds: 1300),
                                  child: Text(
                                    "Bienvenido",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30), // Adjust the right padding as needed
                            child: Container(
                              width: 115, // Adjust the size as needed
                              child: Image.asset('assets/LOGOFCC.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 60),
                                  FadeInUp(
                                    duration: Duration(milliseconds: 1400),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(11, 81, 45, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _emailController,
                                              style: TextStyle(color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: "Email o numero de telefono",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Por favor introduzca su correo electrónico.';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _passwordController,
                                              obscureText: true,
                                              style: TextStyle(color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: "Contraseña",
                                                hintStyle: TextStyle(color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Por favor, introduzca su contraseña.';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  FadeInUp(
                                    duration: Duration(milliseconds: 1500),
                                    child: Text(
                                      "Olvide mi contraseña?",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  FadeInUp(
                                    duration: Duration(milliseconds: 1600),
                                    child: MaterialButton(
                                      onPressed: _signIn,
                                      height: 50,
                                      color: Colors.teal[600],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Ingresar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/register');
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Crea tu cuenta',
                                                style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
