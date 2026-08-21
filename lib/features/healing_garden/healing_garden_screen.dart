import 'dart:math' as math; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 

 
class Task { 
  final String id; 
  final String name; 
  final bool completed; 
 
  Task({required this.id, required this.name, required this.completed}); 
} 
 
class HealingGardenScreen extends StatefulWidget { 
  const HealingGardenScreen({super.key}); 
 
  @override 
  State<HealingGardenScreen> createState() => _HealingGardenScreenState(); 
} 
 
class _HealingGardenScreenState extends State<HealingGardenScreen> with TickerProviderStateMixin { 
  final List<Task> _tasks = []; 
  final TextEditingController _inputCtrl = TextEditingController(); 
  bool _adding = false; 
  String? _newTreeId; 
 
  late AnimationController _fireflyCtrl; 
 
  @override 
  void initState() { 
    super.initState(); 
    _fireflyCtrl = AnimationController( 
      vsync: this, 
      duration: const Duration(seconds: 4), 
    )..repeat(); 
 
    // Add some sample data for visual parity since we don't have a real backend 
    _tasks.addAll([ 
      Task(id: 'task-1', name: 'Submit assignment', completed: true), 
      Task(id: 'task-2', name: 'Read a book', completed: false), 
      Task(id: 'task-3', name: 'Drink water', completed: true), 
    ]); 
  } 
 
  @override 
  void dispose() { 
    _inputCtrl.dispose(); 
    _fireflyCtrl.dispose(); 
    super.dispose(); 
  } 
 
  void _handleAdd(String val) { 
    if (val.trim().isEmpty || _adding) return; 
    setState(() { 
      _adding = true;
      _tasks.add(Task( 
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        name: val.trim(), 
        completed: false, 
      )); 
      _adding = false;
    }); 
    _inputCtrl.clear(); 
  } 
 
  void _handleComplete(String id) { 
    setState(() { 
      final index = _tasks.indexWhere((t) => t.id == id); 
      if (index != -1) { 
        _tasks[index] = Task( 
          id: _tasks[index].id, 
          name: _tasks[index].name, 
          completed: true, 
        ); 
        _newTreeId = id; 
      } 
    }); 
    Future.delayed(const Duration(seconds: 2), () { 
      if (mounted) { 
        setState(() => _newTreeId = null); 
      } 
    }); 
  } 
 
