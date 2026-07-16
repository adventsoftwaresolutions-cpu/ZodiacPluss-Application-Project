import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_radius.dart';
import '../data/models/review_model.dart';

enum _ReviewAction { report }

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    required this.review,
    required this.onReport,
    super.key,
  });

  final ExpertReview review;
  final VoidCallback onReport;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? .99 : 1,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ReviewHeader(review: widget.review, onReport: _report),
              const SizedBox(height: 12),
              _Stars(rating: widget.review.rating),
              const SizedBox(height: 10),
              Text(
                widget.review.comment,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withValues(alpha: .78),
                      height: 1.55,
                    ),
              ),
              const SizedBox(height: 13),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.schedule_rounded,
                    size: 15,
                    color: colors.onSurface.withValues(alpha: .48),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${_relativeTime(widget.review.createdAt)}  •  ${DateFormat('d MMM y, h:mm a').format(widget.review.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: .52),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _report() {
    HapticFeedback.selectionClick();
    widget.onReport();
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({required this.review, required this.onReport});

  final ExpertReview review;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: .14),
            child: Text(
              _initials(review.clientName),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  review.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (review.isReported)
                  Text(
                    'Reported for review',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<_ReviewAction>(
            tooltip: 'Review actions',
            enabled: !review.isReported,
            onSelected: (_ReviewAction action) => onReport(),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<_ReviewAction>>[
              PopupMenuItem<_ReviewAction>(
                value: _ReviewAction.report,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.flag_outlined,
                      size: 19,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'Report review',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      );
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) => Row(
        children: List<Widget>.generate(
          5,
          (int index) => Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20,
            color: const Color(0xFFFFB020),
          ),
        ),
      );
}

String _initials(String name) {
  final List<String> parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String part) => part.isNotEmpty)
      .toList();
  return parts.take(2).map((String part) => part[0].toUpperCase()).join();
}

String _relativeTime(DateTime createdAt) {
  final Duration difference = DateTime.now().difference(createdAt);
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  return DateFormat('d MMM').format(createdAt);
}
