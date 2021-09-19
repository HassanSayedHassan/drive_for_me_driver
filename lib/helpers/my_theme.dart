
import 'package:drive_for_me_user/constants/color.dart';
import 'package:flutter/material.dart';

import '../res.dart';

class MyTheme{
  var context;
  MyTheme(this.context);

  Color get backgroundColor{
    return  Theme.of(context).brightness != Brightness.dark?
    Colors.white:Colors.black;
  }
  Color get buttonNavColor{
    return  Theme.of(context).brightness != Brightness.dark?
    Color(0xffececec):Color(0xff393939);
  }
  AssetImage get appLogo{
    return  Theme.of(context).brightness != Brightness.dark?
    AssetImage('assets/images/logo_light.png'):AssetImage('assets/images/logo_dark.png');
  }

  Color get textColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get iconColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get borderEnabledColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get borderFocusedColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get hintColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.grayLight:MyColors.grayLight;
  }
  Color get chatContainerRightColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get chatTextRightColor{
    return  Theme.of(context).brightness != Brightness.dark?
    Colors.white:Colors.black;
  }
  Color get chatContainerLeftColor{
    return  Theme.of(context).brightness != Brightness.dark?
    Color(0xffeae9e9):Colors.white;
  }
  Color get chatTextLeftColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get buttonColor{
    return  Theme.of(context).brightness != Brightness.dark?
    MyColors.primaryLight:MyColors.primaryDarkBlue;
  }
  Color get buttonTextColor{
    return  Theme.of(context).brightness != Brightness.dark?
    Colors.white:Colors.black;
  }
  String get getMap{
    return  Theme.of(context).brightness != Brightness.dark?
    Res.map_silver:Res.map_dark;
  }
}