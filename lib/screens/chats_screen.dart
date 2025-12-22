// Chats Screen
//
// Direct Messages and Group chats screen.
// Features segmented control, pinned contacts, and message list.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/segmented_control.dart';
import '../widgets/pinned_contacts.dart';
import '../widgets/chat_list_tile.dart';
import 'conversation_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _segmentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Sample pinned contacts
  final List<PinnedContactData> pinnedContacts = const [
    PinnedContactData(
      id: '1',
      firstName: 'Priya',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      isActive: true,
    ),
    PinnedContactData(
      id: '2',
      firstName: 'Arjun',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
      isActive: false,
    ),
    PinnedContactData(
      id: '3',
      firstName: 'Maya',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      isActive: true,
    ),
    PinnedContactData(
      id: '4',
      firstName: 'Rahul',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
      isActive: false,
    ),
  ];

  // Sample direct chats
  final List<ChatData> directChats = const [
    ChatData(
      id: '1',
      name: 'Priya Sharma',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      lastMessage: 'See you at the library at 4!',
      timestamp: '2m',
      status: 'Active now',
      hasUnread: true,
    ),
    ChatData(
      id: '2',
      name: 'Arjun Patel',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
      lastMessage: '',
      timestamp: 'now',
      status: 'Typing…',
      hasUnread: true,
      isTyping: true,
    ),
    ChatData(
      id: '3',
      name: 'Maya Singh',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      lastMessage: 'The design project looks amazing! 🎨',
      timestamp: '15m',
      hasUnread: false,
    ),
    ChatData(
      id: '4',
      name: 'Rahul Mehta',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
      lastMessage: 'Can you share the notes from yesterday?',
      timestamp: '1h',
      hasUnread: false,
    ),
    ChatData(
      id: '5',
      name: 'Sneha Iyer',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuATbxvPrSOQMYmwil7e9XLqQmU1eqD42GSJuBRMdeX5Kk94wJYo1b8RMm2745ge042PR01v9ZMd31qY2aFkvpXyXC4v7sgkJrz-5IIjFzqpPOdq8Bwh1-wz61BZz4EQFoQESPcvQjJiTDYfwkL7dE1JvPdtygty9YXXWRnioFXRLBBFELaSWkJ2LiV9DCjUtqYvAb9Wbjr8oqA6b6wuf3GUwEH__Se8QyK8UX7SWzt0CrAoIKwVtHOFucMvO4finDatSX8V3Pgx2jZw',
      lastMessage: 'Thanks for helping with the project!',
      timestamp: '3h',
      hasUnread: true,
    ),
    ChatData(
      id: '6',
      name: 'Karan Verma',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEVVoh-Uary0BlW9Tge9pwf0cnABIYG_JRk-IKPyalPqPz0rmaMZPO4snt2x3BmtCqFVCB6WKsVuVwzWzrW0MckNH44I4xUgKbdad5Z9arNXto3p60uSDvWazuXWTic63Jk_A7GvZmJX_KHXZUck2-1MuW4aQ8knHnNgUe-ieOhwe13JxJyyPk_-X0ogKbRd49ON0XccNdUMj-zBNvV5vlIRMI-kzDbcTD-lVtEQN6JR7d7RHP-uI-g1-4U-dhe6RH9m1Tdcr5wI7c',
      lastMessage: 'Basketball game tomorrow at 5?',
      timestamp: 'Yesterday',
      hasUnread: false,
    ),
  ];

  // Sample group chats
  final List<ChatData> groupChats = const [
    ChatData(
      id: 'g1',
      name: 'CS Batch 2024',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7Pce6moFrBNpBunqHcKb_ePiMmhtqpCtSPttO-sVzR0rvXWCT8ouzvJg2EULR63D5K5Cxr-6FS_cRJeke6E60YTbtbRozXrdi0KloHyg9YcR2H5KUZpuCrmSDPzHCJeM_YJjRNg2WRSZj9PPadfmju-dFnwpokeQSEhE95Y9jzLWITD0UYBFLSqQgDJTYqoH447cHexOQ3K-tRC_TXb1U6TXJe4sS8wuHVxF4DinoOqi9hiQbi5Go0ofTLBsK33imuOADLXctyV53',
      lastMessage: 'Arjun: Assignment deadline extended!',
      timestamp: '10m',
      hasUnread: true,
    ),
    ChatData(
      id: 'g2',
      name: 'TechVerse Club',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCBtO4n2Sm-ip68hnvnFevthGKNa8M6lf3J6rX-13asuvBKQ6AeXst_v-qmduT60GVw9SQR3_0n4UejmLJLsKQRF6fh-yxjKoo7Q43CyR3wYM2yuVXJPfAtzpc-K3M9Ojyf5Omfo0xbKyWR-ylD2LR7eO2AbZOdiwtLVzmzm6TMK9KxZ_mLv5P1P5BntHwfUQyDy96s-50TZ4t5w9FjRypVzsmfTfsU05_qwNZnlcRLI8GxB77euLVjktX-WnWfGG0s4ilvbgIANdjp',
      lastMessage: 'Maya: Workshop slides uploaded 📄',
      timestamp: '2h',
      hasUnread: false,
    ),
    ChatData(
      id: 'g3',
      name: 'Hostel 4 Gang',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      lastMessage: 'Who\'s ordering food tonight? 🍕',
      timestamp: 'Yesterday',
      hasUnread: true,
    ),
  ];

  void _navigateToConversation(ChatData chat) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ConversationScreen(
              chatId: chat.id,
              name: chat.name,
              avatarUrl: chat.avatarUrl,
              activityStatus: chat.status,
              activityIcon: chat.status == 'Active now' ? '🟢' : null,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      color: theme.backgroundLight,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primaryAccent.withValues(alpha: 0.03),
                  theme.backgroundLight,
                  theme.secondaryAccent.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
          // Main content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Safe area padding
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top + theme.spacingM,
                ),
              ),
              // Header title
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                  child: Text('Inbox', style: theme.heading1),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingL)),
              // Segmented control
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                  child: SegmentedControl(
                    segments: const ['Direct', 'Groups'],
                    selectedIndex: _segmentIndex,
                    onSegmentChanged: (index) {
                      setState(() => _segmentIndex = index);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingL)),
              // Search bar
              SliverToBoxAdapter(child: _buildSearchBar(context)),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingL)),
              // Pinned contacts (only for Direct)
              if (_segmentIndex == 0) ...[
                SliverToBoxAdapter(
                  child: PinnedContactsRow(
                    contacts: pinnedContacts,
                    onContactTap: (contact) {
                      // Handle contact tap
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: theme.spacingM)),
              ],
              // Chat list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chats = _segmentIndex == 0 ? directChats : groupChats;
                    if (index >= chats.length) return null;
                    return ChatListTile(
                      chat: chats[index],
                      onTap: () {
                        // Only navigate for Direct messages (not groups)
                        if (_segmentIndex == 0) {
                          _navigateToConversation(chats[index]);
                        }
                      },
                      onArchive: () {
                        // Handle archive
                      },
                      onMute: () {
                        // Handle mute
                      },
                    );
                  },
                  childCount: _segmentIndex == 0
                      ? directChats.length
                      : groupChats.length,
                ),
              ),
              // Bottom padding for nav bar
              SliverToBoxAdapter(
                child: SizedBox(
                  height: theme.spacingXXL + theme.bottomNavHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = context.cuTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacingM,
          vertical: theme.spacingS,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(theme.radiusFull),
          border: Border.all(color: theme.mutedPrimary.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radiusFull),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: theme.textSecondary,
                  size: 22,
                ),
                SizedBox(width: theme.spacingS),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: theme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search friends…',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: theme.spacingS,
                      ),
                    ),
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
