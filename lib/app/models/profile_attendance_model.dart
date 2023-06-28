// To parse this JSON data, do
//
//     final profileAttendance = profileAttendanceFromMap(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

class ProfileAttendance {
  String? status;
  String? message;
  Pagination? pagination;
  List<Datum>? data;

  ProfileAttendance({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory ProfileAttendance.fromJson(String str) =>
      ProfileAttendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileAttendance.fromMap(Map<String, dynamic> json) =>
      ProfileAttendance(
        status: json["status"],
        message: json["message"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromMap(json["pagination"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "pagination": pagination?.toMap(),
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  int? attendanceId;
  int? regisNumber;
  FullName? fullName;
  DateTime? dayDate;
  String? dayDateName;
  String? timeIn;
  String? timeOut;
  String? late;
  String? early;
  Absent? absent;
  String? totalAttendance;
  String? statusAttendance;

  Datum({
    this.attendanceId,
    this.regisNumber,
    this.fullName,
    this.dayDate,
    this.dayDateName,
    this.timeIn,
    this.timeOut,
    this.late,
    this.early,
    this.absent,
    this.totalAttendance,
    this.statusAttendance,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        attendanceId: json["attendanceId"],
        regisNumber: json["regisNumber"],
        fullName: fullNameValues.map[json["fullName"]]!,
        dayDate:
            json["dayDate"] == null ? null : DateTime.parse(json["dayDate"]),
        dayDateName: json["dayDateName"],
        timeIn: json["timeIn"],
        timeOut: json["timeOut"],
        late: json["late"],
        early: json["early"],
        absent: absentValues.map[json["absent"]]!,
        totalAttendance: json["totalAttendance"],
        statusAttendance: json["statusAttendance"],
      );

  Map<String, dynamic> toMap() => {
        "attendanceId": attendanceId,
        "regisNumber": regisNumber,
        "fullName": fullNameValues.reverse[fullName],
        "dayDate":
            "${dayDate!.year.toString().padLeft(4, '0')}-${dayDate!.month.toString().padLeft(2, '0')}-${dayDate!.day.toString().padLeft(2, '0')}",
        "dayDateName": dayDateName,
        "timeIn": timeIn,
        "timeOut": timeOut,
        "late": late,
        "early": early,
        "absent": absentValues.reverse[absent],
        "totalAttendance": totalAttendance,
        "statusAttendance": statusAttendance,
      };
}

enum Absent { EMPTY, Y }

final absentValues = EnumValues({"": Absent.EMPTY, "Y": Absent.Y});

enum FullName { RUDI }

final fullNameValues = EnumValues({"Rudi": FullName.RUDI});

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(String str) =>
      Pagination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        totalItems: json["totalItems"],
        perPage: json["perPage"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toMap() => {
        "totalItems": totalItems,
        "perPage": perPage,
        "currentPage": currentPage,
        "totalPages": totalPages,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
