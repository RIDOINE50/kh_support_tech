import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Données de la FAQ (tu pourras les modifier ou les charger depuis l'API plus tard)
    final List<Map<String, String>> faqData = [
      {
        'question': 'Comment suivre l\'état de ma commande ?',
        'reponse': 'Connectez-vous à votre compte, allez dans "Mon Profil" puis cliquez sur "Mes commandes". Vous y verrez le statut en temps réel (En attente, En cours, Livré).'
      },
      {
        'question': 'Quels sont les délais d\'intervention pour une panne ?',
        'reponse': 'Pour les urgences, nous intervenons sous 2h à 4h. Pour les demandes standards, l\'intervention est programmée sous 24h à 48h après validation du devis.'
      },
      {
        'question': 'Comment obtenir un devis pour une formation ?',
        'reponse': 'Rendez-vous dans la section "Formations", choisissez le programme qui vous intéresse et cliquez sur "Demander un devis". Vous recevrez une proposition sous 24h.'
      },
      {
        'question': 'Les pièces de rechange sont-elles garanties ?',
        'reponse': 'Oui, toutes les pièces de rechange fournies par KH SUPPORT TECH bénéficient d\'une garantie constructeur allant de 6 à 12 mois selon le type de matériel.'
      },
      {
        'question': 'Puis-je annuler une demande de service ?',
        'reponse': 'Oui, tant que le statut de votre demande est "En attente", vous pouvez l\'annuler depuis la section "Mes interventions" ou en contactant notre support.'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Questions Fréquentes',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: faqData.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = faqData[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                iconColor: AppColors.primary,
                collapsedIconColor: AppColors.textSecondary,
                title: Text(
                  item['question']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      item['reponse']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}