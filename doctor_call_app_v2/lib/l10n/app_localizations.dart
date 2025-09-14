import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// No description provided for @indicators.
  ///
  /// In en, this message translates to:
  /// **'Indicators'**
  String get indicators;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @hospitalManagement.
  ///
  /// In en, this message translates to:
  /// **'Hospital Management'**
  String get hospitalManagement;

  /// No description provided for @totalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get totalPatients;

  /// No description provided for @totalDepartments.
  ///
  /// In en, this message translates to:
  /// **'Total Departments'**
  String get totalDepartments;

  /// No description provided for @activeMissions.
  ///
  /// In en, this message translates to:
  /// **'Active Missions'**
  String get activeMissions;

  /// No description provided for @performanceIndicators.
  ///
  /// In en, this message translates to:
  /// **'Performance Indicators'**
  String get performanceIndicators;

  /// No description provided for @patientsList.
  ///
  /// In en, this message translates to:
  /// **'Patients List'**
  String get patientsList;

  /// No description provided for @addNewPatient.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get addNewPatient;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @patientId.
  ///
  /// In en, this message translates to:
  /// **'Patient ID'**
  String get patientId;

  /// No description provided for @admissionDate.
  ///
  /// In en, this message translates to:
  /// **'Admission Date'**
  String get admissionDate;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @departmentsList.
  ///
  /// In en, this message translates to:
  /// **'Departments List'**
  String get departmentsList;

  /// No description provided for @addNewDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add New Department'**
  String get addNewDepartment;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentName;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @availableBeds.
  ///
  /// In en, this message translates to:
  /// **'Available Beds'**
  String get availableBeds;

  /// No description provided for @hospitalInfo.
  ///
  /// In en, this message translates to:
  /// **'Hospital Information'**
  String get hospitalInfo;

  /// No description provided for @totalBeds.
  ///
  /// In en, this message translates to:
  /// **'Total Beds'**
  String get totalBeds;

  /// No description provided for @occupiedBeds.
  ///
  /// In en, this message translates to:
  /// **'Occupied Beds'**
  String get occupiedBeds;

  /// No description provided for @availableBedsCount.
  ///
  /// In en, this message translates to:
  /// **'Available Beds'**
  String get availableBedsCount;

  /// No description provided for @occupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get occupancyRate;

  /// No description provided for @missionsList.
  ///
  /// In en, this message translates to:
  /// **'Missions List'**
  String get missionsList;

  /// No description provided for @addNewMission.
  ///
  /// In en, this message translates to:
  /// **'Add New Mission'**
  String get addNewMission;

  /// No description provided for @missionTitle.
  ///
  /// In en, this message translates to:
  /// **'Mission Title'**
  String get missionTitle;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned To'**
  String get assignedTo;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @performanceMetrics.
  ///
  /// In en, this message translates to:
  /// **'Performance Metrics'**
  String get performanceMetrics;

  /// No description provided for @patientSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Patient Satisfaction'**
  String get patientSatisfaction;

  /// No description provided for @staffEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Staff Efficiency'**
  String get staffEfficiency;

  /// No description provided for @responseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// No description provided for @qualityScore.
  ///
  /// In en, this message translates to:
  /// **'Quality Score'**
  String get qualityScore;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @systemSettings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get systemSettings;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @cardiology.
  ///
  /// In en, this message translates to:
  /// **'Cardiology'**
  String get cardiology;

  /// No description provided for @pediatrics.
  ///
  /// In en, this message translates to:
  /// **'Pediatrics'**
  String get pediatrics;

  /// No description provided for @surgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgery;

  /// No description provided for @icu.
  ///
  /// In en, this message translates to:
  /// **'ICU'**
  String get icu;

  /// No description provided for @totalPatientsStat.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get totalPatientsStat;

  /// No description provided for @executedMissions.
  ///
  /// In en, this message translates to:
  /// **'Executed Missions'**
  String get executedMissions;

  /// No description provided for @mainDashboard.
  ///
  /// In en, this message translates to:
  /// **'Main Dashboard'**
  String get mainDashboard;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @activeDepartments.
  ///
  /// In en, this message translates to:
  /// **'Active Departments'**
  String get activeDepartments;

  /// No description provided for @waitingTime.
  ///
  /// In en, this message translates to:
  /// **'Waiting Time'**
  String get waitingTime;

  /// No description provided for @allDepartments.
  ///
  /// In en, this message translates to:
  /// **'All Departments'**
  String get allDepartments;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @medicalDepartmentsManagement.
  ///
  /// In en, this message translates to:
  /// **'Medical Departments Management'**
  String get medicalDepartmentsManagement;

  /// No description provided for @totalRooms.
  ///
  /// In en, this message translates to:
  /// **'Total Rooms'**
  String get totalRooms;

  /// No description provided for @totalWards.
  ///
  /// In en, this message translates to:
  /// **'Total Wards'**
  String get totalWards;

  /// No description provided for @averageCapacity.
  ///
  /// In en, this message translates to:
  /// **'Average Capacity'**
  String get averageCapacity;

  /// No description provided for @filtersAndSearch.
  ///
  /// In en, this message translates to:
  /// **'Filters and Search'**
  String get filtersAndSearch;

  /// No description provided for @departmentType.
  ///
  /// In en, this message translates to:
  /// **'Department Type'**
  String get departmentType;

  /// No description provided for @emergencyDepartment.
  ///
  /// In en, this message translates to:
  /// **'Emergency Department'**
  String get emergencyDepartment;

  /// No description provided for @surgeryDepartment.
  ///
  /// In en, this message translates to:
  /// **'Surgery Department'**
  String get surgeryDepartment;

  /// No description provided for @internalMedicine.
  ///
  /// In en, this message translates to:
  /// **'Internal Medicine'**
  String get internalMedicine;

  /// No description provided for @intensive.
  ///
  /// In en, this message translates to:
  /// **'Intensive Care'**
  String get intensive;

  /// No description provided for @outpatient.
  ///
  /// In en, this message translates to:
  /// **'Outpatient'**
  String get outpatient;

  /// No description provided for @centralHospital.
  ///
  /// In en, this message translates to:
  /// **'Central Hospital'**
  String get centralHospital;

  /// No description provided for @northernHospital.
  ///
  /// In en, this message translates to:
  /// **'Northern Hospital'**
  String get northernHospital;

  /// No description provided for @southernHospital.
  ///
  /// In en, this message translates to:
  /// **'Southern Hospital'**
  String get southernHospital;

  /// No description provided for @westernHospital.
  ///
  /// In en, this message translates to:
  /// **'Western Hospital'**
  String get westernHospital;

  /// No description provided for @easternHospital.
  ///
  /// In en, this message translates to:
  /// **'Eastern Hospital'**
  String get easternHospital;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room Type'**
  String get roomType;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room Number'**
  String get roomNumber;

  /// No description provided for @bedCapacity.
  ///
  /// In en, this message translates to:
  /// **'Bed Capacity'**
  String get bedCapacity;

  /// No description provided for @availableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available Rooms'**
  String get availableRooms;

  /// No description provided for @occupiedRooms.
  ///
  /// In en, this message translates to:
  /// **'Occupied Rooms'**
  String get occupiedRooms;

  /// No description provided for @maintenanceRooms.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Rooms'**
  String get maintenanceRooms;

  /// No description provided for @singleRoom.
  ///
  /// In en, this message translates to:
  /// **'Single Room'**
  String get singleRoom;

  /// No description provided for @doubleRoom.
  ///
  /// In en, this message translates to:
  /// **'Double Room'**
  String get doubleRoom;

  /// No description provided for @ward.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get ward;

  /// No description provided for @operatingRoom.
  ///
  /// In en, this message translates to:
  /// **'Operating Room'**
  String get operatingRoom;

  /// No description provided for @emergencyRoom.
  ///
  /// In en, this message translates to:
  /// **'Emergency Room'**
  String get emergencyRoom;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get addRoom;

  /// No description provided for @editRoom.
  ///
  /// In en, this message translates to:
  /// **'Edit Room'**
  String get editRoom;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete Room'**
  String get deleteRoom;

  /// No description provided for @roomStatus.
  ///
  /// In en, this message translates to:
  /// **'Room Status'**
  String get roomStatus;

  /// No description provided for @underMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get underMaintenance;

  /// No description provided for @detailedStatistics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailedStatistics;

  /// No description provided for @averageWaitingTime.
  ///
  /// In en, this message translates to:
  /// **'Average Waiting Time'**
  String get averageWaitingTime;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @serviceEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Service Efficiency'**
  String get serviceEfficiency;

  /// No description provided for @completedMissions.
  ///
  /// In en, this message translates to:
  /// **'Completed Missions'**
  String get completedMissions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'arrived'**
  String get arrived;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'Mission'**
  String get mission;

  /// No description provided for @newReport.
  ///
  /// In en, this message translates to:
  /// **'New report'**
  String get newReport;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'generated'**
  String get generated;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatient;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @addMission.
  ///
  /// In en, this message translates to:
  /// **'Add Mission'**
  String get addMission;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @weeklyMeeting.
  ///
  /// In en, this message translates to:
  /// **'Weekly Meeting'**
  String get weeklyMeeting;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @systemMaintenance.
  ///
  /// In en, this message translates to:
  /// **'System Maintenance'**
  String get systemMaintenance;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get monthlyReport;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @generalHospital.
  ///
  /// In en, this message translates to:
  /// **'General Hospital'**
  String get generalHospital;

  /// No description provided for @specializedHospital.
  ///
  /// In en, this message translates to:
  /// **'Specialized Hospital'**
  String get specializedHospital;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @addDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add Department'**
  String get addDepartment;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @noDepartmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Departments Found'**
  String get noDepartmentsFound;

  /// No description provided for @addFirstDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add First Department'**
  String get addFirstDepartment;

  /// No description provided for @hospitalManagementAndData.
  ///
  /// In en, this message translates to:
  /// **'Hospital Management and Data'**
  String get hospitalManagementAndData;

  /// No description provided for @hospitalLevel.
  ///
  /// In en, this message translates to:
  /// **'Hospital Level'**
  String get hospitalLevel;

  /// No description provided for @reputationRate.
  ///
  /// In en, this message translates to:
  /// **'Reputation Rate'**
  String get reputationRate;

  /// No description provided for @cashBalance.
  ///
  /// In en, this message translates to:
  /// **'Cash Balance'**
  String get cashBalance;

  /// No description provided for @virtualCurrency.
  ///
  /// In en, this message translates to:
  /// **'Virtual Currency'**
  String get virtualCurrency;

  /// No description provided for @hospitalInformation.
  ///
  /// In en, this message translates to:
  /// **'Hospital Information'**
  String get hospitalInformation;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @establishmentYear.
  ///
  /// In en, this message translates to:
  /// **'Establishment Year'**
  String get establishmentYear;

  /// No description provided for @bed.
  ///
  /// In en, this message translates to:
  /// **'bed'**
  String get bed;

  /// No description provided for @numberOfEmployees.
  ///
  /// In en, this message translates to:
  /// **'Number of Employees'**
  String get numberOfEmployees;

  /// No description provided for @operationalStatistics.
  ///
  /// In en, this message translates to:
  /// **'Operational Statistics'**
  String get operationalStatistics;

  /// No description provided for @activeDoctors.
  ///
  /// In en, this message translates to:
  /// **'Active Doctors'**
  String get activeDoctors;

  /// No description provided for @activeNurses.
  ///
  /// In en, this message translates to:
  /// **'Active Nurses'**
  String get activeNurses;

  /// No description provided for @financialStatistics.
  ///
  /// In en, this message translates to:
  /// **'Financial Statistics'**
  String get financialStatistics;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @monthlyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expenses'**
  String get monthlyExpenses;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @totalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get totalAssets;

  /// No description provided for @keyPerformanceIndicators.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get keyPerformanceIndicators;

  /// No description provided for @operationalEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Operational Efficiency'**
  String get operationalEfficiency;

  /// No description provided for @bedOccupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Bed Occupancy Rate'**
  String get bedOccupancyRate;

  /// No description provided for @financialHealthIndex.
  ///
  /// In en, this message translates to:
  /// **'Financial Health Index'**
  String get financialHealthIndex;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @qualityAward.
  ///
  /// In en, this message translates to:
  /// **'Quality Award'**
  String get qualityAward;

  /// No description provided for @excellenceRating.
  ///
  /// In en, this message translates to:
  /// **'Excellence Rating'**
  String get excellenceRating;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get stars;

  /// No description provided for @accreditation.
  ///
  /// In en, this message translates to:
  /// **'Accreditation'**
  String get accreditation;

  /// No description provided for @international.
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get international;

  /// No description provided for @adminTools.
  ///
  /// In en, this message translates to:
  /// **'Admin Tools'**
  String get adminTools;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// No description provided for @totalReports.
  ///
  /// In en, this message translates to:
  /// **'Total Reports'**
  String get totalReports;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @lastReport.
  ///
  /// In en, this message translates to:
  /// **'Last Report'**
  String get lastReport;

  /// No description provided for @filtersAndReports.
  ///
  /// In en, this message translates to:
  /// **'Filters and Reports'**
  String get filtersAndReports;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @reportType.
  ///
  /// In en, this message translates to:
  /// **'Report Type'**
  String get reportType;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get exportExcel;

  /// No description provided for @detailedPerformanceReports.
  ///
  /// In en, this message translates to:
  /// **'Detailed Performance Reports'**
  String get detailedPerformanceReports;

  /// No description provided for @addNewReport.
  ///
  /// In en, this message translates to:
  /// **'Add New Report'**
  String get addNewReport;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @serviceRate.
  ///
  /// In en, this message translates to:
  /// **'Service Rate'**
  String get serviceRate;

  /// No description provided for @occupancyRatePercent.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate (%)'**
  String get occupancyRatePercent;

  /// No description provided for @patientSatisfactionPercent.
  ///
  /// In en, this message translates to:
  /// **'Patient Satisfaction (%)'**
  String get patientSatisfactionPercent;

  /// No description provided for @performanceStatus.
  ///
  /// In en, this message translates to:
  /// **'Performance Status'**
  String get performanceStatus;

  /// No description provided for @noReportsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Reports Available'**
  String get noReportsAvailable;

  /// No description provided for @monthlyStatistics.
  ///
  /// In en, this message translates to:
  /// **'Monthly Statistics'**
  String get monthlyStatistics;

  /// No description provided for @bestPerformance.
  ///
  /// In en, this message translates to:
  /// **'Best Performance'**
  String get bestPerformance;

  /// No description provided for @worstPerformance.
  ///
  /// In en, this message translates to:
  /// **'Worst Performance'**
  String get worstPerformance;

  /// No description provided for @performanceTargets.
  ///
  /// In en, this message translates to:
  /// **'Performance Targets'**
  String get performanceTargets;

  /// No description provided for @targetWaitingTime.
  ///
  /// In en, this message translates to:
  /// **'Target Waiting Time'**
  String get targetWaitingTime;

  /// No description provided for @targetSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Target Satisfaction'**
  String get targetSatisfaction;

  /// No description provided for @targetOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Target Occupancy'**
  String get targetOccupancy;

  /// No description provided for @targetServiceRate.
  ///
  /// In en, this message translates to:
  /// **'Target Service Rate'**
  String get targetServiceRate;

  /// No description provided for @allMissions.
  ///
  /// In en, this message translates to:
  /// **'All Missions'**
  String get allMissions;

  /// No description provided for @medicalMissionsManagement.
  ///
  /// In en, this message translates to:
  /// **'Medical Missions Management'**
  String get medicalMissionsManagement;

  /// No description provided for @totalMissions.
  ///
  /// In en, this message translates to:
  /// **'Total Missions'**
  String get totalMissions;

  /// No description provided for @delayedMissions.
  ///
  /// In en, this message translates to:
  /// **'Delayed Missions'**
  String get delayedMissions;

  /// No description provided for @missionStatus.
  ///
  /// In en, this message translates to:
  /// **'Mission Status'**
  String get missionStatus;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @missionType.
  ///
  /// In en, this message translates to:
  /// **'Mission Type'**
  String get missionType;

  /// No description provided for @emergencyMission.
  ///
  /// In en, this message translates to:
  /// **'Emergency Mission'**
  String get emergencyMission;

  /// No description provided for @routineMission.
  ///
  /// In en, this message translates to:
  /// **'Routine Mission'**
  String get routineMission;

  /// No description provided for @maintenanceMission.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mission'**
  String get maintenanceMission;

  /// No description provided for @consultationMission.
  ///
  /// In en, this message translates to:
  /// **'Consultation Mission'**
  String get consultationMission;

  /// No description provided for @missionCalendar.
  ///
  /// In en, this message translates to:
  /// **'Mission Calendar'**
  String get missionCalendar;

  /// No description provided for @currentMonth.
  ///
  /// In en, this message translates to:
  /// **'Current Month'**
  String get currentMonth;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get calendarView;

  /// No description provided for @missionNumber.
  ///
  /// In en, this message translates to:
  /// **'Mission Number'**
  String get missionNumber;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @noMissionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Missions Found'**
  String get noMissionsFound;

  /// No description provided for @addFirstMission.
  ///
  /// In en, this message translates to:
  /// **'Add First Mission'**
  String get addFirstMission;

  /// No description provided for @teamPerformance.
  ///
  /// In en, this message translates to:
  /// **'Team Performance'**
  String get teamPerformance;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @averageResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Average Response Time'**
  String get averageResponseTime;

  /// No description provided for @onTimeDelivery.
  ///
  /// In en, this message translates to:
  /// **'On Time Delivery'**
  String get onTimeDelivery;

  /// No description provided for @activeTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Active Team Members'**
  String get activeTeamMembers;

  /// No description provided for @patientNameOrId.
  ///
  /// In en, this message translates to:
  /// **'Patient Name or ID'**
  String get patientNameOrId;

  /// No description provided for @patientsManagement.
  ///
  /// In en, this message translates to:
  /// **'Patients Management'**
  String get patientsManagement;

  /// No description provided for @inService.
  ///
  /// In en, this message translates to:
  /// **'In Service'**
  String get inService;

  /// No description provided for @criticalCases.
  ///
  /// In en, this message translates to:
  /// **'Critical Cases'**
  String get criticalCases;

  /// No description provided for @discharged.
  ///
  /// In en, this message translates to:
  /// **'Discharged'**
  String get discharged;

  /// No description provided for @caseSeverity.
  ///
  /// In en, this message translates to:
  /// **'Case Severity'**
  String get caseSeverity;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @routine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get routine;

  /// No description provided for @patientType.
  ///
  /// In en, this message translates to:
  /// **'Patient Type'**
  String get patientType;

  /// No description provided for @inpatient.
  ///
  /// In en, this message translates to:
  /// **'Inpatient'**
  String get inpatient;

  /// No description provided for @patientNumber.
  ///
  /// In en, this message translates to:
  /// **'Patient Number'**
  String get patientNumber;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get arrivalTime;

  /// No description provided for @noPatientsFound.
  ///
  /// In en, this message translates to:
  /// **'No Patients Found'**
  String get noPatientsFound;

  /// No description provided for @addFirstPatient.
  ///
  /// In en, this message translates to:
  /// **'Add First Patient'**
  String get addFirstPatient;

  /// No description provided for @addEmergencyPatient.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Patient'**
  String get addEmergencyPatient;

  /// No description provided for @transferPatient.
  ///
  /// In en, this message translates to:
  /// **'Transfer Patient'**
  String get transferPatient;

  /// No description provided for @dischargePatient.
  ///
  /// In en, this message translates to:
  /// **'Discharge Patient'**
  String get dischargePatient;

  /// No description provided for @generalSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'General System Settings'**
  String get generalSystemSettings;

  /// No description provided for @systemName.
  ///
  /// In en, this message translates to:
  /// **'System Name'**
  String get systemName;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @defaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Default Language'**
  String get defaultLanguage;

  /// No description provided for @maxUsersAllowed.
  ///
  /// In en, this message translates to:
  /// **'Max Users Allowed'**
  String get maxUsersAllowed;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @addNewUser.
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get addNewUser;

  /// No description provided for @exportUserList.
  ///
  /// In en, this message translates to:
  /// **'Export User List'**
  String get exportUserList;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @enableTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Enable Two Factor'**
  String get enableTwoFactor;

  /// No description provided for @recordUserActivity.
  ///
  /// In en, this message translates to:
  /// **'Record User Activity'**
  String get recordUserActivity;

  /// No description provided for @sessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Session Duration'**
  String get sessionDuration;

  /// No description provided for @maxLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Max Login Attempts'**
  String get maxLoginAttempts;

  /// No description provided for @saveSecuritySettings.
  ///
  /// In en, this message translates to:
  /// **'Save Security Settings'**
  String get saveSecuritySettings;

  /// No description provided for @backupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup Section'**
  String get backupSection;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// No description provided for @createBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Create Backup Now'**
  String get createBackupNow;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @noFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No File Chosen'**
  String get noFileChosen;

  /// No description provided for @restoreFromFile.
  ///
  /// In en, this message translates to:
  /// **'Restore From File'**
  String get restoreFromFile;

  /// No description provided for @systemStatistics.
  ///
  /// In en, this message translates to:
  /// **'System Statistics'**
  String get systemStatistics;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @registeredHospitals.
  ///
  /// In en, this message translates to:
  /// **'Registered Hospitals'**
  String get registeredHospitals;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
