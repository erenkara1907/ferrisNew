import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../utility/error_handler/sentry_error_handler.dart';

enum ServicePath {
  login('/api/v1/auth/login'),
  verifyOtp("/api/v1/auth/verify-otp"),
  changePassword("/api/v1/auth/change-password"),
  getUser("/api/v1/auth/get-user"),
  setDeviceToken("/api/v1/set-device-token"),
  logout("/api/v1/auth/logout"),
  jobValetStandards("/api/v1/job-valet-standards"),
  jobExpenses("/api/v1/job-expenses"),
  jobExpenseCategories("/api/v1/job-expense-categories"),
  jobStops("/api/v1/job-stops"),
  jobsStopCategories("/api/v1/job-stop-categories"),
  jobTrackings("/api/v1/job-tracking-cordinates"),
  jobTrackingsBulk("/api/v1/job-tracking-cordinates/bulk"),
  jobConditionImage("/api/v1/job-inspection-condition-images"),
  damageCategories("/api/v1/categories"),
  getAllDamageAssets("/api/v1/get-all-damage-assets"),
  getAllDamageCombination("/api/v1/damage-combinations"),
  getAllGrade("/api/v1/grades"),
  getAllGradeRule("/api/v1/grade-rules"),
  getAllGradeRuleUplift("/api/v1/grade-rule-uplifts"),
  jobInspectionsDamages("/api/v1/damages"),
  jobInspectionsCheckList("/api/v1/job-inspection-checklists"),
  damageFailures("/api/v1/failures"),

  damageIssues("/api/v1/issues"),
  damageParts("/api/v1/parts"),
  damageRepairs("/api/v1/repairs"),
  damageDelete("/api/v1/damages"),
  jobInspections("/api/v1/job-inspections"),
  jobInspectionsUpdate("/api/v1/job-inspections/update"),
  jobInspectionsAbortTypes("/api/v1/job-inspection-abort-types"),
  jobInspectionsCustomerSign("/api/v1/job-inspections/customer-sign"),
  jobInspectionsInspectorSign("/api/v1/job-inspections//inspector-sign"),
  job("/api/v1/jobs"),
  jobPrice("/api/v1/pricing-templates");

  final String value;
  const ServicePath(this.value);
}

final class NetworkSpeedChecker {
// Function to check network speed(Future Method)
  Future<bool> checkNetworkSpeed(BuildContext context) async {
    const url =
        'https://drive.google.com/uc?export=download&id=1lEn1DtJQW6-nTcoS_FG7-EB3Kamy0147'; // Doğrudan indirme için link
    final stopwatch = Stopwatch()..start();
    const thresholdKbps = 500; // Zayıf sinyal eşiği Kbps cinsinden

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final elapsed = stopwatch.elapsedMilliseconds;
        final speedInKbps =
            ((response.bodyBytes.length / 1024) / (elapsed / 1000)) *
                8; // İndirme hızını Kbps cinsinden hesapla

        bool isWeakSignal =
            speedInKbps < thresholdKbps; // Hız eşiğin altında mı kontrol et
        return isWeakSignal;
      } else {
        // İndirme başarısız olduysa zayıf sinyal olarak kabul et
        return true; // Hata durumunda zayıf sinyal
      }
    } catch (e, s) {
      await SentryErrorHandler.instance.capture(e, stackTrace: s);
      // İstisna durumunda zayıf sinyal olarak kabul et
      return true; // İstisna durumunda zayıf sinyal
    }
  }
}
