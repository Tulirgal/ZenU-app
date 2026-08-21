import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class ChatScreen extends StatefulWidget { 
  const ChatScreen({super.key}); 
  @override 
  State<ChatScreen> createState() => _ChatScreenState(); 
} 
 
class _ChatScreenState extends State<ChatScreen> { 
  final _msgCtrl = TextEditingController(); 
  final _scrollCtrl = ScrollController(); 
   
  final List<Map<String, dynamic>> _messages = [ 
    { 
      'role': 'assistant', 
      'content': "Hello! I'm Seviyan, your wellness companion. Share what's on your mind — I'm here for you. 🌿" 
    } 
  ]; 
   
  String? _sessionId; 
  bool _isTyping = false; 
  late final ModuleTheme theme; 
 
  @override 
  void initState() { 
    super.initState(); 
    theme = ModuleThemes.chat; 
    _logEngagement(); 
  } 
 
  Future<void> _logEngagement() async { 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/engagement', data: { 
        'module_id': 'chatbot_seviyan', 
        'event_type': 'opened' 
      }); 
    } catch (_) {} 
  } 
 
  @override 
  void dispose() { 
    _msgCtrl.dispose(); 
    _scrollCtrl.dispose(); 
    super.dispose(); 
  } 
 
  void _scrollToBottom() { 
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      if (_scrollCtrl.hasClients) { 
        _scrollCtrl.animateTo( 
          _scrollCtrl.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOut, 
        ); 
      } 
    }); 
  } 
 
  Future<void> _send() async { 
    final text = _msgCtrl.text.trim(); 
    if (text.isEmpty) return; 
 
    _msgCtrl.clear(); 
    setState(() { 
      _messages.add({'role': 'user', 'content': text}); 
      _isTyping = true; 
    }); 
    _scrollToBottom(); 
 
    try { 
      final c = await ApiClient.getInstance(); 
      final reqData = {'message': text}; 
      if (_sessionId != null) { 
        reqData['session_id'] = _sessionId!; 
      } 
 
      final res = await c.post('/api/chat/message', data: reqData); 
       
      if (res.statusCode == 200 && mounted) { 
        setState(() { 
          if (res.data['session_id'] != null) { 
            _sessionId = res.data['session_id'] as String; 
          } 
          _messages.add({'role': 'assistant', 'content': res.data['reply'] ?? ''}); 
          _isTyping = false; 
        }); 
        _scrollToBottom(); 
      } 
    } catch (_) { 
      if (mounted) { 
        setState(() { 
          _messages.add({'role': 'assistant', 'content': "I'm having trouble connecting right now. Please try again later."}); 
          _isTyping = false; 
        }); 
        _scrollToBottom(); 
      } 
    } 
  } 
 
  void _reset() { 
    setState(() { 
      _sessionId = null; 
      _messages.clear(); 
      _messages.add({ 
        'role': 'assistant', 
        'content': "Hello! I'm Seviyan, your wellness companion. Share what's on your mind — I'm here for you. 🌿" 
      }); 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
        title: Text('💬 Seviyan', style: GoogleFonts.inter(color: theme.textPrimary, fontWeight: FontWeight.w600)), 
        actions: [ 
          IconButton( 
            icon: const Icon(Icons.refresh), 
            onPressed: _reset, 
            tooltip: 'Reset Chat', 
          ), 
        ], 
      ), 
      body: ModuleBackground( 
        moduleKey: 'chat', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              Expanded( 
                child: ListView.builder( 
                  controller: _scrollCtrl, 
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), 
                  itemCount: _messages.length + (_isTyping ? 1 : 0), 
                  itemBuilder: (context, i) { 
                    if (i == _messages.length) { 
                      return const _TypingIndicator().animate().fadeIn(); 
                    } 
                    final msg = _messages[i]; 
                    final isUser = msg['role'] == 'user'; 
                    return Align( 
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, 
                      child: Container( 
                        margin: const EdgeInsets.only(bottom: 12), 
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), 
                        decoration: BoxDecoration( 
                          color: isUser ? theme.accentColor : theme.cardBg, 
                          borderRadius: BorderRadius.circular(20).copyWith( 
                            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20), 
                            bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(20), 
                          ), 
                          border: isUser ? null : Border.all(color: theme.cardBorder), 
                        ), 
                        child: Text( 
                          msg['content'] as String, 
                          style: GoogleFonts.inter( 
                            color: isUser ? Colors.white : theme.textPrimary, 
                            fontSize: 15, 
                          ), 
                        ), 
                      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0), 
                    ); 
                  }, 
                ), 
              ), 
              Container( 
                padding: const EdgeInsets.all(16), 
                decoration: BoxDecoration( 
                  color: theme.cardBg.withValues(alpha: 0.8), 
                  border: Border(top: BorderSide(color: theme.cardBorder)), 
                ), 
                child: Row( 
                  children: [ 
                    Expanded( 
                      child: TextField( 
                        controller: _msgCtrl, 
                        style: GoogleFonts.inter(color: theme.textPrimary), 
                        decoration: InputDecoration( 
                          hintText: 'Type a message...', 
                          hintStyle: GoogleFonts.inter(color: theme.textSecondary), 
                          filled: true, 
                          fillColor: theme.cardBg, 
                          border: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(24), 
                            borderSide: BorderSide(color: theme.cardBorder), 
                          ), 
                          enabledBorder: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(24), 
                            borderSide: BorderSide(color: theme.cardBorder), 
                          ), 
                          focusedBorder: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(24), 
                            borderSide: BorderSide(color: theme.accentColor), 
                          ), 
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), 
                        ), 
                        onSubmitted: (_) => _send(), 
                      ), 
                    ), 
                    const SizedBox(width: 12), 
                    CircleAvatar( 
                      radius: 24, 
                      backgroundColor: theme.accentColor, 
                      child: IconButton( 
                        icon: const Icon(Icons.send_rounded, color: Colors.white), 
                        onPressed: _isTyping ? null : _send, 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
class _TypingIndicator extends StatelessWidget { 
  const _TypingIndicator(); 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.chat; 
    return Align( 
      alignment: Alignment.centerLeft, 
      child: Container( 
        margin: const EdgeInsets.only(bottom: 12), 
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), 
        decoration: BoxDecoration( 
          color: theme.cardBg, 
          borderRadius: BorderRadius.circular(20).copyWith( 
            bottomLeft: const Radius.circular(4), 
          ), 
          border: Border.all(color: theme.cardBorder), 
        ), 
        child: Row( 
          mainAxisSize: MainAxisSize.min, 
          children: List.generate(3, (i) =>  
            Container( 
              margin: const EdgeInsets.symmetric(horizontal: 2), 
              width: 8, height: 8, 
              decoration: BoxDecoration( 
                color: theme.textSecondary, 
                shape: BoxShape.circle, 
              ), 
            ).animate(onPlay: (c) => c.repeat(), delay: (i * 200).ms) 
             .fade(duration: 300.ms, begin: 0.3, end: 1.0) 
             .then() 
             .fade(duration: 300.ms, begin: 1.0, end: 0.3) 
          ), 
        ), 
      ), 
    ); 
  } 
}
