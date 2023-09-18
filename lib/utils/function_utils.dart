int extractIdFromUrl(String url) {
  final pattern = RegExp(r'[^0-9]');
  final String id = url.replaceAll(pattern, '');
  return int.parse(id);
}

int computeDifference(var listOfNotifications, int storageLatestNotfId) {
  final apiLatestNotfId = int.parse(listOfNotifications.first.id);
  int difference = (apiLatestNotfId - storageLatestNotfId);
  if (difference > 10) difference = 10;
  return difference;
}
