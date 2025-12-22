// Connections Screen
//
// Friends and connections page with search, friend requests,
// vibe match discovery, and network list.

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/search_header.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/vibe_match_card.dart';
import '../widgets/network_list.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  int _selectedFilterIndex = -1;

  // Sample data - replace with real data
  final List<FilterChipData> filters = const [
    FilterChipData(label: 'My Dept'),
    FilterChipData(label: 'Hostel 4'),
    FilterChipData(label: 'TechVerse Club'),
    FilterChipData(label: 'CS Batch 24'),
  ];

  final List<FriendRequestData> friendRequests = const [
    FriendRequestData(
      id: '1',
      name: 'Priya Sharma',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      major: 'Computer Science',
      mutualConnection: '5 mutual friends',
    ),
    FriendRequestData(
      id: '2',
      name: 'Arjun Patel',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
      major: 'Data Science',
      mutualConnection: 'Via TechVerse',
    ),
    FriendRequestData(
      id: '3',
      name: 'Maya Singh',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      major: 'Design',
    ),
  ];

  final List<VibeMatchData> vibeMatches = const [
    VibeMatchData(
      id: '1',
      name: 'Riya Kapoor',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuATbxvPrSOQMYmwil7e9XLqQmU1eqD42GSJuBRMdeX5Kk94wJYo1b8RMm2745ge042PR01v9ZMd31qY2aFkvpXyXC4v7sgkJrz-5IIjFzqpPOdq8Bwh1-wz61BZz4EQFoQESPcvQjJiTDYfwkL7dE1JvPdtygty9YXXWRnioFXRLBBFELaSWkJ2LiV9DCjUtqYvAb9Wbjr8oqA6b6wuf3GUwEH__Se8QyK8UX7SWzt0CrAoIKwVtHOFucMvO4finDatSX8V3Pgx2jZw',
      vibeTag: '🎸 Plays Guitar',
    ),
    VibeMatchData(
      id: '2',
      name: 'Vivek Reddy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
      vibeTag: '♟️ Plays Chess',
    ),
    VibeMatchData(
      id: '3',
      name: 'Ananya Das',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEVVoh-Uary0BlW9Tge9pwf0cnABIYG_JRk-IKPyalPqPz0rmaMZPO4snt2x3BmtCqFVCB6WKsVuVwzWzrW0MckNH44I4xUgKbdad5Z9arNXto3p60uSDvWazuXWTic63Jk_A7GvZmJX_KHXZUck2-1MuW4aQ8knHnNgUe-ieOhwe13JxJyyPk_-X0ogKbRd49ON0XccNdUMj-zBNvV5vlIRMI-kzDbcTD-lVtEQN6JR7d7RHP-uI-g1-4U-dhe6RH9m1Tdcr5wI7c',
      vibeTag: '📚 Bookworm',
    ),
  ];

  final List<NetworkMemberData> networkMembers = const [
    NetworkMemberData(
      id: '1',
      name: 'Rahul Mehta',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
      status: 'Studying at Library',
      isOnline: true,
    ),
    NetworkMemberData(
      id: '2',
      name: 'Sneha Iyer',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      status: 'At the Cafeteria',
      isOnline: true,
    ),
    NetworkMemberData(
      id: '3',
      name: 'Karan Verma',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
      status: 'Last seen 2h ago',
      isOnline: false,
    ),
    NetworkMemberData(
      id: '4',
      name: 'Nisha Gupta',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      status: 'In a meeting',
      isOnline: false,
    ),
    NetworkMemberData(
      id: '5',
      name: 'Aditya Roy',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuATbxvPrSOQMYmwil7e9XLqQmU1eqD42GSJuBRMdeX5Kk94wJYo1b8RMm2745ge042PR01v9ZMd31qY2aFkvpXyXC4v7sgkJrz-5IIjFzqpPOdq8Bwh1-wz61BZz4EQFoQESPcvQjJiTDYfwkL7dE1JvPdtygty9YXXWRnioFXRLBBFELaSWkJ2LiV9DCjUtqYvAb9Wbjr8oqA6b6wuf3GUwEH__Se8QyK8UX7SWzt0CrAoIKwVtHOFucMvO4finDatSX8V3Pgx2jZw',
      status: 'Playing Basketball',
      isOnline: true,
    ),
  ];

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
                  theme.primaryAccent.withValues(alpha: 0.05),
                  theme.backgroundLight,
                  theme.secondaryAccent.withValues(alpha: 0.05),
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
                  child: Text('Connections', style: theme.heading1),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingL)),
              // Search header
              SliverToBoxAdapter(
                child: SearchHeader(
                  hintText: 'Find classmates, seniors…',
                  filters: filters,
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (index) {
                    setState(() {
                      _selectedFilterIndex = _selectedFilterIndex == index
                          ? -1
                          : index;
                    });
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingXL)),
              // Friend requests section
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Pending Invites',
                  child: SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                      itemCount: friendRequests.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: theme.spacingM),
                      itemBuilder: (context, index) {
                        return FriendRequestCard(
                          request: friendRequests[index],
                          onAccept: () {
                            // Handle accept
                          },
                          onDecline: () {
                            // Handle decline
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingXL)),
              // Vibe match section
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Vibe Match ✨',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                    child: VibeMatchGrid(
                      matches: vibeMatches,
                      onCardTap: (match) {
                        // Handle card tap
                      },
                      onAddTap: (match) {
                        // Handle add
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: theme.spacingXL)),
              // Network section
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  title: 'Your Network',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                    child: NetworkList(
                      members: networkMembers,
                      onMemberTap: (member) {
                        // Handle member tap
                      },
                      onChatTap: (member) {
                        // Handle chat
                      },
                    ),
                  ),
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = context.cuTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
          child: Text(title, style: theme.heading3),
        ),
        SizedBox(height: theme.spacingM),
        child,
      ],
    );
  }
}
