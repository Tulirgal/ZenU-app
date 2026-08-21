import 'dart:math' as math;
import 'dart:ui'; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/api/api_client.dart'; 

import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class ChatMessage { 
  final int id; 
  final String role; 
  final String content; 
 
  ChatMessage({required this.id, required this.role, required this.content}); 
} 
 
class ChatScreen extends StatefulWidget { 
  const ChatScreen({super.key}); 
 
  @override 
  State<ChatScreen> createState() => _ChatScreenState(); 
} 
 
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin { 
  final List<ChatMessage> _messages = []; 
  final TextEditingController _inputCtrl = TextEditingController(); 
  final ScrollController _scrollCtrl = ScrollController(); 
  bool _isSending = false; 
 
  static const _quickPrompts = [ 
    "I'm feeling overwhelmed by school", 
    'Help me unwind after a long day', 
    'I need a gentle pep talk', 
    "Let's plan one small next step", 
  ]; 
 
  @override 
  void initState() { 
    super.initState(); 
    _messages.add( 
      ChatMessage( 
        id: -1, 
        role: 'assistant', 
        content: "Hello, I'm Seviyan. Share what's on your mind, and we'll work through it together.", 
      ), 
    ); 
  } 
 
  @override 
  void dispose() { 
    _inputCtrl.dispose(); 
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
 
  String? _conversationId;

  void _sendMessage(String text) async { 
    if (text.trim().isEmpty || _isSending) return; 
     
    setState(() { 
      _messages.add(ChatMessage(id: DateTime.now().millisecondsSinceEpoch, role: 'user', content: text.trim())); 
      _isSending = true; 
    }); 
    _inputCtrl.clear(); 
    _scrollToBottom(); 
 
    try {
      final client = await ApiClient.getInstance();
      final res = await client.post('/api/chat/messages', data: {
        'message': text.trim(),
        if (_conversationId != null) 'conversationId': _conversationId,
      });

      if (res.statusCode == 200 && res.data != null) {
        final reply = res.data['reply'] as String;
        _conversationId = res.data['conversationId'] as String?;
        if (mounted) {
          setState(() { 
            _messages.add(ChatMessage(id: DateTime.now().millisecondsSinceEpoch, role: 'assistant', content: reply)); 
            _isSending = false; 
          }); 
        }
      } else {
        if (mounted) {
          setState(() { 
            _messages.add(ChatMessage(id: DateTime.now().millisecondsSinceEpoch, role: 'assistant', content: 'Sorry, I ran into an error connecting to the server.')); 
            _isSending = false; 
          }); 
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() { 
          _messages.add(ChatMessage(id: DateTime.now().millisecondsSinceEpoch, role: 'assistant', content: 'Network error. Please try again later.')); 
          _isSending = false; 
        }); 
      }
    }
    _scrollToBottom(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'chat', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              // Header 
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                child: Row( 
                  children: [ 
                    IconButton( 
                      onPressed: () => context.pop(), 
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), 
                      color: ZenTokens.fg, 
                    ), 
                    const SizedBox(width: 8), 
                    Text( 
                      'Chat', 
                      style: GoogleFonts.inter( 
                        fontSize: 18, 
                        fontWeight: FontWeight.w600, 
                        color: ZenTokens.fg, 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
 
              // Messages 
              Expanded( 
                child: ListView.builder( 
                  controller: _scrollCtrl, 
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
                  itemCount: _messages.length, 
                  itemBuilder: (context, index) { 
                    final msg = _messages[index]; 
                    return _ChatBubble(message: msg); 
                  }, 
                ), 
              ), 
 
              // Footer / Input Area 
              Container( 
                width: double.infinity, 
                constraints: const BoxConstraints(maxWidth: 768), 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), 
                child: Column( 
                  mainAxisSize: MainAxisSize.min, 
                  children: [ 
                    // Seviyan Companion & Thought Cloud 
                    SizedBox( 
                      height: 64, 
                      child: Stack( 
                        alignment: Alignment.bottomCenter, 
                        clipBehavior: Clip.none, 
                        children: [ 
                          // Glow 
                          Container( 
                            width: 64, 
                            height: 24, 
                            decoration: BoxDecoration( 
                              borderRadius: BorderRadius.circular(100), 
                              boxShadow: [ 
                                BoxShadow( 
                                  color: const Color(0xFF93C5FD).withValues(alpha: 0.35), 
                                  blurRadius: 12, 
                                  spreadRadius: 8, 
                                ) 
                              ], 
                            ), 
                          ), 
                          // Panda Icon Placeholder 
                          Container( 
                            width: 64, 
                            height: 64, 
                            decoration: BoxDecoration( 
                              color: ZenTokens.surface, 
                              shape: BoxShape.circle, 
                              border: Border.all(color: ZenTokens.borderSoft), 
                            ), 
                            child: Center( 
                              child: Text('🐼', style: TextStyle(fontSize: 32)), 
                            ), 
                          ), 
                          if (_isSending) 
                            Positioned( 
                              right: -10, 
                              top: 0, 
                              child: const _ThoughtCloud(), 
                            ), 
                        ], 
                      ), 
                    ), 
 
                    const SizedBox(height: 16), 
 
                    // Quick Prompts 
                    if (_messages.length <= 1) 
                      Wrap( 
                        spacing: 8, 
                        runSpacing: 8, 
                        alignment: WrapAlignment.center, 
                        children: _quickPrompts.map((p) { 
                          return GestureDetector( 
                            onTap: () => _sendMessage(p), 
                            child: Container( 
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
                              decoration: BoxDecoration( 
                                color: const Color(0xFFF4F7FC), 
                                borderRadius: BorderRadius.circular(16), 
                                border: Border.all( 
                                  color: ZenTokens.primary.withValues(alpha: 0.22), 
                                ), 
                                boxShadow: [ 
                                  BoxShadow( 
                                    color: const Color(0xFF0F172A).withValues(alpha: 0.05), 
                                    blurRadius: 14, 
                                    offset: const Offset(0, 4), 
                                    spreadRadius: -10, 
                                  ) 
                                ], 
                              ), 
                              child: Text( 
                                p, 
                                style: GoogleFonts.inter( 
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500, 
                                  color: const Color(0xFF1B264B), 
                                ), 
                              ), 
                            ), 
                          ); 
                        }).toList(), 
                      ), 
                     
                    const SizedBox(height: 16), 
 
                    // Input Field 
                    Container( 
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
                      decoration: BoxDecoration( 
                        color: Colors.white.withValues(alpha: 0.12), 
                        borderRadius: BorderRadius.circular(22), 
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)), 
                        boxShadow: [ 
                          BoxShadow( 
                            color: Colors.black.withValues(alpha: 0.15), 
                            blurRadius: 32, 
                            offset: const Offset(0, 10), 
                            spreadRadius: -18, 
                          ) 
                        ], 
                      ), 
                      child: ClipRRect( 
                        borderRadius: BorderRadius.circular(22), 
                        child: BackdropFilter( 
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), 
                          child: Row( 
                            children: [ 
                              Expanded( 
                                child: TextField( 
                                  controller: _inputCtrl, 
                                  enabled: !_isSending, 
                                  style: GoogleFonts.inter( 
                                    fontSize: 14, 
                                    color: Colors.white, 
                                  ), 
                                  decoration: InputDecoration( 
                                    hintText: "Share what's on your mind…", 
                                    hintStyle: GoogleFonts.inter( 
                                      fontSize: 14, 
                                      color: const Color(0xFFDBEAFE).withValues(alpha: 0.55), 
                                    ), 
                                    border: InputBorder.none, 
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), 
                                  ), 
                                  onSubmitted: _sendMessage, 
                                ), 
                              ), 
                              const SizedBox(width: 8), 
                              GestureDetector( 
                                onTap: () => _sendMessage(_inputCtrl.text), 
                                child: Container( 
                                  width: 32, 
                                  height: 32, 
                                  decoration: BoxDecoration( 
                                    color: ZenTokens.primary, 
                                    shape: BoxShape.circle, 
                                  ), 
                                  child: const Icon( 
                                    Icons.send_rounded, 
                                    color: Colors.white, 
                                    size: 14, 
                                  ), 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
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
 
class _ChatBubble extends StatelessWidget { 
  final ChatMessage message; 
 
  const _ChatBubble({required this.message}); 
 
  @override 
  Widget build(BuildContext context) { 
    final isUser = message.role == 'user'; 
     
    return Padding( 
      padding: const EdgeInsets.only(bottom: 16), 
      child: Row( 
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start, 
        children: [ 
          Flexible( 
            child: Container( 
              constraints: const BoxConstraints(maxWidth: 320), // Approx 85% on mobile 
              margin: EdgeInsets.only( 
                left: isUser ? 32 : 0, 
                right: isUser ? 0 : 32, 
              ), 
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), 
              decoration: BoxDecoration( 
                color: isUser ? ZenTokens.primary : Colors.white, 
                border: isUser ? null : Border.all(color: ZenTokens.border), 
                borderRadius: BorderRadius.only( 
                  topLeft: const Radius.circular(20), 
                  topRight: const Radius.circular(20), 
                  bottomLeft: Radius.circular(isUser ? 20 : 8), 
                  bottomRight: Radius.circular(isUser ? 8 : 20), 
                ), 
                boxShadow: [ 
                  BoxShadow( 
                    color: const Color(0xFF1E295A).withValues(alpha: 0.05), 
                    blurRadius: 8, 
                    offset: const Offset(0, 4), 
                  ) 
                ], 
              ), 
              child: Text( 
                message.content, 
                style: GoogleFonts.inter( 
                  fontSize: 16, 
                  height: 1.6, // leading-relaxed 
                  color: isUser ? Colors.white : ZenTokens.fg, 
                ), 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
class _ThoughtCloud extends StatefulWidget { 
  const _ThoughtCloud(); 
 
  @override 
  State<_ThoughtCloud> createState() => _ThoughtCloudState(); 
} 
 
class _ThoughtCloudState extends State<_ThoughtCloud> with SingleTickerProviderStateMixin { 
  late AnimationController _ctrl; 
 
  @override 
  void initState() { 
    super.initState(); 
    _ctrl = AnimationController( 
      vsync: this, 
      duration: const Duration(milliseconds: 1600), 
    )..repeat(); 
  } 
 
  @override 
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Row( 
      crossAxisAlignment: CrossAxisAlignment.end, 
      children: List.generate(3, (index) { 
        final size = 3.0 + (index * 1.5); 
        final mb = index == 0 ? 1.0 : (index == 1 ? 4.0 : 7.0); 
         
        return AnimatedBuilder( 
          animation: _ctrl, 
          builder: (context, child) { 
            // Staggered sine wave for opacity 
            // Delays: 0, 0.18, 0.36 
            final delay = index * 0.1125; // 0.18s / 1.6s 
            final t = (_ctrl.value - delay) % 1.0; 
            final val = t < 0 ? t + 1.0 : t; 
             
            // Calculate opacity from 0.3 -> 0.7 -> 0.3 using sine 
            final opacity = 0.3 + (0.4 * (0.5 * (1 - (math.cos(val * 2 * 3.14159))))); 
             
            return Container( 
              margin: EdgeInsets.only(left: 2, bottom: mb), 
              width: size, 
              height: size, 
              decoration: BoxDecoration( 
                color: Colors.white.withValues(alpha: opacity), 
                shape: BoxShape.circle, 
              ), 
            ); 
          }, 
        ); 
      }), 
    ); 
  } 
}
