import 'package:dogs_breeds/fragments/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'components.dart';
import 'fragments/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => BreedViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dogs-breeds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Dogs-breeds'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Tabs' index
  int _selectedIndex = 0;
  final userController = TextEditingController();
  final passwdController = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      Provider.of<BreedViewModel>(context, listen: false).fetchBreeds(prefs);
    });
    userController.text = 'Enzo';
    passwdController.text = '123456';
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetOptions(BreedViewModel viewModel, int index) {
    return index == 0
        ? homeFragment(viewModel: viewModel, context: context)
        : loginFragment(
            userController: userController,
            passwdController: passwdController,
            onRetry: () {
              setState(() {});
            },
            onLogin: () {
              Api()
                  .login(userController.text, passwdController.text)
                  .then((dynamic response) {
                setState(() {
                  if (response['id'] != null) {
                    SharedPreferences.getInstance()
                        .then((SharedPreferences prefs) {
                      prefs.setBool('is_logged_in', true);
                      if (response['name'] != null) {
                        prefs.setString('name', response['name']);
                      }
                    });
                  }
                });
              });
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final BreedViewModel viewModel = Provider.of<BreedViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              Widget child = Center();
              if (snapshot.hasData) {
                if (snapshot.data.getBool('is_logged_in') ?? false) {
                  child = TextButton(
                      onPressed: () {
                        SharedPreferences.getInstance()
                            .then((SharedPreferences prefs) {
                          setState(() {
                            prefs.setBool('is_logged_in', false);
                          });
                        });
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.white),
                      ));
                }
              }
              return Center(
                child: child,
              );
            },
          )
        ],
      ),
      body: Center(
        child: _widgetOptions(viewModel, _selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: dogBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
