import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<dynamic> dosenList = [];

  @override
  void initState() {
    super.initState();
    loadDosenData();
  }

  Future<void> loadDosenData() async {
    final String response = await rootBundle
        .loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      dosenList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'Whtheresia',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(
                    child: Text(
                      'Belum ada pencarian',
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          final List<dynamic> messages = dosen['messages'] ?? [];
          final lastMessage = messages.isNotEmpty
              ? messages[messages.length - 1]['message']
              : 'Belum ada chat';
          final int lastMessageFrom =
              messages.isNotEmpty ? messages[messages.length - 1]['from'] : -1;
          final String lastMessageTime =
              lastMessageFrom == 0 ? '2 menit lalu' : 'Kemarin';

          // Hitung jumlah pesan yang belum dibaca
          final int unreadCount =
              messages.where((msg) => msg['is_read'] == false).length;

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PesanScreen(dosen: dosen),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(dosen['avatar']),
            ),
            title: Text(dosen['full_name']),
            subtitle: Text(lastMessage),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (unreadCount == 0 && lastMessageFrom == 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  lastMessageTime,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync),
            label: 'Pembaruan',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups),
            label: 'Komunitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.call),
            label: 'Panggilan',
          ),
        ],
      ),
    );
  }
}
