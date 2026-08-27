import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final int propertyId;

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final PropertiesApi _api = PropertiesApi();
  ClientPropertyDetail? _property;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final property = await _api.show(widget.propertyId);
      if (!mounted) return;
      setState(() {
        _property = property;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = S.current.propertyLoadFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final property = _property;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkGray,
        title: Text(
          property?.title ?? s.savedProperties,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.pictonBlue),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      style: AppFonts.body(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : property == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: (property.mainImageUrl ?? '').isNotEmpty
                                ? Image.network(
                                    property.mainImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, st) => _placeholder(),
                                  )
                                : _placeholder(),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          property.title,
                          style: AppFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGray,
                          ),
                        ),
                        if ((property.address ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            property.address!,
                            style: AppFonts.body(
                              fontSize: 14,
                              color:
                                  AppColors.darkGray.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                        if ((property.squareFootage ?? 0) > 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            '${s.propertySquareFootage}: ${property.squareFootage}',
                            style: AppFonts.body(
                              fontSize: 14,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                        if ((property.bedrooms ?? 0) > 0 ||
                            (property.bathrooms ?? 0) > 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${s.propertyBedrooms}: ${property.bedrooms ?? '—'}  ·  ${s.propertyBathrooms}: ${property.bathrooms ?? '—'}',
                            style: AppFonts.body(
                              fontSize: 14,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                        if ((property.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _Section(
                            title: s.propertyDescription,
                            body: property.description!,
                          ),
                        ],
                        if ((property.entryInstructions ?? '').isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _Section(
                            title: s.propertyEntryInstructions,
                            body: property.entryInstructions!,
                          ),
                        ],
                        if (property.additionalImageUrls.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            s.propertyAdditionalPhotos,
                            style: AppFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: property.additionalImageUrls.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final url =
                                    property.additionalImageUrls[index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    url,
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.pictonBlue.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: const Icon(
        Icons.home_work_outlined,
        color: AppColors.pictonBlue,
        size: 40,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: AppFonts.body(
            fontSize: 14,
            color: AppColors.darkGray.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
