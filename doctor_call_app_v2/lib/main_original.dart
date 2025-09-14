import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/dashboard_content.dart';
import 'screens/departments_screen.dart';
import 'screens/hospital_screen.dart';
import 'screens/indicators_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/settings_screen.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageService().loadLanguage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageService(),
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'Doctor Call Dashboard',
            locale: languageService.currentLocale,
            supportedLocales: LanguageService.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFF007BFF),
              fontFamily: languageService.isRTL() ? 'Tajawal' : null,
            ),
            debugShowCheckedModeBanner: false,
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // قائمة الويدجت الخاصة بكل صفحة
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardContent(),
    HospitalScreen(),
    DepartmentsScreen(),
    PatientsScreen(),
    MissionsScreen(),
    IndicatorsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // إغلاق الـ Drawer إذا كان مفتوحًا على الشاشات الصغيرة
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدام LayoutBuilder لتحديد عرض الشاشة
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 600;
        return Scaffold(
          appBar: isDesktop
              ? null // لا يوجد AppBar على شاشات سطح المكتب
              : AppBar(
                  title: const Text('القائمة الرئيسية'),
                  backgroundColor: const Color(0xFF007BFF),
                  elevation: 0,
                ),
          // إظهار الـ Drawer فقط على الشاشات الصغيرة
          drawer: isDesktop
              ? null
              : Drawer(
                  child: SidebarMenu(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  ),
                ),
          body: Row(
            children: [
              // إظهار الشريط الجانبي على الشاشات الكبيرة
              if (isDesktop)
                SidebarMenu(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                ),
              // محتوى الصفحة الرئيسي
              Expanded(
                child: Container(
                  color: Colors.white, // خلفية بيضاء لمنطقة المحتوى
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ويدجت الشريط الجانبي القابل لإعادة الاستخدام
class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SidebarMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final loc = AppLocalizations.of(context)!;
    final isRTL = languageService.isRTL();

    final menuItems = [
      loc.dashboard,
      loc.hospital,
      loc.departments,
      loc.patients,
      loc.missions,
      loc.indicators,
      loc.settings,
    ];

    final colors = [
      Colors.white,
      Colors.white,
      const Color(0xFFFFC107), // أصفر
      const Color(0xFF17A2B8), // سماوي
      const Color(0xFF6C757D), // رمادي
      const Color(0xFF28A745), // أخضر
      const Color(0xFF343A40), // أسود
    ];

    final textColors = [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];

    return Container(
      width: 250,
      color: const Color(0xFF007BFF),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: isRTL
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: isRTL ? 16.0 : 0,
              left: isRTL ? 0 : 16.0,
              top: 20.0,
              bottom: 20.0,
            ),
            child: Text(
              loc.dashboard,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                    color: isSelected
                        ? colors[index].withValues(alpha: 0.9)
                        : colors[index],
                    borderRadius: BorderRadius.circular(8),
                    elevation: isSelected ? 4 : 0,
                    shadowColor: Colors.black.withValues(alpha: 0.5),
                    child: InkWell(
                      onTap: () => onItemTapped(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          menuItems[index],
                          style: TextStyle(
                            color: isSelected
                                ? textColors[index]
                                : textColors[index],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
