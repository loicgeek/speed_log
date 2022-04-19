import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speedest_logistics/app/data/api_client.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/route_path.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/models/city.dart';
import 'package:speedest_logistics/parcels/data/models/quarter.dart';
import 'package:speedest_logistics/parcels/data/repositories/city_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List bottomItems = [
    [AntDesign.home, 'Home', false],
    [MaterialCommunityIcons.truck_delivery, 'Tracking', false],
    [Icons.history, 'History', false],
    [Ionicons.ios_person, 'Profile', false]
  ];
  late CityRepository cityRepository;
  City? selectedCity;
  Quarter? from;
  Quarter? to;

  @override
  void initState() {
    cityRepository = locator.get<CityRepository>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/speed_log_ver.png",
                height: 150,
              ),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(minHeight: 200),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        //const SizedBox(height: 15),
                        const Text(
                          'Send parcel  now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TypeAheadField<City>(
                          loadingBuilder: (context) {
                            return AppLoader.ballClipRotateMultiple();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: cityController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                fillColor: Colors.white10,
                                filled: true,
                                hintText: 'SELECT CITY',
                                helperText: 'City of delivery',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              )),
                          suggestionsCallback: (pattern) async {
                            return await cityRepository.find(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              //  leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion.name),
                              // subtitle: Text('\$${suggestion['price']}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            selectedCity = suggestion;
                            cityController.text = suggestion.name;
                            setState(() {});
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         ProductPage(product: suggestion)));
                          },
                        ),

                        const SizedBox(height: 15),
                        TypeAheadField<Quarter>(
                          loadingBuilder: (context) {
                            return AppLoader.ballClipRotateMultiple();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: fromController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                fillColor: Colors.white10,
                                filled: true,
                                hintText: 'FROM',
                                helperText: "Quater of departure",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              )),
                          suggestionsCallback: (pattern) async {
                            if (selectedCity == null) return [];
                            return await cityRepository.findQuarterByCityId(
                                selectedCity!.id, pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              //  leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion.name),
                              // subtitle: Text('\$${suggestion['price']}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            from = suggestion;
                            setState(() {});
                            fromController.text = suggestion.name;
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         ProductPage(product: suggestion)));
                          },
                        ),

                        const SizedBox(height: 15),
                        TypeAheadField<Quarter>(
                          loadingBuilder: (context) {
                            return AppLoader.ballClipRotateMultiple();
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: toController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                fillColor: Colors.white10,
                                filled: true,
                                hintText: 'TO',
                                helperText: "Quater of arrival",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              )),
                          suggestionsCallback: (pattern) async {
                            if (selectedCity == null) return [];
                            return await cityRepository.findQuarterByCityId(
                                selectedCity!.id, pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              //  leading: Icon(Icons.shopping_cart),
                              title: Text(suggestion.name),
                              // subtitle: Text('\$${suggestion['price']}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            to = suggestion;
                            setState(() {});
                            toController.text = suggestion.name;
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         ProductPage(product: suggestion)));
                          },
                        ),

                        const SizedBox(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RoutePath.sendParcel,
                                arguments: {
                                  "city": selectedCity!,
                                  "from": from!,
                                  'to': to!,
                                },
                              );
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text('Start',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white)),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Material(
              //     borderRadius: BorderRadius.circular(8),
              //     elevation: 4,
              //     child: Container(
              //       height: 80,
              //       width: MediaQuery.of(context).size.width,
              //       // margin: const EdgeInsets.all(16),
              //       // padding: const EdgeInsets.all(2),
              //       decoration: BoxDecoration(
              //         color: Colors.indigoAccent,
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: <Widget>[
              //           const SizedBox(width: 15),
              //           Expanded(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: const <Widget>[
              //                 Text(
              //                   'NEW USER?',
              //                   style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.bold),
              //                 ),
              //                 SizedBox(height: 8),
              //                 Text(
              //                     '''Use promo code APPWRITE2022 for 20% Off''',
              //                     style: TextStyle(
              //                         color: Colors.white60, fontSize: 14))
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(MaterialCommunityIcons.barcode_scan),
        ),
        bottomNavigationBar: BottomAppBar(
          // ****** APP BAR ******************
          shape:
              const CircularNotchedRectangle(), // ← carves notch for FAB in BottomAppBar
          color: Theme.of(context).primaryColor.withAlpha(255),
          // ↑ use .withAlpha(0) to debug/peek underneath ↑ BottomAppBar
          elevation: 0, // ← removes slight shadow under FAB, hardly noticeable
          clipBehavior: Clip.antiAlias,
          // ↑ default elevation is 8. Peek it by setting color ↑ alpha to 0
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            // ***** NAVBAR  *************************
            elevation: 0, // 0 removes ugly rectangular NavBar shadow
            // CRITICAL ↓ a solid color here destroys FAB notch. Use alpha 0!
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            // ====================== END OF INTERESTING STUFF =================
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.home,
                  size: 40,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  MaterialCommunityIcons.face_profile,
                  size: 40,
                ),
                label: 'Profile',
              )
            ],
          ),
        ),
        // extendBody: true,
      ),
    );
  }
}
