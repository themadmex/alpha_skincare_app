import 'dart:core';

import 'package:intl/intl.dart';

// Date format configuration
class DateFormatConfig {
  final String format;
  final bool useRelative;
  final bool includeTime;
  final bool use12Hour;
  final String locale;

  const DateFormatConfig({
    required this.format,
    this.useRelative = false,
    this.includeTime = false,
    this.use12Hour = true,
    this.locale = 'en_US',
  });

  // Predefined configurations
  static const DateFormatConfig standard = DateFormatConfig(
    format: 'yyyy-MM-dd',
  );

  static const DateFormatConfig display = DateFormatConfig(
    format: 'MMM dd, yyyy',
  );

  static const DateFormatConfig displayWithTime = DateFormatConfig(
    format: 'MMM dd, yyyy h:mm a',
    includeTime: true,
  );

  static const DateFormatConfig relative = DateFormatConfig(
    format: 'MMM dd, yyyy',
    useRelative: true,
  );

  static const DateFormatConfig relativeWithTime = DateFormatConfig(
    format: 'MMM dd, yyyy h:mm a',
    useRelative: true,
    includeTime: true,
  );

  static const DateFormatConfig scan = DateFormatConfig(
    format: 'MMM dd, h:mm a',
    useRelative: true,
    includeTime: true,
  );

  static const DateFormatConfig compact = DateFormatConfig(
    format: 'MM/dd/yyyy',
  );

  static const DateFormatConfig long = DateFormatConfig(
    format: 'EEEE, MMMM dd, yyyy',
  );

  static const DateFormatConfig timeOnly = DateFormatConfig(
    format: 'h:mm a',
    includeTime: true,
  );

  static const DateFormatConfig iso = DateFormatConfig(
    format: 'yyyy-MM-ddTHH:mm:ss.SSSZ',
    includeTime: true,
    use12Hour: false,
  );
}

// Smart date formatter with unified approach
class SmartDateFormatter {
  static final Map<String, DateFormat> _formatCache = {};

  // Main formatting method
  static String format(DateTime dateTime, {DateFormatConfig? config}) {
    config ??= DateFormatConfig.display;

    if (config.useRelative) {
      return _formatRelative(dateTime, config);
    }

    return _formatStandard(dateTime, config);
  }

  // Format with custom pattern
  static String formatWithPattern(DateTime dateTime, String pattern, {String? locale}) {
    final config = DateFormatConfig(
      format: pattern,
      locale: locale ?? 'en_US',
    );
    return _formatStandard(dateTime, config);
  }

  // Parse date from string
  static DateTime? parse(String dateString, {DateFormatConfig? config}) {
    config ??= DateFormatConfig.standard;

    try {
      final formatter = _getFormatter(config);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse with multiple format attempts
  static DateTime? parseFlexible(String dateString) {
    final configs = [
      DateFormatConfig.iso,
      DateFormatConfig.standard,
      DateFormatConfig.display,
      DateFormatConfig.compact,
    ];

    for (final config in configs) {
      final result = parse(dateString, config: config);
      if (result != null) return result;
    }

    // Try ISO parsing as fallback
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Standard formatting
  static String _formatStandard(DateTime dateTime, DateFormatConfig config) {
    final formatter = _getFormatter(config);
    return formatter.format(dateTime);
  }

  // Relative formatting with fallback
  static String _formatRelative(DateTime dateTime, DateFormatConfig config) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Today
    if (_isToday(dateTime, now)) {
      if (config.includeTime) {
        return 'Today, ${_formatTime(dateTime, config.use12Hour)}';
      }
      return 'Today';
    }

    // Yesterday
    if (_isYesterday(dateTime, now)) {
      if (config.includeTime) {
        return 'Yesterday, ${_formatTime(dateTime, config.use12Hour)}';
      }
      return 'Yesterday';
    }

    // This week
    if (difference.inDays < 7) {
      final dayName = DateFormat('EEEE', config.locale).format(dateTime);
      if (config.includeTime) {
        return '$dayName, ${_formatTime(dateTime, config.use12Hour)}';
      }
      return dayName;
    }

    // This year
    if (dateTime.year == now.year) {
      final monthDay = DateFormat('MMM dd', config.locale).format(dateTime);
      if (config.includeTime) {
        return '$monthDay, ${_formatTime(dateTime, config.use12Hour)}';
      }
      return monthDay;
    }

    // Relative formatting with fallback
    static String _formatRelative(DateTime dateTime, DateFormatConfig config) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      // Today
      if (_isToday(dateTime, now)) {
        if (config.includeTime) {
          return 'Today, ${_formatTime(dateTime, config.use12Hour)}';
        }
        return 'Today';
      }

      // Yesterday
      if (_isYesterday(dateTime, now)) {
        if (config.includeTime) {
          return 'Yesterday, ${_formatTime(dateTime, config.use12Hour)}';
        }
        return 'Yesterday';
      }

      // This week
      if (difference.inDays < 7) {
        final dayName = DateFormat('EEEE', config.locale).format(dateTime);
        if (config.includeTime) {
          return '$dayName, ${_formatTime(dateTime, config.use12Hour)}';
        }
        return dayName;
      }

      // This year
      if (dateTime.year == now.year) {
        final monthDay = DateFormat('MMM dd', config.locale).format(dateTime);
        if (config.includeTime) {
          return '$monthDay, ${_formatTime(dateTime, config.use12Hour)}';
        }
        return monthDay;
      }

      // Fallback to standard format
      return _formatStandard(dateTime, config);
    }

    // Format time based on 12/24 hour preference
    static String _formatTime(DateTime dateTime, bool use12Hour) {
      final pattern = use12Hour ? 'h:mm a' : 'HH:mm';
      return DateFormat(pattern).format(dateTime);
    }

    // Get cached formatter
    static DateFormat _getFormatter(DateFormatConfig config) {
      final key = '${config.format}_${config.locale}';

      if (!_formatCache.containsKey(key)) {
        _formatCache[key] = DateFormat(config.format, config.locale);
      }

      return _formatCache[key]!;
    }

    // Utility methods
    static bool _isToday(DateTime date, DateTime now) {
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }

    static bool _isYesterday(DateTime date, DateTime now) {
      final yesterday = now.subtract(const Duration(days: 1));
      return date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day;
    }

    // Convenience methods for common use cases
    static String displayDate(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.display);
    }

    static String displayDateTime(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.displayWithTime);
    }

