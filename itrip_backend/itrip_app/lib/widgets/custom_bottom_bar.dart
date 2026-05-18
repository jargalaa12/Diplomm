import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom floating pill bottom navigation bar with glassmorphism bubble animation.
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bubbleAnimation;
  late int _previousIndex;

  final List<_NavItem> items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Нүүр'),
    _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Захиалга',
    ),
    _NavItem(
      icon: Icons.confirmation_number_outlined,
      activeIcon: Icons.confirmation_number,
      label: 'Онцгой',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Профайл',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bubbleAnimation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _bubbleAnimation = Tween<double>(
        begin: _previousIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
      _previousIndex = widget.currentIndex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 8),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFB0B0B0),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / items.length;
            final bubbleSize = itemWidth - 8;
            return AnimatedBuilder(
              animation: _bubbleAnimation,
              builder: (context, child) {
                final bubbleLeft = _bubbleAnimation.value * itemWidth + 4;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Dark pill background for active tab
                    Positioned(
                      left: bubbleLeft,
                      top: 6,
                      bottom: 6,
                      width: bubbleSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B6B6B),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                    // Glassmorphism holographic bubble
                    Positioned(
                      left: bubbleLeft + bubbleSize / 2 - bubbleSize / 2,
                      top: -6,
                      width: bubbleSize,
                      height: 80,
                      child: _GlassBubble(size: bubbleSize),
                    ),
                    // Tab items
                    Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final isActive = widget.currentIndex == index;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => widget.onTap(index),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                  child: Icon(
                                    isActive ? item.activeIcon : item.icon,
                                    key: ValueKey('icon_${index}_$isActive'),
                                    size: 22,
                                    color: isActive
                                        ? const Color(0xFFFF4B2B)
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.label,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 11,
                                    fontWeight: isActive
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isActive
                                        ? const Color(0xFFFF4B2B)
                                        : Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Glassmorphism holographic bubble widget
class _GlassBubble extends StatefulWidget {
  final double size;
  const _GlassBubble({required this.size});

  @override
  State<_GlassBubble> createState() => _GlassBubbleState();
}

class _GlassBubbleState extends State<_GlassBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final t = _shimmerController.value;
        return CustomPaint(
          painter: _HolographicBubblePainter(animationValue: t),
          size: Size(widget.size, 80),
        );
      },
    );
  }
}

class _HolographicBubblePainter extends CustomPainter {
  final double animationValue;

  _HolographicBubblePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rx = size.width / 2 - 2;
    final ry = size.height / 2 - 2;

    final rect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: rx * 2,
      height: ry * 2,
    );

    // Translucent frosted fill
    final fillPaint = Paint()
      ..color = Colors.white.withAlpha(30)
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, fillPaint);

    // Inner highlight arc (top-left gloss)
    final glossPaint = Paint()
      ..color = Colors.white.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final glossRect = Rect.fromCenter(
      center: Offset(cx - 4, cy - 4),
      width: rx * 1.2,
      height: ry * 1.0,
    );
    canvas.drawArc(glossRect, 3.8, 1.8, false, glossPaint);
  }

  @override
  bool shouldRepaint(_HolographicBubblePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItem({required this.icon, required this.activeIcon, required this.label});
}
