import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vetappflutter/rutas.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  Future<void> _signOut(context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vet App', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => Navigator.pushNamed(context, Routes.addPet),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
            iconSize: 27.0,
            color: Colors.white,
          )
        ],
        backgroundColor: Color.fromARGB(255, 70, 185, 164),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('animals')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(data['name']),
                      trailing: SizedBox(
                        width: 100, // Adjust this value as needed
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.editPet,
                                    arguments: {
                                      'name': data['name'],
                                      'age': data['age'],
                                      'weight': data['weight'],
                                      'id': data.id,
                                    });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('animals')
                                    .doc(data.id)
                                    .delete();
                              },
                              color: Color.fromARGB(255, 164, 61, 54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
