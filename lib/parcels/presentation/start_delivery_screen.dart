import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speedest_logistics/app/presentation/loaders/app_loader.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/app/presentation/snackbars/snackbars.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/data/repositories/city_repository.dart';

import '../data/models/city.dart';
import '../data/models/quarter.dart';

class StartDeliveryScreen extends StatefulWidget {
  const StartDeliveryScreen({Key? key}) : super(key: key);

  @override
  State<StartDeliveryScreen> createState() => _StartDeliveryScreenState();
}

class _StartDeliveryScreenState extends State<StartDeliveryScreen> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

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
    return Scaffold(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 13),
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
                              hintText: 'Select city',
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
                              hintText: 'From',
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
                              hintText: 'To',
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
                          onTap: () async {
                            if (selectedCity == null ||
                                from == null ||
                                to == null) {
                              return;
                            }
                            var response =
                                await Navigator.of(context).pushNamed(
                              RoutePath.sendParcel,
                              arguments: {
                                "city": selectedCity!,
                                "from": from!,
                                'to': to!,
                              },
                            );
                            if (response == true) {
                              selectedCity = null;
                              from = null;
                              to = null;
                              fromController.clear();
                              toController.clear();
                              cityController.clear();
                              setState(() {});
                              AppSnackbars.showSucess(
                                context,
                                message: "Your request has been sent",
                              );
                            }
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
          ],
        ),
      ),
    );
  }
}
