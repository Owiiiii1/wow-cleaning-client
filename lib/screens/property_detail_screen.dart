import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/screens/property_form_screen.dart';
import 'package:wow_cleaning/services/api_client.dart';
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
  bool _deleting = false;
  bool _changed = false;
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

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(propertyId: widget.propertyId),
      ),
    );
    if (updated == true) {
      _changed = true;
      await _load();
    }
  }

  Future<void> _confirmDelete() async {
    if (_deleting) return;
    final s = S.current;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            s.propertyDeleteTitle,
            style: AppFonts.headline(fontSize: 18, color: AppColors.darkLiver),
          ),
          content: Text(
            s.propertyDeleteConfirm,
            style: AppFonts.body(fontSize: 15, color: AppColors.darkLiver),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                s.cancel,
                style: AppFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkLiver,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                s.propertyDelete,
                style: AppFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _api.delete(widget.propertyId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _deleting = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _deleting = false;
        _error = s.propertyDeleteFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final property = _property;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.darkGray,
          title: Text(
            (property?.title ?? s.savedProperties).toUpperCase(),
            style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
          ),
          actions: [
            if (property != null)
              IconButton(
                onPressed: _deleting ? null : _openEdit,
                icon: const Icon(Icons.edit_outlined),
                tooltip: s.editProperty,
              ),
          ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.pictonBlue),
              )
            : _error != null && property == null
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
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
                    property.title.toUpperCase(),
                    style: AppFonts.headline(
                      fontSize: 22,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    title: s.propertyStepAddress,
                    icon: Icons.place_outlined,
                    child: Text(
                      property.displayAddress ?? '—',
                      style: AppFonts.body(
                        fontSize: 15,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: s.propertyStepDescription,
                    icon: Icons.home_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if ((property.squareFootage ?? 0) > 0)
                              _StatChip(
                                icon: Icons.square_foot_rounded,
                                label: '${property.squareFootage} sqft',
                              ),
                            if ((property.bedrooms ?? 0) > 0)
                              _StatChip(
                                icon: Icons.bed_outlined,
                                label:
                                    '${property.bedrooms} ${s.propertyBedroomsShort}',
                              ),
                            if ((property.bathrooms ?? 0) > 0)
                              _StatChip(
                                icon: Icons.bathtub_outlined,
                                label:
                                    '${property.bathrooms} ${s.propertyBathroomsShort}',
                              ),
                          ],
                        ),
                        if ((property.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            property.description!,
                            style: AppFonts.body(
                              fontSize: 14,
                              color: AppColors.darkGray.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: s.propertyStepInstructions,
                    icon: Icons.key_outlined,
                    child: Text(
                      (property.entryInstructions ?? '').isEmpty
                          ? '—'
                          : property.entryInstructions!,
                      style: AppFonts.body(
                        fontSize: 14,
                        color: AppColors.darkGray.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  if (property.additionalImageUrls.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: s.propertyAdditionalPhotos,
                      icon: Icons.photo_library_outlined,
                      child: SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: property.additionalImageUrls.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final url = property.additionalImageUrls[index];
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
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _deleting ? null : _openEdit,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.pictonBlue,
                        side: const BorderSide(color: AppColors.pictonBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(
                        s.editProperty,
                        style: AppFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: _deleting ? null : _confirmDelete,
                      child: _deleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Color(0xFFE53935),
                              ),
                            )
                          : Text(
                              s.propertyDelete,
                              style: AppFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFE53935),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.pictonBlue.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.pictonBlue.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.pictonBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pictonBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.pictonBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
