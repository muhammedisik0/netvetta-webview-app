class INotification {
  late String id, cariId, content, url;

  INotification.fromJson(Map json) {
    id = json['id'];
    cariId = json['cari'];
    content = json['metin'];
    url = json['url'];
  }
}
