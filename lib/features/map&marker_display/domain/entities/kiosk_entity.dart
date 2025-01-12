class Kiosk {
  String placeId;
  String address;
  String? aislesCount;
  String? cashierCount;
  String city;
  String? crowdId;
  String districtName;
  String? employeeCount;
  String image;
  double lat;
  double lng;
  String name;
  String status;
  String streetName;
  String type;
  String w3W;
  List<String>? unavailableMissions;

  Kiosk(
      {required this.placeId,
      required this.address,
      required this.aislesCount,
      required this.cashierCount,
      required this.city,
      required this.crowdId,
      required this.districtName,
      required this.employeeCount,
      required this.image,
      required this.lat,
      required this.lng,
      required this.name,
      required this.status,
      required this.streetName,
      required this.type,
      required this.w3W,
      this.unavailableMissions});
}
