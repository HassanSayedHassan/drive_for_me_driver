
class PlacePredictions{
  String? secondaryText;
  String? mainText;
  String? placeId;

  PlacePredictions({this.secondaryText, this.mainText, this.placeId});

  PlacePredictions.fomJason(Map<String,dynamic>json)
  {
    placeId=json["place_id"];
    secondaryText=json["structured_formatting"]["secondary_text"];
    mainText=json["structured_formatting"]["main_text"];
  }
}