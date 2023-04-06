import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/app_home.dart';
import 'package:rsaproject/router.dart';
import 'package:rsaproject/pages/signup.dart';
import 'package:rsaproject/utils/api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, String> _errors = {};

  void goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AppHome()));
  }

  void login(AppStateModel appState) async {
    final email = emailController.text;
    final password = passwordController.text;
    final res = await loginUser(email, password);
    setState(() {
      _errors.clear();
    });
    if (res.code == 200) {
      appState.setUser(User.from(res.data));
      loadSchools(appState);
      goToHome();
    } else if (res.code == 400) {
      setState(() {
        _errors['email'] = res.data['errors']['email']['message'];
        _errors['password'] = res.data['errors']['password']['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 64),
                  if (_errors.containsKey("email"))
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              _errors['email']!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                            contentPadding: EdgeInsets.all(12)),
                      )),
                  const SizedBox(height: 12),
                  if (_errors.containsKey("password"))
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              _errors['password']!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                              contentPadding: EdgeInsets.all(12)),
                          obscureText: true)),
                  const SizedBox(height: 46),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: 40,
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 36, 143, 185))),
                        child: const Text('Continue',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: () {
                          login(Provider.of<AppStateModel>(context,
                              listen: false));
                        },
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                      child: const Text("Don't have an account? Sign up here"))
                ],
              ),
            )));
  }
}
