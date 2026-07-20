import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider<Object> expertAvatarImage(String source) {
  final Uri? uri = Uri.tryParse(source);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return NetworkImage(source);
  }
  if (uri != null && uri.scheme == 'file') {
    return FileImage(File.fromUri(uri));
  }
  if (source.startsWith('/')) return FileImage(File(source));
  return AssetImage(source);
}
