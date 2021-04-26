import 'package:dogs_breeds/components.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget loginFragment(
    {@required VoidCallback onRetry,
    @required VoidCallback onLogin,
    @required TextEditingController userController,
    @required TextEditingController passwdController}) {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
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
                  onPressed: onRetry,
                  child: Text(
                    "Retry",
                    style: TextStyle(color: dogBlue, fontSize: 18),
                  ))
            ]);
      } else if (snapshot.hasData) {
        if (snapshot.data.getBool('is_logged_in') ?? false) {
          child = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (BuildContext context,
                        AsyncSnapshot<SharedPreferences> snapshot) {
                      if (snapshot.hasData) {
                        return RichText(
                          text: TextSpan(
                            text: 'Hello ',
                            style: TextStyle(color: dogBlue, fontSize: 25),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${snapshot.data.getString('name') ?? ''}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' 😃'),
                            ],
                          ),
                        );

                        return Text(
                          "Hello ${snapshot.data.getString('name') ?? ''}",
                          style: TextStyle(fontSize: 25),
                        );
                      }
                      {
                        return Center();
                      }
                    }),
                Image.asset('assets/welcome.png')
              ],
            ),
          );
        } else {
          child = Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/cautious_dog.png'),
                    ),
                    Text(
                      "Authentification",
                      style: TextStyle(color: dogBlue, fontSize: 25),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: userController,
                      decoration: InputDecoration(hintText: 'username'),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwdController,
                      decoration: InputDecoration(hintText: 'password'),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                        onPressed: onLogin, child: Icon(Icons.login)),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        child = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(), Text('Connecting...')],
          ),
        );
      }
      return Container(
        color: Colors.white,
        child: Center(
          child: child,
        ),
      );
    },
  );
}
