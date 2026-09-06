import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wow_cleaning/services/api_client.dart';

class AuthorizedNetworkImage extends StatefulWidget {
  const AuthorizedNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  final String url;
  final BoxFit fit;
  final Widget? errorWidget;

  @override
  State<AuthorizedNetworkImage> createState() => _AuthorizedNetworkImageState();
}

class _AuthorizedNetworkImageState extends State<AuthorizedNetworkImage> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AuthorizedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _load();
  }

  void _load() {
    _bytes = ApiClient()
        .getBytes(widget.url)
        .then((value) => Uint8List.fromList(value));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _bytes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!, fit: widget.fit);
        }
        if (snapshot.hasError) {
          return widget.errorWidget ??
              const Center(child: Icon(Icons.broken_image_outlined));
        }
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }
}
