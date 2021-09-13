import 'package:drive_for_me_user/helpers/my_theme.dart';
import 'package:drive_for_me_user/widgets/cusstom_drower.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'add_driver_screen.dart';
import 'home_screen.dart';
import 'success_send_email.dart';

class TapedScreens extends StatefulWidget {


  @override
  _TapedScreensState createState() => _TapedScreensState();
}

class _TapedScreensState extends State<TapedScreens> {

   PersistentTabController _controller = PersistentTabController(initialIndex: 1);

   List<Widget> _buildScreens() {
     return [
       HomeScreen(),
       AddDriverScreen()
     ];
   }

   List<PersistentBottomNavBarItem> _navBarsItems() {
     return [
       PersistentBottomNavBarItem(
         icon: Icon(CupertinoIcons.home),
         title: ("All Live Trips"),
         activeColorPrimary: MyTheme(context).iconColor,
         activeColorSecondary:MyTheme(context).iconColor,
         inactiveColorPrimary: CupertinoColors.systemGrey,
       ),
       PersistentBottomNavBarItem(
         icon: Icon(CupertinoIcons.car_detailed),
         title: ("Add Driver"),
//         activeColorSecondary: MyTheme(context).buttonTextColor,
         activeColorPrimary: MyTheme(context).iconColor,
         activeColorSecondary:MyTheme(context).iconColor,
         inactiveColorPrimary: CupertinoColors.systemGrey,
       ),
     ];
   }
   List<String> _titles=[
     "Show ALl Live Trips",
     "Add New Driver",

   ];
  int selectedIndex=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme(context).backgroundColor,
      appBar: AppBar(
        title: Text(_titles[selectedIndex]) ,
        centerTitle: true,
        backgroundColor:MyTheme(context).iconColor ,
        actions: [
          InkWell(
              onTap: () {
                if (Theme.of(context).brightness != Brightness.dark) {
                  EasyDynamicTheme.of(context).changeTheme();
                  EasyDynamicTheme.of(context).changeTheme();
                } else {
                  EasyDynamicTheme.of(context).changeTheme();
                }
              },
              child: Icon(
                Icons.mood,
                color: Colors.amber,
                size: 40,
              )),
        ],
      ),
     // drawer: CustomDrawer(),
      body:  PersistentTabView(

        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: MyTheme(context).buttonNavColor, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
        onItemSelected: (index){
        setState(() {
          selectedIndex=index;
        });
        },
      ),
    );
  }
}



