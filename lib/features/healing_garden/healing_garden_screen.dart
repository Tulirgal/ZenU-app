import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_service.dart';
import '../../core/api/api_client.dart';
import '../../shared/widgets/module_background.dart';

// --- Task Model ---
class GardenTask {
  final String id;
  final String name;
  final bool completed;
  final DateTime createdAt;

  GardenTask({
    required this.id,
    required this.name,
    required this.completed,
    required this.createdAt,
  });

  factory GardenTask.fromJson(Map<String, dynamic> json) {
    return GardenTask(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  GardenTask copyWith({bool? completed}) {
    return GardenTask(
      id: id,
      name: name,
      completed: completed ?? this.completed,
      createdAt: createdAt,
    );
  }
}

// --- PRNG ---
int hashStr(String str) {
  int h = 0;
  for (int i = 0; i < str.length; i++) {
    h = ((31 * h) + str.codeUnitAt(i)) & 0xFFFFFFFF;
  }
  return h;
}

double Function() mulberry32(int seed) {
  int s = seed & 0xFFFFFFFF;
  return () {
    s = (s + 0x6d2b79f5) & 0xFFFFFFFF;
    int t = ((s ^ (s >> 15)) * (1 | s)) & 0xFFFFFFFF;
    t = (t + ((t ^ (t >> 7)) * (61 | t))) & 0xFFFFFFFF;
    int res = (t ^ (t >> 14)) & 0xFFFFFFFF;
    return res / 4294967296.0;
  };
}

class HealingGardenScreen extends StatefulWidget {
  const HealingGardenScreen({super.key});

  @override
  State<HealingGardenScreen> createState() => _HealingGardenScreenState();
}

class _HealingGardenScreenState extends State<HealingGardenScreen> with SingleTickerProviderStateMixin {
  late ApiClient _dio;
  final TextEditingController _taskController = TextEditingController();
  
  List<GardenTask> _tasks = [];
  bool _isLoading = true;
  bool _isAdding = false;
  DateTime? _startTime;
  
  late AnimationController _fireflyController;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _fireflyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _initApi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('healing_garden', 'opened');
    });
  }

  Future<void> _initApi() async {
    _dio = await ApiClient.getInstance();
    _loadTasks();
  }

  @override
  void dispose() {
    _fireflyController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final res = await _dio.get('/api/healing-garden/tasks');
      if (res.statusCode == 200) {
        final data = res.data;
        if (data['tasks'] != null) {
          final List<dynamic> list = data['tasks'];
          setState(() {
            _tasks = list.map((e) => GardenTask.fromJson(e)).toList();
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading garden tasks: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addTask() async {
    final name = _taskController.text.trim();
    if (name.isEmpty || _isAdding) return;

    setState(() => _isAdding = true);
    try {
      final res = await _dio.post('/api/healing-garden/tasks', data: {'name': name});
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data['task'] != null) {
          setState(() {
            _tasks.add(GardenTask.fromJson(data['task']));
            _taskController.clear();
          });
        }
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
    } finally {
      setState(() => _isAdding = false);
    }
  }

  Future<void> _completeTask(String id) async {
    // Optimistic update
    setState(() {
      final idx = _tasks.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _tasks[idx] = _tasks[idx].copyWith(completed: true);
      }
    });

    try {
      await _dio.patch('/api/healing-garden/tasks/$id/complete');
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      if (mounted) {
        context.read<AuthService>().trackEngagement('healing_garden', 'completed', durationSec: elapsed);
      }
    } catch (e) {
      debugPrint('Error completing task: $e');
      // Revert
      setState(() {
        final idx = _tasks.indexWhere((t) => t.id == id);
        if (idx != -1) {
          _tasks[idx] = _tasks[idx].copyWith(completed: false);
        }
      });
    }
  }

  Future<void> _deleteTask(String id) async {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    try {
      await _dio.delete('/api/healing-garden/tasks/$id');
    } catch (e) {
      debugPrint('Error deleting task: $e');
      _loadTasks(); // Reload on fail
    }
  }

  Future<void> _clearGarden() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF233240),
        title: Text('Clear entire garden?', style: GoogleFonts.inter(color: const Color(0xFFede4d3))),
        content: Text('This removes all seeds and trees. Are you sure?', style: GoogleFonts.inter(color: const Color(0xFFc7bca7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFc7bca7))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear', style: TextStyle(color: Color(0xFFc9705a))),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ids = _tasks.map((t) => t.id).toList();
    setState(() {
      _tasks.clear();
    });

    for (final id in ids) {
      try {
        await _dio.delete('/api/healing-garden/tasks/$id');
      } catch (e) {
        debugPrint('Error deleting task $id: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trees = _tasks.where((t) => t.completed).toList();
    final seeds = _tasks.where((t) => !t.completed).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1c2a38),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFede4d3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Healing Garden',
          style: GoogleFonts.inter(color: const Color(0xFFede4d3), fontSize: 16),
        ),
      ),
      body: ModuleBackground(
        moduleKey: 'healing-garden',
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Header
              Column(
                children: [
                  Text(
                    'a quiet place for finished work'.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: const Color(0xFFf2c14e),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Healing Garden',
                    style: GoogleFonts.lora(
                      fontSize: 36,
                      color: const Color(0xFFede4d3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plant a task when you start it. Mark it done, and watch it grow into a tree —\na living record of everything you have accomplished.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFFc7bca7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat(trees.length.toString(), 'Trees Grown'),
                  const SizedBox(width: 40),
                  _buildStat(seeds.length.toString(), 'Seeds Planted'),
                ],
              ),
              const SizedBox(height: 28),

              // Garden Scene
              Container(
                height: 300,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                    colors: [
                      Color(0xFF1c2a38),
                      Color(0xFF3a4a5a),
                      Color(0xFFc98a4b),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 50,
                      offset: const Offset(0, 20),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: math.max(MediaQuery.of(context).size.width - 40, 760),
                    height: 300,
                    child: AnimatedBuilder(
                      animation: _fireflyController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _GardenPainter(
                            tasks: _tasks,
                            animationValue: _fireflyController.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add Task Form
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      style: GoogleFonts.inter(color: const Color(0xFFede4d3), fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Name something you want to accomplish... e.g. 'Submit assignment'",
                        hintStyle: GoogleFonts.inter(color: const Color(0xFFc7bca7).withValues(alpha: 0.6), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFF233240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color(0xFFede4d3).withValues(alpha: 0.12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color(0xFFede4d3).withValues(alpha: 0.12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFf2c14e), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => _addTask(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isAdding || _taskController.text.trim().isEmpty ? null : _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf2c14e),
                      foregroundColor: const Color(0xFF2b2115),
                      disabledBackgroundColor: const Color(0xFFf2c14e).withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _isAdding ? '...' : 'Plant seed 🌱',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lists Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInProgressPanel(seeds)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildGrownPanel(trees)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildInProgressPanel(seeds),
                      const SizedBox(height: 16),
                      _buildGrownPanel(trees),
                    ],
                  );
                },
              ),
              
              if (_tasks.isNotEmpty) ...[
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _clearGarden,
                  child: Text(
                    'Clear entire garden',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFc7bca7),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.lora(
            fontSize: 30,
            color: const Color(0xFFf2c14e),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 2,
            color: const Color(0xFFc7bca7),
          ),
        ),
      ],
    );
  }

  Widget _buildInProgressPanel(List<GardenTask> seeds) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF233240),
        border: Border.all(color: const Color(0xFFede4d3).withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🌱 In Progress',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFede4d3)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFede4d3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  seeds.length.toString(),
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFc7bca7)),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            Text('Loading your garden...', style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFFc7bca7)))
          else if (seeds.isEmpty)
            Text('Nothing planted yet — add a task above.', style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFFc7bca7)))
          else
            ...seeds.map((t) => _buildSeedItem(t)),
        ],
      ),
    );
  }

  Widget _buildGrownPanel(List<GardenTask> trees) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF233240),
        border: Border.all(color: const Color(0xFFede4d3).withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🌲 Grown',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFede4d3)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFede4d3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  trees.length.toString(),
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFc7bca7)),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          if (trees.isEmpty)
            Text('No trees yet — finish something to grow one.', style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFFc7bca7)))
          else
            ...trees.map((t) => _buildTreeItem(t)),
        ],
      ),
    );
  }

  Widget _buildSeedItem(GardenTask task) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFede4d3).withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.name,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFede4d3)),
            ),
          ),
          OutlinedButton(
            onPressed: () => _completeTask(task.id),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFa4c3a2),
              side: const BorderSide(color: Color(0xFF588157)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Mark done ✔', style: GoogleFonts.inter(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => _deleteTask(task.id),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFc9705a),
              side: const BorderSide(color: Color(0xFFc9705a)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('✖', style: GoogleFonts.inter(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeItem(GardenTask task) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFede4d3).withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFFc7bca7),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => _deleteTask(task.id),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFc7bca7),
              side: BorderSide(color: const Color(0xFFede4d3).withValues(alpha: 0.2)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('✖', style: GoogleFonts.inter(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// --- Custom Painter for Garden ---
class _GardenPainter extends CustomPainter {
  final List<GardenTask> tasks;
  final double animationValue;
  final List<Color> _leafColors = const [
    Color(0xFF6b9080),
    Color(0xFFa4c3a2),
    Color(0xFF588157),
    Color(0xFF3a5a40),
  ];

  _GardenPainter({required this.tasks, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate system based on W=900, H=340
    final double H = 340;
    final double groundY = 300;
    
    // Scale to fit or scroll. We assume the Canvas size is width >= 760, height = 300
    // Actually the viewBox was 0 0 900 340 with preserveAspectRatio="xMidYMax slice"
    // Let's just scale everything based on height to keep aspect ratio.
    final double scale = size.height / H;
    
    canvas.save();
    canvas.scale(scale, scale);

    // 1. Draw Hills
    final Paint hillPaint1 = Paint()..color = const Color(0xFF3f5a49)..style = PaintingStyle.fill;
    final Path hillPath1 = Path()
      ..moveTo(0, groundY - 30)
      ..quadraticBezierTo(150, groundY - 70, 300, groundY - 35)
      ..quadraticBezierTo(600 - (300 - 150), groundY - 35 + (groundY - 35 - (groundY - 70)), 600, groundY - 40) // T command approximation
      ..quadraticBezierTo(900 - (600 - 450), groundY - 40 + (groundY - 40 - (groundY - 35)), 900, groundY - 20) // T
      ..lineTo(900, H)
      ..lineTo(0, H)
      ..close();
    canvas.drawPath(hillPath1, hillPaint1);

    final Paint hillPaint2 = Paint()..color = const Color(0xFF2c4536)..style = PaintingStyle.fill;
    final Path hillPath2 = Path()
      ..moveTo(0, groundY)
      ..quadraticBezierTo(200, groundY - 25, 450, groundY - 5)
      ..quadraticBezierTo(900 - (450 - 200), groundY - 5 + (groundY - 5 - (groundY - 25)), 900, groundY - 15) // T
      ..lineTo(900, H)
      ..lineTo(0, H)
      ..close();
    canvas.drawPath(hillPath2, hillPaint2);

    // 2. Draw Fireflies
    final Paint fireflyPaint = Paint()
      ..color = const Color(0xFFf2c14e)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    
    for (int i = 0; i < 12; i++) {
      final double width = 2.0 + (i % 3);
      final double leftPercent = 5.0 + (i * 8);
      final double topPercent = 30.0 + (i % 4) * 15;
      
      final double bx = (leftPercent / 100.0) * size.width / scale;
      final double by = (topPercent / 100.0) * H;
      
      // Animate y and opacity. Duration varies per firefly: 4 + i seconds.
      // animationValue goes from 0.0 to 1.0 over 12 seconds.
      final double dur = (4 + i).toDouble();
      final double localTime = (animationValue * 12.0) % dur;
      final double progress = localTime / dur; // 0.0 -> 1.0
      
      // y: [0, -14, 0]
      final double yOffset = math.sin(progress * math.pi * 2) * -14.0;
      
      // opacity: [0.4, 1.0, 0.4]
      final double opacity = 0.4 + (math.sin(progress * math.pi * 2) + 1) / 2 * 0.6;
      
      fireflyPaint.color = const Color(0xFFf2c14e).withValues(alpha: opacity);
      
      canvas.drawCircle(Offset(bx, by + yOffset), width, fireflyPaint);
    }

    // 3. Draw Garden Items
    final items = tasks.take(40).toList();
    final int n = math.max(items.length, 1);
    final double realW = size.width / scale;
    final double availableWidth = realW - 120;
    final double maxSpacing = 85;
    final double spacing = math.min(availableWidth / n, maxSpacing);
    final double totalWidth = spacing * n;
    final double startX = (realW - totalWidth) / 2;

    for (int i = 0; i < items.length; i++) {
      final task = items[i];
      final double x = startX + (i + 0.5) * spacing;
      final rng = mulberry32(hashStr(task.id));
      
      canvas.save();
      canvas.translate(x, groundY);
      
      if (task.completed) {
        final treeScale = 0.85 + rng() * 0.5;
        _drawTree(canvas, rng, treeScale);
      } else {
        _drawSeed(canvas, rng);
      }
      
      canvas.restore();
    }

    canvas.restore();
  }

  void _drawSeed(Canvas canvas, double Function() rng) {
    final double jitter = (rng() - 0.5) * 6;
    canvas.translate(jitter, 0);

    final Paint seedPaint1 = Paint()..color = const Color(0xFF4a3728).withValues(alpha: 0.85);
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, -2), width: 10, height: 6), seedPaint1);

    final Paint seedPaint2 = Paint()..color = const Color(0xFF588157);
    canvas.drawCircle(const Offset(0, -5), 2.4, seedPaint2);
  }

  void _drawTree(Canvas canvas, double Function() rng, double treeScale) {
    final double trunkH = (60 + rng() * 40) * treeScale;
    final double trunkW = (6 + rng() * 4) * treeScale;
    final double lean = (rng() - 0.5) * 10;

    // Trunk
    final Paint trunkPaint = Paint()
      ..color = const Color(0xFF4a3728)
      ..style = PaintingStyle.fill;
    final Paint trunkStroke = Paint()
      ..color = const Color(0xFF33261b)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final Path trunkPath = Path()
      ..moveTo(-trunkW / 2, 0)
      ..cubicTo(-trunkW / 2 + lean * 0.3, -trunkH * 0.5, lean * 0.6, -trunkH * 0.6, lean, -trunkH)
      ..lineTo(lean + trunkW * 0.6, -trunkH)
      ..cubicTo(lean * 0.6 + trunkW, -trunkH * 0.6, trunkW / 2 + lean * 0.3, -trunkH * 0.5, trunkW / 2, 0)
      ..close();

    canvas.drawPath(trunkPath, trunkPaint);
    canvas.drawPath(trunkPath, trunkStroke);

    // Branches
    final Paint branchStroke = Paint()
      ..color = const Color(0xFF4a3728)
      ..strokeWidth = 2.5 * treeScale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final int branchCount = 2 + (rng() * 3).floor();
    for (int b = 0; b < branchCount; b++) {
      final double t = 0.35 + rng() * 0.5;
      final double by = -trunkH * t;
      final double bx = lean * t;
      final int dir = b % 2 == 0 ? -1 : 1;
      final double len = (18 + rng() * 16) * treeScale;
      final double angle = (dir * (30 + rng() * 25) * math.pi) / 180;
      final double ex = bx + math.sin(angle) * len;
      final double ey = by - math.cos(angle) * len;

      final Path branchPath = Path()
        ..moveTo(bx, by)
        ..quadraticBezierTo((bx + ex) / 2 + dir * 8, (by + ey) / 2, ex, ey);
      canvas.drawPath(branchPath, branchStroke);
    }

    // Leaves Canopy
    final int clusterCount = 5 + (rng() * 5).floor();
    final double canopyCx = lean;
    final double canopyCy = -trunkH - 6 * treeScale;
    final double canopyR = (26 + rng() * 14) * treeScale;

    final Paint leafPaint = Paint()..style = PaintingStyle.fill;
    
    for (int c = 0; c < clusterCount; c++) {
      final double ang = rng() * math.pi * 2;
      final double rad = rng() * canopyR * 0.85;
      final double cx = canopyCx + math.cos(ang) * rad;
      final double cy = canopyCy + math.sin(ang) * rad * 0.7;
      final double r = (10 + rng() * 10) * treeScale;
      final Color color = _leafColors[(rng() * _leafColors.length).floor()];
      
      leafPaint.color = color.withValues(alpha: 0.92);
      canvas.drawCircle(Offset(cx, cy), r, leafPaint);
    }

    // Gold Flecks
    if (rng() > 0.4) {
      final int flecks = 2 + (rng() * 3).floor();
      final Paint fleckPaint = Paint()
        ..color = const Color(0xFFf2c14e).withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;

      for (int f = 0; f < flecks; f++) {
        final double ang = rng() * math.pi * 2;
        final double rad = rng() * canopyR * 0.7;
        final double cx = canopyCx + math.cos(ang) * rad;
        final double cy = canopyCy + math.sin(ang) * rad * 0.7;
        
        canvas.drawCircle(Offset(cx, cy), 1.6 * treeScale, fleckPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GardenPainter oldDelegate) {
    return true; // Always repaint for fireflies
  }
}
