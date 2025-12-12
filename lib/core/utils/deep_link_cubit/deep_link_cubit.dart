import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

part 'deep_link_state.dart';

class DeepLinkCubit extends Cubit<DeepLinkState> {
  DeepLinkCubit() : super(DeepLinkInitial());

  bool _isInitialized = false; // 👈 New Flag
  late final AppLinks _appLinks;

  Future<void> initDeepLinks(BuildContext context) async {
    if (_isInitialized) return; // ⛔ يمنع إعادة التشغيل

    _isInitialized = true; // ✔ تشغيل مرة واحدة فقط
    _appLinks = AppLinks();

    // Listen to app while running
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri, context);
    });

    // Handle app opened by link
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      _handleDeepLink(initial, context);
    }
  }

  void _handleDeepLink(Uri uri, BuildContext context) {
    print("📥 DeepLink Received → $uri");

    if (uri.pathSegments.contains("product")) {
      final id = uri.pathSegments.last;
      print("➡ Navigate to product: $id");
      context.push("/product/$id");

      emit(DeepLinkOpenedProduct(id));
    }
  }
}
