// ignore_for_file: no_leading_underscores_for_local_identifiers

class HomeModel {
  HomeModel({
    required this.status,
    required this.message,
    this.attendOnday,
    this.category,
    this.attendance,
  });
  late final String status;
  late final String message;
  late final AttendOnday? attendOnday;
  late final List<Category>? category;
  late final List<Attendance>? attendance;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    attendOnday = AttendOnday.fromJson(json['attendOnday']);
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    attendance = List.from(json['attendance'])
        .map((e) => Attendance.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['attendOnday'] = attendOnday!.toJson();
    _data['category'] = category!.map((e) => e.toJson()).toList();
    _data['attendance'] = attendance!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AttendOnday {
  AttendOnday({
    required this.dayDate,
    required this.statusAbsen,
    required this.timeIn,
    required this.timeOut,
    required this.late,
    required this.early,
    required this.absent,
    required this.totalAttendance,
  });
  late final String? dayDate;
  late final int? statusAbsen;
  late final String? timeIn;
  late final String? timeOut;
  late final String? late;
  late final String? early;
  late final String? absent;
  late final String? totalAttendance;

  AttendOnday.fromJson(Map<String, dynamic> json) {
    dayDate = json['dayDate'];
    statusAbsen = json['statusAbsen'];
    timeIn = json['timeIn'];
    timeOut = json['timeOut'];
    late = json['late'];
    early = json['early'];
    absent = json['absent'];
    totalAttendance = json['totalAttendance'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dayDate'] = dayDate;
    _data['statusAbsen'] = statusAbsen;
    _data['timeIn'] = timeIn;
    _data['timeOut'] = timeOut;
    _data['late'] = late;
    _data['early'] = early;
    _data['absent'] = absent;
    _data['totalAttendance'] = totalAttendance;
    return _data;
  }

  toMap() {
    return {
      'dayDate': dayDate,
      'statusAbsen': statusAbsen,
      'timeIn': timeIn,
      'timeOut': timeOut,
      'late': late,
      'early': early,
      'absent': absent,
      'totalAttendance': totalAttendance,
    };
  }

  AttendOnday.fromMap(Map<String?, dynamic> map) {
    dayDate = map['dayDate'];
    statusAbsen = map['statusAbsen'];
    timeIn = map['timeIn'];
    timeOut = map['timeOut'];
    late = map['late'];
    early = map['early'];
    absent = map['absent'];
    totalAttendance = map['totalAttendance'];
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.status,
    required this.icon,
  });
  late final int id;
  late final String name;
  late final String slug;
  late final int status;
  late final String icon;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    status = json['status'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['status'] = status;
    _data['icon'] = icon;
    return _data;
  }

  toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'status': status,
      'icon': icon,
    };
  }

  Category.fromMap(Map<String?, dynamic> map) {
    id = map['id'];
    name = map['name'];
    slug = map['slug'];
    status = map['status'];
    icon = map['icon'];
  }
}

class Attendance {
  Attendance({
    required this.attendanceId,
    required this.regisNumber,
    required this.fullName,
    required this.dayDate,
    required this.dayDateName,
    required this.timeIn,
    required this.timeOut,
    required this.late,
    required this.early,
    required this.absent,
    required this.totalAttendance,
    required this.statusAttendance,
    required this.inLat,
    required this.inLong,
    required this.outLat,
    required this.outLong,
  });
  late final int attendanceId;
  late final int regisNumber;
  late final String fullName;
  late final String dayDate;
  late final String dayDateName;
  late final String timeIn;
  late final String timeOut;
  late final String late;
  late final String early;
  late final String absent;
  late final String totalAttendance;
  late final String statusAttendance;
  late final String? inLat;
  late final String? inLong;
  late final String? outLat;
  late final String? outLong;

  Attendance.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    regisNumber = json['regisNumber'];
    fullName = json['fullName'];
    dayDate = json['dayDate'];
    dayDateName = json['dayDateName'];
    timeIn = json['timeIn'];
    timeOut = json['timeOut'];
    late = json['late'];
    early = json['early'];
    absent = json['absent'];
    totalAttendance = json['totalAttendance'];
    statusAttendance = json['statusAttendance'];
    inLat = json['inLat'];
    inLong = json['inLong'];
    outLat = json['outLat'];
    outLong = json['outLong'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['attendanceId'] = attendanceId;
    _data['regisNumber'] = regisNumber;
    _data['fullName'] = fullName;
    _data['dayDate'] = dayDate;
    _data['dayDateName'] = dayDateName;
    _data['timeIn'] = timeIn;
    _data['timeOut'] = timeOut;
    _data['late'] = late;
    _data['early'] = early;
    _data['absent'] = absent;
    _data['totalAttendance'] = totalAttendance;
    _data['statusAttendance'] = statusAttendance;
    _data['inLat'] = inLat;
    _data['inLong'] = inLong;
    _data['outLat'] = outLat;
    _data['outLong'] = outLong;
    return _data;
  }
}
