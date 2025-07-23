import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'drawer.dart';
import 'app_bar.dart';
import 'bottom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: "Gestión Académica"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuCard(
              icon: Icons.calendar_today,
              title: 'Periodos Académicos',
              subtitle: 'Gestión de Periodos Académicos',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.pushNamed(context, '/gestionPeriodosAcademicos');
              },
            ),

            // Calendario integrado
            const SizedBox(height: 20),
            _buildCalendarSection(context),
          ],
        ),
      ),
      bottomNavigationBar: const BottomFooter(),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.9),
              Colors.blue.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(Icons.event, size: 38, color: Colors.blue),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calendario Académico',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Selecciona un día para ver/agregar notificaciones',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  setState(() {
                    _selectedDate = date;
                  });
                  
                  // Navegar a la lista de notificaciones para la fecha seleccionada
                  Navigator.pushNamed(
                    context,
                    '/gestionNotificaciones',
                    arguments: {
                      'selectedDate': date,
                      'showOnlyDate': true,
                    },
                  );
                },
                weekendTextStyle: TextStyle(color: Colors.red),
                thisMonthDayBorderColor: Colors.grey,
                weekFormat: false,
                height: 420.0,
                selectedDateTime: _selectedDate,
                daysHaveCircularBorder: true,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                markedDateCustomShapeBorder: CircleBorder(
                  side: BorderSide(color: Colors.blue, width: 2),
                ),
                markedDateCustomTextStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                selectedDayButtonColor: Colors.blue,
                selectedDayTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayButtonColor: Colors.blue.withOpacity(0.3),
                todayTextStyle: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                headerTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconColor: Colors.blue,
                locale: 'es_ES',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Icon(icon, size: 38, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
