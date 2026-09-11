class ServiceItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final dynamic details;
  
  ServiceItem({required this.id, required this.title, required this.category, this.description = '', this.details});
  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    description: json['description'] ?? '',
    details: json['details'],
  );
  
  factory ServiceItem.fromMap(Map<String, dynamic> map) => ServiceItem.fromJson(map);
}
