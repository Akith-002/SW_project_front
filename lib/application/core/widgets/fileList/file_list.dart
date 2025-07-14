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
  final void Function(String)? onSearch;
  final int totalCount; // ✅ NEW: total count of records

  const FileList({
    super.key,
    required this.breadcrumbItems,
    required this.table,
    this.onSearch,
    this.totalCount = 0, // ✅ Default to 0
  });

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Breadcrumb(items: [
          for (var item in widget.breadcrumbItems)
            BreadcrumbItem(label: item),
        ]),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${AppString.all_files.l10n(context)!}${widget.totalCount}", // ✅ Dynamic count
                style: AppStyling.semiBoldTextSize16
                    .copyWith(color: colors(context).colorBlack),
              ),
              const Spacer(),
              SizedBox(
                width: 290,
                height: 37,
                child: TextField(
                  controller: searchController,
                  onSubmitted: widget.onSearch,
                  decoration: InputDecoration(
                    hintText: AppString.search.l10n(context),
                    hintStyle: AppStyling.regularTextSize14,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors(context).colorGrey5!,
                      ),
                    ),
                    filled: true,
                    fillColor: colors(context).colorGrey1,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              iconButtonWidget(
                color: colors(context).colorBlack!,
                iconName: PhosphorIconsRegular.funnelSimple,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
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
                  AppString.advanced.l10n(context)!,
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
