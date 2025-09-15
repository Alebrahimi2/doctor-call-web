# 📱 Mobile-First Design & Accessibility - Doctor Call App

**Flutter Web & Mobile Responsive Design**  
**آخر تحديث**: 15 سبتمبر 2025

---

## 📋 **نظرة عامة**

تطبيق **Doctor Call** مصمم ليعمل بكفاءة على جميع الأجهزة:

- 📱 **Mobile First** - الأولوية للموبايل
- 💻 **Desktop Responsive** - متجاوب مع سطح المكتب
- 🌐 **Web Compatible** - متوافق مع المتصفحات
- ♿ **Accessibility** - إمكانية الوصول للجميع
- 🎨 **Material Design 3** - تصميم حديث

---

## 📐 **Breakpoints نقاط التجاوب**

### أحجام الشاشات:

| الجهاز | العرض | التصميم | الاستخدام |
|--------|-------|---------|-----------|
| **Mobile** | < 600px | Single Column | أساسي |
| **Tablet** | 600px - 1024px | Two Columns | متوسط |
| **Desktop** | > 1024px | Multi Columns | متقدم |
| **Large Desktop** | > 1440px | Wide Layout | شامل |

### تطبيق Breakpoints:

```dart
// lib/utils/responsive_helper.dart
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static int getCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
```

---

## 🏗️ **Responsive Layouts**

### 1️⃣ **Adaptive AppBar**

```dart
// lib/widgets/responsive/adaptive_app_bar.dart
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  const AdaptiveAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: ResponsiveHelper.isMobile(context) ? 18 : 24,
        ),
      ),
      actions: ResponsiveHelper.isMobile(context) 
        ? _buildMobileActions()
        : actions,
      elevation: ResponsiveHelper.isMobile(context) ? 4 : 0,
    );
  }
  
  List<Widget> _buildMobileActions() {
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          // Handle menu actions
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'profile', child: Text('الملف الشخصي')),
          PopupMenuItem(value: 'settings', child: Text('الإعدادات')),
          PopupMenuItem(value: 'logout', child: Text('تسجيل الخروج')),
        ],
      ),
    ];
  }

  @override
  Size get preferredSize => Size.fromHeight(
    ResponsiveHelper.isMobile(context) ? 56 : 64
  );
}
```

### 2️⃣ **Responsive Grid**

