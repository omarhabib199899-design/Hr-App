// To parse this JSON data, do
//
//     final assetListResponse = assetListResponseFromJson(jsonString);

import 'dart:convert';

AssetListResponse assetListResponseFromJson(String str) => AssetListResponse.fromJson(json.decode(str));

String assetListResponseToJson(AssetListResponse data) => json.encode(data.toJson());

class AssetListResponse {
  bool status;
  String message;
  int statusCode;
  List<AssetData> data;

  AssetListResponse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory AssetListResponse.fromJson(Map<String, dynamic> json) => AssetListResponse(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: List<AssetData>.from(json["data"].map((x) => AssetData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AssetData {
  int id;
  String asset;
  String assignedDate;
  String? returnedDate;
  String status;
  String? returnCondition;
  String? notes;

  AssetData({
    required this.id,
    required this.asset,
    required this.assignedDate,
    required this.returnedDate,
    required this.status,
    required this.returnCondition,
    required this.notes,
  });

  factory AssetData.fromJson(Map<String, dynamic> json) => AssetData(
    id: json["id"],
    asset: json["asset"],
    assignedDate: json["assigned_date"],
    returnedDate: json["returned_date"],
    status: json["status"],
    returnCondition: json["return_condition"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "asset": asset,
    "assigned_date": assignedDate,
    "returned_date": returnedDate,
    "status": status,
    "return_condition": returnCondition,
    "notes": notes,
  };
}
