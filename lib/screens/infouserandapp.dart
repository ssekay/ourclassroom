import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:async';

import '../utils/constants.dart';

class InfoUserAndApp extends StatefulWidget {
  const InfoUserAndApp({super.key});

  @override
  State<InfoUserAndApp> createState() => _InfoUserAndAppState();
}

class _InfoUserAndAppState extends State<InfoUserAndApp> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 및 사용자 정보'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ListView(
            children: [
              const SizedBox(height: 10,),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('사용자'),
                subtitle: Text('${Constants.currentUser.grade}학년 ${Constants.currentUser.classNum}반  ${Constants.currentUser.name}'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('앱 이름'),
                subtitle: Text(_packageInfo.appName),
              ),
              ListTile(
                leading: const Icon(Icons.verified),
                title: const Text('버전'),
                subtitle: Text(_packageInfo.version),
              ),
              ListTile(
                leading: const Icon(Icons.build),
                title: const Text('빌드 번호'),
                subtitle: Text(_packageInfo.buildNumber),
              ),
              const ListTile(
                leading: Icon(Icons.copyright),
                title: Text('저작권'),
                subtitle: Text('© 2024 안양외고 앱개발 동아리'),
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text('개발자'),
                subtitle: Text('안양외고 앱개발 동아리'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
