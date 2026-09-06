import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/properties_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.item, required this.onTap});

  final ClientPropertyItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    final address = item.displayAddress;
    final stats = item.hasHousingParams
        ? '${item.squareFootage} sqft  ·  ${item.bedrooms} ${s.propertyBedroomsShort}  ·  ${item.bathrooms} ${s.propertyBathroomsShort}'
        : null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.pictonBlue.withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.pictonBlue.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.darkGray.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: (item.mainImageUrl ?? '').isNotEmpty
                    ? Image.network(
                        item.mainImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const _PropertyPhotoFallback(),
                      )
                    : const _PropertyPhotoFallback(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title.toUpperCase(),
                      style: AppFonts.headline(
                        fontSize: 16,
                        color: AppColors.darkGray,
                      ),
                    ),
                    if ((address ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 16,
                            color: AppColors.pictonBlue,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              address!,
                              style: AppFonts.body(
                                fontSize: 13,
                                color: AppColors.darkGray.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (stats != null) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _StatChip(
                            icon: Icons.square_foot_rounded,
                            label: '${item.squareFootage} sqft',
                          ),
                          _StatChip(
                            icon: Icons.bed_outlined,
                            label:
                                '${item.bedrooms} ${s.propertyBedroomsShort}',
                          ),
                          _StatChip(
                            icon: Icons.bathtub_outlined,
                            label:
                                '${item.bathrooms} ${s.propertyBathroomsShort}',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _PropertyPhotoFallback extends StatelessWidget {
  const _PropertyPhotoFallback();

  @override
  Widget build(BuildContext context) {
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
