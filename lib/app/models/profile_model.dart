// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_label

class ProfileModels {
  ProfileModels({
    required this.status,
    required this.message,
    required this.dataProfile,
  });
  late final String? status;
  late final String? message;
  late final String? token;
  late final DataProfile? dataProfile;

  ProfileModels.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'] == null ? "" : json["token"] as String;
    dataProfile =
        json['data'] != null ? DataProfile.fromJson(json['data']) : null;
  }

  Map<String?, dynamic> toJson() {
    final _data = <String?, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    if (dataProfile != null) {
      _data['data'] = dataProfile!.toJson();
    }

    return _data;
  }
}

class DataProfile {
  DataProfile({
    this.uid,
    required this.regisNumber,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.companyId,
    required this.companyName,
    required this.deptId,
    required this.deptName,
    required this.placementCode,
    required this.placementName,
    required this.gender,
    required this.fotoUrl,
    required this.emei,
    required this.statusAccountId,
    required this.statusAccountName,
    required this.statusVerifId,
    required this.statusVerifName,
    this.shift,
    required this.modelData,
  });
  int? uid;
  int? regisNumber;
  late final String? fullName;
  late final int? phone;
  late final String? email;
  late final int? companyId;
  late final String? companyName;
  late final int? deptId;
  late final String? deptName;
  late final String? placementCode;
  late final String? placementName;
  String? gender;
  late final String? fotoUrl;
  late final String? emei;
  late final int? statusAccountId;
  late final String? statusAccountName;
  late final int? statusVerifId;
  late final String? statusVerifName;
  late final Shift? shift;
  late final String? modelData;

  DataProfile.fromJson(Map<String?, dynamic> json) {
    uid = json['uid'];
    regisNumber = json['regisNumber'];
    fullName = json['fullName'];
    phone = json['phone'];
    email = json['email'] == null ? "" : json["email"] as String;
    companyId = json['companyId'];
    companyName = json['companyName'];
    deptId = json['deptId'];
    deptName = json['deptName'];
    placementCode = json['placementCode'];
    placementName = json['placementName'];
    gender = json['gender'];
    fotoUrl = json['fotoUrl'];
    emei = json['emei'];
    statusAccountId = json['statusAccountId'];
    statusAccountName = json['statusAccountName'];
    statusVerifId = json['statusVerifId'];
    statusVerifName = json['statusVerifName'];
    shift = Shift.fromJson(json['shift']);
    modelData = json['model_data'];
  }

  Map<String?, dynamic> toJson() {
    final _data = <String?, dynamic>{};
    _data['uid'] = uid;
    _data['regisNumber'] = regisNumber;
    _data['fullName'] = fullName;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['companyId'] = companyId;
    _data['companyName'] = companyName;
    _data['deptId'] = deptId;
    _data['deptName'] = deptName;
    _data['placementCode'] = placementCode;
    _data['placementName'] = placementName;
    _data['gender'] = gender;
    _data['fotoUrl'] = fotoUrl;
    _data['emei'] = emei;
    _data['statusAccountId'] = statusAccountId;
    _data['statusAccountName'] = statusAccountName;
    _data['statusVerifId'] = statusVerifId;
    _data['statusVerifName'] = statusVerifName;
    _data['shift'] = shift!.toJson();
    _data['model_data'] = modelData;
    return _data;
  }

  toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'companyId': companyId,
      'companyName': companyName,
      'deptId': deptId,
      'deptName': deptName,
      'placementCode': placementCode,
      'placementName': placementName,
      'fotoUrl': fotoUrl,
      'statusAccountId': statusAccountId,
      'statusAccountName': statusAccountName,
      'statusVerifId': statusVerifId,
      'statusVerifName': statusVerifName,
      'model_data': modelData,
    };
  }

  DataProfile.fromMap(Map<String?, dynamic> map) {
    uid = map['uid'];
    fullName = map['fullName'];
    phone = map['phone'];
    email = map['email'];
    companyId = map['companyId'];
    companyName = map['companyName'];
    deptId = map['deptId'];
    deptName = map['deptName'];
    placementCode = map['placementCode'];
    placementName = map['placementName'];
    fotoUrl = map['fotoUrl'];
    statusAccountId = map['statusAccountId'];
    statusAccountName = map['statusAccountName'];
    statusVerifId = map['statusVerifId'];
    statusVerifName = map['statusVerifName'];
    modelData = map['model_data'];
  }
}

class Shift {
  Shift({
    required this.uid,
    required this.shiftIn,
    required this.shiftOut,
    required this.diffHour,
    required this.radius,
    required this.inLat,
    required this.inLong,
    required this.outLat,
    required this.outLong,
  });
  late final int? uid;
  late final String? shiftIn;
  late final String? shiftOut;
  late final String? diffHour;
  late final String? radius;
  late final String? inLat;
  late final String? inLong;
  late final String? outLat;
  late final String? outLong;

  Shift.fromJson(Map<String?, dynamic> json) {
    uid = json['uid'];
    shiftIn = json['shiftIn'];
    shiftOut = json['shiftOut'];
    diffHour = json['diffHour'];
    radius = json['radius'];
    inLat = json['inLat'];
    inLong = json['inLong'];
    outLat = json['outLat'];
    outLong = json['outLong'];
  }

  Map<String?, dynamic> toJson() {
    final _data = <String?, dynamic>{};
    _data['uid'] = uid;
    _data['shiftIn'] = shiftIn;
    _data['shiftOut'] = shiftOut;
    _data['diffHour'] = diffHour;
    _data['radius'] = radius;
    _data['inLat'] = inLat;
    _data['inLong'] = inLong;
    _data['outLat'] = outLat;
    _data['outLong'] = outLong;
    return _data;
  }

  toMap() {
    return {
      'shiftIn': shiftIn,
      'shiftOut': shiftOut,
      'diffHour': diffHour,
      'radius': radius,
      'inLat': inLat,
      'inLong': inLong,
      'outLat': outLat,
      'outLong': outLong,
    };
  }

  Shift.fromMap(Map<String?, dynamic> map) {
    shiftIn = map['shiftIn'];
    shiftOut = map['shiftOut'];
    diffHour = map['diffHour'];
    radius = map['radius'];
    inLat = map['inLat'];
    inLong = map['inLong'];
    outLat = map['outLat'];
    outLong = map['outLong'];
  }
}
