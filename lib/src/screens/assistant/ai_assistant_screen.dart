// lib/src/screens/assistant/ai_assistant_screen.dart
import 'package:flutter/material.dart';

class AIAssistantScreen extends StatelessWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: 'ai-assistant-title',
          child: Material(
            color: Colors.transparent,
            child: Text('AI Assistant'),
          ),
        ),
      ),
      body: Column(
        children: [
          const _TipStrip(),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              children: const [
                _BotBubble(
                  text:
                  'Hai! Aku bisa bantu meringkas aktivitas anak, saran tugas, dan rencana uang saku. Mau coba?',
                ),
                _UserBubble(text: 'Boleh. Rekomendasi tugas mingguan untuk anak kelas 5 dong.'),
                _BotBubble(
                  text:
                  'Saran minggu ini:\n• 3× bereskan kamar (Rp 5.000)\n• 2× cuci piring (Rp 3.000)\n• 1× bantu belanja (Rp 7.000)\nTotal potensi: Rp 28.000',
                ),
                _UserBubble(text: 'Mantap. Bisa dibuat jadwal otomatis?'),
                _BotBubble(
                  text:
                  'Ini demo statis dulu. Nanti tombol “Generate Jadwal” akan mengisi daftar tugas anak secara otomatis ✨',
                ),
              ],
            ),
          ),
          const _InputStub(),
        ],
      ),
    );
  }
}

class _TipStrip extends StatelessWidget {
  const _TipStrip();

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Ringkas pengeluaran minggu ini',
      'Buat misi hemat harian',
      'Rencana uang saku bulanan',
      'Ide tugas berbasis usia',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tips
            .map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(t, style: const TextStyle(fontSize: 12.5)),
        ))
            .toList(),
      ),
    );
  }
}

class _InputStub extends StatelessWidget {
  const _InputStub();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan (coming soon)…',
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
                  ),
                  prefixIcon: const Icon(Icons.smart_toy_outlined),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: null, // disabled for static demo
              icon: const Icon(Icons.send),
              label: const Text('Kirim'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotBubble extends StatelessWidget {
  final String text;
  const _BotBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 48, bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEAFF),
          border: Border.all(color: const Color(0xFFB9A7FF).withOpacity(0.6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14.5)),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 48, bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF7FF),
          border: Border.all(color: const Color(0xFF9DD1FF).withOpacity(0.7)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14.5)),
      ),
    );
  }
}
