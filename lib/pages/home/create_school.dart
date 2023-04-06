import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/pages/home/school.dart';
import 'package:rsaproject/utils/api.dart';

class CreateSchool extends StatefulWidget {
  const CreateSchool({super.key});

  @override
  State<StatefulWidget> createState() => _CreateSchool();
}

class _CreateSchool extends State<CreateSchool> {
  String? _error = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();

  _createSchool(AppStateModel state) async {
    var res = await createSchool(
        state.user!, nameController.text, shortNameController.text);

    if (res.code != 200) {
      setState(() {
        _error = res.data['message'];
      });
    } else {
      var info = SchoolInfo.from(res.data);
      state.addSchool(info);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => School(info: info)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create a school",
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 64),
                if (_error != null)
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        _error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                          contentPadding: EdgeInsets.all(12)),
                    )),
                const SizedBox(height: 16),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextField(
                      controller: shortNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Short Name (Optional)',
                          contentPadding: EdgeInsets.all(12)),
                    )),
                const SizedBox(height: 28),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                        ),
                        child: MaterialButton(
                            color: Theme.of(context).colorScheme.primary,
                            child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child: Text('Create!',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)))
                                  ],
                                )),
                            onPressed: () {
                              _createSchool(Provider.of<AppStateModel>(context,
                                  listen: false));
                            })))
              ],
            ),
          )),
    );
  }
}
