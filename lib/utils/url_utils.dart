int extractIdFromUrl(String url) {
  final pattern = RegExp(r'[^0-9]');
  final String id = url.replaceAll(pattern, '');
  return int.parse(id);
}
