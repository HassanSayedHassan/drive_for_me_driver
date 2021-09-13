class DriverModel{
  String ?id;
  String ?token;
  String ?name;
  String ?phone;
  String ?password;
  String ?carNumber;
  String ?carColor;
  String ?carType;
  String ?imageUrl;
  String ?imageStr;
  String ?hasOrderId;
  double ?totalCash;
  int ?ordersNumber;
  double ?sumRates;
  int ?ratesNum;
  bool ?status;
  bool ?hasOrder;

  DriverModel({
    this.id="NULL",
    this.token="NULL",
    this.name="NULL",
    this.phone="NULL",
    this.password="NULL",
    this.carNumber="NULL",
    this.carColor="NULL",
    this.carType="NULL",
    this.hasOrderId="NULL",
    this.imageUrl="NULL",
    this.imageStr="NULL",
    this.ordersNumber=0,
    this.sumRates=0.0,
    this.totalCash=0.0,
    this.ratesNum=0,
    this.status=false,
    this.hasOrder=false,
  });
  DriverModel.fromJson(Map<String,dynamic> data){
    id = data['id'];
    token = data['token'];
    name = data['name'];
    phone = data['phone'];
    password = data['password'];
    carNumber = data['carNumber'];
    carColor = data['carColor'];
    carType = data['carType'];
    ordersNumber = data['OrdersNumber'];
    sumRates = data['sumRates'];
    hasOrderId = data['hasOrderId'];
    imageUrl = data['imageUrl'];
    imageStr = data['imageStr'];
    ratesNum = data['ratesNum'];
    totalCash = data['totalCash'];
    status = data['status'];
    hasOrder = data['hasOrder'];
  }
  Map<String, dynamic> toJason() => {
    'id' : id,
    'token' : token,
    'name' : name,
    'phone' : phone,
    'imageUrl' : imageUrl,
    'imageStr' : imageStr,
    'password' : password,
    'carNumber' : carNumber,
    'carColor' : carColor,
    'carType' : carType,
    'hasOrderId' : hasOrderId,
    'OrdersNumber' : ordersNumber,
    'ratesNum' : ratesNum,
    'totalCash' : totalCash,
    'sumRates' : sumRates,
    'status' : status,
    'hasOrder' : hasOrder,
  };
}