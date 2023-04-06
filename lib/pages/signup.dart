import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/app_home.dart';
import 'package:rsaproject/pages/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rsaproject/utils/api.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleInitialController = TextEditingController();

  Map<String, String> _errors = {};

  Future<bool> signup(AppStateModel state) async {
    var success = false;
    Map<String, String> errors = {};

    if (!EmailValidator.validate(emailController.text)) {
      errors['email'] = 'Email is invalid';
    }

    if (passwordConfirmController.text != passwordController.text) {
      errors['password'] = "Passwords do not match";
    }

    if (!(passwordController.text.length > 6)) {
      errors['password'] = "Password must be longer than 6 characters";
    }

    if (firstNameController.text.isEmpty) {
      errors['firstName'] = "First name can't be blank";
    }

    if (lastNameController.text.isEmpty) {
      errors['lastName'] = "Last name can't be blank";
    }

    setState(() {
      _errors = errors;
    });

    if (errors.isNotEmpty) {
      return false;
    }

    var email = emailController.text;
    var password = passwordController.text;
    var firstName = firstNameController.text;
    var lastName = lastNameController.text;
    var middleInitial = middleInitialController.text;

    var res =
        await signupUser(email, password, firstName, lastName, middleInitial);

    if (res.code == 400) {
      setState(() {
        _errors['email'] = res.data['errors']['email']['message'];
      });
      return false;
    } else {
      state.setUser(User.from(res.data));
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 64),
                  const Text(
                    'Signup',
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
                        keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                              contentPadding: EdgeInsets.all(12)),
                          obscureText: true)),
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
                          controller: passwordConfirmController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Confirm Password',
                              contentPadding: EdgeInsets.all(12)),
                          obscureText: true)),
                  const SizedBox(height: 12),
                  if (_errors.containsKey("firstName"))
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              _errors['firstName']!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'First Name',
                            contentPadding: EdgeInsets.all(12)),
                      )),
                  const SizedBox(height: 12),
                  if (_errors.containsKey("middleInitial"))
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              _errors['middleInitial']!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextField(
                          onChanged: (text) {
                            if (text.length > 1) {
                              middleInitialController.text = text[0];
                            }
                          },
                          controller: middleInitialController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Middle Initial (Optional)',
                              contentPadding: EdgeInsets.all(12)),
                          obscureText: true)),
                  const SizedBox(height: 12),
                  if (_errors.containsKey("lastName"))
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              _errors['lastName']!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Last Name',
                              contentPadding: EdgeInsets.all(12)))),
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
                          signup(Provider.of<AppStateModel>(context,
                                  listen: false))
                              .then((success) => {
                                    if (success)
                                      {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AppHome()))
                                      }
                                  });
                        },
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text("Already have an account? Log in here"))
                ],
              ),
            ])));
  }
}
