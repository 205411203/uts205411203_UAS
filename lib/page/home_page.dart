import 'package:flutter/material.dart';
import 'package:uts205411203/component/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Halaman Homepage
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
//Data ebook judul, ringkasan dan author
class _HomePageState extends State<HomePage> {
  // text fields' controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  //koneksi ke collection ebook Firebase Firestore
  final CollectionReference _ebookss =
  FirebaseFirestore.instance.collection('ebooks');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _titleController.text = documentSnapshot['title'];
      _summaryController.text = documentSnapshot['summary'];
      _authorController.text = documentSnapshot['author'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Judul Buku'),
                ),
                TextField(
                  controller: _summaryController,
                  decoration: const InputDecoration(labelText: 'Ringkasan Isi'),
                ),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Pengarang'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? title = _titleController.text;
                    final String? summary = _summaryController.text;
                    final String? author = _authorController.text;

                    if (title != null && summary != null) {
                      if (action == 'create') {
                        // simpan data ebook ke Firebase Firestore
                        await _ebookss.add({"title": title, "summary": summary, "author": author});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _ebookss
                            .doc(documentSnapshot!.id)
                            .update({"title": title, "summary": summary, "author": author});
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _summaryController.text = '';
                      _authorController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Hapus data ebook sesuai Id
  Future<void> _deleteEbook(String ebookId) async {
    await _ebookss.doc(ebookId).delete();

    // Tampilkan pesan
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Berhasil menghapus data buku')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat My Ebook'),
        backgroundColor: PalletteColors.primaryRed,
      ),
      // Menggunakan StreamBuilder untuk menampilkan data ebook dari Firestore secara real-time
      body: StreamBuilder(
        stream: _ebookss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(documentSnapshot['author']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Tombol edit ebook
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // Tombol hapus ebook
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteEbook(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}