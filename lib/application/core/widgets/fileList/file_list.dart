import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FileList extends StatefulWidget {
  final List<String> breadcrumbItems;
  final Widget table;
  const FileList(
      {super.key, required this.breadcrumbItems, required this.table});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Breadcrumb(items: [
          // BreadcrumbItem(label: AppString.landAcquisition.localize(context)!),
          // generate breadcrumb items from the list
          for (var item in widget.breadcrumbItems) BreadcrumbItem(label: item),
        ]),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${AppString.all_files.localize(context)!}60",
                style: AppStyling.semiBoldTextSize16
                    .copyWith(color: colors(context).colorBlack),
              ),
              Spacer(),
              SizedBox(
                width: 290,
                height: 37,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppString.search.localize(context),
                    hintStyle: AppStyling.regularTextSize14,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors(context).colorGrey5!,
                      ),
                    ),
                    filled: true,
                    fillColor: colors(context).colorGrey1,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              iconButtonWidget(
                color: colors(context).colorBlack!,
                iconName: PhosphorIconsRegular.funnelSimple,
                onPressed: () {},
              ),
              SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colors(context).colorGrey9!,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppString.advanced.localize(context)!,
                  style: AppStyling.semiBoldTextSize12.copyWith(
                    color: colors(context).colorBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: widget.table),
      ],
    );
  }
}
