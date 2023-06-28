// ignore_for_file: no_leading_underscores_for_local_identifiers

class AttendanceHistoryModel {
  AttendanceHistoryModel({
    required this.status,
    required this.message,
    required this.totalItems,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.attendanceHistory,
  });
  late final String? status;
  late final String? message;
  late final int? totalItems;
  late final int? perPage;
  late final int? currentPage;
  late final int? totalPages;
  late final List<AttendanceHistory>? attendanceHistory;

  AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalItems = json['totalItems'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    attendanceHistory = List.from(json['data'])
        .map((e) => AttendanceHistory.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['totalItems'] = totalItems;
    _data['perPage'] = perPage;
    _data['currentPage'] = currentPage;
    _data['totalPages'] = totalPages;
    _data['data'] = attendanceHistory!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AttendanceHistory {
  AttendanceHistory({
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
  late final int? attendanceId;
  late final int? regisNumber;
  late final String fullName;
  late final String? dayDate;
  late final String? dayDateName;
  late final String? timeIn;
  late final String? timeOut;
  late final String? late;
  late final String? early;
  late final String? absent;
  late final String? totalAttendance;
  late final String? statusAttendance;
  late final String? inLat;
  late final String? inLong;
  late final String? outLat;
  late final String? outLong;

  AttendanceHistory.fromJson(Map<String, dynamic> json) {
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
