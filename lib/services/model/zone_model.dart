// Zone info

class ZoneModel {
  List<LocationData>? location;

  ZoneModel({this.location});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    if (json['location'] != null) {
      location = new List<LocationData>.empty(growable: true);
      json['location'].forEach((v) {
        location!.add(new LocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationData {
  double? latitude;
  double? longitude;
  String? address;
  double? distance;

  LocationData({this.latitude, this.longitude, this.address, this.distance});

  LocationData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['distance'] = this.distance;
    return data;
  }
}

// Wifi info
class WifiNames {
  List<WifiInfo>? wifiInfo;

  WifiNames({this.wifiInfo});

  WifiNames.fromJson(Map<String, dynamic> json) {
    if (json['wifi_info'] != null) {
      wifiInfo = new List<WifiInfo>.empty(growable: true);
      json['wifi_info'].forEach((v) {
        wifiInfo!.add(new WifiInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wifiInfo != null) {
      data['wifi_info'] = this.wifiInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WifiInfo {
  String? name;

  WifiInfo({this.name});

  WifiInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
