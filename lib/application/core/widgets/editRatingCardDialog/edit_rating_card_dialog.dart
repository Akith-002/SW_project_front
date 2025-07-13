import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/due_to_difficulties_modal.dart';
import 'package:land_asset_valuation/application/core/widgets/enter_new_no_modal.dart';
import 'package:land_asset_valuation/application/core/widgets/asset_change_modal.dart';
import 'package:land_asset_valuation/application/core/widgets/invalid_owners_dialogbox.dart';
import 'package:land_asset_valuation/application/core/widgets/saved_succesfully_dialogbox.dart';
import 'package:land_asset_valuation/application/core/widgets/street_name_modal.dart';
import 'package:land_asset_valuation/application/core/widgets/asset_division_dialog.dart';
import 'package:land_asset_valuation/application/pages/asset_division/cubit/asset_division_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/data/models/asset_division.dart';
import 'package:land_asset_valuation/injection.dart';

class EditRatingCardDialog {
  static void showEditRatingCardDialog(BuildContext context, {Asset? asset}) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = 1; // Default selected value

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: colors(context).colorWhite,
            contentPadding:
                EdgeInsets.zero, // Remove default padding to control width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Adds rounded corners
            ),
            content: SizedBox(
              width: 384, // Fixed width
              child: Padding(
                padding: EdgeInsets.all(24), // Internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit your rating card',
                      style: AppStyling.boldTextSize22.copyWith(
                        color: colors(context).colorBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Select one of the options",
                      style: AppStyling.regularTextSize16.copyWith(
                        color: colors(context).colorGrey3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Division',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 1,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Reconciliation',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 2,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Change number',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 3,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          title: Text(
                            'Due to difficulties',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 4,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: AppString.cancel.l10n(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.l10n(context)!,
                          onPressed: () {
                            Navigator.pop(
                                context); // Handle the selected option
                            switch (selectedValue) {
                              case 1:
                                // Division option
                                if (asset != null) {
                                  _handleDivision(context, asset);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Asset information not available for division'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                break;
                              case 2:
                                // Reconciliation option
                                _handleReconciliation(context);
                                break;
                              case 3:
                                // Change number option
                                if (asset != null) {
                                  _handleChangeNumber(context, asset);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Asset information not available for changing number'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                break;
                              case 4:
                                // Due to difficulties option
                                _handleDueToDifficulties(context);
                                break;
                              default:
                                debugPrint(
                                    "Unknown option selected: $selectedValue");
                            }
                          },
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showMultiSelectEditRatingCardDialog(
      BuildContext context, List<Asset> selectedAssets) {
    // Check if all selected assets have the same owner
    if (selectedAssets.isEmpty) return;

    String firstOwner = selectedAssets.first.owner;
    bool hasSameOwner =
        selectedAssets.every((asset) => asset.owner == firstOwner);

    // Proceed with normal multi-select dialog if owners match
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = 1; // Default selected value

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: colors(context).colorWhite,
            contentPadding:
                EdgeInsets.zero, // Remove default padding to control width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Adds rounded corners
            ),
            content: SizedBox(
              width: 384, // Fixed width
              child: Padding(
                padding: EdgeInsets.all(24), // Internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit your rating card',
                      style: AppStyling.boldTextSize22.copyWith(
                        color: colors(context).colorBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Select one of the options",
                      style: AppStyling.regularTextSize16.copyWith(
                        color: colors(context).colorGrey3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Consolidation',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 1,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            if (!hasSameOwner) {
                              // Show invalid owners dialog immediately when option is clicked
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  contentPadding: EdgeInsets.zero,
                                  content: InvalidOwners(
                                    onClose: () => Navigator.pop(context),
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Unidentified',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 2,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            if (!hasSameOwner) {
                              // Show invalid owners dialog immediately when option is clicked
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  contentPadding: EdgeInsets.zero,
                                  content: InvalidOwners(
                                    onClose: () => Navigator.pop(context),
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: AppString.cancel.l10n(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.l10n(context)!,
                          onPressed: () {
                            if (!hasSameOwner) {
                              // Show invalid owners dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  contentPadding: EdgeInsets.zero,
                                  content: InvalidOwners(
                                    onClose: () => Navigator.pop(context),
                                  ),
                                ),
                              );
                              return;
                            }

                            // Handle the selected option
                            Navigator.pop(context);

                            switch (selectedValue) {
                              case 1:
                                // Consolidation option
                                _handleConsolidationForMultiSelect(
                                    context, selectedAssets);
                                break;
                              case 2:
                                // Unidentified option
                                _handleUnidentified(context, selectedAssets);
                                break;
                              default:
                                debugPrint(
                                    "Unknown option selected: $selectedValue");
                            }
                          },
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showAddRatingCardDialog(BuildContext context,
      {String? sourceContext}) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = 1; // Default selected value

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: colors(context).colorWhite,
            contentPadding:
                EdgeInsets.zero, // Remove default padding to control width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Adds rounded corners
            ),
            content: SizedBox(
              width: 384, // Fixed width
              child: Padding(
                padding: EdgeInsets.all(24), // Internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add new rating card',
                      style: AppStyling.boldTextSize22.copyWith(
                        color: colors(context).colorBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Select one of the property categories",
                      style: AppStyling.regularTextSize16.copyWith(
                        color: colors(context).colorGrey3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Domestic',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 1,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Offices',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 2,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Agriculture',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 3,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          title: Text(
                            'Shops',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 4,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          title: Text(
                            'Special',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 5,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: AppString.cancel.l10n(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.l10n(context)!,
                          onPressed: () {
                            Navigator.pop(context);

                            // Determine appropriate sidebar index based on source context
                            String? selectedIndex;
                            if (sourceContext != null) {
                              switch (sourceContext) {
                                case 'massRating':
                                  selectedIndex = '2';
                                  break;
                                case 'ratingAssessment':
                                  selectedIndex = '3';
                                  break;
                                case 'ratingBuilding':
                                  selectedIndex = '4';
                                  break;
                                case 'ratingObject':
                                  selectedIndex = '5';
                                  break;
                                case 'landAcquisition':
                                  selectedIndex = '1';
                                  break;
                                case 'MRrentalEvidence':
                                  selectedIndex = '6';
                                  break;
                                case 'landMiscellaneous':
                                  selectedIndex = '7';
                                  break;
                              }
                            }

                            // Navigate to the appropriate rating card form based on selection
                            Map<String, String> queryParams = {};
                            if (selectedIndex != null) {
                              queryParams['selectedIndex'] = selectedIndex;
                            }
                            if (sourceContext != null) {
                              queryParams['source'] = sourceContext;
                            }

                            switch (selectedValue) {
                              case 1:
                                // Domestic
                                context.pushNamed(
                                    Pages.routeDomesticRatingCard.toPathName(),
                                    queryParameters: queryParams);
                                break;
                              case 2:
                                // Offices
                                context.pushNamed(
                                    Pages.routeOfficesRatingCard.toPathName(),
                                    queryParameters: queryParams);
                                break;
                              case 3:
                                // Agriculture
                                context.pushNamed(
                                    Pages.routeAgricultureRatingCard
                                        .toPathName(),
                                    queryParameters: queryParams);
                                break;
                              case 4:
                                // Shops
                                context.pushNamed(
                                    Pages.routeShopsRatingCard.toPathName(),
                                    queryParameters: queryParams);
                                break;
                              case 5:
                                // Special
                                context.pushNamed(
                                    Pages.routeSpecialRatingCard.toPathName(),
                                    queryParameters: queryParams);
                                break;
                              default:
                                debugPrint(
                                    "Unknown rating card type: $selectedValue");
                            }
                          },
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _handleConsolidationForMultiSelect(
      BuildContext context, List<Asset> selectedAssets) {
    final TextEditingController newNoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: EnterNewNoWidget(
          controller: newNoController,
          onSave: () {
            String newNumber = newNoController.text.trim();
            if (newNumber.isNotEmpty) {
              debugPrint("New consolidation number: $newNumber");
            }
            Navigator.pop(context);
          },
        ),
      ),
    );

    debugPrint("Consolidation selected for ${selectedAssets.length} assets");
    debugPrint(
        "Assets to consolidate: ${selectedAssets.map((a) => a.assetNo).join(', ')}");
  }

  static void _handleUnidentified(
      BuildContext context, List<Asset> selectedAssets) {
    showDialog(
      context: context,
      builder: (context) =>
          SavedMessageCard(onClose: () => Navigator.pop(context)),
    );
    debugPrint("Unidentified selected for ${selectedAssets.length} assets");
    debugPrint(
        "Assets to mark as unidentified: ${selectedAssets.map((a) => a.assetNo).join(', ')}");
    // Example steps:
    // 1. Validate that assets can be marked as unidentified
    // 2. Show confirmation dialog
    // 3. Call API to update asset status
    // 4. Handle success/error responses    // 5. Refresh the asset list
  }

  // Comprehensive division functionality for single asset
  static void _handleDivision(BuildContext context, Asset asset) {
    debugPrint("Division option selected for asset: ${asset.assetNumber}");

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => injection<AssetDivisionCubit>(),
        child: AssetDivisionDialog(asset: asset),
      ),
    ).then((result) {
      if (result != null && result is AssetDivisionResponse) {
        debugPrint("Asset division completed successfully");
        debugPrint("New asset IDs: ${result.newAssetIds}");

        // Optionally refresh the asset list or update UI
        // This would typically trigger a refresh of the parent widget
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Asset divided successfully! Created ${result.newAssetIds?.length ?? 0} new assets.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  // TODO: Implement reconciliation functionality for single asset
  static void _handleReconciliation(BuildContext context) {
    debugPrint("Reconciliation option selected");
    final TextEditingController newNoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: StreetNameModal(
          newNoController: newNoController,
          onSave: () {
            String newNumber = newNoController.text.trim();
            if (newNumber.isNotEmpty) {
              debugPrint("New street number: $newNumber");
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
  // Implement change number functionality for single asset
  static void _handleChangeNumber(BuildContext context, Asset asset) {
    debugPrint("Change number option selected for asset: ${asset.assetNo}");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: AssetChangeModal(
          asset: asset,
          onSave: () {
            Navigator.pop(context);
            // Show success dialog
            showDialog(
              context: context,
              builder: (context) => SavedMessageCard(
                onClose: () => Navigator.pop(context),
              ),
            );
          },
        ),
      ),
    );
  }

  // TODO: Implement due to difficulties functionality for single asset
  static void _handleDueToDifficulties(BuildContext context) {
    debugPrint("Due to difficulties option selected");
    final TextEditingController newNoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: DueToDifficultiesModal(
          newNoController: newNoController,
          onSave: () {
            String newNumber = newNoController.text.trim();
            if (newNumber.isNotEmpty) {
              debugPrint("New street number: $newNumber");
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
