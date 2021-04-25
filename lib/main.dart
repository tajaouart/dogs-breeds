import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'api.dart';
import 'components.dart';
import 'dao/database.dart';
import 'models.dart';

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
  int _selectedIndex = 0;
  final userController = TextEditingController();
  final passwdController = TextEditingController();

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      Provider.of<BreedViewModel>(context, listen: false).fetchBreeds(prefs);
    });
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetOptions(BreedViewModel viewModel, int index) {
    return index == 0 ? homeFragment(viewModel) : loginFragment();
  }

  Widget loginFragment() {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        Widget child;
        if (snapshot.hasError) {
          child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Error',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  height: 32,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      "Retry",
                      style: TextStyle(color: dogBlue, fontSize: 18),
                    ))
              ]);
        } else if (snapshot.hasData) {
          if (snapshot.data.getBool('is_logged_in') ?? false) {
            child = Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Logged in",
                    style: TextStyle(color: Colors.green, fontSize: 25),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 32,
                  )
                ],
              ),
            );
          } else {
            child = Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64,
                    ),
                    Text(
                      "Authentification",
                      style: TextStyle(color: dogBlue, fontSize: 25),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(hintText: 'username'),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: passwdController,
                      decoration: InputDecoration(hintText: 'password'),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Api()
                              .login(userController.text ?? "",
                                  passwdController.text ?? "")
                              .then((value) {
                            setState(() {
                              if (value["id"] != null) {
                                SharedPreferences.getInstance().then((value) {
                                  value.setBool('is_logged_in', true);
                                });
                              }
                            });
                            print(value);
                          });
                        },
                        child: Icon(Icons.login)),
                  ],
                ),
              ),
            );
          }
        } else {
          child = Center(
            child: Text('...'),
          );
        }
        return Center(
          child: child,
        );
      },
    );
  }

  Widget homeFragment(BreedViewModel viewModel) {
    return (viewModel.listBreeds != null && viewModel.listBreeds.isNotEmpty)
        ? Padding(
            padding: EdgeInsets.all(0),
            child: GridView.count(
              padding: EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              children: [
                for (final Breed breed in viewModel.listBreeds)
                  InkWell(
                    onTap: () {
                      showDetailModal(breed);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              child: Container(
                                  child: (breed.imageUrl == null ||
                                          breed.imageUrl.isEmpty)
                                      ? FutureBuilder<String>(
                                          future: getImageUrl(breed.name),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            Widget child;
                                            if (snapshot.hasData) {
                                              getDatabasesPath().then((value) {
                                                breed.imageUrl = snapshot.data;
                                                AppDatabase database =
                                                    AppDatabase(value);
                                                final breedDao =
                                                    database.breedDao;
                                                breedDao.updateBreed(breed);
                                              });

                                              child = Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        snapshot.data),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              child = const Icon(
                                                Icons.image,
                                                size: 60,
                                              );
                                            } else {
                                              child = Container(
                                                color: Colors.black12,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                ),
                                              );
                                            }
                                            return child;
                                          },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(breed.imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 8.0, bottom: 8),
                            child: Text(
                              breed.name.inCaps,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        : CircularProgressIndicator();
  }

  void showDetailModal(Breed breed) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16)),
          child: Container(
            color: dogWhite,
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(breed.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 300,
                  ),
                  Container(
                      color: dogBlue,
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Center(
                          child: Text(
                        breed.name.inCaps,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ))),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sub-breeds : ${breed.subBreeds.length}",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          children: <Widget>[
                            for (final String subBreed in breed.subBreeds)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {},
                                  leading:
                                      Image.asset('assets/pets_black_24dp.png'),
                                  title: Text(subBreed.inCaps),
                                ),
                              )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BreedViewModel viewModel = Provider.of<BreedViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              Widget child = Center();
              if (snapshot.hasData) {
                if (snapshot.data.getBool('is_logged_in') ?? false) {
                  child = TextButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((value) {
                          setState(() {
                            value.setBool('is_logged_in', false);
                          });
                        });
                      },
                      child: Text(
                        "Log out",
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

const dogBlue = const Color(0xFF1A91DB);
const dogWhite = const Color(0xFFEEEEEE);
