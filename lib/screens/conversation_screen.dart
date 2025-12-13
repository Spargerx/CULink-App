/// Conversation Screen
///
/// Individual chat conversation with immersive header,
/// message stream, and floating composer.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';
import '../widgets/chat_header.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/message_context_menu.dart';
import '../widgets/event_card.dart';

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

  // Context menu state
  OverlayEntry? _contextMenuOverlay;
  int? _selectedMessageIndex;
  String? _replyingToText;

  // Sample messages - replace with actual data
  List<dynamic> _messages = []; // Can be MessageData or EventData

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
        // Event card for meetup
        EventData(
          id: 'event1',
          title: 'Coffee at Block 4?',
          location: 'Café Botanica, Block 4',
          time: 'Today, 4:00 PM',
          type: 'Meetup',
          emoji: '☕',
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
          replyTo: _replyingToText,
        ),
      );
      _replyingToText = null;
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

  void _showContextMenu(int index, Offset position) {
    final item = _messages[index];
    if (item is! MessageData) return;

    HapticFeedback.mediumImpact();
    setState(() => _selectedMessageIndex = index);

    _contextMenuOverlay = OverlayEntry(
      builder: (context) => MessageContextMenu(
        position: position,
        isOwnMessage: item.isOutgoing,
        onReply: () {
          setState(() {
            _replyingToText = item.text;
          });
        },
        onReact: () {
          _showReactionPicker(index);
        },
        onCopy: () {
          Clipboard.setData(ClipboardData(text: item.text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied to clipboard'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onDelete: () {
          setState(() {
            _messages.removeAt(index);
          });
        },
        onDismiss: _dismissContextMenu,
      ),
    );

    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _showReactionPicker(int index) {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = OverlayEntry(
      builder: (context) => ReactionPicker(
        onReactionSelected: (emoji) {
          final item = _messages[index];
          if (item is MessageData) {
            setState(() {
              _messages[index] = MessageData(
                id: item.id,
                text: item.text,
                time: item.time,
                isOutgoing: item.isOutgoing,
                reaction: emoji,
                replyTo: item.replyTo,
                showTime: item.showTime,
              );
            });
          }
        },
        onDismiss: _dismissContextMenu,
      ),
    );
    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _dismissContextMenu() {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = null;
    setState(() => _selectedMessageIndex = null);
  }

  @override
  void dispose() {
    _contextMenuOverlay?.remove();
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
              // Reply preview
              if (_replyingToText != null) _buildReplyPreview(context),
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

  Widget _buildReplyPreview(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingL,
        vertical: theme.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.secondaryAccent.withValues(alpha: 0.1),
        border: Border(
          left: BorderSide(color: theme.secondaryAccent, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, size: 18, color: theme.secondaryAccent),
          SizedBox(width: theme.spacingS),
          Expanded(
            child: Text(
              _replyingToText!,
              style: theme.bodySmall.copyWith(color: theme.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _replyingToText = null),
            child: Icon(Icons.close, size: 18, color: theme.textSecondary),
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
        final item = _messages[messageIndex];

        // Handle event card
        if (item is EventData) {
          return EventCard(
            event: item,
            isOutgoing: false,
            onAccept: () {
              // Handle accept
            },
            onEdit: () {
              // Handle edit
            },
          );
        }

        // Handle regular message
        final message = item as MessageData;

        // Determine grouping (skip event cards for grouping logic)
        bool isFirstInGroup = true;
        bool isLastInGroup = true;

        if (messageIndex > 0 && _messages[messageIndex - 1] is MessageData) {
          final prevMessage = _messages[messageIndex - 1] as MessageData;
          isFirstInGroup = prevMessage.isOutgoing != message.isOutgoing;
        }

        if (messageIndex < _messages.length - 1 &&
            _messages[messageIndex + 1] is MessageData) {
          final nextMessage = _messages[messageIndex + 1] as MessageData;
          isLastInGroup = nextMessage.isOutgoing != message.isOutgoing;
        }

        final isSelected = _selectedMessageIndex == messageIndex;

        return GestureDetector(
          onLongPressStart: (details) {
            _showContextMenu(messageIndex, details.globalPosition);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()..scale(isSelected ? 0.97 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.secondaryAccent.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: MessageBubble(
              message: message,
              isFirstInGroup: isFirstInGroup,
              isLastInGroup: isLastInGroup,
            ),
          ),
        );
      },
    );
  }
}
