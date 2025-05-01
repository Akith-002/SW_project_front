import 'package:flutter/material.dart';
import 'package:sri_lanka_provinces_districts_cities/sri_lanka_provinces_districts_cities.dart';

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  height: 24 / 16,
  fontFamily: "Roboto",
  color: Colors.white,
);

class AdvancedSearchModal extends StatefulWidget {
  const AdvancedSearchModal({super.key});

  @override
  _AdvancedSearchModalState createState() => _AdvancedSearchModalState();
}

class _AdvancedSearchModalState extends State<AdvancedSearchModal> {
  List<District> _districts = [];
  District? _selectedDistrict;
  List<String> _gnDivisions = [];
  String? _selectedGNDivision;
  String? _selectedDSDivision;
  String? _selectedVillage;
  String? _selectedDocumentType;

  final List<String> _documentTypes = [
    "Type A",
    "Type B",
    "Type C",
  ];

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  void _loadDistricts() {
    setState(() {
      _districts = getAllDistricts();
    });
  }

  List<District> getAllDistricts() {
    List<District> allDistricts = [];
    for (int provinceId = 1; provinceId <= 9; provinceId++) {
      allDistricts.addAll(getDistrictsByProvinceId(provinceId));
    }
    return allDistricts;
  }

  void _loadGNDummyData(District district) {
    setState(() {
      _gnDivisions = [
        "${district.nameEn} - GN 1",
        "${district.nameEn} - GN 2",
        "${district.nameEn} - GN 3",
      ];
      _selectedGNDivision = null;
      _selectedDSDivision = null;
      _selectedVillage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: 1061,
        height: 728,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Advanced Search",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ),
              ),
              _buildInputField("Master File Reference Number",
                  placeholder: "25614781487939", fullWidth: true),
              _buildRow(
                _buildInputField("DS Reference Number"),
                _buildDropdownField("Document Reference Type", _documentTypes,
                    _selectedDocumentType, (newValue) {
                  setState(() {
                    _selectedDocumentType = newValue;
                  });
                }),
              ),
              _buildRow(
                _buildDropdownDistrict("District"),
                _buildDropdownField(
                    "DS Division", _gnDivisions, _selectedDSDivision,
                    (newValue) {
                  setState(() {
                    _selectedDSDivision = newValue;
                  });
                }, placeholder: "Choose GN or District First"),
              ),
              _buildRow(
                _buildDropdownField(
                    "Choose GN Division", _gnDivisions, _selectedGNDivision,
                    (newValue) {
                  setState(() {
                    _selectedGNDivision = newValue;
                  });
                }),
                _buildDropdownField("Village", _gnDivisions, _selectedVillage,
                    (newValue) {
                  setState(() {
                    _selectedVillage = newValue;
                  });
                }, placeholder: "Choose GN Division First"),
              ),
              _buildRow(
                _buildInputField("Acquiring Officer"),
                _buildInputField("Advanced Tracing Number"),
              ),
              _buildRow(
                _buildInputField("Land Ministry Reference Number"),
                _buildInputField("Acquisition Name"),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint(
                        "Selected District: ${_selectedDistrict?.nameEn}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0062A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    "Advanced Search",
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 **Row Layout**
  Widget _buildRow(Widget field1, Widget field2) {
    return Row(
      children: [
        Expanded(child: field1),
        SizedBox(width: 10),
        Expanded(child: field2),
      ],
    );
  }

  Widget _buildInputField(String label,
      {String? placeholder, bool fullWidth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto",
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: fullWidth ? 1013 : double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Roboto",
              height: 24 / 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder ?? label,
              hintStyle: TextStyle(
                fontSize: 14,
                fontFamily: "Roboto",
                height: 24 / 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownDistrict(String label) {
    return _buildDropdownField(label, _districts.map((d) => d.nameEn).toList(),
        _selectedDistrict?.nameEn, (newValue) {
      setState(() {
        _selectedDistrict =
            _districts.firstWhere((district) => district.nameEn == newValue);
        _loadGNDummyData(_selectedDistrict!);
      });
    });
  }

  Widget _buildDropdownField(String label, List<String> items,
      String? selectedValue, Function(String?) onChanged,
      {String? placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto",
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                placeholder ?? "Select $label",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Roboto",
                  height: 24 / 14,
                  color: Colors.grey.shade800,
                ),
              ),
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
