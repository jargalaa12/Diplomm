import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';
import '../../widgets/custom_image_widget.dart';
import '../tours_detail_page/tours_detail_page.dart';

class ToursSectionScreen extends StatefulWidget {
  const ToursSectionScreen({super.key});

  @override
  State<ToursSectionScreen> createState() => _ToursSectionScreenState();
}

class _ToursSectionScreenState extends State<ToursSectionScreen> {
  static const Color _orange = Color(0xFFFF6B00);
  static const Color _bg     = Color(0xFFF4F6F8);

  late Future<List<dynamic>> _toursFuture;
  List<dynamic> _allTours  = [];

  String?   _selectedLocation;
  DateTime? _selectedDate;
  bool      _isSearching = false;
  bool      _isFiltered  = false;

  @override
  void initState() {
    super.initState();
    _toursFuture = ApiService.getTours();
  }

  Future<void> _refresh() async {
    setState(() {
      _toursFuture      = ApiService.getTours();
      _allTours         = [];
      _selectedLocation = null;
      _selectedDate     = null;
      _isFiltered       = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _selectedLocation = null;
      _selectedDate     = null;
      _isFiltered       = false;
      _toursFuture      = Future.value(_allTours);
    });
  }

  Future<void> _doSearch() async {
    setState(() => _isSearching = true);
    try {
      String? dateStr;
      if (_selectedDate != null) {
        dateStr =
            "${_selectedDate!.year}-"
            "${_selectedDate!.month.toString().padLeft(2, '0')}-"
            "${_selectedDate!.day.toString().padLeft(2, '0')}";
      }
      final result = await ApiService.getTours(
        location: _selectedLocation,
        date: dateStr,
      );
      setState(() {
        _toursFuture = Future.value(result);
        _isSearching = false;
        _isFiltered  = true;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Хайлт амжилтгүй: $e")),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final now  = DateTime.now();
    final pick = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _orange),
        ),
        child: child!,
      ),
    );
    if (pick != null) setState(() => _selectedDate = pick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<dynamic>>(
          future: _toursFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: _orange));
            }
            if (snapshot.hasError) {
              return Center(child: Text("Алдаа: ${snapshot.error}"));
            }

            if (_allTours.isEmpty && (snapshot.data ?? []).isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _allTours = snapshot.data!);
              });
            }

            final tours = snapshot.data ?? [];

            return CustomScrollView(
              slivers: [
                // ✅ Буцах товчтой Hero
                SliverToBoxAdapter(child: _buildHero()),
                SliverToBoxAdapter(child: _buildSearchCard()),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      children: [
                        Text(
                          "Онцлох аяллууд",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_isFiltered)
                          GestureDetector(
                            onTap: _clearSearch,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.6.h),
                              decoration: BoxDecoration(
                                color: _orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _orange.withOpacity(0.4)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.close,
                                      size: 12.sp, color: _orange),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "Арилгах",
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      color: _orange,
                                      fontWeight: FontWeight.w600,
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

                if (_isFiltered)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 4.w, right: 4.w, bottom: 0.5.h),
                      child: Text(
                        "${tours.length} аялал олдлоо",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),

                tours.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Column(
                            children: [
                              Icon(Icons.search_off,
                                  size: 40.sp,
                                  color: Colors.grey.shade400),
                              SizedBox(height: 1.h),
                              Text(
                                "Аялал олдсонгүй",
                                style:
                                    TextStyle(color: Colors.grey.shade500),
                              ),
                              SizedBox(height: 2.h),
                              if (_isFiltered)
                                TextButton.icon(
                                  onPressed: _clearSearch,
                                  icon: const Icon(Icons.arrow_back,
                                      color: _orange),
                                  label: Text(
                                    "Бүх аяллыг харах",
                                    style: TextStyle(color: _orange),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => _buildTourCard(
                                tours[i] as Map<String, dynamic>),
                            childCount: tours.length,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.58,
                          ),
                        ),
                      ),

                SliverToBoxAdapter(child: SizedBox(height: 3.h)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ✅ Буцах товч нэмэгдсэн Hero
  Widget _buildHero() {
    return SizedBox(
      height: 22.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg",
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),

          // ✅ Буцах товч — зүүн дээд буланд
          Positioned(
            top: 1.h,
            left: 3.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Text(
              "Аялал",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    final locations = _allTours
        .map((t) => t['location']?.toString() ?? '')
        .where((l) => l.isNotEmpty)
        .toSet()
        .toList();

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Хаашаа"),
          SizedBox(height: 0.8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  "Байршил сонгох",
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 12.sp),
                ),
                value: _selectedLocation,
                items: locations.map((loc) {
                  return DropdownMenuItem(
                    value: loc,
                    child: Text(loc, style: TextStyle(fontSize: 12.sp)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedLocation = v),
                icon:
                    const Icon(Icons.keyboard_arrow_down, color: _orange),
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          _buildLabel("Хэзээ"),
          SizedBox(height: 0.8.h),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "Огноо сонгох"
                          : "${_selectedDate!.year}-"
                            "${_selectedDate!.month.toString().padLeft(2, '0')}-"
                            "${_selectedDate!.day.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _selectedDate == null
                            ? Colors.grey.shade500
                            : Colors.black87,
                        fontWeight: _selectedDate == null
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: _orange),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSearching ? null : _doSearch,
              icon: _isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.search, color: Colors.white),
              label: Text(
                _isSearching ? "Хайж байна..." : "Хайх",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                disabledBackgroundColor: _orange.withOpacity(0.6),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildTourCard(Map<String, dynamic> tour) {
    final imageUrl = ApiService.getImageUrl(tour["image"]);

    final schedules     = tour['schedules'] as List<dynamic>? ?? [];
    String dateText     = '';
    String durationText = '';

    if (schedules.isNotEmpty) {
      final s  = schedules.first;
      dateText = s['start_date']?.toString() ?? '';
      try {
        final start = DateTime.parse(s['start_date'].toString());
        final end   = DateTime.parse(s['end_date'].toString());
        final days  = end.difference(start).inDays;
        durationText = "$days өдөр ${days > 1 ? days - 1 : 0} шөнө";
      } catch (_) {}
    }

    return GestureDetector(
      onTap: () {
        final id = tour["id"];
        if (id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ToursDetailPage(id: id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14.h,
              width: double.infinity,
              child: imageUrl.isEmpty
                  ? const Center(child: Icon(Icons.image, size: 40))
                  : CustomImageWidget(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      semanticLabel: tour["name"] ?? "tour",
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour["name"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5.sp,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (dateText.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 11.sp, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(dateText,
                            style: TextStyle(
                                fontSize: 9.5.sp,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  if (durationText.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 11.sp, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(durationText,
                            style: TextStyle(
                                fontSize: 9.5.sp,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],

                  Text(
                    "₮ ${_formatPrice(tour["price"])}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      color: _orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    final n = double.tryParse(price.toString())?.toInt() ?? 0;
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write("'");
      buf.write(s[i]);
    }
    return buf.toString();
  }
}