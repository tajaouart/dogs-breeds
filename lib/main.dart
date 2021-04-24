import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Provider.of<BreedViewModel>(context, listen: false).fetchBreeds();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _widgetOptions(BreedViewModel viewModel, int index) {
    return index == 0 ? option1(viewModel) : option2();
  }

  Widget option2() {
    return Center(
      child: Text('Login'),
    );
  }

  Widget option1(viewModel) {
    return (viewModel.breeds != null && viewModel.breeds.isNotEmpty)
        ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  for (final Breed breed in viewModel.breeds)
                    InkWell(
                      onTap: () {},
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
}
