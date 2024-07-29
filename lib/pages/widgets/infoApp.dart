import 'package:flutter/material.dart';

class InfoApp extends StatefulWidget {
  const InfoApp({super.key});

  @override
  State<InfoApp> createState() => _InfoAppState();
}

class _InfoAppState extends State<InfoApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Comment utiliser l'application Domestik",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Découvrez les fonctionnalités de l'application grâce à ces informations.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            // HomePage
            const InfoSection(
              title: 'Page d\'accueil',
              icon: Icons.home,
              content: [
                "Consultez toutes vos tâches à venir, qu'elles soient à faire immédiatement ou à une date ultérieure.",
                "Marquez vos tâches comme 'Confirmées' une fois terminées pour que d'autres utilisateurs puissent les valider.",
              ],
              page: "Home"
            ),

            // Validation
            const InfoSection(
              title: 'Validation',
              icon: Icons.access_time_outlined,
              content: [
                "Chaque utilisateur peut confirmer si une tâche a été réalisée avec succès.",
              ],
              page: "Validation"
            ),

            // Page d'ajout
            const InfoSection(
              title: 'Page d\'ajout',
              icon: Icons.add,
              content: [
                "Affiche la liste des utilisateurs du foyer, distinguant ceux désactivés par une bordure colorée sur la droite. Seul l'administrateur peut gérer les rôles des utilisateurs (comme les rendre administrateurs), les désactiver (pour ceux absents du foyer), ou les supprimer.",
                "Cette page propose également la gestion des tâches, avec la possibilité pour l'administrateur de supprimer des tâches spécifiques."
              ],
              page: "Ajout"
            ),
            //Add Page

            // Paramètres
            const InfoSection(
              title: 'Paramètres',
              icon: Icons.settings,
              content: [
                "Modifiez votre profil, gérez les notifications et choisissez entre le mode sombre ou clair.",
              ],
              page: "Paramètre"
            ),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> content;
  final String page;


  const InfoSection({super.key, 
    required this.title,
    required this.icon,
    required this.content,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content
                .map((item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ))
                .toList(),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: const Color(0xff8463BE),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              Text(
                page,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
