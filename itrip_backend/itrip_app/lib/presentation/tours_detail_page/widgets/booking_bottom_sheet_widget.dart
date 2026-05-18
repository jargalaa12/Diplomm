import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:itrip_app/services/api_service.dart';

class BookingBottomSheetWidget extends StatefulWidget {
  final String tourTitle;
  final List<dynamic> schedules;
  final int tourId;

  const BookingBottomSheetWidget({
    super.key,
    required this.tourTitle,
    required this.schedules,
    required this.tourId,
  });

  @override
  State<BookingBottomSheetWidget> createState() =>
      _BookingBottomSheetWidgetState();
}

class _BookingBottomSheetWidgetState
    extends State<BookingBottomSheetWidget> {
  int _selectedIndex = 0;
  int _groupSize = 1;
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialController = TextEditingController();

  int _getPrice(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();

    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(cleaned) ?? 0;
    }

    return 0;
  }

  bool _validate() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showError("Бүх мэдээллийг бөглөнө үү");
      return false;
    }

    if (!_emailController.text.contains("@")) {
      _showError("Имэйл буруу байна");
      return false;
    }

    if (_phoneController.text.length < 8) {
      _showError("Утас буруу байна");
      return false;
    }

    return true;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  /// 🔥 FIXED FUNCTION
  Future<void> _confirmBooking() async {
    if (isLoading) return;
    if (widget.schedules.isEmpty) return;

    if (ApiService.token == null) {
      _showError("Та дахин нэвтэрнэ үү");
      return;
    }

    if (!_validate()) return;

    final selected = widget.schedules[_selectedIndex];
    final seats = selected["available_seats"] ?? 9999;

    if (_groupSize > seats) {
      _showError("Суудал хүрэлцэхгүй байна");
      return;
    }

    setState(() => isLoading = true);

    try {
      final parts = _nameController.text.trim().split(" ");
      final firstName = parts.first;
      final lastName =
          parts.length > 1 ? parts.sublist(1).join(" ") : "User";

      await ApiService.createBooking(
        tourId: widget.tourId,
        scheduleId: selected["id"],
        people: _groupSize,
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      /// 🔥 ХАМГИЙН ЧУХАЛ FIX
      if (mounted) {
        Navigator.pop(context, true); // 👈 RESULT буцаана
      }

    } catch (e) {
      _showError("Алдаа гарлаа: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.schedules.isEmpty) {
      return const Center(child: Text("Хуваарь байхгүй"));
    }

    final selected = widget.schedules[_selectedIndex];

    final price = _getPrice(
      selected["price"] ??
          selected["price_per_person"] ??
          selected["amount"],
    );

    final total = price * _groupSize;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Захиалгын сонголт",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 2.h),
                Text(widget.tourTitle),

                SizedBox(height: 3.h),

                const Text("Огноо сонгох"),
                SizedBox(height: 1.h),

                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.schedules.length,
                    itemBuilder: (context, index) {
                      final s = widget.schedules[index];
                      final isSelected = index == _selectedIndex;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            color: isSelected
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16),
                              const SizedBox(width: 6),
                              Text("${s["start_date"]}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 3.h),

                const Text("Хүн"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _groupSize > 1
                          ? () => setState(() => _groupSize--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$_groupSize"),
                    IconButton(
                      onPressed: () =>
                          setState(() => _groupSize++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                _buildInput("Овог нэр", _nameController),
                _buildInput("Имэйл", _emailController),
                _buildInput("Утас", _phoneController),
                _buildInput("Тайлбар", _specialController,
                    maxLines: 2),

                SizedBox(height: 3.h),

                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Нийт үнэ"),
                      Text("$total ₮",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        isLoading ? null : _confirmBooking,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Захиалах"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialController.dispose();
    super.dispose();
  }
}