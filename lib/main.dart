import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const PinPassGenerator());
}

class PinPassGenerator extends StatelessWidget {
  const PinPassGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: _notifier,
        builder: (_, mode, __) {
          return MaterialApp(
            title: 'PassPin Generator',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              primaryColor: Colors.white30,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.grey,
              primaryColor: Colors.black,
            ),
            home: const GenHomePage(title: 'PPG Home Page'),
          );
        });
  }
}

class GenHomePage extends StatefulWidget {
  const GenHomePage({super.key, required this.title});

  final String title;

  @override
  State<GenHomePage> createState() => _GenHomePageState();
}


class PasswordGenPage extends StatefulWidget {
  const PasswordGenPage({super.key});

  @override
  State<PasswordGenPage> createState() => _GetPasswordGenPage();
}

class PinGenPage extends StatefulWidget {
  const PinGenPage({super.key});

  @override
  State<PinGenPage> createState() => _GetPinGenPage();
}

class _GetPinGenPage extends State<PinGenPage> {

  bool _isPinSizeOfSix = false;
  String _nowPin = "****";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getMainColor(false),
      appBar: AppBar(
        title: Text(
          "PinG",
          style: TextStyle(
            color: ThemeHelper.getTextColor(),
            fontWeight: FontWeight.w800,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: ThemeHelper.getTextColor(),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 100, 15, 0),
          child: Container(
              decoration: BoxDecoration(
                  color: ThemeHelper.getSecondColor(),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                      child: Container(
                        height: 100,
                        width: 330,
                        decoration: BoxDecoration(
                            color: ThemeHelper.getMainColor(false),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            _nowPin,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ThemeHelper.getTextColor(),
                            ),
                          ),
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: SwitchListTile(
                        title: Text('Шестизначный пин-код',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        value: _isPinSizeOfSix,
                        onChanged: (bool value) {
                          setState(() {
                            _isPinSizeOfSix = value;
                          });
                        },
                        selectedTileColor: ThemeHelper.getMainColor(false),
                        tileColor: ThemeHelper.getMainColor(false),
                        secondary: Icon(
                          Icons.gpp_good,
                          color: ThemeHelper.getMainColor(false),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: buildMaterialButtonGenerate(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: buildMaterialButtonCopy(),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }

  Material buildMaterialButtonGenerate() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          setState(() {
            _nowPin = generatePin();
          });
        },
        child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 60,
            width: 330,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeHelper.getButtonColor(),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  LayoutBuilder(builder: (context, constrains) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeHelper.getMainColor(true),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: const Icon(
                        Icons.pin,
                        color: Colors.white,
                      ),
                    );
                  }),
                  Expanded(child: Text(
                    "Сгенерировать",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ThemeHelper.getTextColor(),
                    ),
                  ))
                ],
              ),
            )
        ),
      ),
    );
  }

  Material buildMaterialButtonCopy() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: _nowPin));
        },
        child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 60,
            width: 330,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeHelper.getButtonColor()
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  LayoutBuilder(builder: (context, constrains) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeHelper.getMainColor(true),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                    );
                  }),
                  Expanded(child: Text(
                    "Копировать",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ThemeHelper.getTextColor(),
                    ),
                  ))
                ],
              ),
            )
        ),
      ),
    );
  }

  String generatePin() {
    String numbers = '1234567890';
    int pinLength = 0;
    if (_isPinSizeOfSix) {
      pinLength = 6;
    } else {
      pinLength = 4;
    }
    String seed = numbers;
    String password = '';
    List<String> list = seed.split('').toList();
    Random rand = Random();
    for (int i = 0; i < pinLength; i++) {
      int index = rand.nextInt(list.length);
      password += list[index];
    }
    return password;
  }
}


class _GetPasswordGenPage extends State<PasswordGenPage> {

