import 'package:flutter/material.dart';
import 'hijo/hijo_home.dart';
import 'padre/padre_home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A5276),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 80, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'VigilIA',
                style: TextStyle(
                  fontSize: 48, fontWeight: FontWeight.bold,
                  color: Colors.white, letterSpacing: 2,
                ),
              ),
              const Text(
                'Monitoreo familiar inteligente',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 60),
              // Botón Padre
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A5276),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  icon: const Icon(Icons.person, size: 28),
                  label: const Text('Entrar como Padre',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PadreHome()),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botón Hijo
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  icon: const Icon(Icons.child_care, size: 28),
                  label: const Text('Entrar como Hijo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HijoHome()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}