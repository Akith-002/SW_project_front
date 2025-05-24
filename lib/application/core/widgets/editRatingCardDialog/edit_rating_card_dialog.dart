import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/invalid_owners_dialogbox.dart';
import 'package:land_asset_valuation/application/core/widgets/sendsuccessfully_dialogbox.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';

import 'package:land_asset_valuation/data/models/asset.dart';

class EditRatingCardDialog {
  static void showEditRatingCardDialog(BuildContext context) {
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
                          text: AppString.cancel.localize(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.localize(context)!,
                          onPressed: () {
                            Navigator.pop(context);
                            debugPrint("Selected Option: $selectedValue");
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
                          text: AppString.cancel.localize(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.localize(context)!,
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
                          text: AppString.cancel.localize(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.localize(context)!,
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

  // TODO: Implement consolidation functionality for multiple assets
  static void _handleConsolidationForMultiSelect(
      BuildContext context, List<Asset> selectedAssets) {
    // TODO: Implement consolidation logic
    // This function should handle the consolidation process for the selected assets
    // Parameters:
    // - context: BuildContext for navigation and dialogs
    // - selectedAssets: List of assets to be consolidated

    debugPrint("Consolidation selected for ${selectedAssets.length} assets");
    debugPrint(
        "Assets to consolidate: ${selectedAssets.map((a) => a.assetNo).join(', ')}");
  }

  // TODO: Implement unidentified functionality for multiple assets
  static void _handleUnidentified(
      BuildContext context, List<Asset> selectedAssets) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: SuccessfullySaved(
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
    debugPrint("Unidentified selected for ${selectedAssets.length} assets");
    debugPrint(
        "Assets to mark as unidentified: ${selectedAssets.map((a) => a.assetNo).join(', ')}");

    // TODO: Add unidentified implementation here
    // Example steps:
    // 1. Validate that assets can be marked as unidentified
    // 2. Show confirmation dialog
    // 3. Call API to update asset status
    // 4. Handle success/error responses
    // 5. Refresh the asset list
  }
}
