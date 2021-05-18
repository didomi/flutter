import 'dart:io';

enum LogLevel { verbose, debug, info, warn, error }

extension LogLevelExtension on LogLevel {

  /// Get Platform specific level value
  int get platformLevel {
    if (Platform.isAndroid) {
      return androidLevel;
    } else if (Platform.isIOS) {
      return iosLevel;
    } else {
      throw("Platform is neither android nor ios");
    }
  }

  /// Get Android level value
  int get androidLevel {
    switch (this) {
      case LogLevel.verbose:
        return 2; // Log.VERBOSE (2)

      case LogLevel.debug:
        return 3; // Log.DEBUG (3)

      case LogLevel.info:
        return 4; // Log.INFO (4)

      case LogLevel.warn:
        return 5; // Log.WARN (5)

      case LogLevel.error:
        return 6; // Log.ERROR (6)

      default:
        return 2; // Log.VERBOSE (2)
    }
  }

  /// Get iOS level value
  int get iosLevel {
    switch (this) {
      case LogLevel.info:
      case LogLevel.verbose:
        return 1; // OSLogType.info (1)

      case LogLevel.debug:
        return 2; // OSLogType.debug (2)

      case LogLevel.warn:
        return 16; // OSLogType.error (16)

      case LogLevel.error:
        return 17; // OSLogType.fault (17)

      default:
        return 1; // OSLogType.info (1)
    }
  }
}
