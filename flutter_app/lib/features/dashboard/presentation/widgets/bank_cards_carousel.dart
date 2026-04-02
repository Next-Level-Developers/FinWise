import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class BankCardsCarousel extends StatelessWidget {
  const BankCardsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        children: const <Widget>[
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
          _AddCardTile(),
        ],
      ),
    );
  }
}

enum CardType { debit, credit }

class BankCardItem extends StatelessWidget {
  const BankCardItem({
    super.key,
    required this.type,
    required this.maskedNumber,
    required this.cardColor,
    required this.textColor,
  });

  final CardType type;
  final String maskedNumber;
  final Color cardColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.cardWidth,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'N.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              _buildNetworkLogo(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    type == CardType.debit ? 'Debit Card' : 'Credit Card',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '•••• $maskedNumber',
                    style: AppTextStyles.cardNumber.copyWith(color: textColor),
                  ),
                ],
              ),
              if (type == CardType.debit) _DetailsButton(textColor: textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkLogo() {
    if (type == CardType.debit) {
      return SizedBox(
        width: 40,
        height: 26,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEB001B),
                ),
              ),
            ),
            Positioned(
              left: 14,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
  const _DetailsButton({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.remove_red_eye_outlined, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            'Details',
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
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
