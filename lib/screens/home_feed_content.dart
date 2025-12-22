// Home Feed Content
//
// Feed content without navigation bar (used inside MainShellScreen).
// Shows stories row and post cards.

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/story_circle.dart';
import '../widgets/post_card.dart';

class HomeFeedContent extends StatelessWidget {
  const HomeFeedContent({super.key});

  // Sample data
  static const StoryData _myStory = StoryData(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuATbxvPrSOQMYmwil7e9XLqQmU1eqD42GSJuBRMdeX5Kk94wJYo1b8RMm2745ge042PR01v9ZMd31qY2aFkvpXyXC4v7sgkJrz-5IIjFzqpPOdq8Bwh1-wz61BZz4EQFoQESPcvQjJiTDYfwkL7dE1JvPdtygty9YXXWRnioFXRLBBFELaSWkJ2LiV9DCjUtqYvAb9Wbjr8oqA6b6wuf3GUwEH__Se8QyK8UX7SWzt0CrAoIKwVtHOFucMvO4finDatSX8V3Pgx2jZw',
    name: 'My Story',
    hasUnseenStory: false,
  );

  static const List<StoryData> _stories = [
    StoryData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      name: 'Sarah',
      hasUnseenStory: true,
    ),
    StoryData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
      name: 'James',
      hasUnseenStory: false,
    ),
    StoryData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      name: 'Elara',
      hasUnseenStory: true,
    ),
    StoryData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
      name: 'Mike',
      hasUnseenStory: true,
    ),
  ];

  static const List<PostData> _posts = [
    PostData(
      userName: 'Anna Travels',
      userHandle: '@anna_travels',
      userAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuATbxvPrSOQMYmwil7e9XLqQmU1eqD42GSJuBRMdeX5Kk94wJYo1b8RMm2745ge042PR01v9ZMd31qY2aFkvpXyXC4v7sgkJrz-5IIjFzqpPOdq8Bwh1-wz61BZz4EQFoQESPcvQjJiTDYfwkL7dE1JvPdtygty9YXXWRnioFXRLBBFELaSWkJ2LiV9DCjUtqYvAb9Wbjr8oqA6b6wuf3GUwEH__Se8QyK8UX7SWzt0CrAoIKwVtHOFucMvO4finDatSX8V3Pgx2jZw',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEVVoh-Uary0BlW9Tge9pwf0cnABIYG_JRk-IKPyalPqPz0rmaMZPO4snt2x3BmtCqFVCB6WKsVuVwzWzrW0MckNH44I4xUgKbdad5Z9arNXto3p60uSDvWazuXWTic63Jk_A7GvZmJX_KHXZUck2-1MuW4aQ8knHnNgUe-ieOhwe13JxJyyPk_-X0ogKbRd49ON0XccNdUMj-zBNvV5vlIRMI-kzDbcTD-lVtEQN6JR7d7RHP-uI-g1-4U-dhe6RH9m1Tdcr5wI7c',
      title: 'Golden Hour at the Coast',
      description:
          'Unforgettable sunset hues painting the sky after a long week of classes. Campus life isn\'t just about books, it\'s about these moments too. 🌅',
      likes: 1200,
      comments: 45,
      featuredComment: CommentData(
        userName: 'Mike',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
        text: 'So inspiring! Need to visit this spot soon!',
      ),
    ),
    PostData(
      userName: 'Sarah_Art',
      userHandle: '@sarah_creates',
      userAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDW8SKaAIpXE4Bc10lD-n4hHGyjdjmHuO1q6oDIaxRqG_QD_ZpsvThmCHmTCk3F4rMXYrEoRJR5ALtatJX2B_K0hrBqgeB3GCdWyt-9x3FOomT6VpQwU2_xRjdgH3GMeWGnO-V3TPil9R5_PMxouZFYAxjiXlJRwiXWwxSG8DoWOypXTzMjaD5lQqh35RBtQJETQceNda-EVKQZ_mG4g5h8-Fx8Uk5Nrex-lxbKInzCUpjIH51lKSymYtgfF59Lcg_A_znHtz1F9VNx',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7Pce6moFrBNpBunqHcKb_ePiMmhtqpCtSPttO-sVzR0rvXWCT8ouzvJg2EULR63D5K5Cxr-6FS_cRJeke6E60YTbtbRozXrdi0KloHyg9YcR2H5KUZpuCrmSDPzHCJeM_YJjRNg2WRSZj9PPadfmju-dFnwpokeQSEhE95Y9jzLWITD0UYBFLSqQgDJTYqoH447cHexOQ3K-tRC_TXb1U6TXJe4sS8wuHVxF4DinoOqi9hiQbi5Go0ofTLBsK33imuOADLXctyV53',
      title: 'Morning Serenity',
      description:
          'Exploring warm tones and soft textures in my latest digital piece. Inspired by cozy campus coffee breaks and quiet study sessions. ☕️',
      likes: 987,
      comments: 32,
      featuredComment: CommentData(
        userName: 'James_P',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC5QuE7Lgtjhn_TpA49dYu3-ucvtk8RS6-vdY0z3jdwJm-svXXSpwO4khth_0J58SFCEKCVmVuccTYLvc280ShktJtrzbOMkcCySt60iZ7K3QwiXHcGfrml8rpvWB184okRiStZu6HbjIXOCsUiszjOcdl0xGNKjjYjr6WReCCr7g4ukjdOk12JBxrlIOT6FlUMBFW1m7tgvEwofZgnlc8oANofgjVjKnzELaOLwavfTor_Vom99EYBThgwQ2fgDtL7disfm8SeEwgM',
        text: 'Love the muted palette! Great work!',
      ),
    ),
    PostData(
      userName: 'Elara Events',
      userHandle: '@campus_happenings',
      userAvatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASMJ6LU2YbScvSwmftMYza95Y2I1D29RTrDr64zT3VoWsLUs8hPXx8-HFkt5FwaGsWVKaKL2-DsF-QQujhbdR8rdcHi5LP_scTq2nG1WQXUhDFGOKb9A2bTlGEL1xLJB0nojqU7m2qWqyJsM1rh4RVclmDvsz45P2hsEezA9ZfdkgBSXG_acujwJmK9fWWxC3yMPOmxx4PFsc4PNd9joYKCyDDLcivAb_4-z93jXk0sz7yN9ia_ceFayQ_A4-kUCoWQNp6CzL5QsRW',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCBtO4n2Sm-ip68hnvnFevthGKNa8M6lf3J6rX-13asuvBKQ6AeXst_v-qmduT60GVw9SQR3_0n4UejmLJLsKQRF6fh-yxjKoo7Q43CyR3wYM2yuVXJPfAtzpc-K3M9Ojyf5Omfo0xbKyWR-ylD2LR7eO2AbZOdiwtLVzmzm6TMK9KxZ_mLv5P1P5BntHwfUQyDy96s-50TZ4t5w9FjRypVzsmfTfsU05_qwNZnlcRLI8GxB77euLVjktX-WnWfGG0s4ilvbgIANdjp',
      title: 'Spring Fashion Showcase',
      description:
          'A sneak peek at the designs from our annual student fashion show! Incredible talent making waves on campus. 👗',
      likes: 1800,
      comments: 68,
      featuredComment: CommentData(
        userName: 'Mike_Styles',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuABWMLXw-v7YdY2B2Tk_al8-iqushRz0v04r-el02DzcTmDST8yMtuVNv9Joj092bJvCW2jAHfM5LZcFMzTTbvAKFefBUFks38_oHMqlUDKCi7qNJjGmUuPKHctBJ4zHKAvdOiB9in5K5CRvQwh17wSyG1utQcYx-bEC5-6yLPEVWMcYSMmB4jYEIOQvlp4CZ6kmcH0sSfASlVtGVaMjbMUA2BAzY89LKdBXuqtOIu-f7TSZ1PbEFbIH19I6aL47GzwFEa0V-7yoibs',
        text: 'That yellow outfit is stunning! Great job everyone!',
      ),
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
              // Header
              SliverToBoxAdapter(child: _buildHeader(context)),
              // Stories
              SliverToBoxAdapter(child: _buildStoriesSection(context)),
              // Posts
              SliverPadding(
                padding: EdgeInsets.only(
                  left: theme.spacingM,
                  right: theme.spacingM,
                  bottom: theme.spacingXXL + theme.bottomNavHeight,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: theme.spacingL),
                      child: PostCard(post: _posts[index]),
                    );
                  }, childCount: _posts.length),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + theme.spacingM,
        left: theme.spacingL,
        right: theme.spacingL,
        bottom: theme.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CULink',
            style: theme.heading1.copyWith(fontSize: 32, letterSpacing: -0.5),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.mutedPrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: theme.textPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      padding: EdgeInsets.only(bottom: theme.spacingM),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.mutedPrimary.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: StoriesRow(myStory: _myStory, stories: _stories),
    );
  }
}
