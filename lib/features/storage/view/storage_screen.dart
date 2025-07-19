import 'package:bookapp/shared/utils/linearGradient.dart';
import 'package:flutter/material.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  Future<List<String>> _fetchSaves() async {
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'gdfsd',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: customGradinet()),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchSaves(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('خطا در بارگذاری سیوها'));
          }

          final saves = snapshot.data ?? [];

          if (saves.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.save_alt_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'هیچ سیوی پیدا نشد!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: saves.length,
            itemBuilder: (context, index) {
              final save = saves[index];
              return ListTile(
                leading: const Icon(Icons.save),
                title: Text(save),
              );
            },
          );
        },
      ),
    );
  }
}