```dart
// lib/widgets/responsive/responsive_grid.dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.childAspectRatio = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

### 3️⃣ **Adaptive Navigation**

```dart
// lib/widgets/responsive/adaptive_navigation.dart
class AdaptiveNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  
  const AdaptiveNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final destinations = [
      NavigationDestination(
        icon: Icon(Icons.dashboard),
        label: 'الرئيسية',
      ),
      NavigationDestination(
        icon: Icon(Icons.people),
        label: 'المرضى',
      ),
      NavigationDestination(
        icon: Icon(Icons.local_hospital),
        label: 'المستشفيات',
      ),
      NavigationDestination(
        icon: Icon(Icons.assignment),
        label: 'المهام',
      ),
    ];

    if (ResponsiveHelper.isMobile(context)) {
      return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
      );
    } else {
      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        destinations: destinations
          .map((dest) => NavigationRailDestination(
            icon: dest.icon,
            label: Text(dest.label),
          ))
          .toList(),
      );
    }
  }
}
```

---

## ♿ **Accessibility Features**

### 1️⃣ **Semantic Labels**

```dart
// lib/widgets/accessible/accessible_button.dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;

  const AccessibleButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      hint: tooltip,
      button: true,
      child: Tooltip(
        message: tooltip ?? text,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
```

### 2️⃣ **Screen Reader Support**

```dart
// lib/widgets/accessible/accessible_patient_card.dart
class AccessiblePatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;

  const AccessiblePatientCard({
    Key? key,
    required this.patient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final semanticLabel = '''
      مريض: ${patient.name}، 
      العمر: ${patient.age} سنة، 
      الحالة: ${patient.condition}، 
      الوضع: ${patient.status}، 
      الأولوية: ${patient.severity}
    ''';

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getSeverityColor(patient.severity),
            child: Text(
              patient.name.substring(0, 1),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            patient.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العمر: ${patient.age}'),
              Text('الحالة: ${patient.condition}'),
              Text('الوضع: ${patient.status}'),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical': return Colors.red;
      case 'emergency': return Colors.orange;
      case 'urgent': return Colors.yellow;
      default: return Colors.green;
    }
  }
}
```

### 3️⃣ **High Contrast Support**

```dart
// lib/themes/accessible_theme.dart
class AccessibleTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    textTheme: _accessibleTextTheme,
    elevatedButtonTheme: _accessibleButtonTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: _accessibleTextTheme,
    elevatedButtonTheme: _accessibleButtonTheme,
  );

  static ThemeData get highContrastTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.highContrastLight(),
    textTheme: _highContrastTextTheme,
    elevatedButtonTheme: _highContrastButtonTheme,
  );

  static TextTheme get _accessibleTextTheme => const TextTheme(
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  );

  static TextTheme get _highContrastTextTheme => const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18, 
      height: 1.6, 
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 16, 
      height: 1.5, 
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.bold,
    ),
  );

  static ElevatedButtonThemeData get _accessibleButtonTheme =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(120, 48), // Minimum touch target
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );

  static ElevatedButtonThemeData get _highContrastButtonTheme =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(140, 56), // Larger touch targets
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
}
```

---

## 📱 **Mobile-Specific Components**

### 1️⃣ **Swipe Actions**

```dart
// lib/widgets/mobile/swipeable_patient_card.dart
class SwipeablePatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTreat;
  final VoidCallback? onTransfer;
  final VoidCallback? onDischarge;

  const SwipeablePatientCard({
    Key? key,
    required this.patient,
    this.onTreat,
    this.onTransfer,
    this.onDischarge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!ResponsiveHelper.isMobile(context)) {
      return PatientCard(patient: patient); // Regular card for desktop
    }

    return Dismissible(
      key: Key('patient_${patient.id}'),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.healing, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.transfer_within_a_station, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onTreat?.call();
        } else {
          onTransfer?.call();
        }
      },
      child: PatientCard(patient: patient),
    );
  }
}
```

### 2️⃣ **Bottom Sheet Actions**

```dart
// lib/widgets/mobile/patient_actions_sheet.dart
class PatientActionsSheet extends StatelessWidget {
  final Patient patient;

  const PatientActionsSheet({Key? key, required this.patient}) : super(key: key);

