import 'package:flutter/material.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. On récupère les couleurs dynamiques du thème (elles changent selon le mode clair/sombre)
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor, // ✅ Fond qui s'adapte au mode sombre
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor), // ✅ Couleur dynamique
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'À propos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // ✅ Couleur dynamique
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // LISTE DES ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _AboutMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Présentation',
                    onTap: () => _goToDetail(context, 'Présentation', 
                      'KH SUPPORT TECH : Votre Partenaire en Excellence Numérique\n\n'
                      'Fondée avec la vision de démocratiser l\'accès aux technologies de pointe, KH SUPPORT TECH s\'est imposée comme un acteur majeur dans le domaine des solutions informatiques et numériques en Afrique.\n\n'
                      'NOTRE HISTOIRE\n\n'
                      'Depuis notre création, nous n\'avons cessé d\'innover et de nous adapter aux besoins spécifiques de nos clients. Notre parcours est jalonné de succès, de défis relevés avec brio et surtout, de relations durables tissées avec nos partenaires et clients.\n\n'
                      'NOTRE APPROCHE\n\n'
                      'Nous croyons fermement que la technologie doit être un levier de croissance et non une contrainte. C\'est pourquoi nous adoptons une approche humaine et personnalisée, en prenant le temps de comprendre vos enjeux avant de vous proposer des solutions sur mesure.\n\n'
                      'NOS DOMAINES D\'EXPERTISE\n\n'
                      '• Maintenance informatique et support technique\n'
                      '• Développement de solutions logicielles\n'
                      '• Formation professionnelle aux nouvelles technologies\n'
                      '• Installation et gestion de réseaux\n'
                      '• Solutions cloud et transformation digitale\n'
                      '• Vente de matériel informatique de qualité\n\n'
                      'NOTRE ENGAGEMENT\n\n'
                      'Nous nous engageons à vous fournir des services de haute qualité, dans le respect des délais et avec un souci constant d\'excellence. Votre satisfaction est notre priorité absolue.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.flag,
                    title: 'Mission & Vision',
                    onTap: () => _goToDetail(context, 'Mission & Vision', 
                      'NOTRE MISSION\n\n'
                      'Accompagner les entreprises et les particuliers dans leur transformation digitale en leur fournissant des solutions technologiques innovantes, accessibles et adaptées à leurs besoins spécifiques.\n\n'
                      'OBJECTIFS STRATÉGIQUES\n\n'
                      '• Rendre la technologie accessible à tous, regardless du niveau de compétence\n'
                      '• Former la prochaine génération de professionnels du numérique\n'
                      '• Réduire la fracture digitale en Afrique de l\'Ouest\n'
                      '• Offrir un support technique réactif et professionnel\n'
                      '• Promouvoir l\'innovation et l\'excellence opérationnelle\n\n'
                      'NOTRE VISION\n\n'
                      'Devenir le leader régional des services informatiques intégrés d\'ici 2030, reconnu pour notre expertise, notre innovation et notre engagement envers le développement des compétences numériques.\n\n'
                      'AMBITIONS À LONG TERME\n\n'
                      '• Établir un réseau de centres de formation dans toute la sous-région\n'
                      '• Développer des partenariats stratégiques avec les géants de la tech\n'
                      '• Créer un incubateur pour soutenir les startups locales\n'
                      '• Contribuer activement à la digitalisation de l\'administration publique\n\n'
                      'NOS VALEURS FONDAMENTALES\n\n'
                      'Excellence • Innovation • Intégrité • Proximité • Engagement'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.groups_outlined,
                    title: 'Notre équipe',
                    onTap: () => _goToDetail(context, 'Notre équipe', 
                      'UNE ÉQUIPE PASSIONNÉE ET EXPÉRIMENTÉE\n\n'
                      'Chez KH SUPPORT TECH, notre plus grande force réside dans notre capital humain. Nous avons réuni des professionnels talentueux, passionnés et dévoués à votre réussite.\n\n'
                      'NOTRE COMPOSITION\n\n'
                      '• Ingénieurs systèmes et réseaux certifiés\n'
                      '• Développeurs full-stack experts\n'
                      '• Formateurs pédagogues et expérimentés\n'
                      '• Techniciens de maintenance qualifiés\n'
                      '• Conseillers commerciaux à l\'écoute\n'
                      '• Chefs de projets aguerris\n\n'
                      'NOTRE CULTURE D\'ENTREPRISE\n\n'
                      'Nous favorisons un environnement de travail collaboratif où l\'innovation et le partage des connaissances sont encouragés. Chaque membre de notre équipe bénéficie de formations continues pour rester à la pointe des dernières technologies.\n\n'
                      'NOS EXPERTS\n\n'
                      'Notre équipe compte plus de 15 ans d\'expérience cumulée dans le secteur des TIC. Nous sommes fiers de la diversité de nos compétences et de notre capacité à travailler en synergie pour résoudre vos problèmes les plus complexes.\n\n'
                      'REJOIGNEZ-NOUS\n\n'
                      'Nous sommes toujours à la recherche de talents passionnés. Si vous souhaitez faire partie de l\'aventure KH SUPPORT TECH, n\'hésitez pas à nous contacter.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.handshake_outlined,
                    title: 'Nos partenaires',
                    onTap: () => _goToDetail(context, 'Nos partenaires', 
                      'DES PARTENARIATS STRATÉGIQUES DE QUALITÉ\n\n'
                      'La réussite de KH SUPPORT TECH repose également sur la force de nos partenariats. Nous collaborons avec des acteurs majeurs du secteur technologique pour vous garantir des solutions de pointe.\n\n'
                      'NOS PARTENAIRES TECHNOLOGIQUES\n\n'
                      '• Constructeurs de matériel informatique de renommée mondiale\n'
                      '• Éditeurs de logiciels leaders du marché\n'
                      '• Fournisseurs de solutions cloud internationales\n'
                      '• Opérateurs télécoms locaux et régionaux\n\n'
                      'NOS PARTENAIRES INSTITUTIONNELS\n\n'
                      '• Ministères et administrations publiques\n'
                      '• Établissements d\'enseignement supérieur\n'
                      '• Organisations internationales de développement\n'
                      '• Chambres de commerce et d\'industrie\n\n'
                      'NOS PARTENAIRES COMMERCIAUX\n\n'
                      '• Grandes entreprises nationales et multinationales\n'
                      '• PME et startups innovantes\n'
                      '• Associations professionnelles\n\n'
                      'POURQUOI NOS PARTENAIRES NOUS FONT CONFIANCE\n\n'
                      'Notre sérieux, notre expertise technique et notre engagement à respecter nos engagements font de nous un partenaire de choix. Nous entretenons des relations durables basées sur la confiance mutuelle et la recherche de bénéfices partagés.\n\n'
                      'DEVENEZ NOTRE PARTENAIRE\n\n'
                      'Vous souhaitez collaborer avec nous ? Nous sommes ouverts à toutes propositions de partenariats gagnant-gagnant.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.emoji_events_outlined,
                    title: 'Nos réalisations',
                    onTap: () => _goToDetail(context, 'Nos réalisations', 
                      'UN PALMARÈS QUI TÉMOIGNE DE NOTRE EXCELLENCE\n\n'
                      'Depuis notre création, nous avons mené à bien des centaines de projets qui témoignent de notre expertise et de notre engagement.\n\n'
                      'CHIFFRES CLÉS\n\n'
                      '• Plus de 500 projets réalisés avec succès\n'
                      '• Plus de 2000 professionnels formés\n'
                      '• 98% de taux de satisfaction client\n'
                      '• 50+ entreprises accompagnées dans leur transformation digitale\n'
                      '• 15 certifications et labels obtenus\n\n'
                      'PROJETS PHARES\n\n'
                      '• Digitalisation complète d\'institutions publiques majeures\n'
                      '• Déploiement de réseaux informatiques pour de grandes entreprises\n'
                      '• Création de plateformes e-learning innovantes\n'
                      '• Organisation de salons et conférences technologiques\n'
                      '• Mise en place de centres de formation équipés de dernière génération\n\n'
                      'RECONNAISSANCES\n\n'
                      '• Prix de l\'Innovation Technologique 2023\n'
                      '• Certification ISO 9001 pour la qualité de nos services\n'
                      '• Partenaire agréé de grandes marques internationales\n'
                      '• Reconnaissance par les autorités locales pour notre contribution au développement numérique\n\n'
                      'TÉMOIGNAGES CLIENTS\n\n'
                      '"KH SUPPORT TECH a transformé notre façon de travailler. Leur professionnalisme et leur réactivité sont exemplaires." - PDG d\'une grande entreprise locale\n\n'
                      '"Les formations dispensées sont de haute qualité et directement applicables." - Responsable RH d\'une multinationale'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.photo_library_outlined,
                    title: 'Galerie photos',
                    onTap: () => _goToDetail(context, 'Galerie photos', 
                      'DÉCOUVREZ KH SUPPORT TECH EN IMAGES\n\n'
                      'Notre galerie photo vous invite à découvrir notre univers, nos locaux, nos équipes en action et les moments forts de notre activité.\n\n'
                      'NOS LOCAUX\n\n'
                      'Découvrez nos installations modernes et équipées : salles de formation climatisées, labor informatiques de pointe, espaces de coworking et bureaux de notre équipe.\n\n'
                      'NOS ÉVÉNEMENTS\n\n'
                      'Retrouvez les photos de nos différents événements : lancements de formations, conférences, ateliers pratiques, cérémonies de remise de certificats et team building.\n\n'
                      'NOS FORMATIONS EN ACTION\n\n'
                      'Immersion au cœur de nos sessions de formation : apprenants concentrés, travaux pratiques, projets de groupe et moments de partage.\n\n'
                      'NOS RÉALISATIONS\n\n'
                      'Visitez en images nos projets : installations de réseaux, déploiement de solutions logicielles, maintenance d\'infrastructures critiques.\n\n'
                      'NOS ÉQUIPES\n\n'
                      'Portrait de nos collaborateurs : moments de travail, collaborations, formations internes et vie d\'entreprise.\n\n'
                      'NOTE : Cette section sera prochainement enrichie avec une véritable galerie interactive permettant de visualiser toutes nos photos en haute résolution.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.video_library_outlined,
                    title: 'Galerie vidéos',
                    onTap: () => _goToDetail(context, 'Galerie vidéos', 
                      'KH SUPPORT TECH EN VIDÉO\n\n'
                      'Plongez au cœur de notre activité à travers nos vidéos : présentations, tutoriels, témoignages et reportages.\n\n'
                      'NOS VIDÉOS DE PRÉSENTATION\n\n'
                      'Découvrez KH SUPPORT TECH en images : notre histoire, nos valeurs, nos services et notre vision du futur numérique.\n\n'
                      'TUTORIELS ET FORMATIONS\n\n'
                      'Accédez à nos tutoriels vidéo pour vous former aux outils et technologies : bases de l\'informatique, logiciels bureautiques, programmation, maintenance, réseaux et bien plus encore.\n\n'
                      'TÉMOIGNAGES CLIENTS\n\n'
                      'Écoutez ceux qui nous font confiance : dirigeants d\'entreprises, apprenants, partenaires partagent leur expérience et leur satisfaction.\n\n'
                      'REPORTAGES ET ÉVÉNEMENTS\n\n'
                      'Revivez nos événements en vidéo : conférences, salons, lancements de produits, cérémonies et moments forts de notre actualité.\n\n'
                      'DÉMONSTRATIONS DE PRODUITS\n\n'
                      'Découvrez en vidéo nos solutions logicielles, notre matériel informatique et nos services de maintenance.\n\n'
                      'NOTE : Cette section sera prochainement enrichie avec une bibliothèque vidéo complète accessible en streaming direct depuis l\'application.'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.contact_mail_outlined,
                    title: 'Nous contacter',
                    onTap: () => _goToDetail(context, 'Nous contacter', 
                      'ENTRONS EN CONTACT\n\n'
                      'Notre équipe est à votre disposition pour répondre à toutes vos questions, besoins et projets. N\'hésitez pas à nous contacter.\n\n'
                      'COORDONNÉES\n\n'
                      '📧 Email : contact@khsupport.com\n'
                      ' Téléphone : +225 07 00 00 00 / +225 05 00 00 00\n'
                      '📱 WhatsApp : +225 07 00 00 00\n'
                      ' Siège social : Abidjan, Côte d\'Ivoire\n\n'
                      'HORAIRES D\'OUVERTURE\n\n'
                      'Lundi - Vendredi : 8h00 - 18h00\n'
                      'Samedi : 9h00 - 13h00\n'
                      'Dimanche : Fermé\n\n'
                      'SUPPORT TECHNIQUE\n\n'
                      'Notre support technique est disponible :\n'
                      '• Par email : support@khsupport.com (réponse sous 24h)\n'
                      '• Par téléphone : ligne dédiée disponible pendant les heures d\'ouverture\n'
                      '• Urgences : service d\'astreinte disponible 7j/7 pour nos clients sous contrat de maintenance\n\n'
                      'FORMULAIRES DE CONTACT\n\n'
                      'Vous pouvez également utiliser notre formulaire de contact disponible sur notre site web pour :\n'
                      '• Demander un devis gratuit\n'
                      '• Vous inscrire à une formation\n'
                      '• Solliciter une intervention technique\n'
                      '• Proposer un partenariat\n'
                      '• Envoyer toute autre demande\n\n'
                      'SUIVEZ-NOUS SUR LES RÉSEAUX SOCIAUX\n\n'
                      'Facebook : @KHSUPPORTTECH\n'
                      'LinkedIn : KH Support Tech\n'
                      'Twitter : @KHSUPPORT\n'
                      'YouTube : KH Support Tech Official'),
                  ),
                  _AboutMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Localisation',
                    onTap: () => _goToDetail(context, 'Localisation', 
                      'OÙ NOUS TROUVER ?\n\n'
                      'KH SUPPORT TECH est stratégiquement situé pour mieux vous servir.\n\n'
                      'ADRESSE DU SIÈGE\n\n'
                      'KH SUPPORT TECH\n'
                      'Immeuble [Nom de l\'immeuble]\n'
                      'Quartier [Nom du quartier]\n'
                      'Boulevard [Nom du boulevard]\n'
                      'Abidjan, Côte d\'Ivoire\n'
                      'Code postal : 00225\n\n'
                      'ACCÈS ET TRANSPORTS\n\n'
                      'En voiture :\n'
                      '• Parking disponible pour nos visiteurs\n'
                      '• Accès facile depuis les principaux axes de la ville\n'
                      '• Proximité des grandes enseignes commerciales\n\n'
                      'En transports en commun :\n'
                      '• Arrêt de bus à 2 minutes à pied\n'
                      '• Lignes disponibles : [Numéros des lignes]\n'
                      '• Station de taxi nearby\n\n'
                      'NOS AUTRES IMPLANTATIONS\n\n'
                      'Nous prévoyons d\'ouvrir prochainement des antennes dans les villes suivantes :\n'
                      '• Bouaké\n'
                      '• San Pedro\n'
                      '• Yamoussoukro\n'
                      '• Et dans d\'autres pays de la sous-région\n\n'
                      'CARTE INTERACTIVE\n\n'
                      'NOTE : Une carte interactive Google Maps sera intégrée prochainement dans cette section pour vous guider facilement jusqu\'à nos locaux.\n\n'
                      'POINTS DE REPÈRE\n'
                      '• À côté de [Point de repère connu]\n'
                      '• En face de [Établissement connu]\n'
                      '• Proche de [Lieu emblématique]'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToDetail(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AboutDetailScreen(title: title, content: content),
      ),
    );
  }
}

// ==========================================
// WIDGET RÉUTILISABLE POUR LES ITEMS DU MENU
// ==========================================
class _AboutMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AboutMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ 2. Couleurs dynamiques pour les éléments de la liste
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final dividerColor = Theme.of(context).dividerColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: dividerColor, // ✅ Ligne de sération qui change en mode sombre
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: subTextColor, // ✅ Icône qui s'adapte
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor, // ✅ Texte qui s'adapte
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: subTextColor, // ✅ Flèche qui s'adapte
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ÉCRAN DE DÉTAIL
// ==========================================
class AboutDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const AboutDetailScreen({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ 3. Couleurs dynamiques pour l'écran de détail
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor, // ✅ Fond qui s'adapte
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: content.split('\n\n').map((paragraph) {
                    bool isTitle = paragraph == paragraph.toUpperCase() && paragraph.length < 50;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        paragraph,
                        style: TextStyle(
                          fontSize: isTitle ? 18 : 16,
                          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
                          color: isTitle ? primaryColor : textColor, // ✅ Titres en couleur primaire, texte normal en couleur dynamique
                          height: 1.6,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}