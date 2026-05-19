import 'package:intl/intl.dart';

/// Utility class for date formatting and manipulation.
class AppDateUtils {
  AppDateUtils._();

  /// Format a date string to a human-readable format (e.g., "Jan 15, 2024").
  static String formatDate(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format a date string to a short format (e.g., "Jan 15").
  static String formatDateShort(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return DateFormat('MMM d').format(date);
  }

  /// Format a date string with time (e.g., "Jan 15, 2024 3:30 PM").
  static String formatDateTime(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return DateFormat('MMM d, yyyy h:mm a').format(date);
  }

  /// Get relative time description (e.g., "2 hours ago", "Yesterday").
  static String timeAgo(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays > 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inHours > 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 1) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get today's date as a formatted string (yyyy-MM-dd).
  static String get todayString => DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// Get a past date string (yyyy-MM-dd) relative to today.
  static String daysAgo(int days) {
    final date = DateTime.now().subtract(Duration(days: days));
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format seconds into "Xm Ys" format.
  static String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}
