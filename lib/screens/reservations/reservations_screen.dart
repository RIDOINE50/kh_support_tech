import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  int _selectedDay = 15;
  int _selectedMonth = 6; // Juin
  int _selectedYear = 2025;

  final List<Map<String, dynamic>> _reservations = [
    {
      'title': 'Initiation informatique',
      'date': '15 Juin 2025',
      'time': '09:00 - 12:00',
      'status': 'Confirmé',
      'statusColor': const Color(0xFF22C55E),
      'icon': Icons.computer,
      'iconColor': AppColors.primary,
    },
    {
      'title': 'Formation Intelligence Artificielle',
      'date': '18 Juin 2025',
      'time': '14:00 - 17:00',
      'status': 'En attente',
      'statusColor': const Color(0xFFF59E0B),
      'icon': Icons.psychology,
      'iconColor': AppColors.secondary,
    },
    {
      'title': 'Maintenance PC à domicile',
      'date': '20 Juin 2025',
      'time': '10:00 - 11:30',
      'status': 'Confirmé',
      'statusColor': const Color(0xFF22C55E),
      'icon': Icons.build,
      'iconColor': AppColors.success,
    },
    {
      'title': 'Pilotage de Drone',
      'date': '25 Juin 2025',
      'time': '08:00 - 12:00',
      'status': 'En attente',
      'statusColor': const Color(0xFFF59E0B),
      'icon': Icons.flight,
      'iconColor': AppColors.warning,
    },
  ];

  final List<String> _weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  final List<int> _weekDates = [9, 10, 11, 12, 13, 14, 15];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Réservations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // CALENDRIER HORIZONTAL
            _buildCalendar(),

            const SizedBox(height: 20),

            // TITRE SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mes réservations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${_reservations.length} prévues',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // LISTE DES RÉSERVATIONS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  return _buildReservationCard(_reservations[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CALENDRIER HORIZONTAL
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mois et navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: AppColors.textSecondary, size: 24),
              const Text(
                'Juin 2025',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 24),
            ],
          ),
          const SizedBox(height: 16),

          // Jours de la semaine
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((day) {
              return SizedBox(
                width: 36,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDates.map((date) {
              final isSelected = date == _selectedDay;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = date;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // CARTE DE RÉSERVATION
  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (reservation['iconColor'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              reservation['icon'] as IconData,
              color: reservation['iconColor'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  reservation['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Date et heure
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      reservation['date'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      reservation['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Statut
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (reservation['statusColor'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    reservation['status'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: reservation['statusColor'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Flèche
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}