import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OntsgoiiScreen extends StatefulWidget {
  const OntsgoiiScreen({super.key});

  @override
  State<OntsgoiiScreen> createState() =>
      _OntsgoiiScreenState();
}

class _OntsgoiiScreenState
    extends State<OntsgoiiScreen>
    with SingleTickerProviderStateMixin {

  int _currentPage = 0;

  int _nextPage = 0;

  bool _isAnimating = false;

  bool _swipingLeft = true;

  late AnimationController
      _animController;

  late Animation<double>
      _waveAnim;

  double _dragStartX = 0;

  double _dragDelta = 0;

  final List<_PromoItem> _items = [

    _PromoItem(

      imageUrl:
          'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=1200&q=80',

      location:
          'Солонгос',

      title:
          'Хязгааргүй дата сим',

      description:
          '2 сарын unlimited дата болон ярианы эрхтэй хямдралтай сим карт.',

      originalPrice:
          '₮ 60,000',

      discountedPrice:
          '₮ 51,000',
    ),

    _PromoItem(

      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200&q=80',

      location:
          'Тайланд',

      title:
          'Пхукет аялал',

      description:
          '5 шөнө all inclusive аялал. Нислэг болон буудал багтсан.',

      originalPrice:
          '₮ 1,200,000',

      discountedPrice:
          '₮ 960,000',
    ),

    _PromoItem(

      imageUrl:
          'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=1200&q=80',

      location:
          'Мальдив',

      title:
          'Романтик аялал',

      description:
          'Далайн эргийн luxury villa болон хосын тусгай багц.',

      originalPrice:
          '₮ 2,500,000',

      discountedPrice:
          '₮ 2,250,000',
    ),
  ];

  @override
  void initState() {

    super.initState();

    _animController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
        milliseconds: 800,
      ),
    );

    _waveAnim =
        CurvedAnimation(

      parent: _animController,

      curve:
          Curves.easeInOutCubic,
    );

    _animController
        .addStatusListener(

      (status) {

        if (status ==
            AnimationStatus.completed) {

          setState(() {

            _currentPage =
                _nextPage;

            _isAnimating =
                false;

            _dragDelta = 0;
          });

          _animController.reset();
        }
      },
    );
  }

  @override
  void dispose() {

    _animController.dispose();

    super.dispose();
  }

  void _startSwipe(
    bool goForward,
  ) {

    if (_isAnimating) return;

    final target =
        goForward
            ? _currentPage + 1
            : _currentPage - 1;

    if (target < 0 ||
        target >= _items.length) {
      return;
    }

    setState(() {

      _nextPage = target;

      _swipingLeft =
          goForward;

      _isAnimating = true;
    });

    _animController.forward();
  }

  void _onDragStart(
    DragStartDetails d,
  ) {

    _dragStartX =
        d.globalPosition.dx;

    _dragDelta = 0;
  }

  void _onDragUpdate(
    DragUpdateDetails d,
  ) {

    setState(() {

      _dragDelta =
          d.globalPosition.dx -
              _dragStartX;
    });
  }

  void _onDragEnd(
    DragEndDetails d,
  ) {

    final velocity =
        d.primaryVelocity ?? 0;

    if (_dragDelta < -40 ||
        velocity < -300) {

      _startSwipe(true);

    } else if (_dragDelta > 40 ||
        velocity > 300) {

      _startSwipe(false);

    } else {

      setState(() {

        _dragDelta = 0;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFFFF7F2),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFFFF6B35),

        elevation: 0,

        centerTitle: true,

        title: Text(

          'Онцгой',

          style:
              GoogleFonts.dmSans(

            fontSize: 20,

            fontWeight:
                FontWeight.bold,

            color: Colors.white,
          ),
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: GestureDetector(

              onHorizontalDragStart:
                  _onDragStart,

              onHorizontalDragUpdate:
                  _onDragUpdate,

              onHorizontalDragEnd:
                  _onDragEnd,

              child: AnimatedBuilder(

                animation: _waveAnim,

                builder:
                    (context, _) {

                  return LayoutBuilder(

                    builder:
                        (
                          context,
                          constraints,
                        ) {

                      final size =
                          Size(

                        constraints
                            .maxWidth,

                        constraints
                            .maxHeight,
                      );

                      return Stack(

                        children: [

                          Positioned.fill(

                            child:
                                _PromoCard(

                              item:
                                  _items[
                                      _currentPage],
                            ),
                          ),

                          if (_isAnimating)

                            ClipPath(

                              clipper:
                                  _LiquidBlobClipper(

                                progress:
                                    _waveAnim
                                        .value,

                                fromRight:
                                    _swipingLeft,

                                size:
                                    size,
                              ),

                              child:
                                  _PromoCard(

                                item:
                                    _items[
                                        _nextPage],
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Row(

            mainAxisAlignment:
                MainAxisAlignment
                    .center,

            children: List.generate(

              _items.length,

              (index) {

                final isActive =
                    index ==
                        (_isAnimating
                            ? _nextPage
                            : _currentPage);

                return AnimatedContainer(

                  duration:
                      const Duration(
                    milliseconds: 300,
                  ),

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),

                  width:
                      isActive
                          ? 20
                          : 8,

                  height: 8,

                  decoration:
                      BoxDecoration(

                    color:
                        isActive

                            ? const Color(
                                0xFFFF6B35,
                              )

                            : const Color(
                                0xFFFFD3C2,
                              ),

                    borderRadius:
                        BorderRadius.circular(
                      4,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}

class _PromoCard
    extends StatelessWidget {

  final _PromoItem item;

  const _PromoCard({
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return Padding(

      padding:
          const EdgeInsets.all(
        16,
      ),

      child: Container(

        decoration: BoxDecoration(

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.orange
                      .withOpacity(
                0.18,
              ),

              blurRadius: 20,

              offset:
                  const Offset(0, 10),
            ),
          ],
        ),

        child: ClipRRect(

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          child: Stack(

            children: [

              Positioned.fill(

                child:
                    CachedNetworkImage(

                  imageUrl:
                      item.imageUrl,

                  fit: BoxFit.cover,
                ),
              ),

              Positioned(

                left: 0,
                right: 0,
                bottom: 0,

                child: Container(

                  padding:
                      const EdgeInsets.all(
                    18,
                  ),

                  decoration:
                      const BoxDecoration(

                    color:
                        Color(0xFFFFF4EE),

                    borderRadius:
                        BorderRadius.only(

                      topLeft:
                          Radius.circular(
                        24,
                      ),

                      topRight:
                          Radius.circular(
                        24,
                      ),
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(

                        item.location,

                        style:
                            GoogleFonts.dmSans(

                          color:
                              const Color(
                            0xFFFF6B35,
                          ),

                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(

                        item.title,

                        style:
                            GoogleFonts.dmSans(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        item.description,

                        maxLines: 3,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            GoogleFonts.dmSans(

                          fontSize: 14,

                          color:
                              Colors.grey.shade700,

                          height: 1.6,
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Row(

                        children: [

                          Text(

                            item.originalPrice,

                            style:
                                GoogleFonts.dmSans(

                              fontSize: 15,

                              decoration:
                                  TextDecoration.lineThrough,

                              color:
                                  Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Text(

                            item.discountedPrice,

                            style:
                                GoogleFonts.dmSans(

                              fontSize: 24,

                              fontWeight:
                                  FontWeight.bold,

                              color:
                                  const Color(
                                0xFFFF6B35,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      SizedBox(

                        width:
                            double.infinity,

                        child:
                            ElevatedButton(

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                const Color(
                              0xFFFF6B35,
                            ),

                            padding:
                                const EdgeInsets.symmetric(
                              vertical: 15,
                            ),

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          onPressed: () {

                            showModalBottomSheet(

                              context:
                                  context,

                              isScrollControlled:
                                  true,

                              backgroundColor:
                                  Colors.white,

                              shape:
                                  const RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.vertical(

                                  top:
                                      Radius.circular(
                                    30,
                                  ),
                                ),
                              ),

                              builder:
                                  (context) {

                                return Padding(

                                  padding:
                                      const EdgeInsets.all(
                                    20,
                                  ),

                                  child:
                                      SingleChildScrollView(

                                    child:
                                        Column(

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [

                                        ClipRRect(

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),

                                          child:
                                              CachedNetworkImage(

                                            imageUrl:
                                                item.imageUrl,

                                            height:
                                                240,

                                            width:
                                                double.infinity,

                                            fit:
                                                BoxFit.cover,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              20,
                                        ),

                                        Text(

                                          item.title,

                                          style:
                                              GoogleFonts.dmSans(

                                            fontSize:
                                                24,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              14,
                                        ),

                                        Row(

                                          children: [

                                            const Icon(

                                              Icons.location_on,

                                              color:
                                                  Color(
                                                0xFFFF6B35,
                                              ),
                                            ),

                                            const SizedBox(
                                              width:
                                                  6,
                                            ),

                                            Text(

                                              item.location,

                                              style:
                                                  GoogleFonts.dmSans(

                                                fontSize:
                                                    15,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height:
                                              18,
                                        ),

                                        Text(

                                          item.description,

                                          style:
                                              GoogleFonts.dmSans(

                                            fontSize:
                                                15,

                                            height:
                                                1.8,

                                            color:
                                                Colors.grey.shade700,
                                          ),
                                        ),

                                        const SizedBox(
                                          height:
                                              26,
                                        ),

                                        Row(

                                          children: [

                                            Text(

                                              item.originalPrice,

                                              style:
                                                  GoogleFonts.dmSans(

                                                fontSize:
                                                    16,

                                                decoration:
                                                    TextDecoration.lineThrough,

                                                color:
                                                    Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(
                                              width:
                                                  10,
                                            ),

                                            Text(

                                              item.discountedPrice,

                                              style:
                                                  GoogleFonts.dmSans(

                                                fontSize:
                                                    28,

                                                fontWeight:
                                                    FontWeight.bold,

                                                color:
                                                    const Color(
                                                  0xFFFF6B35,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height:
                                              30,
                                        ),

                                        SizedBox(

                                          width:
                                              double.infinity,

                                          child:
                                              ElevatedButton(

                                            style:
                                                ElevatedButton.styleFrom(

                                              backgroundColor:
                                                  const Color(
                                                0xFFFF6B35,
                                              ),

                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical:
                                                    16,
                                              ),
                                            ),

                                            onPressed:
                                                () {

                                              Navigator.pop(
                                                context,
                                              );
                                            },

                                            child:
                                                Text(

                                              "Хаах",

                                              style:
                                                  GoogleFonts.dmSans(

                                                color:
                                                    Colors.white,

                                                fontSize:
                                                    16,

                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          child: Text(

                            "Дэлгэрэнгүй",

                            style:
                                GoogleFonts.dmSans(

                              fontSize: 16,

                              fontWeight:
                                  FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoItem {

  final String imageUrl;

  final String location;

  final String title;

  final String description;

  final String originalPrice;

  final String discountedPrice;

  const _PromoItem({

    required this.imageUrl,

    required this.location,

    required this.title,

    required this.description,

    required this.originalPrice,

    required this.discountedPrice,
  });
}

class _LiquidBlobClipper
    extends CustomClipper<Path> {

  final double progress;

  final bool fromRight;

  final Size size;

  _LiquidBlobClipper({

    required this.progress,

    required this.fromRight,

    required this.size,
  });

  @override
  Path getClip(Size s) {

    final w = s.width;

    final h = s.height;

    final centerY = h * 0.5;

    final radius =
        math.sqrt(
              w * w +
                  h * h,
            ) *
            progress;

    final path = Path();

    if (fromRight) {

      path.addOval(

        Rect.fromCircle(

          center: Offset(
            w,
            centerY,
          ),

          radius: radius,
        ),
      );

    } else {

      path.addOval(

        Rect.fromCircle(

          center: Offset(
            0,
            centerY,
          ),

          radius: radius,
        ),
      );
    }

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path>
        oldClipper,
  ) {

    return true;
  }
}