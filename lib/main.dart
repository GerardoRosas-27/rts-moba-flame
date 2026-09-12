import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/assets.dart';
import 'game/battle/battle_game.dart';
import 'game/enums.dart';
import 'game/rts_game.dart';
import 'ui/battle_hud.dart';
import 'ui/hud.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const RtsApp());
}

class RtsApp extends StatelessWidget {
  const RtsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTS Moba Flame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF00AEEF),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

enum _Scene { city, battle }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RtsGame _city;
  BattleGame? _battle;
  _Scene _scene = _Scene.city;
  int _session = 0;

  Map<UnitKind, int> _deployed = {};

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    GameAssets.instance.resetProgress();
    _city = RtsGame(onRequestBattle: _enterBattle);
    _battle = null;
    _scene = _Scene.city;
    _deployed = {};
    _session++;
  }

  void _retry() {
    setState(_startNewGame);
  }

  void _enterBattle() {
    if (_scene == _Scene.battle) return;
    final prep = _city.prepareBattleDetachment();
    if (prep == null) return;
    _deployed = Map.of(prep.counts);
    final battle = BattleGame(
      detachment: prep,
      onFinished: _onBattleFinished,
    );
    setState(() {
      _battle = battle;
      _scene = _Scene.battle;
    });
  }

  void _onBattleFinished(BattleResult result) {
    if (!mounted) return;
    _city.applyBattleResult(
      deployed: _deployed,
      survivors: result.survivors,
      outcome: result.outcome,
    );
    _deployed = {};
    setState(() {
      _battle = null;
      _scene = _Scene.city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Offstage(
            offstage: _scene != _Scene.city,
            child: TickerMode(
              enabled: _scene == _Scene.city,
              child: GameWidget<RtsGame>(
                key: ValueKey(_session),
                game: _city,
                overlayBuilderMap: {
                  'hud': (context, game) => RtsHud(game: game),
                },
                loadingBuilder: (context) => const _LoadingSplash(),
                errorBuilder: (context, error) => _LoadErrorScreen(
                  error: error,
                  onRetry: _retry,
                ),
              ),
            ),
          ),
          if (_scene == _Scene.battle && _battle != null)
            BattleDragLayer(
              game: _battle!,
              child: GameWidget<BattleGame>(
                game: _battle!,
                overlayBuilderMap: {
                  'battleHud': (context, game) => BattleHud(game: game),
                },
                loadingBuilder: (context) => const ColoredBox(
                  color: Color(0xFF120E18),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF00AEEF)),
                  ),
                ),
                errorBuilder: (context, error) => _LoadErrorScreen(
                  error: error,
                  onRetry: () {
                    setState(() {
                      _battle = null;
                      _scene = _Scene.city;
                    });
                    _city.showToast('Error en batalla — de vuelta a la base');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LoadingSplash extends StatelessWidget {
  const _LoadingSplash();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0B0E14),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ValueListenableBuilder<double>(
              valueListenable: GameAssets.instance.loadProgress,
              builder: (context, progress, _) {
                return ValueListenableBuilder<String>(
                  valueListenable: GameAssets.instance.loadLabel,
                  builder: (context, label, _) {
                    final pct = (progress * 100).clamp(0, 100).round();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sports_esports,
                          size: 56,
                          color: Color(0xFF00AEEF),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'RTS Moba Flame',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          label.isEmpty ? 'Cargando…' : label,
                          style: const TextStyle(
                            color: Color(0xFFB0B8C4),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress <= 0 ? null : progress,
                            minHeight: 10,
                            backgroundColor: const Color(0xFF1A2030),
                            color: const Color(0xFF00AEEF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$pct%',
                          style: const TextStyle(
                            color: Color(0xFF7A8494),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadErrorScreen extends StatelessWidget {
  const _LoadErrorScreen({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0B0E14),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 56, color: Color(0xFFFF6B6B)),
                const SizedBox(height: 16),
                const Text(
                  'Error al cargar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB0B8C4),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00AEEF),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