  static void show(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PatientActionsSheet(patient: patient),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'إجراءات للمريض: ${patient.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 24),
          _buildActionButton(
            context,
            icon: Icons.healing,
            title: 'بدء العلاج',
            subtitle: 'نقل المريض لحالة العلاج',
            color: Colors.green,
            onTap: () => _startTreatment(context),
          ),
          _buildActionButton(
            context,
            icon: Icons.transfer_within_a_station,
            title: 'نقل المريض',
            subtitle: 'نقل لقسم آخر',
            color: Colors.blue,
            onTap: () => _transferPatient(context),
          ),
          _buildActionButton(
            context,
            icon: Icons.assignment,
            title: 'تفاصيل الحالة',
            subtitle: 'عرض التفاصيل الكاملة',
            color: Colors.orange,
            onTap: () => _viewDetails(context),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  void _startTreatment(BuildContext context) {
    Navigator.pop(context);
    // Implement treatment logic
  }

  void _transferPatient(BuildContext context) {
    Navigator.pop(context);
    // Implement transfer logic
  }

  void _viewDetails(BuildContext context) {
    Navigator.pop(context);
    // Navigate to details screen
  }
}
```

---

## 🎨 **Touch-Friendly UI**

### 1️⃣ **Minimum Touch Targets**

```dart
// lib/constants/ui_constants.dart
class UIConstants {
  // Touch targets (minimum 44px according to accessibility guidelines)
  static const double minTouchTarget = 44.0;
  static const double recommendedTouchTarget = 48.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Responsive spacing
  static double getSpacing(BuildContext context, double baseSpacing) {
    if (ResponsiveHelper.isMobile(context)) {
      return baseSpacing;
    } else if (ResponsiveHelper.isTablet(context)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.5;
    }
  }
}
```

### 2️⃣ **Gesture-Friendly Cards**

```dart
// lib/widgets/touch/gesture_patient_card.dart
class GesturePatientCard extends StatefulWidget {
  final Patient patient;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const GesturePatientCard({
    Key? key,
    required this.patient,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  _GesturePatientCardState createState() => _GesturePatientCardState();
}

class _GesturePatientCardState extends State<GesturePatientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      onLongPress: () {
        _animationController.reverse();
        widget.onLongPress?.call();
        
        // Haptic feedback for mobile
        if (ResponsiveHelper.isMobile(context)) {
          HapticFeedback.mediumImpact();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(
                horizontal: UIConstants.spacingM,
                vertical: UIConstants.spacingS,
              ),
              child: Container(
                padding: EdgeInsets.all(UIConstants.spacingM),
                constraints: BoxConstraints(
                  minHeight: UIConstants.recommendedTouchTarget,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: _getSeverityColor(),
                      child: Text(
                        widget.patient.name.substring(0, 1),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: UIConstants.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.patient.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${widget.patient.age} سنة - ${widget.patient.condition}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getSeverityColor() {
    switch (widget.patient.severity) {
      case 'critical': return Colors.red;
      case 'emergency': return Colors.orange;
      case 'urgent': return Colors.yellow;
      default: return Colors.green;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

---

## 📊 **Performance Optimization**

### 1️⃣ **Lazy Loading for Large Lists**

```dart
// lib/widgets/performance/lazy_patient_list.dart
class LazyPatientList extends StatefulWidget {
  final List<Patient> patients;
  
  const LazyPatientList({Key? key, required this.patients}) : super(key: key);

  @override
  _LazyPatientListState createState() => _LazyPatientListState();
}

class _LazyPatientListState extends State<LazyPatientList> {
  final ScrollController _scrollController = ScrollController();
  static const int _itemsPerPage = 20;
  int _currentPage = 0;
  
  List<Patient> get _visiblePatients {
    final endIndex = (_currentPage + 1) * _itemsPerPage;
    return widget.patients.take(endIndex).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if ((_currentPage + 1) * _itemsPerPage < widget.patients.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _visiblePatients.length + 1,
      itemBuilder: (context, index) {
        if (index < _visiblePatients.length) {
          return GesturePatientCard(
            patient: _visiblePatients[index],
            onTap: () => _onPatientTap(_visiblePatients[index]),
          );
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.all(UIConstants.spacingM),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _onPatientTap(Patient patient) {
    if (ResponsiveHelper.isMobile(context)) {
      PatientActionsSheet.show(context, patient);
    } else {
      // Navigate to details for desktop
      Navigator.pushNamed(context, '/patient-details', arguments: patient);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

## 🔧 **Testing Mobile UI**

### 1️⃣ **Device Preview Testing**

```dart
// lib/main.dart
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only in debug mode
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: DashboardScreen(),
    );
  }
}
```

---

## 📝 **Best Practices**

### ✅ **Mobile-First Checklist**

- [ ] **Touch Targets**: 44px minimum
- [ ] **Responsive Text**: Scales with device
- [ ] **Navigation**: Appropriate for screen size
- [ ] **Images**: Optimized for retina displays
- [ ] **Loading States**: Show progress indicators
- [ ] **Error Handling**: User-friendly error messages
- [ ] **Offline Support**: Cache critical data
- [ ] **Performance**: 60fps animations

### ♿ **Accessibility Checklist**

- [ ] **Screen Reader**: Semantic labels
- [ ] **Color Contrast**: WCAG 2.1 compliant
- [ ] **Font Size**: Scalable text
- [ ] **Keyboard Navigation**: Full app access
- [ ] **Focus Management**: Clear focus indicators
- [ ] **Voice Over**: iOS compatibility
- [ ] **TalkBack**: Android compatibility

---

**📞 للدعم الفني**: راجع [Flutter Documentation](https://docs.flutter.dev/development/ui/layout/responsive)