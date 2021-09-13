


import 'package:drive_for_me_user/models/adress.dart';
import 'package:drive_for_me_user/models/current_user_model.dart';
import 'package:drive_for_me_user/models/driver_model.dart';

class RequestModel
{
  String? id;
  CurrentUserModel ?currentUserModel=CurrentUserModel();
  DriverModel? driverModel=DriverModel();

  Address? pickUpLocation=Address();
  Address? dropOffLocation=Address();

  String? status;
  String? cashPrice;
  double? rateDriver;
  String? userAnyComment;
  String? paymentMethode;
  String? cancelledCase;

  String? requestData;
  String? acceptedDate;
  String? pickedDate;
  String? dropOffData;

  RequestModel({
   this.id="NULL",
    this.currentUserModel,
    this.driverModel,
    this.pickUpLocation,
    this.dropOffLocation,
    this.status="send",
    this.cashPrice="NULL",
    this.rateDriver=0.0,
    this.userAnyComment="NULL",
    this.paymentMethode="NULL",
    this.cancelledCase="NULL",
    this.requestData="NULL",
    this.acceptedDate="NULL",
    this.pickedDate="NULL",
    this.dropOffData="NULL",
});



  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentUserModel=CurrentUserModel.fromJson(json['currentUserModel']);
    driverModel=DriverModel.fromJson(json['driverModel']);
    pickUpLocation=Address.fromJson(json['pickUpLocation']);
    dropOffLocation=Address.fromJson(json['dropOffLocation']);

    status = json['status'];
    cashPrice = json['cashPrice'];
    rateDriver = json['rateDriver'];
    userAnyComment = json['userAnyComment'];
    paymentMethode = json['paymentMethode'];
    cancelledCase = json['cancelledCase'];
    requestData = json['requestData'];
    acceptedDate = json['acceptedDate'];
    pickedDate = json['pickedDate'];
    dropOffData = json['dropOffData'];

  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'currentUserModel': this.currentUserModel!.toJson(),
    'driverModel': this.driverModel!.toJason(),
    'pickUpLocation': this.pickUpLocation!.toJson(),
    'dropOffLocation': this.dropOffLocation!.toJson(),

    'status': status,
    'cashPrice': cashPrice,
    'rateDriver': rateDriver,
    'userAnyComment': userAnyComment,
    'paymentMethode': paymentMethode,
    'cancelledCase': cancelledCase,
    'requestData': requestData,
    'acceptedDate': acceptedDate,
    'pickedDate': pickedDate,
    'dropOffData': dropOffData,

  };



}