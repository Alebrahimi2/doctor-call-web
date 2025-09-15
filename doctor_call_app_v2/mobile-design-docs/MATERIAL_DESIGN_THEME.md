# 🎨 Flutter Material Design 3 Theme System

**Doctor Call App - Complete Design System**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 🌈 **نظام الألوان**

### Primary Color Palette

```dart
// lib/theme/app_colors.dart
class AppColors {
  // Primary Colors - Medical Theme
  static const Color primary = Color(0xFF1976D2); // Medical Blue
  static const Color primaryVariant = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF4CAF50); // Healthy Green
  static const Color secondaryVariant = Color(0xFF388E3C);
  
  // Medical Status Colors
  static const Color critical = Color(0xFFD32F2F); // Red
  static const Color emergency = Color(0xFFFF7043); // Orange
  static const Color urgent = Color(0xFFFDD835); // Yellow
  static const Color stable = Color(0xFF66BB6A); // Green
  static const Color recovered = Color(0xFF42A5F5); // Light Blue
  
  // Neutral Colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onBackground = Color(0xFF1C1B1F);
  
  // Additional Medical Colors
  static const Color hospital = Color(0xFF0288D1);
  static const Color ambulance = Color(0xFFE91E63);
  static const Color doctor = Color(0xFF7B1FA2);
  static const Color nurse = Color(0xFF5E35B1);
  static const Color patient = Color(0xFF00796B);
}
```

### Color Schemes

```dart
// lib/theme/color_schemes.dart
class AppColorSchemes {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    error: AppColors.critical,
    onError: Colors.white,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF003258),
    secondary: Color(0xFFA5D6A7),
    onSecondary: Color(0xFF00363A),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
  );

  static ColorScheme get medicalColorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );
}
```

---

## 📝 **Typography System**

### Arabic-Optimized Typography

```dart
// lib/theme/typography.dart
class AppTypography {
  static const String arabicFontFamily = 'Cairo';
  static const String englishFontFamily = 'Roboto';

  static TextTheme get arabicTextTheme => TextTheme(
    displayLarge: GoogleFonts.cairo(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.12,
    ),
    displayMedium: GoogleFonts.cairo(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: GoogleFonts.cairo(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    headlineLarge: GoogleFonts.cairo(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.cairo(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: GoogleFonts.cairo(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),
    titleLarge: GoogleFonts.cairo(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: GoogleFonts.cairo(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.50,
    ),
    titleSmall: GoogleFonts.cairo(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    bodyLarge: GoogleFonts.cairo(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: GoogleFonts.cairo(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: GoogleFonts.cairo(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
    labelLarge: GoogleFonts.cairo(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: GoogleFonts.cairo(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: GoogleFonts.cairo(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // Medical-specific text styles
  static TextStyle get patientNameStyle => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle get medicalInfoStyle => GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface.withOpacity(0.7),
  );

  static TextStyle get statusStyle => GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get emergencyStyle => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.critical,
  );
}
```

---

## 🎯 **Component Themes**

### Card Theme

```dart
// lib/theme/component_themes.dart
class ComponentThemes {
  static CardTheme get cardTheme => CardTheme(
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
  );

  static ElevatedButtonThemeData get elevatedButtonTheme =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: AppTypography.arabicTextTheme.labelLarge,
      ),
    );

  static OutlinedButtonThemeData get outlinedButtonTheme =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        side: const BorderSide(width: 1),
        textStyle: AppTypography.arabicTextTheme.labelLarge,
      ),
    );

  static TextButtonThemeData get textButtonTheme =>
    TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: AppTypography.arabicTextTheme.labelLarge,
      ),
    );

  static FloatingActionButtonThemeData get fabTheme =>
    const FloatingActionButtonThemeData(
      elevation: 4,
      shape: CircleBorder(),
    );

  static AppBarTheme get appBarTheme => AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.onSurface,
    titleTextStyle: AppTypography.arabicTextTheme.headlineSmall,
    toolbarTextStyle: AppTypography.arabicTextTheme.bodyMedium,
  );

  static NavigationBarThemeData get navigationBarTheme =>
    NavigationBarThemeData(
      elevation: 3,
      labelTextStyle: MaterialStateProperty.all(
        AppTypography.arabicTextTheme.labelMedium,
      ),
    );

  static BottomSheetThemeData get bottomSheetTheme =>
    const BottomSheetThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,
    );

  static DialogTheme get dialogTheme => DialogTheme(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    titleTextStyle: AppTypography.arabicTextTheme.headlineSmall,
    contentTextStyle: AppTypography.arabicTextTheme.bodyMedium,
  );

  static ChipThemeData get chipTheme => ChipThemeData(
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    labelStyle: AppTypography.arabicTextTheme.labelMedium,
  );
}
```

