import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class HealingGardenScreen extends StatefulWidget { 
  const HealingGardenScreen({super.key}); 
  @override 
  State<HealingGardenScreen> createState() => _HealingGardenScreenState(); 
} 
 
class _HealingGardenScreenState extends State<HealingGardenScreen> { 
  final _ctrl = TextEditingController(); 
  List<Map<String, dynamic>> _tasks = []; 
  bool _loading = true; 
 
  @override 
  void initState() { 
    super.initState(); 
    _loadTasks(); 
  } 
 
  Future<void> _loadTasks() async { 
    setState(() => _loading = true); 
    try { 
      final c = await ApiClient.getInstance(); 
      final res = await c.get('/api/healing-garden/tasks'); 
      if (res.statusCode == 200 && mounted) { 
        setState(() { 
          _tasks = List<Map<String, dynamic>>.from(res.data['tasks'] ?? []); 
          _loading = false; 
        }); 
      } 
    } catch (_) { 
      if (mounted) setState(() => _loading = false); 
    } 
  } 
 
  Future<void> _addTask(String title) async { 
    if (title.isEmpty) return; 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/healing-garden/tasks', data: {'title': title}); 
      _ctrl.clear(); 
      _loadTasks(); 
    } catch (_) {} 
  } 
 
  Future<void> _markDone(String id) async { 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.patch('/api/healing-garden/tasks/$id/complete'); 
      await c.post('/api/signals/engagement', data: {'module_id': 'healing_garden', 'event_type': 'completed'}); 
      _loadTasks(); 
    } catch (_) {} 
  } 
 
  Future<void> _deleteTask(String id) async { 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.delete('/api/healing-garden/tasks/$id'); 
      _loadTasks(); 
    } catch (_) {} 
  } 
 
  @override 
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.healingGarden; 
    final inProgress = _tasks.where((t) => t['is_completed'] != true).toList(); 
    final completed = _tasks.where((t) => t['is_completed'] == true).toList(); 
 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
      ), 
      body: ModuleBackground( 
        moduleKey: 'healing_garden', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              // Header 
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                child: Column( 
                  children: [ 
                    Stack( 
                      alignment: Alignment.center, 
                      children: [ 
                        // Fireflies 
                        ...List.generate(5, (i) => Positioned( 
                          left: 40.0 * i, top: 10.0 * (i % 2), 
                          child: Container(width: 4, height: 4, decoration: BoxDecoration(color: theme.accentColor, shape: BoxShape.circle)) 
                            .animate(onPlay: (c) => c.repeat()) 
                            .fade(duration: 800.ms).then().fade(duration: 800.ms, begin: 1.0, end: 0.2), 
                        )), 
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: List.generate(completed.length > 8 ? 8 : completed.length, (i) => const Text('🌲', style: TextStyle(fontSize: 32))), 
                        ), 
                      ], 
                    ), 
                    const SizedBox(height: 12), 
                    Text('${completed.length} Trees Grown   ${_tasks.length} Seeds Planted', 
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: theme.textPrimary), 
                    ).animate().fadeIn(), 
                  ], 
                ), 
              ), 
 
              // Add Task 
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), 
                child: TextField( 
                  controller: _ctrl, 
                  style: GoogleFonts.inter(color: theme.textPrimary), 
                  decoration: InputDecoration( 
                    hintText: 'Plant a new task seed...', 
                    hintStyle: GoogleFonts.inter(color: theme.textSecondary), 
                    filled: true, 
                    fillColor: theme.cardBg, 
                    suffixIcon: IconButton( 
                      icon: Icon(Icons.add_circle, color: theme.accentColor), 
                      onPressed: () => _addTask(_ctrl.text.trim()), 
                    ), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.cardBorder)), 
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.cardBorder)), 
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.accentColor)), 
                  ), 
                  onSubmitted: _addTask, 
                ), 
              ), 
 
              // Lists 
              Expanded( 
                child: _loading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : ListView( 
                      padding: const EdgeInsets.all(24), 
                      children: [ 
                        if (inProgress.isNotEmpty) ...[ 
                          Text('🌱 In Progress', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textPrimary)), 
                          const SizedBox(height: 12), 
                          ...inProgress.map((t) => _buildTaskTile(t, theme, false)), 
                          const SizedBox(height: 24), 
                        ], 
                        if (completed.isNotEmpty) ...[ 
                          Text('🌳 Grown', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textPrimary)), 
                          const SizedBox(height: 12), 
                          ...completed.map((t) => _buildTaskTile(t, theme, true)), 
                        ] 
                      ], 
                    ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildTaskTile(Map<String, dynamic> t, ModuleTheme theme, bool isDone) { 
    final id = t['id'].toString(); 
    return Container( 
      margin: const EdgeInsets.only(bottom: 12), 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
      decoration: BoxDecoration( 
        color: theme.cardBg, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: theme.cardBorder), 
      ), 
      child: Row( 
        children: [ 
          Expanded( 
            child: Text(t['title'] as String? ?? '', 
              style: GoogleFonts.inter( 
                color: isDone ? theme.textSecondary : theme.textPrimary, 
                decoration: isDone ? TextDecoration.lineThrough : null, 
              ), 
            ), 
          ), 
          if (!isDone) 
            IconButton( 
              icon: const Icon(Icons.check_circle_outline, color: Colors.green), 
              onPressed: () => _markDone(id), 
              tooltip: 'Mark done', 
            ), 
          IconButton( 
            icon: Icon(Icons.close, color: theme.textSecondary, size: 20), 
            onPressed: () => _deleteTask(id), 
            tooltip: 'Delete', 
          ), 
        ], 
      ), 
    ).animate().fadeIn(); 
  } 
}
