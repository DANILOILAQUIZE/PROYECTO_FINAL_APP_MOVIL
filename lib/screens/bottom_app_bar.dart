import 'package:flutter/material.dart';

class BottomFooter extends StatelessWidget {
  final VoidCallback? onHomeTap;
  const BottomFooter({super.key, this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x552196F3),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 34, color: Colors.white),
            onPressed: onHomeTap ?? () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            tooltip: 'Inicio',
          ),
        ],
      ),
    );
  }
}