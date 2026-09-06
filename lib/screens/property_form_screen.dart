import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wow_cleaning/config/us_states.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key, this.propertyId});

  final int? propertyId;

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  static const _totalSteps = 4;

  final PropertiesApi _api = PropertiesApi();
  final ImagePicker _picker = ImagePicker();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _sqftController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _entryController = TextEditingController();
  final _titleController = TextEditingController();

  String? _stateCode;
  String? _mainImagePath;
  String? _existingMainUrl;
  final List<String> _additionalPaths = [];
  List<String> _existingAdditionalUrls = [];
  int _step = 0;
  bool _saving = false;
  bool _loading = false;
  String? _error;

  bool get _isEditing => widget.propertyId != null;

  static final _zipPattern = RegExp(r'^\d{5}(-\d{4})?$');

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    final id = widget.propertyId;
    if (id == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final property = await _api.show(id);
      if (!mounted) return;
      _titleController.text = property.title;
      _line1Controller.text = (property.addressLine1 ?? '').trim().isNotEmpty
          ? property.addressLine1!.trim()
          : (property.address ?? '');
      _line2Controller.text = property.addressLine2 ?? '';
      _cityController.text = property.city ?? '';
      _zipController.text = property.postalCode ?? '';
      final state = (property.state ?? '').trim().toUpperCase();
      _stateCode = UsStates.all.containsKey(state) ? state : null;
      _sqftController.text = (property.squareFootage ?? 0) > 0
          ? '${property.squareFootage}'
          : '';
      _bedroomsController.text = (property.bedrooms ?? 0) > 0
          ? '${property.bedrooms}'
          : '';
      _bathroomsController.text = (property.bathrooms ?? 0) > 0
          ? '${property.bathrooms}'
          : '';
      _descriptionController.text = property.description ?? '';
      _entryController.text = property.entryInstructions ?? '';
      _existingMainUrl = property.mainImageUrl;
      _existingAdditionalUrls = List<String>.from(property.additionalImageUrls);
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.propertyLoadFailed;
      });
    }
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _sqftController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _descriptionController.dispose();
    _entryController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  String get _stepName {
    final s = S.current;
    return switch (_step) {
      0 => s.propertyStepAddress,
      1 => s.propertyStepDescription,
      2 => s.propertyStepInstructions,
      _ => s.propertyStepPhotos,
    };
  }

  bool _validateCurrentStep() {
    final s = S.current;
    switch (_step) {
      case 0:
        final line1 = _line1Controller.text.trim();
        final city = _cityController.text.trim();
        final zip = _zipController.text.trim();
        if (line1.isEmpty ||
            city.isEmpty ||
            _stateCode == null ||
            zip.isEmpty) {
          setState(() => _error = s.propertyAddressRequired);
          return false;
        }
        if (!_zipPattern.hasMatch(zip)) {
          setState(() => _error = s.propertyZipInvalid);
          return false;
        }
      case 1:
        final sqft = int.tryParse(_sqftController.text.trim());
        final bedrooms = int.tryParse(_bedroomsController.text.trim());
        final bathrooms = int.tryParse(_bathroomsController.text.trim());
        if (sqft == null ||
            sqft < 1 ||
            bedrooms == null ||
            bedrooms < 1 ||
            bathrooms == null ||
            bathrooms < 1) {
          setState(() => _error = s.propertyHousingRequired);
          return false;
        }
      case 3:
        if (_titleController.text.trim().isEmpty) {
          setState(() => _error = s.propertyTitleRequired);
          return false;
        }
    }
    setState(() => _error = null);
    return true;
  }

  void _goNext() {
    if (!_validateCurrentStep()) return;
    FocusScope.of(context).unfocus();
    if (_step < _totalSteps - 1) {
      setState(() => _step += 1);
      return;
    }
    _save();
  }

  void _goBack() {
    if (_saving || _step == 0) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _step -= 1;
      _error = null;
    });
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
    if (!_validateCurrentStep()) return;

    final title = _titleController.text.trim();
    final sqft = int.parse(_sqftController.text.trim());
    final bedrooms = int.parse(_bedroomsController.text.trim());
    final bathrooms = int.parse(_bathroomsController.text.trim());
    final line1 = _line1Controller.text.trim();
    final line2 = _line2Controller.text.trim();
    final city = _cityController.text.trim();
    final zip = _zipController.text.trim();
    final description = _descriptionController.text.trim();
    final entryInstructions = _entryController.text.trim();

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      if (_isEditing) {
        await _api.update(
          id: widget.propertyId!,
          title: title,
          squareFootage: sqft,
          bedrooms: bedrooms,
          bathrooms: bathrooms,
          addressLine1: line1,
          addressLine2: line2,
          city: city,
          state: _stateCode,
          postalCode: zip,
          description: description,
          entryInstructions: entryInstructions,
          mainImagePath: _mainImagePath,
          additionalImagePaths: List<String>.from(_additionalPaths),
        );
      } else {
        await _api.create(
          title: title,
          squareFootage: sqft,
          bedrooms: bedrooms,
          bathrooms: bathrooms,
          addressLine1: line1,
          addressLine2: line2,
          city: city,
          state: _stateCode,
          postalCode: zip,
          description: description,
          entryInstructions: entryInstructions,
          mainImagePath: _mainImagePath,
          additionalImagePaths: List<String>.from(_additionalPaths),
        );
      }
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.darkGray,
                  ),
                  Expanded(
                    child: Text(
                      (_isEditing ? s.editProperty : s.addProperty)
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppFonts.headline(
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        s.bookingStepOf(_step + 1, _totalSteps),
                        style: AppFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.darkGray.withValues(alpha: 0.55),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _stepName,
                        style: AppFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / _totalSteps,
                      minHeight: 6,
                      backgroundColor: AppColors.darkGray.withValues(
                        alpha: 0.08,
                      ),
                      color: AppColors.pictonBlue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.pictonBlue,
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      children: [
                        if (_error != null) ...[
                          Text(
                            _error!,
                            style: AppFonts.body(
                              color: Colors.red.shade700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        ...switch (_step) {
                          0 => _buildAddressStep(s),
                          1 => _buildDescriptionStep(s),
                          2 => _buildInstructionsStep(s),
                          _ => _buildPhotosStep(s),
                        },
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  if (_step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _goBack,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          foregroundColor: AppColors.darkGray,
                          side: BorderSide(
                            color: AppColors.darkGray.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          s.back,
                          style: AppFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (_step > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _saving || _loading ? null : _goNext,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: AppColors.pictonBlue,
                        disabledBackgroundColor: AppColors.pictonBlue
                            .withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
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
                              _step == _totalSteps - 1
                                  ? s.saveProperty
                                  : s.next,
                              style: AppFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAddressStep(S s) {
    return [
      _FieldLabel(s.propertyAddressLine1),
      const SizedBox(height: 8),
      TextField(
        controller: _line1Controller,
        textCapitalization: TextCapitalization.words,
        decoration: _inputDecoration(s.propertyAddressLine1Hint),
      ),
      const SizedBox(height: 16),
      _FieldLabel(s.propertyAddressLine2),
      const SizedBox(height: 8),
      TextField(
        controller: _line2Controller,
        textCapitalization: TextCapitalization.words,
        decoration: _inputDecoration(s.propertyAddressLine2Hint),
      ),
      const SizedBox(height: 16),
      _FieldLabel(s.propertyCity),
      const SizedBox(height: 8),
      TextField(
        controller: _cityController,
        textCapitalization: TextCapitalization.words,
        decoration: _inputDecoration(s.propertyCity),
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel(s.propertyState),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _stateCode,
                  isExpanded: true,
                  decoration: _inputDecoration(s.propertySelectState),
                  hint: Text(
                    s.propertySelectState,
                    style: AppFonts.body(
                      color: AppColors.darkGray.withValues(alpha: 0.4),
                    ),
                  ),
                  items: [
                    for (final entry in UsStates.all.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          '${entry.key} — ${entry.value}',
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.body(fontSize: 14),
                        ),
                      ),
                  ],
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _stateCode = value),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel(s.propertyZip),
                const SizedBox(height: 8),
                TextField(
                  controller: _zipController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: _inputDecoration('12345'),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildDescriptionStep(S s) {
    return [
      _FieldLabel(s.propertySquareFootage),
      const SizedBox(height: 8),
      TextField(
        controller: _sqftController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: _inputDecoration(s.propertySquareFootageHint),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel(s.propertyBedrooms),
                const SizedBox(height: 8),
                TextField(
                  controller: _bedroomsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration('1'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FieldLabel(s.propertyBathrooms),
                const SizedBox(height: 8),
                TextField(
                  controller: _bathroomsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _inputDecoration('1'),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _FieldLabel(s.propertyDescription),
      const SizedBox(height: 8),
      TextField(
        controller: _descriptionController,
        minLines: 4,
        maxLines: 8,
        textCapitalization: TextCapitalization.sentences,
        decoration: _inputDecoration(s.propertyDescriptionHint),
      ),
    ];
  }

  List<Widget> _buildInstructionsStep(S s) {
    return [
      _FieldLabel(s.propertyEntryInstructions),
      const SizedBox(height: 8),
      TextField(
        controller: _entryController,
        minLines: 6,
        maxLines: 12,
        textCapitalization: TextCapitalization.sentences,
        decoration: _inputDecoration(s.propertyEntryHint),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.yellow.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.photo_camera_outlined,
              color: AppColors.darkGray,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                s.propertyInstructionsPhotosHint,
                style: AppFonts.body(fontSize: 13, color: AppColors.darkGray),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildPhotosStep(S s) {
    return [
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
        networkUrl: _existingMainUrl,
        onTap: _saving ? null : _pickMain,
        placeholder: s.propertyPickMainPhoto,
      ),
      const SizedBox(height: 18),
      _FieldLabel(s.propertyAdditionalPhotos),
      const SizedBox(height: 8),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          ..._existingAdditionalUrls.map(
            (url) => ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
    ];
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
    required this.networkUrl,
    required this.onTap,
    required this.placeholder,
  });

  final String? path;
  final String? networkUrl;
  final VoidCallback? onTap;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (path != null) {
      child = Image.file(File(path!), fit: BoxFit.cover);
    } else if ((networkUrl ?? '').isNotEmpty) {
      child = Image.network(
        networkUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholderContent(),
      );
    } else {
      child = _placeholderContent();
    }

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
          child: child,
        ),
      ),
    );
  }

  Widget _placeholderContent() {
    return Column(
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
    );
  }
}
