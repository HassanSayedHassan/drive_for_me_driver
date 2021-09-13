import 'package:drive_for_me_user/models/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverProvider with ChangeNotifier {
  DriverModel driverModel = DriverModel(
      phone: "NULL",
      carType: "NULL",
      carNumber: "NULL",
      carColor: "NULL",
      password: "NULL",
      name: "NULL",
      token: "NULL",
      ordersNumber: 0,
      status: false,
      id: "NULL",
      hasOrder: false,
      hasOrderId: "NULL",
      imageStr: "NULL",
      imageUrl: "NULL");

  DriverModel get getCurrentDriver{
    return driverModel;
  }

  void updateCurrentDriver(DriverModel newDriver){
    driverModel.phone=newDriver.phone;
    driverModel.carType=newDriver.carType;

    driverModel.carNumber=newDriver.carNumber;
    driverModel.carColor=newDriver.carColor;
    driverModel.password=newDriver.password;
    driverModel.name=newDriver.name;
    driverModel.token=newDriver.token;
    driverModel.ordersNumber=newDriver.ordersNumber;
    driverModel.status=newDriver.status;
    driverModel.id=newDriver.id;
    driverModel.hasOrder=newDriver.hasOrder;
    driverModel.hasOrderId=newDriver.hasOrderId;
    driverModel.imageStr=newDriver.imageStr;
    driverModel.imageUrl=newDriver.imageUrl;


    notifyListeners();
  }


}
