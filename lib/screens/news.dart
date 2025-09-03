
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/newscontroller.dart';

class News extends StatelessWidget {
  News({super.key});

  final NewsController newController = Get.put(NewsController());

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 뉴스'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (newController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (newController.newsList.isEmpty) {
          return const Center(child: Text('뉴스를 찾을 수 없습니다.'));
        } else {
          return ListView.builder(
            itemCount: newController.newsList.length,
            itemBuilder: (context, index) {
              final news = newController.newsList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    news.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(news.description),
                      const SizedBox(height: 8.0),
                      Text(
                        DateFormat('yyyy년 MM월 dd일 HH:mm').format(news.pubDate),
                        style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    _launchURL(news.link);
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
