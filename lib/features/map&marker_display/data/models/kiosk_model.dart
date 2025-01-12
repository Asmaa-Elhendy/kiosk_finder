import '../../domain/entities/kiosk_entity.dart';

class KioskModel {
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

  KioskModel({
    required this.placeId,
    required this.address,
    this.aislesCount,
    this.cashierCount,
    required this.city,
    this.crowdId,
    required this.districtName,
    this.employeeCount,
    required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    required this.status,
    required this.streetName,
    required this.type,
    required this.w3W,
    this.unavailableMissions,
  });

  factory KioskModel.fromJson(Map<String, dynamic> json) {
    return KioskModel(
      placeId: json['placeId'],
      address: json['address']??'',
      aislesCount: json['aislesCount']??'',
      cashierCount: json['cashierCount']??'',
      city: json['city']??'',
      crowdId: json['crowdId']??'',
      districtName: json['districtName']??'',
      employeeCount: json['employeeCount'].toString()??'',
      image: json['image']??'',
      lat: json['lat']??0,
      lng: json['lng']??0,
      name: json['name']??'',
      status: json['status']??'',
      streetName: json['streetName']??'',
      type: json['type']??'',
      w3W: json['w3W']??'',
      unavailableMissions: List<String>.from(json['unavailableMissions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'address': address,
      'aislesCount': aislesCount,
      'cashierCount': cashierCount,
      'city': city,
      'crowdId': crowdId,
      'districtName': districtName,
      'employeeCount': employeeCount,
      'image': image,
      'lat': lat,
      'lng': lng,
      'name': name,
      'status': status,
      'streetName': streetName,
      'type': type,
      'w3W': w3W,
      'unavailableMissions': unavailableMissions ?? [],
    };
  }

  Kiosk toEntity() {
    return Kiosk(
      placeId: placeId,
      address: address,
      aislesCount: aislesCount,
      cashierCount: cashierCount,
      city: city,
      crowdId: crowdId,
      districtName: districtName,
      employeeCount: employeeCount,
      image: image,
      lat: lat,
      lng: lng,
      name: name,
      status: status,
      streetName: streetName,
      type: type,
      w3W: w3W,
      unavailableMissions: unavailableMissions,
    );
  }

  static KioskModel fromEntity(Kiosk kiosk) {
    return KioskModel(
      placeId: kiosk.placeId,
      address: kiosk.address,
      aislesCount: kiosk.aislesCount,
      cashierCount: kiosk.cashierCount,
      city: kiosk.city,
      crowdId: kiosk.crowdId,
      districtName: kiosk.districtName,
      employeeCount: kiosk.employeeCount,
      image: kiosk.image,
      lat: kiosk.lat,
      lng: kiosk.lng,
      name: kiosk.name,
      status: kiosk.status,
      streetName: kiosk.streetName,
      type: kiosk.type,
      w3W: kiosk.w3W,
      unavailableMissions: kiosk.unavailableMissions,
    );
  }
}
