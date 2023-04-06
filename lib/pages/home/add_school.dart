import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rsaproject/models.dart';
import 'package:rsaproject/utils/api.dart';

class AddSchool extends StatefulWidget {
  const AddSchool({super.key});

  @override
  State<StatefulWidget> createState() => _AddSchool();
}

class _AddSchool extends State<AddSchool> {
  final _statesController = MaterialStatesController({MaterialState.disabled});
  bool _disabled = true;
  TextEditingController codeController = TextEditingController();
  String? _error = null;

  joinSchool(AppStateModel state) async {
    if (_disabled) return;
    var res = await joinViaCode(state.user!, codeController.text);
    setState(() {
      if (res.code != 200) {
        _error = res.data['message'];
      } else {
        _error = null;
        state.addSchool(SchoolInfo.from(res.data));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _statesController.update(MaterialState.disabled, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Container(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_error != null)
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            _error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )),
                    PinCodeTextField(
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        controller: codeController,
                        pinTheme: PinTheme(
                            inactiveColor: Colors.white,
                            fieldWidth: 40,
                            fieldHeight: 50,
                            borderRadius: BorderRadius.circular(12),
                            shape: PinCodeFieldShape.box),
                        onChanged: (code) {
                          _statesController.update(
                              MaterialState.disabled, code.length != 6);
                          _disabled = code.length != 6;
                        }),
                    Container(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                              color: Theme.of(context).colorScheme.surface,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 42.0),
                              child: const Text('Back',
                                  style: TextStyle(fontSize: 16)),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          ElevatedButton(
                              statesController: _statesController,
                              style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 42.0)),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.primary)),
                              onPressed: () {
                                joinSchool(Provider.of<AppStateModel>(context,
                                    listen: false));
                              },
                              child: const Text('Add',
                                  style: TextStyle(fontSize: 16)))
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
