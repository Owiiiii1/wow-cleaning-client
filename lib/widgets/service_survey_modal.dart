import 'package:flutter/material.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/inbox_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';
import 'package:wow_cleaning/widgets/branded_button.dart';

class ServiceSurveyModal extends StatefulWidget {
  const ServiceSurveyModal({super.key, required this.messageId, this.api});

  final int messageId;
  final InboxApi? api;

  @override
  State<ServiceSurveyModal> createState() => _ServiceSurveyModalState();
}

class _ServiceSurveyModalState extends State<ServiceSurveyModal> {
  late final InboxApi _api = widget.api ?? InboxApi();
  final TextEditingController _commentController = TextEditingController();
  final Map<String, int> _answers = {};
  bool _saving = false;
  String? _error;

  bool get _complete =>
      _answers['cleaning_quality'] != null &&
      _answers['punctuality'] != null &&
      _answers['communication'] != null &&
      _answers['service_convenience'] != null;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_complete || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _api.submitSurvey(
        widget.messageId,
        cleaningQuality: _answers['cleaning_quality']!,
        punctuality: _answers['punctuality']!,
        communication: _answers['communication']!,
        serviceConvenience: _answers['service_convenience']!,
        improvementComment: _commentController.text,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = S.current.surveySubmitFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.surveyTitle,
                  textAlign: TextAlign.center,
                  style: AppFonts.headline(
                    fontSize: 20,
                    color: AppColors.darkLiver,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  s.surveyBody,
                  textAlign: TextAlign.center,
                  style: AppFonts.body(
                    fontSize: 14,
                    color: AppColors.darkLiver.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _SurveyScoreRow(
                          label: s.surveyCleaningQuality,
                          value: _answers['cleaning_quality'],
                          onChanged: (value) => setState(
                            () => _answers['cleaning_quality'] = value,
                          ),
                        ),
                        _SurveyScoreRow(
                          label: s.surveyPunctuality,
                          value: _answers['punctuality'],
                          onChanged: (value) =>
                              setState(() => _answers['punctuality'] = value),
                        ),
                        _SurveyScoreRow(
                          label: s.surveyCommunication,
                          value: _answers['communication'],
                          onChanged: (value) =>
                              setState(() => _answers['communication'] = value),
                        ),
                        _SurveyScoreRow(
                          label: s.surveyConvenience,
                          value: _answers['service_convenience'],
                          onChanged: (value) => setState(
                            () => _answers['service_convenience'] = value,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentController,
                          enabled: !_saving,
                          maxLength: 2000,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: s.surveyComment,
                            hintText: s.surveyCommentHint,
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: AppFonts.body(
                      fontSize: 13,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                BrandedButton(
                  label: s.surveySubmit,
                  loading: _saving,
                  onPressed: _complete ? _submit : null,
                ),
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => Navigator.of(context).pop(false),
                  child: Text(s.surveySkip),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SurveyScoreRow extends StatelessWidget {
  const _SurveyScoreRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.body(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkLiver,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var score = 1; score <= 5; score++)
                IconButton(
                  tooltip: '$score',
                  onPressed: () => onChanged(score),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    (value ?? 0) >= score
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.yellow,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
