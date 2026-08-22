import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final bool safetyTriggered;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.safetyTriggered = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Dio _dio = Dio();
  
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _sessionId;

  final String _initialGreeting = 
      "Hello, I'm Seviyan. Share what's on your mind, and we'll work through it together.";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('chatbot_seviyan', 'opened');
      _loadConversations();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    try {
      await _dio.get(
        'https://zenu-backend-5dgz.onrender.com/api/chat/conversations',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          // Note: In a real app, cookies/tokens from CookieJar would be injected here
        ),
      );
      
      // If we loaded past sessions, we could parse them here.
      // For now, if no messages, we just let the initial greeting show.
      if (_messages.isEmpty) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Failed to load past conversations: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(content: text, isUser: true));
      _isLoading = true;
    });
    
    _textController.clear();
    _scrollToBottom();

    try {
      final body = <String, dynamic>{
        'message': text,
      };
      if (_sessionId != null) {
        body['session_id'] = _sessionId;
      }

      final res = await _dio.post(
        'https://zenu-backend-5dgz.onrender.com/api/chat/message',
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final reply = res.data['reply'] as String? ?? "I'm here for you. Can you tell me more?";
      if (res.data['session_id'] != null) {
        _sessionId = res.data['session_id'] as String;
      }
      final safetyTriggered = res.data['safety_triggered'] == true;

      setState(() {
        _messages.add(ChatMessage(
          content: reply,
          isUser: false,
          safetyTriggered: safetyTriggered,
        ));
        _isLoading = false;
      });

      if (safetyTriggered && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'We noticed you might be going through a tough time. Please reach out to someone you trust.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          content: "I had trouble connecting. Please try again — I'm here for you.",
          isUser: false,
        ));
        _isLoading = false;
      });
    }
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _sessionId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162544), // Deep atmosphere for chat
      body: ModuleBackground(
        moduleKey: 'chatbot_seviyan',
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildChatList(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seviyan',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.02 * 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your listening companion',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFFD1E8FF).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: _clearChat,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ZenTokens.radiusZenSm),
              ),
            ),
            child: const Text('Clear chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    final displayMessages = _messages.isEmpty 
        ? [ChatMessage(content: _initialGreeting, isUser: false)] 
        : _messages;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: displayMessages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayMessages.length && _isLoading) {
          return _buildTypingIndicator();
        }

        final msg = displayMessages[index];
        return _buildBubble(msg);
      },
    );
  }

  Widget _buildBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    Color bgColor;
    Color textColor;
    Border? border;

    if (isUser) {
      bgColor = ZenTokens.zenPrimary;
      textColor = Colors.white;
    } else {
      if (message.safetyTriggered) {
        bgColor = Colors.amber.shade100;
        textColor = ZenTokens.zenFg;
        border = Border.all(color: Colors.amber.shade300);
      } else {
        bgColor = Colors.white;
        textColor = ZenTokens.zenFg;
        border = Border.all(color: ZenTokens.zenBorderSoft);
      }
    }

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isUser ? 20 : 8),
      bottomRight: Radius.circular(isUser ? 8 : 20),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: textColor,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: ZenTokens.zenBorderSoft),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: ZenTokens.zenFgMuted,
                shape: BoxShape.circle,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(delay: Duration(milliseconds: index * 200))
            .then()
            .fadeOut(delay: const Duration(milliseconds: 200));
          }),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 32,
              spreadRadius: -18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Share what's on your mind...",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFFD1E8FF).withValues(alpha: 0.55),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: ZenTokens.zenPrimary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, size: 18),
                color: Colors.white,
                onPressed: _isLoading ? null : _sendMessage,
                tooltip: 'Send message',
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
