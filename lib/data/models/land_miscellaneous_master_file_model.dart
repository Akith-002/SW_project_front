class LandMiscellaneousMasterFile {
  final int id;
  final int masterFileNo;
  final String planType;
  final String planNo;
  final String requestingAuthorityReferenceNo;
  final String status;
  final int lots;

  LandMiscellaneousMasterFile({
    required this.id,
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.requestingAuthorityReferenceNo,
    required this.status,
    required this.lots,
  });

  factory LandMiscellaneousMasterFile.fromJson(Map<String, dynamic> json) {
    return LandMiscellaneousMasterFile(
      id: json['id'],
      masterFileNo: json['masterFileNo'],
      planType: json['planType'],
      planNo: json['planNo'],
      requestingAuthorityReferenceNo: json['requestingAuthorityReferenceNo'],
      status: json['status'],
      lots: json['lots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterFileNo': masterFileNo,
      'planType': planType,
      'planNo': planNo,
      'requestingAuthorityReferenceNo': requestingAuthorityReferenceNo,
      'status': status,
      'lots': lots,
    };
  }
}
