import 'package:PARLACLINIC/features/home/view/viewmodels/home_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(articlesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("مقالات"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: state.when(
        data: (articles) => RefreshIndicator(
          onRefresh: () =>
              ref.read(articlesViewModelProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(id: article.id)),
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      if (article.previewImage != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: article.previewImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, _) => const SizedBox(
                                height: 180,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(article.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(article.previewText,
                                maxLines: 3, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Text('دسته: ${article.category}',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("خطا: $e")),
      ),
    );
  }
}

class ArticleDetailPage extends ConsumerWidget {
  final int id;

  const ArticleDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(articleDetailViewModelProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("جزئیات مقاله"),
        backgroundColor: Colors.deepPurple,
      ),
      body: state.when(
        data: (article) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                article.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'دسته‌بندی: ${article.category}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Html(
                data: article.content,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    direction: TextDirection.rtl,
                    lineHeight: LineHeight(1.8),
                  ),
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("خطا: $e")),
      ),
    );
  }
}
