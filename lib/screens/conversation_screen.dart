/// Conversation Screen
///
/// Individual chat conversation with immersive header,
/// message stream, and floating composer.

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';

class ConversationScreen extends StatefulWidget {
  final String chatId;
  final String name;
  final String avatarUrl;
  final String? activityStatus;
  final String? activityIcon;

  const ConversationScreen({
    super.key,
    required this.chatId,
    required this.name,
    required this.avatarUrl,
    this.activityStatus,
    this.activityIcon,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  double _scrollOffset = 0;

  // Sample messages - replace with actual data
  List<MessageData> _messages = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadSampleMessages();
  }

  void _loadSampleMessages() {
    // Check if this is a "new" conversation (for demo, chatId starting with 'new')
    if (widget.chatId.startsWith('new')) {
      _messages = [];
    } else {
      _messages = [
        MessageData(
          id: '1',
          text: 'Hey! Are you coming to the library today?',
          time: '2:30 PM',
          isOutgoing: false,
          showTime: true,
        ),
        MessageData(
          id: '2',
          text: 'Yes! I\'ll be there around 4. Want to grab coffee first?',
          time: '2:32 PM',
          isOutgoing: true,
        ),
        MessageData(
          id: '3',
          text: 'Perfect! ☕',
          time: '2:32 PM',
          isOutgoing: true,
          showTime: true,
        ),
        MessageData(
          id: '4',
          text: 'There\'s this new café near Block 4, have you tried it?',
          time: '2:35 PM',
          isOutgoing: false,
          reaction: '❤️',
        ),
        MessageData(
          id: '5',
          text: 'Not yet! Is it good?',
          time: '2:36 PM',
          isOutgoing: true,
        ),
        MessageData(
          id: '6',
          text:
              'The matcha latte is amazing. And they have this cozy corner with plants everywhere 🌱',
          time: '2:37 PM',
          isOutgoing: false,
          showTime: true,
        ),
        MessageData(
          id: '7',
          text: 'That sounds perfect for studying!',
          time: '2:38 PM',
          isOutgoing: true,
        ),
        MessageData(
          id: '8',
          text: 'Let\'s meet there then! See you at 4 😊',
          time: '2:38 PM',
          isOutgoing: true,
          showTime: true,
        ),
      ];
    }
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        MessageData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          time: _formatTime(DateTime.now()),
          isOutgoing: true,
          showTime: true,
        ),
      );
    });
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final isEmpty = _messages.isEmpty;

    return Scaffold(
      backgroundColor: theme.backgroundLight,
      body: Stack(
        children: [
          // Subtle background texture
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundLight,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.backgroundLight,
                  theme.mutedPrimary.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Header
              ChatHeader(
                name: widget.name,
                avatarUrl: widget.avatarUrl,
                activityStatus: widget.activityStatus,
                activityIcon: widget.activityIcon,
                scrollOffset: _scrollOffset,
                onBackTap: () => Navigator.of(context).pop(),
              ),
              // Message stream
              Expanded(
                child: isEmpty
                    ? _buildEmptyState(context)
                    : _buildMessageList(context),
              ),
              // Wave chip for empty state
              if (isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: theme.spacingM),
                  child: WaveChip(
                    onTap: () {
                      _messageController.text = '👋';
                    },
                  ),
                ),
              // Composer
              MessageComposer(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = context.cuTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.secondaryAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    widget.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      color: theme.secondaryAccent,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacingL),
          // Headline
          Text(
            'Start the vibe with ${widget.name.split(' ').first}.',
            style: TextStyle(
              fontFamily: theme.displayFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: theme.textSecondary,
            ),
          ),
          SizedBox(height: theme.spacingS),
          Text(
            'Say hi!',
            style: theme.bodyMedium.copyWith(
              color: theme.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context) {
    final theme = context.cuTheme;

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: theme.spacingM),
      itemCount: _messages.length + 1, // +1 for date separator
      itemBuilder: (context, index) {
        if (index == 0) {
          return DateSeparator(date: 'Today');
        }

        final messageIndex = index - 1;
        final message = _messages[messageIndex];

        // Determine grouping
        final isFirstInGroup =
            messageIndex == 0 ||
            _messages[messageIndex - 1].isOutgoing != message.isOutgoing;
        final isLastInGroup =
            messageIndex == _messages.length - 1 ||
            _messages[messageIndex + 1].isOutgoing != message.isOutgoing;

        return MessageBubble(
          message: message,
          isFirstInGroup: isFirstInGroup,
          isLastInGroup: isLastInGroup,
          onLongPress: () {
            // Show context menu
          },
        );
      },
    );
  }
}