  void _handleDelete(String id) { 
    setState(() { 
      _tasks.removeWhere((t) => t.id == id); 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final trees = _tasks.where((t) => t.completed).toList(); 
    final seeds = _tasks.where((t) => !t.completed).toList(); 
 
    return Scaffold( 
      backgroundColor: const Color(0xFF1c2a38), 
      body: SafeArea( 
        child: SingleChildScrollView( 
          child: Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40), 
            child: Column( 
              children: [ 
                // Back Link 
                Align( 
                  alignment: Alignment.centerLeft, 
                  child: Padding( 
                    padding: const EdgeInsets.only(bottom: 32), 
                    child: IconButton( 
                      onPressed: () => context.pop(), 
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFede4d3)), 
                    ), 
                  ), 
                ), 
 
                // Header 
                Text( 
                  'A QUIET PLACE FOR FINISHED WORK', 
                  style: GoogleFonts.inter( 
                    fontSize: 12, 
                    letterSpacing: 2, 
                    fontWeight: FontWeight.w600, 
                    color: const Color(0xFFf2c14e), 
                  ), 
                ), 
                const SizedBox(height: 8), 
                Text( 
                  'The Healing Garden', 
                  style: GoogleFonts.lora( 
                    fontSize: 36, 
                    fontWeight: FontWeight.w400, 
                    color: const Color(0xFFede4d3), 
                  ), 
                ), 
                const SizedBox(height: 8), 
                Padding( 
                  padding: const EdgeInsets.symmetric(horizontal: 16), 
                  child: Text( 
                    'Plant a task when you start it. Mark it done, and watch it grow into a tree — a living record of everything you have accomplished.', 
                    textAlign: TextAlign.center, 
                    style: GoogleFonts.inter( 
                      fontSize: 14, 
                      height: 1.6, 
                      color: const Color(0xFFc7bca7), 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 28), 
 
                // Stats 
                Row( 
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [ 
                    Column( 
                      children: [ 
                        Text( 
                          '${trees.length}', 
                          style: GoogleFonts.lora( 
                            fontSize: 30, 
                            color: const Color(0xFFf2c14e), 
                          ), 
                        ), 
                        Text( 
                          'TREES GROWN', 
                          style: GoogleFonts.inter( 
                            fontSize: 12, 
                            letterSpacing: 2, 
                            color: const Color(0xFFc7bca7), 
                          ), 
                        ), 
                      ], 
                    ), 
                    const SizedBox(width: 40), 
                    Column( 
                      children: [ 
                        Text( 
                          '${seeds.length}', 
                          style: GoogleFonts.lora( 
                            fontSize: 30, 
                            color: const Color(0xFFf2c14e), 
                          ), 
                        ), 
                        Text( 
                          'SEEDS PLANTED', 
                          style: GoogleFonts.inter( 
                            fontSize: 12, 
                            letterSpacing: 2, 
                            color: const Color(0xFFc7bca7), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ], 
                ), 
                const SizedBox(height: 28), 
 
                // Garden Scene 
                Container( 
                  width: double.infinity, 
                  height: 300, 
                  decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(16), 
                    gradient: const LinearGradient( 
                      begin: Alignment.topCenter, 
                      end: Alignment.bottomCenter, 
                      colors: [ 
                        Color(0xFF1c2a38), 
                        Color(0xFF3a4a5a), // 55% approx 
                        Color(0xFFc98a4b), 
                      ], 
                      stops: [0.0, 0.55, 1.0], 
                    ), 
                    boxShadow: [ 
                      BoxShadow( 
                        color: Colors.black.withValues(alpha: 0.6), 
                        blurRadius: 50, 
                        offset: const Offset(0, 20), 
                        spreadRadius: -20, 
                      ) 
                    ], 
                  ), 
                  child: ClipRRect( 
                    borderRadius: BorderRadius.circular(16), 
                    child: Stack( 
                      children: [ 
                        Positioned.fill( 
                          child: SingleChildScrollView( 
                            scrollDirection: Axis.horizontal, 
                            child: SizedBox( 
                              width: math.max(900, MediaQuery.of(context).size.width), 
                              child: CustomPaint( 
                                painter: _GardenScenePainter( 
                                  tasks: _tasks, 
                                ), 
                              ), 
                            ), 
                          ), 
                        ), 
                        // Fireflies 
                        ...List.generate(5, (i) { 
                          return AnimatedBuilder( 
                            animation: _fireflyCtrl, 
                            builder: (context, child) { 
                              // Use sine to animate Y up and down, and opacity 
                              final phase = (_fireflyCtrl.value * 2 * math.pi) + (i * 0.8); 
                              final yOffset = math.sin(phase) * 7 - 7; // [0, -14] range 
                              final opacity = 0.4 + (math.sin(phase * 1.5) + 1) / 2 * 0.6; // [0.4, 1.0] 
 
                              return Positioned( 
                                left: MediaQuery.of(context).size.width * (0.15 + i * 0.17), 
                                top: 300 * (0.20 + (i % 3) * 0.15) + yOffset, 
                                child: Container( 
                                  width: 4, 
                                  height: 4, 
                                  decoration: BoxDecoration( 
                                    color: const Color(0xFFf2c14e).withValues(alpha: opacity), 
                                    shape: BoxShape.circle, 
                                    boxShadow: [ 
                                      BoxShadow( 
                                        color: const Color(0xFFf2c14e).withValues(alpha: opacity), 
                                        blurRadius: 8, 
                                        spreadRadius: 2, 
                                      ) 
                                    ], 
                                  ), 
                                ), 
                              ); 
                            }, 
                          ); 
                        }), 
 
                        if (_newTreeId != null) 
                          Positioned.fill( 
                            child: Center( 
                              child: TweenAnimationBuilder<double>( 
                                tween: Tween(begin: 0.0, end: 1.0), 
                                duration: const Duration(milliseconds: 400), 
                                curve: Curves.easeOutBack, 
                                builder: (context, val, child) { 
                                  return Opacity( 
                                    opacity: val.clamp(0.0, 1.0), 
                                    child: Transform.scale( 
                                      scale: 0.8 + (val * 0.2), 
                                      child: Column( 
                                        mainAxisSize: MainAxisSize.min, 
                                        children: [ 
                                          const Text( 
                                            '🌱', 
                                            style: TextStyle(fontSize: 48), 
                                          ), 
                                          Text( 
                                            'A new tree grew!', 
                                            style: GoogleFonts.inter( 
                                              fontSize: 14, 
                                              fontWeight: FontWeight.w600, 
                                              color: const Color(0xFFf2c14e), 
                                            ), 
                                          ), 
                                        ], 
                                      ), 
                                    ), 
                                  ); 
                                }, 
                              ), 
                            ), 
                          ), 
                         
                        if (_tasks.isEmpty) 
                          Positioned( 
                            bottom: 16, 
                            left: 0, 
                            right: 0, 
                            child: Text( 
                              'Plant your first task below to begin your garden.', 
                              textAlign: TextAlign.center, 
                              style: GoogleFonts.inter( 
                                fontSize: 12, 
                                fontStyle: FontStyle.italic, 
                                color: const Color(0xFFc7bca7), 
                              ), 
                            ), 
                          ), 
                      ], 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 24), 
 
                // Input Form 
                Row( 
                  children: [ 
                    Expanded( 
                      child: Container( 
                        decoration: BoxDecoration( 
                          color: const Color(0xFF233240), 
                          border: Border.all(color: const Color(0xFFede4d3).withValues(alpha: 0.12)), 
                          borderRadius: BorderRadius.circular(12), 
                        ), 
                        child: TextField( 
                          controller: _inputCtrl, 
                          style: GoogleFonts.inter( 
                            fontSize: 14, 
                            color: const Color(0xFFede4d3), 
                          ), 
                          decoration: InputDecoration( 
                            hintText: "Name something you want to accomplish... e.g. 'Submit assignment'", 
                            hintStyle: GoogleFonts.inter( 
                              fontSize: 14, 
                              color: const Color(0xFFede4d3).withValues(alpha: 0.5), 
                            ), 
                            border: InputBorder.none, 
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 
                          ), 
                          onSubmitted: _handleAdd, 
                        ), 
                      ), 
                    ), 
                    const SizedBox(width: 8), 
                    ElevatedButton( 
                      onPressed: _adding ? null : () => _handleAdd(_inputCtrl.text), 
                      style: ElevatedButton.styleFrom( 
                        backgroundColor: const Color(0xFFf2c14e), 
                        foregroundColor: const Color(0xFF2b2115), 
                        disabledBackgroundColor: const Color(0xFFf2c14e).withValues(alpha: 0.4), 
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(12), 
                        ), 
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), 
                        elevation: 0, 
                      ), 
                      child: Text( 
                        'Plant seed 🌱', 
                        style: GoogleFonts.inter( 
                          fontSize: 14, 
                          fontWeight: FontWeight.w600, 
                        ), 
                      ), 
                    ), 
                  ], 
                ), 
                const SizedBox(height: 24), 
 
                // Panels Grid 
                Row( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Expanded( 
                      child: _buildPanel( 
                        title: '🌱 In Progress', 
                        count: seeds.length, 
                        tasks: seeds, 
                        emptyText: 'Nothing planted yet — add a task above.', 
                      ), 
                    ), 
                    const SizedBox(width: 16), 
                    Expanded( 
                      child: _buildPanel( 
                        title: '🌳 Grown', 
                        count: trees.length, 
                        tasks: trees, 
                        emptyText: 'No trees grown yet. Mark a task done to plant one.', 
                        isCompleted: true, 
                      ), 
                    ), 
                  ], 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildPanel({ 
    required String title, 
    required int count, 
    required List<Task> tasks, 
    required String emptyText, 
    bool isCompleted = false, 
  }) { 
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
                title, 
                style: GoogleFonts.inter( 
                  fontSize: 14, 
                  fontWeight: FontWeight.w600, 
                  color: const Color(0xFFede4d3), 
                ), 
              ), 
              const SizedBox(width: 8), 
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), 
                decoration: BoxDecoration( 
                  color: const Color(0xFFede4d3).withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(12), 
                ), 
                child: Text( 
                  '$count', 
                  style: GoogleFonts.inter( 
                    fontSize: 12, 
                    color: const Color(0xFFc7bca7), 
                  ), 
                ), 
              ) 
            ], 
          ), 
          const SizedBox(height: 12), 
          if (tasks.isEmpty) 
            Text( 
              emptyText, 
              style: GoogleFonts.inter( 
                fontSize: 12, 
                fontStyle: FontStyle.italic, 
                color: const Color(0xFFc7bca7), 
              ), 
            ) 
          else 
            Column( 
              children: tasks.map((task) { 
                return Container( 
                  padding: const EdgeInsets.symmetric(vertical: 8), 
                  decoration: BoxDecoration( 
                    border: Border( 
                      bottom: BorderSide( 
                        color: const Color(0xFFede4d3).withValues(alpha: 0.08), 
                      ), 
                    ), 
                  ), 
                  child: Row( 
                    children: [ 
                      Expanded( 
                        child: Text( 
                          task.name, 
                          style: GoogleFonts.inter( 
                            fontSize: 14, 
                            color: const Color(0xFFede4d3), 
                            decoration: isCompleted ? TextDecoration.lineThrough : null, 
                          ), 
                        ), 
                      ), 
                      if (!isCompleted) 
                        GestureDetector( 
                          onTap: () => _handleComplete(task.id), 
                          child: Container( 
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 
                            margin: const EdgeInsets.only(right: 8), 
                            decoration: BoxDecoration( 
                              border: Border.all(color: const Color(0xFF588157)), 
                              borderRadius: BorderRadius.circular(8), 
                            ), 
                            child: Text( 
                              'Mark done ✔', 
                              style: GoogleFonts.inter( 
                                fontSize: 12, 
                                color: const Color(0xFFa4c3a2), 
                              ), 
                            ), 
                          ), 
                        ), 
                      GestureDetector( 
                        onTap: () => _handleDelete(task.id), 
                        child: Container( 
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                          decoration: BoxDecoration( 
                            border: Border.all(color: const Color(0xFFc9705a)), 
                            borderRadius: BorderRadius.circular(8), 
                          ), 
                          child: Text( 
                            '✕', 
                            style: GoogleFonts.inter( 
                              fontSize: 12, 
                              color: const Color(0xFFc9705a), 
                            ), 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                ); 
              }).toList(), 
            ), 
        ], 
      ), 
    ); 
  } 
} 
 
class _Mulberry32 { 
  int _seed; 
  _Mulberry32(this._seed); 
 
  double next() { 
    _seed = (_seed + 0x6d2b79f5) & 0xFFFFFFFF; 
    int t = _imul(_seed ^ (_seed >>> 15), 1 | _seed); 
    t = (t + _imul(t ^ (t >>> 7), 61 | t)) ^ t; 
    t = t & 0xFFFFFFFF; 
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296.0; 
  } 
 
  static int _imul(int a, int b) { 
    int al = a & 0xFFFF; 
    int ah = (a >>> 16) & 0xFFFF; 
    int bl = b & 0xFFFF; 
    int bh = (b >>> 16) & 0xFFFF; 
    int res = (al * bl) + (((ah * bl + al * bh) << 16) >>> 0); 
    return res & 0xFFFFFFFF; 
  } 
} 
 
int _hashStr(String str) { 
  int h = 0; 
  for (int i = 0; i < str.length; i++) { 
    h = (31 * h + str.codeUnitAt(i)) & 0xFFFFFFFF; 
  } 
  return h; 
} 
 
class _GardenScenePainter extends CustomPainter { 
  final List<Task> tasks; 
  _GardenScenePainter({required this.tasks}); 
 
  static const double groundY = 280; 
  static const List<Color> _leafColors = [ 
    Color(0xFF6b9080), 
    Color(0xFFa4c3a2), 
    Color(0xFF588157), 
    Color(0xFF3a5a40) 
  ]; 
 
  @override 
  void paint(Canvas canvas, Size size) { 
    final w = size.width; 
    final h = size.height; 
 
    // Hills 
    final hill1Paint = Paint()..color = const Color(0xFF3f5a49)..style = PaintingStyle.fill; 
    final hill1Path = Path() 
      ..moveTo(0, groundY - 30) 
      ..quadraticBezierTo(150, groundY - 70, 300, groundY - 35) 
      ..quadraticBezierTo(450, groundY, 600, groundY - 40) // using quadratic to approximate SVG 'T' 
      ..quadraticBezierTo(750, groundY - 80, w, groundY - 20) 
      ..lineTo(w, h) 
      ..lineTo(0, h) 
      ..close(); 
    canvas.drawPath(hill1Path, hill1Paint); 
 
    final hill2Paint = Paint()..color = const Color(0xFF2c4536)..style = PaintingStyle.fill; 
    final hill2Path = Path() 
      ..moveTo(0, groundY) 
      ..quadraticBezierTo(200, groundY - 25, 450, groundY - 5) 
      ..quadraticBezierTo(675, groundY + 15, w, groundY - 15) 
      ..lineTo(w, h) 
      ..lineTo(0, h) 
      ..close(); 
    canvas.drawPath(hill2Path, hill2Paint); 
 
    final items = tasks.take(40).toList(); 
    final n = math.max(items.length, 1); 
     
    final availableWidth = w - 120; 
    const maxSpacing = 85.0; 
    final spacing = math.min(availableWidth / n, maxSpacing); 
    final totalWidth = spacing * n; 
    final startX = (w - totalWidth) / 2; 
 
    for (int i = 0; i < items.length; i++) { 
      final task = items[i]; 
      final x = startX + (i + 0.5) * spacing; 
      final rng = _Mulberry32(_hashStr(task.id)); 
 
      if (task.completed) { 
        final scale = 0.85 + rng.next() * 0.5; 
        _drawTree(canvas, rng, x, scale); 
      } else { 
        _drawSeed(canvas, rng, x); 
      } 
    } 
  } 
 
  void _drawSeed(Canvas canvas, _Mulberry32 rng, double x) { 
    final jitter = (rng.next() - 0.5) * 6; 
    final seedX = x + jitter; 
 
    final paint1 = Paint() 
      ..color = const Color(0xFF4a3728).withValues(alpha: 0.85) 
      ..style = PaintingStyle.fill; 
    canvas.drawOval(Rect.fromCenter(center: Offset(seedX, groundY - 2), width: 10, height: 6), paint1); 
 
    final paint2 = Paint()..color = const Color(0xFF588157); 
    canvas.drawCircle(Offset(seedX, groundY - 5), 2.4, paint2); 
  } 
 
  void _drawTree(Canvas canvas, _Mulberry32 rng, double x, double scale) { 
    final trunkH = (60 + rng.next() * 40) * scale; 
    final trunkW = (6 + rng.next() * 4) * scale; 
    final lean = (rng.next() - 0.5) * 10; 
 
    canvas.save(); 
    canvas.translate(x, groundY); 
 
    // Trunk 
    final trunkPaint = Paint() 
      ..color = const Color(0xFF4a3728) 
      ..style = PaintingStyle.fill; 
    final trunkStroke = Paint() 
      ..color = const Color(0xFF33261b) 
      ..style = PaintingStyle.stroke 
      ..strokeWidth = 0.6; 
 
    final tPath = Path() 
      ..moveTo(-trunkW / 2, 0) 
      ..cubicTo( 
        -trunkW / 2 + lean * 0.3, -trunkH * 0.5, 
        lean * 0.6, -trunkH * 0.6, 
        lean, -trunkH 
      ) 
      ..lineTo(lean + trunkW * 0.6, -trunkH) 
      ..cubicTo( 
        lean * 0.6 + trunkW, -trunkH * 0.6, 
        trunkW / 2 + lean * 0.3, -trunkH * 0.5, 
        trunkW / 2, 0 
      ) 
      ..close(); 
 
    canvas.drawPath(tPath, trunkPaint); 
    canvas.drawPath(tPath, trunkStroke); 
 
    // Branches 
    final branchCount = 2 + (rng.next() * 3).floor(); 
    final branchPaint = Paint() 
      ..color = const Color(0xFF4a3728) 
      ..style = PaintingStyle.stroke 
      ..strokeWidth = 2.5 * scale 
      ..strokeCap = StrokeCap.round; 
 
    for (int b = 0; b < branchCount; b++) { 
      final t = 0.35 + rng.next() * 0.5; 
      final by = -trunkH * t; 
      final bx = lean * t; 
      final dir = b % 2 == 0 ? -1 : 1; 
      final len = (18 + rng.next() * 16) * scale; 
      final angle = (dir * (30 + rng.next() * 25) * math.pi) / 180; 
      final ex = bx + math.sin(angle) * len; 
      final ey = by - math.cos(angle) * len; 
 
      final bPath = Path() 
        ..moveTo(bx, by) 
        ..quadraticBezierTo( 
          (bx + ex) / 2 + dir * 8, (by + ey) / 2, 
          ex, ey 
        ); 
      canvas.drawPath(bPath, branchPaint); 
    } 
 
    // Leaves 
    final clusterCount = 5 + (rng.next() * 5).floor(); 
    final canopyCx = lean; 
    final canopyCy = -trunkH - 6 * scale; 
    final canopyR = (26 + rng.next() * 14) * scale; 
 
    for (int c = 0; c < clusterCount; c++) { 
      final ang = rng.next() * math.pi * 2; 
      final rad = rng.next() * canopyR * 0.85; 
      final cx = canopyCx + math.cos(ang) * rad; 
      final cy = canopyCy + math.sin(ang) * rad * 0.7; 
      final r = (10 + rng.next() * 10) * scale; 
      final color = _leafColors[(rng.next() * _leafColors.length).floor()]; 
 
      final leafPaint = Paint() 
        ..color = color.withValues(alpha: 0.92) 
        ..style = PaintingStyle.fill; 
      canvas.drawCircle(Offset(cx, cy), r, leafPaint); 
    } 
 
    // Flecks 
    if (rng.next() > 0.4) { 
      final flecks = 2 + (rng.next() * 3).floor(); 
      final fleckPaint = Paint() 
        ..color = const Color(0xFFf2c14e).withValues(alpha: 0.85) 
        ..style = PaintingStyle.fill; 
      for (int f = 0; f < flecks; f++) { 
        final ang = rng.next() * math.pi * 2; 
        final rad = rng.next() * canopyR * 0.7; 
        final cx = canopyCx + math.cos(ang) * rad; 
        final cy = canopyCy + math.sin(ang) * rad * 0.7; 
        canvas.drawCircle(Offset(cx, cy), 1.6 * scale, fleckPaint); 
      } 
    } 
 
    canvas.restore(); 
  } 
 
  @override 
  bool shouldRepaint(covariant _GardenScenePainter oldDelegate) { 
    return true; 
  } 
}
