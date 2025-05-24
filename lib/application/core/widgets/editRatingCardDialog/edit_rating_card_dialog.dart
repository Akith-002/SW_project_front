import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';

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
   static void showMultiSelectEditRatingCardDialog(BuildContext context) {
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

   static void showAddRatingCardDialog(BuildContext context) {
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
}
