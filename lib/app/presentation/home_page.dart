import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:speedest_logistics/app/presentation/router/router.dart';
import 'package:speedest_logistics/locator.dart';
import 'package:speedest_logistics/parcels/presentation/sending_parcels_screen.dart';
import 'package:speedest_logistics/parcels/presentation/start_delivery_screen.dart';
import 'package:speedest_logistics/parcels/presentation/waiting_parcels_screen.dart';

import 'package:speedest_logistics/profile/business_logic/profile_cubit/profile_cubit.dart';
import 'package:speedest_logistics/profile/presentation/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            AnimatedOpacity(
              opacity: _currentIndex == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: const StartDeliveryScreen(),
            ),
            AnimatedOpacity(
              opacity: _currentIndex == 1 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: const SendingParcelsScreen(),
            ),
            AnimatedOpacity(
              opacity: _currentIndex == 2 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: const WaitingParcelsScreen(),
            ),
            AnimatedOpacity(
              opacity: _currentIndex == 3 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: BlocProvider(
                create: (context) => locator.get<ProfileCubit>(),
                child: const ProfilePage(),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoutePath.scanParcelQrCodeScreen);
          },
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
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
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
                  size: 30,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesome.send_o,
                  size: 30,
                ),
                label: 'Sending',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  MaterialCommunityIcons.offer,
                  size: 30,
                ),
                label: 'Offering',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  AntDesign.user,
                  size: 30,
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