---

## 🏥 **Medical-Specific Widgets**

### Patient Status Chip

```dart
// lib/widgets/medical/patient_status_chip.dart
class PatientStatusChip extends StatelessWidget {
  final String status;
  final String severity;

  const PatientStatusChip({
    Key? key,
    required this.status,
    required this.severity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: AppTypography.statusStyle.copyWith(
          color: _getTextColor(),
        ),
      ),
      backgroundColor: _getBackgroundColor(),
      side: BorderSide(color: _getBorderColor()),
      avatar: Icon(
        _getStatusIcon(),
        size: 16,
        color: _getTextColor(),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.critical.withOpacity(0.1);
      case 'emergency':
        return AppColors.emergency.withOpacity(0.1);
      case 'urgent':
        return AppColors.urgent.withOpacity(0.1);
      case 'stable':
        return AppColors.stable.withOpacity(0.1);
      default:
        return AppColors.surface;
    }
  }

  Color _getBorderColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.critical;
      case 'emergency':
        return AppColors.emergency;
      case 'urgent':
        return AppColors.urgent;
      case 'stable':
        return AppColors.stable;
      default:
        return AppColors.onSurface.withOpacity(0.3);
    }
  }

  Color _getTextColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.critical;
      case 'emergency':
        return AppColors.emergency;
      case 'urgent':
        return Colors.amber[800]!;
      case 'stable':
        return AppColors.stable;
      default:
        return AppColors.onSurface;
    }
  }

  IconData _getStatusIcon() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'emergency':
        return Icons.warning;
      case 'urgent':
        return Icons.access_time;
      case 'stable':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}
```

### Medical Action Button

```dart
// lib/widgets/medical/medical_action_button.dart
class MedicalActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final MedicalActionType type;

  const MedicalActionButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.type = MedicalActionType.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getForegroundColor(),
        elevation: type == MedicalActionType.emergency ? 6 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(type == MedicalActionType.emergency ? 30 : 24),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case MedicalActionType.emergency:
        return AppColors.critical;
      case MedicalActionType.treatment:
        return AppColors.secondary;
      case MedicalActionType.transfer:
        return AppColors.hospital;
      case MedicalActionType.discharge:
        return AppColors.stable;
      default:
        return AppColors.primary;
    }
  }

  Color _getForegroundColor() {
    return Colors.white;
  }
}

enum MedicalActionType {
  normal,
  emergency,
  treatment,
  transfer,
  discharge,
}
```

---

## 📱 **Complete Theme Implementation**

### Main Theme File

