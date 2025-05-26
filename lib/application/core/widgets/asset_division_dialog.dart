import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/pages/asset_division/cubit/asset_division_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/asset_division.dart';

class AssetDivisionDialog extends StatefulWidget {
  final Asset asset;

  const AssetDivisionDialog({
    super.key,
    required this.asset,
  });

  @override
  State<AssetDivisionDialog> createState() => _AssetDivisionDialogState();
}

class _AssetDivisionDialogState extends State<AssetDivisionDialog> {
  final List<DivisionPartInput> _divisionParts = [];
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AssetDivisionValidation? _currentValidation;

  @override
  void initState() {
    super.initState();
    // Start with two division parts
    _addDivisionPart();
    _addDivisionPart();
  }

  void _addDivisionPart() {
    setState(() {
      _divisionParts.add(DivisionPartInput());
    });
  }

  void _removeDivisionPart(int index) {
    if (_divisionParts.length > 2) {
      setState(() {
        _divisionParts.removeAt(index);
      });
    }
  }

  void _validateDivision() {
    if (_formKey.currentState?.validate() == true) {
      final request = _buildDivisionRequest();
      context.read<AssetDivisionCubit>().validateDivision(request);
    }
  }

  void _performDivision() {
    if (_formKey.currentState?.validate() == true &&
        _currentValidation?.isValid == true) {
      final request = _buildDivisionRequest();
      context.read<AssetDivisionCubit>().divideAsset(request);
    }
  }

  AssetDivisionRequest _buildDivisionRequest() {
    final parts = _divisionParts
        .map((part) => DivisionPart(
              newAssetNumber: part.assetNumberController.text,
              area: double.tryParse(part.areaController.text) ?? 0.0,
              description: part.descriptionController.text,
              landType: part.selectedLandType,
              coordinates: part.coordinatesController.text.isNotEmpty
                  ? part.coordinatesController.text
                  : null,
            ))
        .toList();

    return AssetDivisionRequest(
      assetId: widget.asset.id.toString(),
      divisionParts: parts,
      reason: _reasonController.text,
      metadata: {
        'originalAssetNumber': widget.asset.assetNumber,
        'originalArea': widget.asset.area?.toString(),
        'divisionTimestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  double get _totalArea {
    return _divisionParts.fold(0.0, (sum, part) {
      return sum + (double.tryParse(part.areaController.text) ?? 0.0);
    });
  }

  double get _originalArea => widget.asset.area ?? 0.0;

  bool get _areaMatches {
    return (_totalArea - _originalArea).abs() < 0.001;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetDivisionCubit, AssetDivisionState>(
      listener: (context, state) {
        if (state is AssetDivisionValidated) {
          setState(() {
            _currentValidation = state.validation;
          });
        } else if (state is AssetDivisionSuccess) {
          Navigator.of(context).pop(state.response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Asset divided successfully! Created ${state.response.newAssetIds?.length ?? 0} new assets.'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AssetDivisionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 800,
          height: 700,
          child: Column(
            children: [
              // Fixed header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildHeader(),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAssetInfo(),
                        const SizedBox(height: 16),
                        _buildAreaSummary(),
                        const SizedBox(height: 16),
                        _buildDivisionParts(),
                        const SizedBox(height: 16),
                        _buildReasonField(),
                        const SizedBox(height: 16),
                        _buildValidationResults(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed action buttons at bottom
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.call_split, size: 24, color: colors(context).colorPrimary5),
        const SizedBox(width: 8),
        const Text(
          'Divide Asset',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildAssetInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors(context).colorGrey1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors(context).colorPrimary5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Asset Number: ${widget.asset.assetNumber}'),
              ),
              Expanded(
                child: Text('Location: ${widget.asset.location ?? 'N/A'}'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
              'Original Area: ${widget.asset.area?.toStringAsFixed(2) ?? 'N/A'} hectares'),
        ],
      ),
    );
  }

  Widget _buildAreaSummary() {
    final isValid = _areaMatches;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValid ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            color: isValid ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Area Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isValid
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),
                Text(
                  'Original: ${_originalArea.toStringAsFixed(2)} ha | Total Parts: ${_totalArea.toStringAsFixed(2)} ha',
                  style: TextStyle(
                    color: isValid
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                  ),
                ),
                if (!isValid)
                  Text(
                    'Difference: ${(_totalArea - _originalArea).toStringAsFixed(2)} ha',
                    style: TextStyle(
                      color: Colors.orange.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivisionParts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Division Parts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors(context).colorPrimary5,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addDivisionPart,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Part'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_divisionParts.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildDivisionPartCard(index),
          );
        }),
      ],
    );
  }

  Widget _buildDivisionPartCard(int index) {
    final part = _divisionParts[index];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors(context).colorGrey3!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Part ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (_divisionParts.length > 2)
                IconButton(
                  onPressed: () => _removeDivisionPart(index),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  tooltip: 'Remove this part',
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: part.assetNumberController,
                  decoration: const InputDecoration(
                    labelText: 'New Asset Number',
                    hintText: 'e.g., A001-1',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Asset number is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: part.areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area (hectares)',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Area is required';
                    }
                    final area = double.tryParse(value!);
                    if (area == null || area <= 0) {
                      return 'Enter valid area';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: part.selectedLandType,
                  decoration: const InputDecoration(
                    labelText: 'Land Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    'Agricultural',
                    'Residential',
                    'Commercial',
                    'Industrial',
                    'Forest',
                    'Water',
                    'Other'
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      part.selectedLandType = value;
                    });
                  },
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Land type is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: part.coordinatesController,
                  decoration: const InputDecoration(
                    labelText: 'Coordinates (optional)',
                    hintText: 'lat, lng',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: part.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Brief description of this part',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: 2,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Description is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Division Reason',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colors(context).colorPrimary5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Explain why this asset needs to be divided...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value?.isEmpty == true) {
              return 'Division reason is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildValidationResults() {
    if (_currentValidation == null) {
      return const SizedBox.shrink();
    }

    final validation = _currentValidation!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: validation.isValid ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validation.isValid ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                validation.isValid ? Icons.check_circle : Icons.error,
                color: validation.isValid ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Validation Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: validation.isValid
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ],
          ),
          if (validation.errors.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...validation.errors.map((error) => Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text(
                    '• $error',
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                )),
          ],
          if (validation.warnings.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...validation.warnings.map((warning) => Padding(
                  padding: const EdgeInsets.only(left: 28, bottom: 4),
                  child: Text(
                    '⚠ $warning',
                    style: TextStyle(color: Colors.orange.shade600),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isLoading =
        context.watch<AssetDivisionCubit>().state is AssetDivisionLoading;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : _validateDivision,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Validate'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: (isLoading || _currentValidation?.isValid != true)
                ? null
                : _performDivision,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors(context).colorPrimary5,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Divide Asset'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    for (final part in _divisionParts) {
      part.dispose();
    }
    super.dispose();
  }
}

class DivisionPartInput {
  final TextEditingController assetNumberController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();
  String? selectedLandType;

  void dispose() {
    assetNumberController.dispose();
    areaController.dispose();
    descriptionController.dispose();
    coordinatesController.dispose();
  }
}
