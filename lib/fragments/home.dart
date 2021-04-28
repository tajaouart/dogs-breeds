import 'package:dogs_breeds/dao/database.dart';
import 'package:dogs_breeds/model/components.dart';
import 'package:dogs_breeds/model/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

Widget homeFragment(
    {@required List<Breed> breeds, @required BuildContext context}) {
  return (breeds != null && breeds.isNotEmpty)
      ? Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: GridView.count(
              padding: EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              children: <Widget>[
                for (final Breed breed in breeds)
                  InkWell(
                    onTap: () {
                      showDetailModal(breed: breed, context: context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                            Widget child = Center();
                                            if (snapshot.hasData) {
                                              getDatabasesPath()
                                                  .then((String path) {
                                                breed.imageUrl = snapshot.data;
                                                AppDatabase database =
                                                    AppDatabase(path);
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
                                            }
                                            return Stack(children: <Widget>[
                                              Positioned.fill(
                                                  child: Container(
                                                color: Colors.black12,
                                                child: Center(
                                                  child: Container(
                                                    width: 32,
                                                    height: 32,
                                                    child: Image.asset(
                                                      'assets/dog.png',
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              child
                                            ]);
                                          },
                                        )
                                      : Stack(children: <Widget>[
                                          Positioned.fill(
                                              child: Container(
                                            color: Colors.black12,
                                            child: Center(
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                child: Image.asset(
                                                  'assets/dog.png',
                                                ),
                                              ),
                                            ),
                                          )),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    breed.imageUrl),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        ])),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 8.0, bottom: 8),
                            child: Text(breed.name.inCaps,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.openSans(color: dogBlue)),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
      : displayShimmer(context);
}

void showDetailModal({@required Breed breed, @required BuildContext context}) {
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
                      style: GoogleFonts.openSans(
                          color: Colors.white, fontSize: 25),
                    ))),
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: 'Sub-breeds :  ',
                            style: GoogleFonts.roboto(
                                color: Colors.grey, fontSize: 18),
                          ),
                          TextSpan(
                            text: '${breed.subBreeds.length}',
                            style: GoogleFonts.roboto(
                                color: dogBlue, fontSize: 18),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (final String subBreed in breed.subBreeds)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  showDetailModal(
                                      breed: breed, context: context);
                                },
                                leading:
                                    Image.asset('assets/pets_black_24dp.png'),
                                title: Text(
                                  subBreed.inCaps,
                                  style: GoogleFonts.openSans(),
                                ),
                              ),
                            )
                        ],
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