```dart
// lib/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.lightColorScheme,
    textTheme: AppTypography.arabicTextTheme,
    
    // Component Themes
    cardTheme: ComponentThemes.cardTheme,
    elevatedButtonTheme: ComponentThemes.elevatedButtonTheme,
    outlinedButtonTheme: ComponentThemes.outlinedButtonTheme,
    textButtonTheme: ComponentThemes.textButtonTheme,
    floatingActionButtonTheme: ComponentThemes.fabTheme,
    appBarTheme: ComponentThemes.appBarTheme,
    navigationBarTheme: ComponentThemes.navigationBarTheme,
    bottomSheetTheme: ComponentThemes.bottomSheetTheme,
    dialogTheme: ComponentThemes.dialogTheme,
    chipTheme: ComponentThemes.chipTheme,
    
    // Additional Themes
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 16,
    ),
    
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.onSurface.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.critical, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.darkColorScheme,
    textTheme: AppTypography.arabicTextTheme.apply(
      bodyColor: AppColorSchemes.darkColorScheme.onSurface,
      displayColor: AppColorSchemes.darkColorScheme.onSurface,
    ),
    
    // Dark mode specific overrides
    cardTheme: ComponentThemes.cardTheme.copyWith(
      color: AppColorSchemes.darkColorScheme.surface,
    ),
    
    appBarTheme: ComponentThemes.appBarTheme.copyWith(
      backgroundColor: AppColorSchemes.darkColorScheme.surface,
      foregroundColor: AppColorSchemes.darkColorScheme.onSurface,
    ),
  );

  // Medical-specific theme extensions
  static ThemeData get medicalTheme => lightTheme.copyWith(
    colorScheme: AppColorSchemes.medicalColorScheme,
    extensions: [
      MedicalColors(
        critical: AppColors.critical,
        emergency: AppColors.emergency,
        urgent: AppColors.urgent,
        stable: AppColors.stable,
        hospital: AppColors.hospital,
        doctor: AppColors.doctor,
        nurse: AppColors.nurse,
        patient: AppColors.patient,
      ),
    ],
  );
}

// Custom theme extension for medical colors
@immutable
class MedicalColors extends ThemeExtension<MedicalColors> {
  final Color critical;
  final Color emergency;
  final Color urgent;
  final Color stable;
  final Color hospital;
  final Color doctor;
  final Color nurse;
  final Color patient;

  const MedicalColors({
    required this.critical,
    required this.emergency,
    required this.urgent,
    required this.stable,
    required this.hospital,
    required this.doctor,
    required this.nurse,
    required this.patient,
  });

  @override
  MedicalColors copyWith({
    Color? critical,
    Color? emergency,
    Color? urgent,
    Color? stable,
    Color? hospital,
    Color? doctor,
    Color? nurse,
    Color? patient,
  }) {
    return MedicalColors(
      critical: critical ?? this.critical,
      emergency: emergency ?? this.emergency,
      urgent: urgent ?? this.urgent,
      stable: stable ?? this.stable,
      hospital: hospital ?? this.hospital,
      doctor: doctor ?? this.doctor,
      nurse: nurse ?? this.nurse,
      patient: patient ?? this.patient,
    );
  }

  @override
  MedicalColors lerp(MedicalColors? other, double t) {
    if (other is! MedicalColors) return this;
    return MedicalColors(
      critical: Color.lerp(critical, other.critical, t)!,
      emergency: Color.lerp(emergency, other.emergency, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      stable: Color.lerp(stable, other.stable, t)!,
      hospital: Color.lerp(hospital, other.hospital, t)!,
      doctor: Color.lerp(doctor, other.doctor, t)!,
      nurse: Color.lerp(nurse, other.nurse, t)!,
      patient: Color.lerp(patient, other.patient, t)!,
    );
  }
}
```

---

## 🎭 **Theme Usage Examples**

### Using Medical Colors

```dart
// In any widget
final medicalColors = Theme.of(context).extension<MedicalColors>()!;

Container(
  color: medicalColors.critical,
  child: Text('Critical Status'),
)
```

### Dynamic Theme Switching

```dart
// lib/providers/theme_provider.dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isMedicalTheme = true;

  ThemeMode get themeMode => _themeMode;
  bool get isMedicalTheme => _isMedicalTheme;

  ThemeData get lightTheme => _isMedicalTheme 
    ? AppTheme.medicalTheme 
    : AppTheme.lightTheme;

  ThemeData get darkTheme => AppTheme.darkTheme;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleMedicalTheme() {
    _isMedicalTheme = !_isMedicalTheme;
    notifyListeners();
  }
}
```

---

**🎨 Material Design 3 مع التخصيص الطبي للتطبيق**