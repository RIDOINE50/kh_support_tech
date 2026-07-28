import 'package:flutter/material.dart';
import 'package:kh_support_tech/models/programme_model.dart';

class ProgrammeDetailScreen extends StatelessWidget {
  final Programme programme;

  const ProgrammeDetailScreen({Key? key, required this.programme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image en grand format si elle existe
            if (programme.image != null)
              Image.network(
                programme.image!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grand titre
                  Text(
                    programme.titre,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 16),
                  
                  // Description complète
                  Text(
                    programme.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5, // Espacement des lignes pour une meilleure lecture
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}