  bool _isPasswordLong = false;
  String _nowPassword = "****************";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getMainColor(false),
      appBar: AppBar(
        title: Text(
          "PassG",
          style: TextStyle(
            color: ThemeHelper.getTextColor(),
            fontWeight: FontWeight.w800,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: ThemeHelper.getTextColor(),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 100, 15, 0),
          child: Container(
              decoration: BoxDecoration(
                  color: ThemeHelper.getSecondColor(),
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                      child: Container(
                        height: 100,
                        width: 330,
                        decoration: BoxDecoration(
                            color: ThemeHelper.getMainColor(false),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            _nowPassword,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeHelper.getTextColor(),
                            ),

                          ),
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: SwitchListTile(
                        title: Text('Длинный пароль',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        value: _isPasswordLong,
                        onChanged: (bool value) {
                          setState(() {
                            _isPasswordLong = value;
                          });
                        },
                        selectedTileColor: ThemeHelper.getMainColor(false),
                        tileColor: ThemeHelper.getMainColor(false),
                        secondary: Icon(
                          Icons.gpp_good,
                          color: ThemeHelper.getMainColor(false),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: buildMaterialButtonGenerate(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: buildMaterialButtonCopy(),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }

  Material buildMaterialButtonGenerate() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          setState(() {
            _nowPassword = generatePassword();
          });
        },
        child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 60,
            width: 330,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeHelper.getButtonColor(),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  LayoutBuilder(builder: (context, constrains) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeHelper.getMainColor(true),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: const Icon(
                        Icons.pin,
                        color: Colors.white,
                      ),
                    );
                  }),
                  Expanded(child: Text(
                    "Сгенерировать",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ThemeHelper.getTextColor(),
                    ),
                  ))
                ],
              ),
            )
        ),
      ),
    );
  }

  Material buildMaterialButtonCopy() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: _nowPassword));
        },
        child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 60,
            width: 330,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeHelper.getButtonColor()
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  LayoutBuilder(builder: (context, constrains) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeHelper.getMainColor(true),
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                    );
                  }),
                  Expanded(child: Text(
                    "Копировать",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: ThemeHelper.getTextColor(),
                    ),
                  ))
                ],
              ),
            )
        ),
      ),
    );
  }

  String generatePassword() {
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '1234567890';
    String symbols = '!@#\$%^&*()<>,./';
    int passLength = 0;
    if (_isPasswordLong) {
      passLength = 24;
    } else {
      passLength = 16;
    }
    String seed = upper + lower + numbers + symbols;
    String password = '';
    List<String> list = seed.split('').toList();
    Random rand = Random();
    for (int i = 0; i < passLength; i++) {
      int index = rand.nextInt(list.length);
      password += list[index];
    }
    return password;
  }
}

class _GenHomePageState extends State<GenHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeHelper.getMainColor(false),
        appBar: AppBar(
          title: Text(
            "PPG",
            style: TextStyle(
              color: ThemeHelper.getTextColor(),
              fontWeight: FontWeight.w800,
              fontSize: 25.0,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              setState(() {
                if (_notifier.value == ThemeMode.light) {
                  _notifier.value = ThemeMode.dark;
                } else {
                  _notifier.value = ThemeMode.light;
                }
              });
            },
            icon: ThemeHelper.getLightIcon(),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 200, 0, 30),
              child: Text(
                "Что будем\nгенерировать?",
                style: TextStyle(
                  color: ThemeHelper.getTextColor(),
                  fontWeight: FontWeight.w800,
                  fontSize: 40.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeHelper.getSecondColor(),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: buildMaterialButtonPassword(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: buildMaterialButtonPin(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  Material buildMaterialButtonPassword() {
    return
      Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PasswordGenPage()),
            );
          },
          child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 70,
              width: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeHelper.getButtonColor(),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constrains) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: ThemeHelper.getMainColor(true),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: const Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(child: Text(
                      "Пароль",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ThemeHelper.getTextColor(),
                      ),
                    ))
                  ],
                ),
              )
          ),
        ),
      );
  }

  Material buildMaterialButtonPin() {
    return
      Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PinGenPage()),
            );
          },
          child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 70,
              width: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ThemeHelper.getButtonColor(),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    LayoutBuilder(builder: (context, constrains) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: ThemeHelper.getMainColor(true),
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: const Icon(
                          Icons.pin,
                          color: Colors.white,
                        ),
                      );
                    }),
                    Expanded(child: Text(
                      "Пин-код",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ThemeHelper.getTextColor(),
                      ),
                    ))
                  ],
                ),
              )
          ),
        ),
      );
  }
}

class ThemeHelper {
  static Color getTextColor() {
    if (_notifier.value == ThemeMode.light) {
      return Colors.black;
    }
    return Colors.white;
  }

  static Color getMainColor(bool isIcon) {
    if (_notifier.value == ThemeMode.light) {
      return Colors.pink.shade50;
    } else if (isIcon) {
      return Colors.tealAccent.shade400;
    }
    return Colors.grey.shade800;
  }

  static Color getButtonColor() {
    if (_notifier.value == ThemeMode.light) {
      return Colors.white;
    }
    return Colors.grey.shade800;
  }

  static Color getSecondColor() {
    if (_notifier.value == ThemeMode.light) {
      return Colors.white;
    }
    return Colors.tealAccent.shade400;
  }

  static Icon getLightIcon() {
    if (_notifier.value == ThemeMode.light) {
      return const Icon(
        Icons.light_mode_rounded,
        color: Colors.black,
      );
    }
    return const Icon(
      Icons.nightlight_round_rounded,
      color: Colors.white,
    );
  }
}
