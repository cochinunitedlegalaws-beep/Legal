class DocumentTemplate {
  final String id;
  final String title;
  final String category;
  final String content;
  DocumentTemplate({required this.id, required this.title, required this.category, this.content = ''});
  factory DocumentTemplate.fromJson(Map<String, dynamic> json) => DocumentTemplate(
    id: json['id'] ?? '', title: json['title'] ?? '', category: json['category'] ?? '', content: json['content'] ?? ''
  );
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'category': category, 'content': content};
}
