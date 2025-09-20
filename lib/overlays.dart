import 'package:flutter/material.dart';
import 'package:super_fly/game.dart';

class ScoreEntry{
  final String name;
  final int score;
  final DateTime dt;
  ScoreEntry(this.name, this.score, this.dt);

}

class ScoreService {
  static String playerName = 'Player';
  static final List<ScoreEntry> _local = [];

  static Future<List<ScoreEntry>> top5() async{
    _local.sort((a,b) => b.score.compareTo(a.score));
    return _local.take(5).toList();
  }

  static Future<void> saveIfTop(String name, int score) async{
    _local.add(ScoreEntry(name, score, DateTime.now()));
  }
}

class HUD extends StatelessWidget {
  static const id = 'HUD';
  final FlyRun game;
  const HUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 8),
          ValueListenableBuilder<int>(
            valueListenable: game.scoreVN,
            builder: (_, v, __) => Text(
              'Score: $v',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: game.pauseGame,
            icon: const Icon(Icons.pause),
            tooltip: 'Pause',
          ),
        ],
      ),
    );
  }
}

class PauseMenu extends StatelessWidget {
  static const id = 'PauseMenu';
  final FlyRun game;
  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Paused', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: game.resumeGame, child: const Text('Resume')),
            ElevatedButton(onPressed: game.goToMenu,   child: const Text('Main Menu')),
          ]),
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  static const id = 'MainMenu';
  final FlyRun game;
  const MainMenu({super.key, required this.game});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final _name = TextEditingController(text: ScoreService.playerName);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('FlyRun', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Your name')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final n = _name.text.trim();
                ScoreService.playerName = n.isEmpty ? 'Player' : n;
                widget.game.startRun();
              },
              child: const Text('Play'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                widget.game.pauseEngine();              
                widget.game.overlays.add(HighScores.id);
              },
              child: const Text('High Scores'),
            ),
          ]),
        ),
      ),
    );
  }
}

class HighScores extends StatelessWidget {
  static const id = 'HighScores';
  final FlyRun game;
  const HighScores({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Top 5', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder<List<ScoreEntry>>(
              future: ScoreService.top5(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                final list = snap.data!;
                if (list.isEmpty) return const Text('No scores yet.');
                return Column(
                  children: list.map((e) => ListTile(
                    dense: true,
                    title: Text(e.name),
                    trailing: Text(e.score.toString()),
                    subtitle: Text(e.dt.toString()),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove(HighScores.id);
                game.overlays.add(MainMenu.id);
              },
              child: const Text('Back'),
            ),
          ]),
        ),
      ),
    );
  }
}