# 🎨 FinWise — Flutter UI Implementation Guide
### Based on Neobank Design Reference | Aligned with FinWise Architecture v1.0

> **Reference Design:** Neobank mobile UI (Home · Add Money · Profile screens)  
> **Target App:** FinWise — AI-Powered Personal Finance Platform  
> **Framework:** Flutter (Dart) | **Architecture:** Feature-First Clean Architecture  
> **Design Language:** Minimal · Modern · Finance-grade

---

## 📋 Table of Contents

1. [Design System & Tokens](#1-design-system--tokens)
2. [Bottom Navigation Bar](#2-bottom-navigation-bar)
3. [Screen 1 — Home / Dashboard](#3-screen-1--home--dashboard)
4. [Screen 2 — Add Money / Transfer](#4-screen-2--add-money--transfer)
5. [Screen 3 — Profile](#5-screen-3--profile)
6. [Shared Widget Patterns](#6-shared-widget-patterns)
7. [File Mapping to Architecture](#7-file-mapping-to-architecture)
8. [Complete Code Snippets](#8-complete-code-snippets)

---

## 1. Design System & Tokens

Map every visual value from the reference UI into `core/theme/` and `core/constants/`.

### 1.1 Color Palette — `app_colors.dart`

```dart
// lib/core/constants/app_colors.dart

class AppColors {
  // ── Brand / Primary ──────────────────────────────────
  static const Color primary        = Color(0xFFB5F233); // Lime green (card, CTA bg)
  static const Color primaryDark    = Color(0xFF8EBF1A); // Hover / pressed state
  static const Color onPrimary      = Color(0xFF0D0D0D); // Text on lime bg (black)

  // ── Neutral Backgrounds ───────────────────────────────
  static const Color background     = Color(0xFFF2F4F3); // App background (off-white)
  static const Color surface        = Color(0xFFFFFFFF); // Cards, bottom nav
  static const Color surfaceVariant = Color(0xFFF7F7F7); // Input fields, tiles

  // ── Ink / Text ────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF0D0D0D); // Headings, amounts
  static const Color textSecondary  = Color(0xFF6B7280); // Subtitles, labels
  static const Color textTertiary   = Color(0xFFADB5BD); // Placeholder, disabled

  // ── Semantic ──────────────────────────────────────────
  static const Color debit         = Color(0xFF0D0D0D); // Expense (negative)
  static const Color credit        = Color(0xFF22C55E); // Income / cashback (+green)
  static const Color warning       = Color(0xFFF59E0B);
  static const Color error         = Color(0xFFEF4444);

  // ── Card Variants ─────────────────────────────────────
  static const Color cardLime       = Color(0xFFB5F233); // Debit card bg
  static const Color cardDark       = Color(0xFF1A1A1A); // Credit card / dark card

  // ── Divider & Border ──────────────────────────────────
  static const Color divider        = Color(0xFFE5E7EB);
  static const Color border         = Color(0xFFD1D5DB);

  // ── Icon tray (bottom nav inactive) ───────────────────
  static const Color navInactive    = Color(0xFF9CA3AF);
  static const Color navActive      = Color(0xFF0D0D0D);
}
```

### 1.2 Typography — `app_text_styles.dart`

```dart
// lib/core/theme/app_text_styles.dart
// Font: Inter (add to pubspec.yaml + assets/fonts/)

class AppTextStyles {
  // Greeting / Page titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Section headings ("Your cards", "Transactions")
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Balance amount — monospaced for digits
  static const TextStyle amountDisplay = TextStyle(
    fontFamily: 'RobotoMono',  // or 'Inter' with tabular-nums feature
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // Card number, masked (•••• 4568)
  static const TextStyle cardNumber = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Body text, merchant name, item titles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Labels, nav items, small chips
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.navInactive,
    letterSpacing: 0.2,
  );

  // "Add money" button text
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );

  // Profile field label ("Name", "E-mail")
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Profile field value
  static const TextStyle fieldValue = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
```

### 1.3 Dimensions — `app_dimensions.dart`

```dart
// lib/core/constants/app_dimensions.dart

class AppDimensions {
  // Padding
  static const double paddingXS  = 4.0;
  static const double paddingS   = 8.0;
  static const double paddingM   = 16.0;
  static const double paddingL   = 24.0;
  static const double paddingXL  = 32.0;

  // Border radius
  static const double radiusS    = 8.0;
  static const double radiusM    = 16.0;
  static const double radiusL    = 20.0;
  static const double radiusXL   = 28.0;
  static const double radiusFull = 999.0;

  // Cards
  static const double cardHeight        = 180.0;  // Debit / credit card
  static const double cardWidth         = 300.0;
  static const double balanceCardHeight = 160.0;

  // Bottom nav
  static const double bottomNavHeight   = 64.0;

  // Avatar
  static const double avatarL           = 88.0;
  static const double avatarS           = 36.0;   // Transaction icon

  // Icon sizes
  static const double iconM             = 22.0;
  static const double iconS             = 18.0;
}
```

### 1.4 ThemeData — `app_theme.dart`

```dart
// lib/core/theme/app_theme.dart

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      background: AppColors.background,
      surface: AppColors.surface,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimary,
        foregroundColor: AppColors.surface,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        textStyle: AppTextStyles.buttonLabel,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
  );
}
```

---

## 2. Bottom Navigation Bar

### Visual Reference
Five tabs: **Home · Map · Transfer · Settings · Profile**  
Active tab icon is filled/bold black; inactive icons are grey. No labels shown except on Profile (avatar thumbnail). No visible background difference — entire bar is white with subtle top shadow.

### Widget: `finwise_bottom_nav.dart`
**File:** `lib/shared/widgets/finwise_bottom_nav.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinWiseBottomNav extends StatelessWidget {
  final int currentIndex;

  const FinWiseBottomNav({super.key, required this.currentIndex});

  static const _tabs = [
    _NavItem(icon: Icons.home_outlined,     activeIcon: Icons.home_rounded,       label: 'Home'),
    _NavItem(icon: Icons.map_outlined,      activeIcon: Icons.map_rounded,        label: 'Map'),
    _NavItem(icon: Icons.swap_horiz,        activeIcon: Icons.swap_horiz_rounded, label: 'Transfer'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded,   label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Standard icon tabs (0–3)
          ..._tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final tab = entry.value;
            final isActive = currentIndex == i;
            return _buildIconTab(
              icon: isActive ? tab.activeIcon : tab.icon,
              isActive: isActive,
              onTap: () => _onTabTapped(context, i),
            );
          }),

          // Profile tab (index 4) — shows circular avatar
          _buildProfileTab(context, isActive: currentIndex == 4),
        ],
      ),
    );
  }

  Widget _buildIconTab({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Icon(
          icon,
          size: AppDimensions.iconM,
          color: isActive ? AppColors.navActive : AppColors.navInactive,
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context, {required bool isActive}) {
    return GestureDetector(
      onTap: () => _onTabTapped(context, 4),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: AppColors.primary, width: 2.5)
              : null,
          image: const DecorationImage(
            image: NetworkImage('https://i.pravatar.cc/150?img=12'), // replace with user avatar
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    const routes = ['/home', '/map', '/transfer', '/settings', '/profile'];
    context.go(routes[index]);
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
```

---

## 3. Screen 1 — Home / Dashboard

### Visual Breakdown

```
┌─────────────────────────────────────┐
│  Good morning, Terry         🔔     │  ← GreetingHeader
│  Welcome to FinWise                 │
├─────────────────────────────────────┤
│  ┌───────────────────────────────┐  │
│  │  Your balance          👁      │  │  ← BalanceCard
│  │  ₹3,200.00                    │  │
│  │  [ + Add money ]              │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  Your cards            + New card   │  ← CardsSectionHeader
│  ┌──────────────┐  ┌─────────────┐ │
│  │  N.       🔴  │  │  VISA    🔴 │ │  ← HorizontalCardCarousel
│  │  (lime green) │  │  (dark)     │ │
│  │  Debit Card   │  │  Credit Card│ │
│  │  •••• 4568   │  │  •••• 2478  │ │
│  └──────────────┘  └─────────────┘ │
├─────────────────────────────────────┤
│  Transactions          See all      │  ← TransactionsSectionHeader
│  ┌───────────────────────────────┐  │
│  │  ☕ Starbucks Coffee  -₹44.80  │  │  ← TransactionListItem (recent)
│  │     Oct 17, 09:00 PM  +₹1.65  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
     [Home] [Map] [Transfer] [Settings] [👤]
```

### `dashboard_screen.dart`

```dart
// lib/features/dashboard/presentation/screens/dashboard_screen.dart

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Greeting header ──────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingL, AppDimensions.paddingM,
                  AppDimensions.paddingL, 0,
                ),
                child: GreetingHeader(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Balance card ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: BalanceCard(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Cards carousel ───────────────────────────
            SliverToBoxAdapter(
              child: CardsSectionHeader(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(
              child: BankCardsCarousel(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // ── Transactions ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: TransactionsSectionHeader(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: RecentTransactionsList(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)), // nav clearance
          ],
        ),
      ),
      bottomNavigationBar: const FinWiseBottomNav(currentIndex: 0),
    );
  }
}
```

### 3.1 Widget: `GreetingHeader`

```dart
// lib/features/dashboard/presentation/widgets/greeting_header.dart

class GreetingHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with actual user from authProvider
    final userName = 'Terry';
    final greeting = _getGreeting();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$greeting, $userName', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 2),
            Text('Welcome to FinWise', style: AppTextStyles.bodySmall),
          ],
        ),
        // Notification bell with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: const Icon(Icons.notifications_outlined,
                  size: AppDimensions.iconM, color: AppColors.textPrimary),
            ),
            // Unread dot
            Positioned(
              top: 8, right: 10,
              child: Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
```

### 3.2 Widget: `BalanceCard`

```dart
// lib/features/dashboard/presentation/widgets/monthly_spend_card.dart
// (repurposed as BalanceCard matching reference UI)

class BalanceCard extends ConsumerStatefulWidget {
  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + eye toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your balance', style: AppTextStyles.bodySmall),
              GestureDetector(
                onTap: () => setState(() => _isHidden = !_isHidden),
                child: Icon(
                  _isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: AppDimensions.iconS,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Amount
          Text(
            _isHidden ? '••••••' : '₹3,200.00',
            style: AppTextStyles.amountDisplay,
          ),
          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.push('/add-money'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              child: const Text('Add money', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.3 Widget: `BankCardsCarousel`

The reference shows a horizontal scrollable list of payment cards. **Debit card** uses lime green (`#B5F233`); **Credit card** uses dark (`#1A1A1A`).

```dart
// lib/features/dashboard/presentation/widgets/bank_cards_carousel.dart

class BankCardsCarousel extends StatelessWidget {
  const BankCardsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        children: const [
          BankCardItem(
            type: CardType.debit,
            maskedNumber: '4568',
            cardColor: AppColors.cardLime,
            textColor: AppColors.textPrimary,
          ),
          SizedBox(width: 12),
          BankCardItem(
            type: CardType.credit,
            maskedNumber: '2478',
            cardColor: AppColors.cardDark,
            textColor: Colors.white,
          ),
          SizedBox(width: 12),
          // "Add new card" placeholder tile
          _AddCardTile(),
        ],
      ),
    );
  }
}

enum CardType { debit, credit }

class BankCardItem extends StatelessWidget {
  final CardType type;
  final String maskedNumber;
  final Color cardColor;
  final Color textColor;

  const BankCardItem({
    super.key,
    required this.type,
    required this.maskedNumber,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.cardWidth,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card logo row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'N.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              // Network logo (Mastercard circles or VISA text)
              _buildNetworkLogo(),
            ],
          ),

          const Spacer(),

          // Card type label + "Details" button (debit only)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == CardType.debit ? 'Debit Card' : 'Credit Card',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '•••• $maskedNumber',
                    style: AppTextStyles.cardNumber.copyWith(color: textColor),
                  ),
                ],
              ),
              // "Details" pill (only on primary/active card)
              if (type == CardType.debit)
                _DetailsButton(textColor: textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkLogo() {
    if (type == CardType.debit) {
      // Mastercard — two overlapping circles
      return SizedBox(
        width: 40, height: 26,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: 26, height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEB001B),
                ),
              ),
            ),
            Positioned(
              left: 14,
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      );
    }
    // VISA text logo
    return const Text(
      'VISA',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  final Color textColor;
  const _DetailsButton({required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.remove_red_eye_outlined, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text('Details', style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _AddCardTile extends StatelessWidget {
  const _AddCardTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: const Center(
        child: Icon(Icons.add, color: AppColors.textSecondary, size: 28),
      ),
    );
  }
}
```

### 3.4 Widget: `CardsSectionHeader`

```dart
// lib/features/dashboard/presentation/widgets/cards_section_header.dart

class CardsSectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Your cards', style: AppTextStyles.titleLarge),
          GestureDetector(
            onTap: () => context.push('/cards/new'),
            child: Row(
              children: [
                const Icon(Icons.add, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 2),
                Text('New card', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### 3.5 Widget: `RecentTransactionsList`

```dart
// lib/features/dashboard/presentation/widgets/recent_transactions_list.dart

class RecentTransactionsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with actual transactions from provider
    final transactions = [
      _TxDemo(
        icon: '☕',
        merchant: 'Starbucks Coffee',
        datetime: 'October 17, 09:00 PM',
        amount: '-₹44.80',
        cashback: '+₹1.65',
        isDebit: true,
      ),
      // Add more demo items as needed
    ];

    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transactions', style: AppTextStyles.titleLarge),
              GestureDetector(
                onTap: () => context.push('/transactions'),
                child: Text('See all', style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // List
        ...transactions.map((tx) => Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL, vertical: 4),
          child: TransactionListItem(
            emoji: tx.icon,
            merchant: tx.merchant,
            datetime: tx.datetime,
            amount: tx.amount,
            cashback: tx.cashback,
            isDebit: tx.isDebit,
          ),
        )),
      ],
    );
  }
}
```

### 3.6 Widget: `TransactionListItem`

```dart
// lib/features/transactions/presentation/widgets/transaction_list_item.dart

class TransactionListItem extends StatelessWidget {
  final String emoji;
  final String merchant;
  final String datetime;
  final String amount;
  final String? cashback;
  final bool isDebit;

  const TransactionListItem({
    super.key,
    required this.emoji,
    required this.merchant,
    required this.datetime,
    required this.amount,
    this.cashback,
    this.isDebit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          // Merchant icon
          Container(
            width: AppDimensions.avatarS,
            height: AppDimensions.avatarS,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),

          // Merchant + datetime
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(merchant, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 2),
                Text(datetime, style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          // Amount + cashback badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDebit ? AppColors.textPrimary : AppColors.credit,
                ),
              ),
              if (cashback != null) ...[
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    cashback!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## 4. Screen 2 — Add Money / Transfer

### Visual Breakdown

```
┌─────────────────────────────────────┐
│  ←     Add money                    │  ← AppBar with back button
├─────────────────────────────────────┤
│  Select card                        │
│  ┌──────────┐  ┌──────────┐  ┌───  │  ← HorizontalCardSelector
│  │  (lime)  │  │  (dark)  │  │ ... │  (smaller pill-style cards)
│  │ Debit •4568│ │ Credit •2478│     │
│  └──────────┘  └──────────┘        │
├─────────────────────────────────────┤
│  Add money to FinWise               │
│  ┌───────────────────────────────┐  │
│  │  ↻  Move your direct deposit  ›  │  ← AddMoneyOptionTile
│  ├───────────────────────────────┤  │
│  │  ⇄  Transfer from other banks ›  │
│  ├───────────────────────────────┤  │
│  │  🍎 Apple Pay               ›  │
│  ├───────────────────────────────┤  │
│  │  💳 Debit / Credit Card      ›  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### `add_money_screen.dart`

```dart
// lib/features/transactions/presentation/screens/add_money_screen.dart

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  int _selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.paddingL),

          // ── Card selector ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
            child: Text('Select card', style: AppTextStyles.titleLarge),
          ),
          const SizedBox(height: 14),
          AddMoneyCardSelector(
            selectedIndex: _selectedCardIndex,
            onChanged: (i) => setState(() => _selectedCardIndex = i),
          ),

          const SizedBox(height: 28),

          // ── Options ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
            child: Text('Add money to FinWise', style: AppTextStyles.titleLarge),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
              child: AddMoneyOptionsList(),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.1 Widget: `AddMoneyCardSelector`

```dart
// lib/features/transactions/presentation/widgets/add_money_card_selector.dart

class AddMoneyCardSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AddMoneyCardSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const _cards = [
    _CardMeta(label: 'Debit card', masked: '4568', color: AppColors.cardLime, textColor: AppColors.textPrimary),
    _CardMeta(label: 'Credit card', masked: '2478', color: AppColors.cardDark, textColor: Colors.white),
    _CardMeta(label: 'Bank', masked: '···', color: Color(0xFF4B5563), textColor: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        itemCount: _cards.length,
        itemBuilder: (context, i) {
          final card = _cards[i];
          final isSelected = selectedIndex == i;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 110,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: card.color,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: isSelected
                    ? Border.all(color: AppColors.textPrimary, width: 2.5)
                    : null,
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Network indicator dot
                  Row(
                    children: [
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle)),
                    ],
                  ),
                  const Spacer(),
                  Text(card.label, style: TextStyle(fontSize: 10, color: card.textColor.withOpacity(0.7))),
                  Text('•••• ${card.masked}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: card.textColor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardMeta {
  final String label, masked;
  final Color color, textColor;
  const _CardMeta({required this.label, required this.masked, required this.color, required this.textColor});
}
```

### 4.2 Widget: `AddMoneyOptionsList`

```dart
// lib/features/transactions/presentation/widgets/add_money_options_list.dart

class AddMoneyOptionsList extends StatelessWidget {
  const AddMoneyOptionsList({super.key});

  static const _options = [
    _Option(icon: Icons.loop_rounded,          label: 'Move your direct deposit'),
    _Option(icon: Icons.swap_horiz_rounded,    label: 'Transfer from other banks'),
    _Option(icon: Icons.apple_rounded,         label: 'Apple Pay'),           // use custom SVG for Apple logo
    _Option(icon: Icons.credit_card_rounded,   label: 'Debit / Credit Card'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _options.asMap().entries.map((entry) {
          final i = entry.key;
          final opt = entry.value;
          final isLast = i == _options.length - 1;
          return Column(
            children: [
              AddMoneyOptionTile(icon: opt.icon, label: opt.label),
              if (!isLast)
                const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class AddMoneyOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const AddMoneyOptionTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      onTap: () {}, // navigate to specific flow
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingM),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(icon, size: AppDimensions.iconS, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTextStyles.bodyLarge),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _Option {
  final IconData icon;
  final String label;
  const _Option({required this.icon, required this.label});
}
```

---

## 5. Screen 3 — Profile

### Visual Breakdown

```
┌─────────────────────────────────────┐
│            Profile                  │  ← AppBar (centered title)
│                                     │
│           [  👤 avatar  ]           │  ← CircleAvatar (88px) + edit icon
│                ✏️                   │
├─────────────────────────────────────┤
│  Personal info              Edit    │
│  ┌───────────────────────────────┐  │
│  │ 👤  Name                      │  │
│  │     Terry Melton              │  │
│  │ ✉️  E-mail                    │  │
│  │     melton89@gmail.com        │  │
│  │ 📞  Phone number              │  │
│  │     +1 201 555-0123           │  │
│  │ 🏠  Home address              │  │
│  │     70 Rainey Street, ...     │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│  Account info                       │  ← Account info section (truncated)
└─────────────────────────────────────┘
     [Home] [Map] [Transfer] [Settings] [👤]
```

### `profile_screen.dart`

```dart
// lib/features/profile/presentation/screens/profile_screen.dart

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingL),

              // Avatar
              ProfileAvatarSection(),

              const SizedBox(height: AppDimensions.paddingXL),

              // Personal info card
              ProfileInfoCard(
                sectionTitle: 'Personal info',
                onEdit: () {},
                fields: const [
                  ProfileField(icon: Icons.person_outline_rounded,   label: 'Name',         value: 'Terry Melton'),
                  ProfileField(icon: Icons.email_outlined,           label: 'E-mail',       value: 'melton89@gmail.com'),
                  ProfileField(icon: Icons.phone_outlined,           label: 'Phone number', value: '+1 201 555-0123'),
                  ProfileField(icon: Icons.home_outlined,            label: 'Home address', value: '70 Rainey Street, Apartment 146, Austin TX 78701'),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // Account info card
              ProfileInfoCard(
                sectionTitle: 'Account info',
                onEdit: null,
                fields: const [
                  ProfileField(icon: Icons.badge_outlined,  label: 'Account type', value: 'FinWise Pro'),
                  ProfileField(icon: Icons.calendar_today_outlined, label: 'Member since', value: 'January 2024'),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FinWiseBottomNav(currentIndex: 4),
    );
  }
}
```

### 5.1 Widget: `ProfileAvatarSection`

```dart
// lib/features/profile/presentation/widgets/profile_avatar_section.dart

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: AppDimensions.avatarL,
          height: AppDimensions.avatarL,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider, width: 2),
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?img=12'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Edit icon bubble
        GestureDetector(
          onTap: () {/* open image picker */},
          child: Container(
            width: 30, height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: const Icon(Icons.edit_outlined,
                size: 15, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
```

### 5.2 Widget: `ProfileInfoCard`

```dart
// lib/features/profile/presentation/widgets/profile_info_card.dart

class ProfileInfoCard extends StatelessWidget {
  final String sectionTitle;
  final VoidCallback? onEdit;
  final List<ProfileField> fields;

  const ProfileInfoCard({
    super.key,
    required this.sectionTitle,
    required this.fields,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sectionTitle, style: AppTextStyles.titleLarge),
            if (onEdit != null)
              GestureDetector(
                onTap: onEdit,
                child: Text('Edit',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.underline)),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Fields card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
          child: Column(
            children: fields.asMap().entries.map((entry) {
              final isLast = entry.key == fields.length - 1;
              return Column(
                children: [
                  _ProfileFieldTile(field: entry.value),
                  if (!isLast)
                    const Divider(height: 1, indent: 52, endIndent: 0, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProfileFieldTile extends StatelessWidget {
  final ProfileField field;
  const _ProfileFieldTile({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(field.icon, size: AppDimensions.iconS, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label, style: AppTextStyles.fieldLabel),
                const SizedBox(height: 2),
                Text(field.value, style: AppTextStyles.fieldValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileField {
  final IconData icon;
  final String label;
  final String value;
  const ProfileField({required this.icon, required this.label, required this.value});
}
```

---

## 6. Shared Widget Patterns

### 6.1 Section Header (reusable)

```dart
// lib/shared/widgets/section_header.dart

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(actionLabel!, style: AppTextStyles.bodySmall),
          ),
      ],
    );
  }
}
```

### 6.2 Amount Badge (cashback / credit chip)

```dart
// lib/shared/widgets/amount_badge.dart

class AmountBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const AmountBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.onPrimary,
        ),
      ),
    );
  }
}
```

### 6.3 FinWise AppBar (custom back-arrow style)

```dart
// lib/shared/widgets/finwise_app_bar.dart

class FinWiseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const FinWiseAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: showBack
          ? GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.textPrimary),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

---

## 7. File Mapping to Architecture

| UI Component | File Path in Architecture |
|---|---|
| `DashboardScreen` | `lib/features/dashboard/presentation/screens/dashboard_screen.dart` |
| `GreetingHeader` | `lib/features/dashboard/presentation/widgets/greeting_header.dart` |
| `BalanceCard` | `lib/features/dashboard/presentation/widgets/monthly_spend_card.dart` |
| `BankCardsCarousel` | `lib/features/dashboard/presentation/widgets/bank_cards_carousel.dart` *(new)* |
| `BankCardItem` | `lib/features/dashboard/presentation/widgets/bank_card_item.dart` *(new)* |
| `RecentTransactionsList` | `lib/features/dashboard/presentation/widgets/recent_transactions_list.dart` |
| `TransactionListItem` | `lib/features/transactions/presentation/widgets/transaction_list_item.dart` |
| `AddMoneyScreen` | `lib/features/transactions/presentation/screens/add_transaction_screen.dart` *(repurpose)* |
| `AddMoneyCardSelector` | `lib/features/transactions/presentation/widgets/payment_method_selector.dart` |
| `AddMoneyOptionsList` | `lib/features/transactions/presentation/widgets/add_money_options_list.dart` *(new)* |
| `ProfileScreen` | `lib/features/profile/presentation/screens/profile_screen.dart` |
| `ProfileAvatarSection` | `lib/features/profile/presentation/widgets/profile_avatar_section.dart` *(new)* |
| `ProfileInfoCard` | `lib/features/profile/presentation/widgets/profile_info_card.dart` *(new)* |
| `FinWiseBottomNav` | `lib/shared/widgets/finwise_bottom_nav.dart` |
| `SectionHeader` | `lib/shared/widgets/section_header.dart` |
| `AmountBadge` | `lib/shared/widgets/amount_badge.dart` |
| `FinWiseAppBar` | `lib/shared/widgets/finwise_app_bar.dart` |
| `AppColors` | `lib/core/constants/app_colors.dart` |
| `AppTextStyles` | `lib/core/theme/app_text_styles.dart` |
| `AppDimensions` | `lib/core/constants/app_dimensions.dart` |
| `AppTheme` | `lib/core/theme/app_theme.dart` |

---

## 8. Complete Code Snippets

### 8.1 GoRouter — Shell with Bottom Nav

```dart
// lib/core/router/app_router.dart

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(path: '/home',     builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/map',      builder: (_, __) => const MapScreen()),
        GoRoute(path: '/transfer', builder: (_, __) => const TransferScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(path: '/profile',  builder: (_, __) => const ProfileScreen()),
      ],
    ),
    // Full-screen routes (no nav)
    GoRoute(path: '/add-money', builder: (_, __) => const AddMoneyScreen()),
    GoRoute(path: '/transactions', builder: (_, __) => const TransactionsScreen()),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = ['/home', '/map', '/transfer', '/settings', '/profile']
        .indexOf(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: FinWiseBottomNav(currentIndex: index.clamp(0, 4)),
    );
  }
}
```

### 8.2 `pubspec.yaml` additions for fonts

```yaml
# pubspec.yaml

flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
        - asset: assets/fonts/Inter-ExtraBold.ttf
          weight: 800
    - family: RobotoMono
      fonts:
        - asset: assets/fonts/RobotoMono-Regular.ttf
          weight: 400
        - asset: assets/fonts/RobotoMono-Medium.ttf
          weight: 500
        - asset: assets/fonts/RobotoMono-Bold.ttf
          weight: 700
```

### 8.3 Wiring theme in `app.dart`

```dart
// lib/app.dart

class FinWiseApp extends ConsumerWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'FinWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
```

---

## 🎨 Visual Design Checklist

Use this when reviewing screens against the reference image:

- [ ] Background is off-white `#F2F4F3`, **not** pure white
- [ ] Cards have **no border**, use white surface on grey background for contrast
- [ ] Balance amount uses **monospaced / tabular** font
- [ ] Debit card is **lime green** `#B5F233` with black text
- [ ] Credit card is **near-black** `#1A1A1A` with white text
- [ ] Mastercard logo is two overlapping circles (red + orange), not an image asset
- [ ] Cashback chip uses lime green with black bold text
- [ ] "Add money" CTA is full-width, **pill-shaped**, solid black
- [ ] Bottom nav icons are grey when inactive, black when active
- [ ] Profile tab shows **circular avatar thumbnail**, not an icon
- [ ] All card corners use `borderRadius: 20–28`
- [ ] Dividers in lists are `indent: 52` (aligned after leading icon)
- [ ] AppBar has **no shadow**, blends with background
- [ ] Typography: headings are `Inter 700`, body is `Inter 400/500`

---

*UI Guide Version 1.0 | FinWise Flutter Team*  
*Reference: Neobank UI (Home · Add Money · Profile) → Adapted for FinWise AI Finance Platform*  
*Architecture: Feature-First Clean Architecture | Riverpod | GoRouter*
