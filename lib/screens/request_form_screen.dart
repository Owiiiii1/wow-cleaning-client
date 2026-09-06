import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wow_cleaning/l10n/app_strings.dart';
import 'package:wow_cleaning/services/api_client.dart';
import 'package:wow_cleaning/services/requests_api.dart';
import 'package:wow_cleaning/theme/app_theme.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key, this.orderId});

  final int? orderId;

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  final _api = RequestsApi();
  final List<XFile> _photos = [];
  bool _submitting = false;

  bool get _isDispute => widget.orderId != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final files = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (!mounted || files.isEmpty) return;
    setState(() {
      final remaining = 5 - _photos.length;
      _photos.addAll(files.take(remaining));
    });
  }

  Future<void> _submit() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      final request = _isDispute
          ? await _api.createDispute(
              orderId: widget.orderId!,
              message: message,
              photoPaths: _photos.map((photo) => photo.path).toList(),
            )
          : await _api.createFeedback(
              message: message,
              photoPaths: _photos.map((photo) => photo.path).toList(),
            );
      if (!mounted) return;
      Navigator.of(context).pop(request);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.displayMessage)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.requestSubmitFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.current;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        title: Text(
          _isDispute ? s.reportProblem : s.newRequest,
          style: AppFonts.headline(fontSize: 18, color: AppColors.darkGray),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            _isDispute ? s.disputePrompt : s.feedbackPrompt,
            style: AppFonts.body(fontSize: 15, color: AppColors.darkGray),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 5,
            maxLines: 10,
            maxLength: 2000,
            enabled: !_submitting,
            decoration: InputDecoration(
              hintText: s.requestMessageHint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  s.requestPhotos(_photos.length),
                  style: AppFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _submitting || _photos.length >= 5
                    ? null
                    : _pickPhotos,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(s.addPhotos),
              ),
            ],
          ),
          if (_photos.isNotEmpty)
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_photos[index].path),
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: IconButton.filled(
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        onPressed: _submitting
                            ? null
                            : () => setState(() => _photos.removeAt(index)),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _controller.text.trim().isEmpty || _submitting
                  ? null
                  : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pictonBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      s.sendRequest,
                      style: AppFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
