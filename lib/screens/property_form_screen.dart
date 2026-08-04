import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key});

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final PropertiesApi _api = PropertiesApi();
  final ImagePicker _picker = ImagePicker();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _entryController = TextEditingController();

  String? _mainImagePath;
  final List<String> _additionalPaths = [];
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _pickMain() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (file == null || !mounted) return;
    setState(() => _mainImagePath = file.path);
  }

  Future<void> _pickAdditional() async {
    final files = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (files.isEmpty || !mounted) return;
    setState(() {
      for (final file in files) {
        if (_additionalPaths.length >= 12) break;
        if (!_additionalPaths.contains(file.path)) {
          _additionalPaths.add(file.path);
        }
      }
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = S.current.propertyTitleRequired);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _api.create(
        title: title,
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        entryInstructions: _entryController.text.trim().isEmpty
            ? null
            : _entryController.text.trim(),
        mainImagePath: _mainImagePath,
        additionalImagePaths: List<String>.from(_additionalPaths),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.propertySaveFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          s.addProperty,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _FieldLabel(s.propertyTitle),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(s.propertyTitleHint),
          ),
          const SizedBox(height: 18),
          _FieldLabel(s.propertyMainPhoto),
          const SizedBox(height: 8),
          _ImagePickerBox(
            path: _mainImagePath,
            onTap: _saving ? null : _pickMain,
            placeholder: s.propertyPickMainPhoto,
          ),
          const SizedBox(height: 18),
          _FieldLabel(s.propertyAddress),
          const SizedBox(height: 8),
          TextField(
            controller: _addressController,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(s.propertyAddressHint),
          ),
          const SizedBox(height: 18),
          _FieldLabel(s.propertyDescription),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(s.propertyDescriptionHint),
          ),
          const SizedBox(height: 18),
          _FieldLabel(s.propertyAdditionalPhotos),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ..._additionalPaths.asMap().entries.map((entry) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(entry.value),
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: _saving
                            ? null
                            : () => setState(
                                  () => _additionalPaths.removeAt(entry.key),
                                ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (_additionalPaths.length < 12)
                InkWell(
                  onTap: _saving ? null : _pickAdditional,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.pictonBlue.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.pictonBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          _FieldLabel(s.propertyEntryInstructions),
          const SizedBox(height: 8),
          TextField(
            controller: _entryController,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(s.propertyEntryHint),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(
              _error!,
              style: AppFonts.body(color: Colors.red.shade700, fontSize: 13),
            ),
          ],
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pictonBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      s.saveProperty,
                      style: AppFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      hintStyle: AppFonts.body(
        color: AppColors.darkGray.withValues(alpha: 0.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.darkGray.withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.darkGray.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.pictonBlue, width: 1.4),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGray,
      ),
    );
  }
}

class _ImagePickerBox extends StatelessWidget {
  const _ImagePickerBox({
    required this.path,
    required this.onTap,
    required this.placeholder,
  });

  final String? path;
  final VoidCallback? onTap;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.pictonBlue.withValues(alpha: 0.3),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: path != null
              ? Image.file(File(path!), fit: BoxFit.cover)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.pictonBlue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      placeholder,
                      style: AppFonts.body(
                        fontSize: 13,
                        color: AppColors.darkGray.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
