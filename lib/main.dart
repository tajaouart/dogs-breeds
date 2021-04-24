import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components.dart';
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

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
    return Center(
      child: Text('Login'),
    );
  }

  Widget homeFragment(BreedViewModel viewModel) {
    return (viewModel.listBreeds != null && viewModel.listBreeds.isNotEmpty)
        ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
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
                                  child: Image.network(
                                    breed.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
            ),
          )
        : CircularProgressIndicator();
  }

  void showDetailModal(Breed breed) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: dogWhite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(breed.imageUrl),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  height: 200,
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
