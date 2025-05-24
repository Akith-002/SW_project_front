class LandAcquisitionMasterFile {
  final int id;
  final int masterFileNo;
  final String planType;
  final String planNo;
  final String requestingAuthorityReferenceNo;
  final String status;

  LandAcquisitionMasterFile({
    required this.id,
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.requestingAuthorityReferenceNo,
    required this.status,
  });

  factory LandAcquisitionMasterFile.fromJson(Map<String, dynamic> json) {
    return LandAcquisitionMasterFile(
      id: json['id'],
      masterFileNo: json['masterFileNo'],
      planType: json['planType'],
      planNo: json['planNo'],
      requestingAuthorityReferenceNo: json['requestingAuthorityReferenceNo'],
      status: json['status'],
    );
  }
}
