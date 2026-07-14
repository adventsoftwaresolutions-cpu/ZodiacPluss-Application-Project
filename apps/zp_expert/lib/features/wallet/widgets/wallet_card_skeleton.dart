import 'package:flutter/material.dart';
import 'package:zp_expert/shared/widgets/shimmer_box.dart';

class WalletCardSkeleton extends StatelessWidget {
  const WalletCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 100, height: 14),
                    SizedBox(height: 10),
                    ShimmerBox(width: 160, height: 34),
                  ],
                ),
              ),
              ShimmerBox(width: 100, height: 100, borderRadius: 50),
            ],
          ),
          SizedBox(height: 28),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 90, height: 12),
                    SizedBox(height: 8),
                    ShimmerBox(width: 80, height: 20),
                    SizedBox(height: 6),
                    ShimmerBox(width: 70, height: 11),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerBox(width: 100, height: 12),
                    SizedBox(height: 8),
                    ShimmerBox(width: 70, height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}