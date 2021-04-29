import 'package:dogs_breeds/fragments/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fragments/login.dart';
import 'model/api.dart';
import 'model/breed_repo.dart';
import 'model/components.dart';
import 'model/models.dart';

void main() {
  runApp(MyApp());
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
    userController.text = 'Enzo';
    passwdController.text = '123456';
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetOptions(List<Breed> breeds, int index) {
    return index == 0
        ? homeFragment(breeds: breeds, context: context)
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
    // start fetching data
    breedsBloc..getBreeds();

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
          child: StreamBuilder<BreedResponse>(
              stream: breedsBloc.subject.stream,
              builder: (context, AsyncSnapshot<BreedResponse> snapshot) {
                return Center(
                  child: _widgetOptions(
                      snapshot.data == null ? [] : snapshot.data.breeds,
                      _selectedIndex),
                );
              })),
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
