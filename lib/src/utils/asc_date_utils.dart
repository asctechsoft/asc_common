import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Date helpers shared across apps. Locale-aware labels follow `Get.locale`.
class AscDateUtils {
  AscDateUtils._();

  /// `YYYY-MM-DD` key for [date] (local time) — the form apps index daily
  /// records by.
  static String formatDateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String todayKey() => formatDateKey(DateTime.now());

  static DateTime parseDateKey(String dateKey) => DateTime.parse(dateKey);

  /// "12 Oct – 18 Oct, 2025" for the Monday-based week containing [date].
  static String weekRange(DateTime date) {
    final start = startOfWeek(date);
    final end = start.add(const Duration(days: 6));
    final fmt = DateFormat('d MMM', Get.locale?.languageCode);
    return '${fmt.format(start)} – ${fmt.format(end)}, ${end.year}';
  }

  static String monthLabel(DateTime date) =>
      DateFormat('MMMM, y', Get.locale?.languageCode).format(date);

  static String yearLabel(DateTime date) => date.year.toString();

  /// Locale-aware medium date, e.g. "Mar 5, 2025" / "5 thg 3, 2025".
  static String shortDate(DateTime date) =>
      DateFormat.yMMMd(Get.locale?.languageCode).format(date);

  /// Monday of [date]'s week.
  static DateTime startOfWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  static DateTime endOfWeek(DateTime date) =>
      startOfWeek(date).add(const Duration(days: 6));

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  static DateTime startOfYear(DateTime date) => DateTime(date.year, 1, 1);

  static DateTime endOfYear(DateTime date) => DateTime(date.year, 12, 31);
}

extension AscDateTimeX on DateTime {
  /// `YYYY-MM-DD` — see [AscDateUtils.formatDateKey].
  String get asDateKey => AscDateUtils.formatDateKey(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
