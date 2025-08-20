class DeviceInfo {
  String? id;
  String? model;
  String? brand;
  String? device;
  String? sdk;
  DeviceInfo({this.id, this.model, this.device, this.brand, this.sdk});

  DeviceInfo.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    model = json['model'];
    brand = json['brand'];
    device = json['device'];
    sdk = json['sdk'].toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};

    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['device'] = device;
    data['sdk'] = sdk;
    return data;
  }
}
