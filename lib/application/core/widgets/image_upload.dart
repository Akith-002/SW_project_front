import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:land_asset_valuation/application/core/services/app_permisions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/light_color_list.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';

/// A widget that displays an image upload interface.
/// It supports both displaying an image or an upload button.
class ImageUpload extends StatelessWidget {
  // Optional parameters to display either an image from file or a path.
  final String? imagePath;
  final File? imageFile;
  // Callback when delete icon is tapped.
  final VoidCallback onDelete;
  // Size of the image container.
  final double size;
  // Callback invoked when a new image is picked.
  final Function(File)? onImagePicked;
  // Determines if the widget is used as an upload button.
  final bool isUploadButton;

  const ImageUpload({
    super.key,
    this.imagePath,
    this.imageFile,
    required this.onDelete,
    this.size = 128,
    this.onImagePicked,
    this.isUploadButton = false,
  });

  /// Shows a bottom sheet to choose image source (camera or gallery).
  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title of the bottom sheet.
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors(context).colorBlack,
                ),
              ),
              const SizedBox(height: 24),
              // Option to take a photo.
              ListTile(
                leading: Icon(
                  PhosphorIconsBold.camera,
                  color: colors(context).colorGrey8,
                ),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(color: colors(context).colorBlack),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              // Option to choose from gallery.
              ListTile(
                leading: Icon(
                  PhosphorIconsBold.image,
                  color: colors(context).colorGrey8,
                ),
                title: Text(
                  'Browse Photos',
                  style: TextStyle(color: colors(context).colorBlack),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Handles image picking logic with required permissions.
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        // Request camera permission before taking photo.
        await AppPermissionManager.requestCameraPermission(context, () async {
          await _getImage(source);
        });
      } else {
        // Request external storage permission for gallery access.
        await AppPermissionManager.requestExternalStoragePermission(context,
            () async {
          await _getImage(source);
        });
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  /// Opens the image picker and returns the selected image.
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    // If an image is picked and a callback is provided, call the callback.
    if (pickedFile != null && onImagePicked != null) {
      onImagePicked!(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If this widget is used as an upload button, display a button instead.
    if (isUploadButton) {
      return InkWell(
        onTap: () => _showImageSourceBottomSheet(context),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors(context).colorGrey9,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  (colors(context).colorGrey5 ?? LightColorList.lightGrey200),
            ),
          ),
          child: Center(
            child: Icon(
              PhosphorIconsBold.plus,
              size: 32,
              color:
                  (colors(context).colorGrey8 ?? LightColorList.lightGrey600),
            ),
          ),
        ),
      );
    }

    // Determine the image provider based on available imageFile or imagePath.
    ImageProvider? imageProvider; // Made nullable
    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (imagePath != null) {
      imageProvider = AssetImage(imagePath!);
    }
    // If imageFile and imagePath are both null, imageProvider will now be null,
    // and no default image will be shown.

    return Stack(
      children: [
        // Display the image or default image.
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: imageProvider!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Overlay delete icon on top of the image.
        Positioned.fill(
          child: Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (colors(context).colorBlack ??
                        LightColorList.lightColorBlack),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    PhosphorIconsBold.trash,
                    color: colors(context).colorWhite,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
