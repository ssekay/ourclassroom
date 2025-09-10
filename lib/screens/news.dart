
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/newscontroller.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final NewsController newController = Get.put(NewsController());
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  void initState(){
    super.initState();
    newController.fetchNewsData('사설');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 뉴스'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value){
                        newController.newsList.clear();
                        newController.fetchNewsData('${_searchController.text} 사설');
                        newController.update();
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      style: const TextStyle(fontSize: 14.0),
                      decoration: const InputDecoration(
                        hintText: '검색어를 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
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
          ) ,
        ],
      ),
    );
  }
}