    static String relativeDate(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.relative);
    }

    static String relativeDateTime(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.relativeWithTime);
    }

    static String scanDate(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.scan);
    }

    static String compactDate(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.compact);
    }

    static String longDate(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.long);
    }

    static String timeOnly(DateTime dateTime) {
      return format(dateTime, config: DateFormatConfig.timeOnly);
    }

    static String isoString(DateTime dateTime) {
      return dateTime.toIso8601String();
    }

    static String apiFormat(DateTime dateTime) {
      return dateTime.toUtc().toIso8601String();
    }

    // Age calculation
    static int calculateAge(DateTime birthDate) {
      final now = DateTime.now();
      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    }

    // Duration formatting
    static String formatDuration(Duration duration, {bool short = false}) {
      if (duration.inDays > 0) {
        if (short) {
          return '${duration.inDays}d';
        } else {
          return '${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'}';
        }
      } else if (duration.inHours > 0) {
        if (short) {
          return '${duration.inHours}h';
        } else {
          return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'}';
        }
      } else if (duration.inMinutes > 0) {
        if (short) {
          return '${duration.inMinutes}m';
        } else {
          return '${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'}';
        }
      } else {
        if (short) {
          return '${duration.inSeconds}s';
        } else {
          return '${duration.inSeconds} ${duration.inSeconds == 1 ? 'second' : 'seconds'}';
        }
      }
    }

    // Time ago formatting
    static String timeAgo(DateTime dateTime) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else if (difference.inDays > 7) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'now';
      }
    }

    // Greeting based on time
    static String getGreeting() {
      final now = DateTime.now();
      final hour = now.hour;

      if (hour < 5) {
        return 'Good night';
      } else if (hour < 12) {
        return 'Good morning';
      } else if (hour < 17) {
        return 'Good afternoon';
      } else if (hour < 22) {
        return 'Good evening';
      } else {
        return 'Good night';
      }
    }

    // Date range utilities
    static String formatDateRange(DateTime start, DateTime end, {DateFormatConfig? config}) {
      config ??= DateFormatConfig.display;

      if (_isToday(start, DateTime.now()) && _isToday(end, DateTime.now())) {
        return 'Today';
      }

      if (start.year == end.year) {
        if (start.month == end.month) {
          if (start.day == end.day) {
            return format(start, config: config);
          } else {
            return '${DateFormat('MMM dd', config.locale).format(start)} - ${DateFormat('dd, yyyy', config.locale).format(end)}';
          }
        } else {
          return '${DateFormat('MMM dd', config.locale).format(start)} - ${DateFormat('MMM dd, yyyy', config.locale).format(end)}';
        }
      } else {
        return '${format(start, config: config)} - ${format(end, config: config)}';
      }
    }

    // Business days calculation
    static int businessDaysBetween(DateTime start, DateTime end) {
      int businessDays = 0;
      DateTime current = start;

      while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
        if (current.weekday < 6) { // Monday to Friday
          businessDays++;
        }
        current = current.add(const Duration(days: 1));
      }

      return businessDays;
    }

    // Date manipulation
    static DateTime addBusinessDays(DateTime date, int days) {
      DateTime result = date;
      int addedDays = 0;

      while (addedDays < days) {
        result = result.add(const Duration(days: 1));
        if (result.weekday < 6) { // Monday to Friday
          addedDays++;
        }
      }

      return result;
    }

    // Validation
    static bool isValidDate(String dateString, {DateFormatConfig? config}) {
      return parse(dateString, config: config) != null;
    }

    // Clear cache
    static void clearCache() {
      _formatCache.clear();
    }
  }

// Extension methods for DateTime
  extension SmartDateTimeExtension on DateTime {
  String smartFormat({DateFormatConfig? config}) {
    return SmartDateFormatter.format(this, config: config);
  }

  String get displayDate => SmartDateFormatter.displayDate(this);
  String get displayDateTime => SmartDateFormatter.displayDateTime(this);
  String get relativeDate => SmartDateFormatter.relativeDate(this);
  String get relativeDateTime => SmartDateFormatter.relativeDateTime(this);
  String get scanDate => SmartDateFormatter.scanDate(this);
  String get compactDate => SmartDateFormatter.compactDate(this);
  String get longDate => SmartDateFormatter.longDate(this);
  String get timeOnly => SmartDateFormatter.timeOnly(this);
  String get timeAgo => SmartDateFormatter.timeAgo(this);
  String get apiFormat => SmartDateFormatter.apiFormat(this);

  bool get isToday => SmartDateFormatter._isToday(this, DateTime.now());
  bool get isYesterday => SmartDateFormatter._isYesterday(this, DateTime.now());
  bool get isWeekend => weekday == 6 || weekday == 7;
  bool get isBusinessDay => !isWeekend;

  int get age => SmartDateFormatter.calculateAge(this);
}

// Extension methods for String
extension SmartDateStringExtension on String {
  DateTime? get parseDate => SmartDateFormatter.parseFlexible(this);
  bool get isValidDate => SmartDateFormatter.isValidDate(this);
}