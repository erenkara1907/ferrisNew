import 'package:ferrisfwt/feature/auth/presentation/view/forgot_password_page.dart';
import 'package:ferrisfwt/feature/auth/presentation/view/sign_in_page.dart';
import 'package:ferrisfwt/feature/auth/presentation/view/verification_code_page.dart';
import 'package:ferrisfwt/feature/auth/presentation/view/verification_page.dart';
import 'package:ferrisfwt/feature/auth/presentation/view/login_page.dart';
import 'package:ferrisfwt/feature/bottom_nav/view/bottom_nav_page.dart';
import 'package:ferrisfwt/feature/chat/presantation/view/chat_page.dart';
import 'package:ferrisfwt/feature/history/presantation/view/history_page.dart';
import 'package:ferrisfwt/feature/history/presantation/view/history_search_page.dart';
import 'package:ferrisfwt/feature/home/data/models/damages/damage_response_model.dart';
import 'package:ferrisfwt/feature/home/data/models/expenses/expenses_response_model_item.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/movement_type/feedback_input_availability.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/map_view2_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/view_expense_detail.dart';
import 'package:ferrisfwt/feature/inspections/data/models/job_inspection_response_model_item.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/I%CC%87nspection_detail_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/condition_image_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/damage_detail_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/damage_recorder&add_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/damages_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/deneme_view.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/edit_details_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/inspection_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/item_checklist_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/sign_inspection2_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/sign_inspection_page.dart';
import 'package:ferrisfwt/feature/inspections/presentation/inspection_view/sign_inspection_widget.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/add_stop_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/expense_detail_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/feedback_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/fuel_level_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/map_view_page.dart';
import 'package:ferrisfwt/feature/home/presentation/sub_view/view_expenses_page.dart';
import 'package:ferrisfwt/feature/home/presentation/view/finish_job_page.dart';
import 'package:ferrisfwt/feature/home/presentation/view/home_page.dart';
import 'package:ferrisfwt/feature/home/presentation/view/job_detail_page.dart';
import 'package:ferrisfwt/feature/home/presentation/view/search_page.dart';
import 'package:ferrisfwt/feature/landing/presentation/view/landing_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/auto_dark_mode.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_change_email.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_change_phone_number.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_change_username.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/appearance_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/change_password_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/permission_page.dart';

import 'package:ferrisfwt/feature/profile/presantation/view/profile_page.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/app_settings_page.dart';

import 'package:ferrisfwt/feature/profile/presantation/view/personal_data_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    observers: [analyticsObserver],
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return CustomTransitionPage(
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return PageTransition<Widget>(child: child, type: PageTransitionType.fade).child;
            },
            child: BottomNavPage(
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            name: 'home_page',
            path: '/home_page',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return PageTransition<Widget>(
                    child: child,
                    type: PageTransitionType.fade,
                  ).child;
                },
                child: const HomePage(),
              );
            },
          ),
          GoRoute(
            name: 'profile_page',
            path: '/profile_page',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return PageTransition<Widget>(
                    child: child,
                    type: PageTransitionType.fade,
                  ).child;
                },
                child: const ProfilePage(),
              );
            },
          ),
          GoRoute(
            name: 'chat_page',
            path: '/chat_page',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return PageTransition<Widget>(
                    child: child,
                    type: PageTransitionType.fade,
                  ).child;
                },
                child: const ChatPage(),
              );
            },
          ),
          GoRoute(
            name: 'history_page',
            path: '/history_page',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return PageTransition<Widget>(
                    child: child,
                    type: PageTransitionType.fade,
                  ).child;
                },
                child: const HistoryPage(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const LandingPage();
        },
      ),
      GoRoute(
        path: '/login_page',
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/map_view_page2',
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MapViewPage2(),
        ),
      ),
      GoRoute(
          path: '/check_location_page',
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;
            return buildRightPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: LocationSettingsPage(
                location: extraState['location'] as Location,
              ),
            );
          }),
      GoRoute(
        path: '/verification_page',
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const VerificationPage(),
        ),
      ),
      GoRoute(
          path: "/verification_code_page",
          pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const VerificationCodePage(),
              )),
      GoRoute(
          path: "/forgot_password",
          pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ForgotPassword(),
              )),
      GoRoute(
          path: "/sign_in_page",
          pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const SignInPage(),
              )),
      GoRoute(
          path: "/view_expense_detail",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;

            return buildRightPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ViewExpenseDetail(
                index: extraState['index'] as int,
                expense: extraState['expense'] as ExpensesResponseModelItem,
              ),
            );
          }),
      GoRoute(
        path: "/personal_data_page",
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PersonalDataPage(),
        ),
      ),
      GoRoute(
        path: "/app_settings_page",
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const AppSettingsPage(),
        ),
      ),
      GoRoute(
        path: "/change_personal_email",
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PersonalChangeEmail(),
        ),
      ),
      GoRoute(
        path: "/change_personal_phone_number",
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const ChangePersonalPhoneNumber(),
        ),
      ),
      GoRoute(
        path: "/change_username",
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const ChangeUsername(),
        ),
      ),
      GoRoute(
        path: "/auto_dark_mode_page",
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const AutoDarkModePage(),
        ),
      ),
      GoRoute(
        path: "/permission_page",
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PermissionsPage(),
        ),
      ),
      GoRoute(
          path: "/apperance_page",
          pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ApperancePage(),
              )),
      GoRoute(
          path: "/change_password_page",
          pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: const ChangePasswordPage(),
              )),
      GoRoute(
        path: "/job_detail_page",
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;

          return buildRightPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: JobDetailPage(
                jobId: extraState['jobId'] as String? ?? '',
                asyncJob: extraState['asyncJob'] as bool? ?? false,
                isSigned: extraState['isSigned'] as bool? ?? false,
                isCameHomePage: extraState['isCameHomePage'] as bool? ?? true,
              ));
        },
      ),
      GoRoute(
        path: "/sign_inspection_page2",
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildRightPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: SignInspection2Page(
                inspectionId: extraState['inspectionId'] as int,
              ));
        },
      ),
      GoRoute(
        path: "/recorded_damages_page",
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildRightPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: RecordedDamages(
                standardIds: extraState['standardIds'],
                jobInspectionId: extraState['jobInspectionId'] as int,
              ));
        },
      ),
      GoRoute(
          path: "/fuel_level_page",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;

            return buildDownPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: FuelLevelPage(
                jobId: extraState['jobId'] as int,
              ),
            );
          }),
      GoRoute(
          path: "/expense_details",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;
            return buildDownPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ExpenseDetails(
                jobId: extraState['jobId'],
              ),
            );
          }),
      GoRoute(
        path: "/add_stop_page",
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const AddStop(),
        ),
      ),
      GoRoute(
          path: "/view_expenses_page",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;

            return buildDownPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ViewExpenses(
                isAsync: extraState['isAsync'] as bool? ?? false,
                jobId: extraState['jobId'],
              ),
            );
          }),
      GoRoute(
          path: "/feedback_page",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;

            return buildDownPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: FeedbackPage(
                feedbackInputAvailability: extraState['feedbackInputAvailability'] as FeedbackInputAvailability,
              ),
            );
          }),
      GoRoute(
        path: "/map_view_page",
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MapViewPage(),
        ),
      ),
      GoRoute(
          path: "/damage_detail_page",
          pageBuilder: (context, state) {
            final extraState = state.extra as Map<String, dynamic>;

            return buildDownPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: DamageDetailPage(
                  standarIds: extraState['standardIds'],
                  jobInspectionId: extraState['inspection'],
                  damageResponse: extraState['damageResponse'] as DamageResponseModel),
            );
          }),
      GoRoute(
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const HomeJobSearchPage(),
        ),
        path: '/search_page',
      ),
      GoRoute(
        pageBuilder: (context, state) => buildRightPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const HistoryJobSearchPage(),
        ),
        path: '/search_history_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildRightPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: InspectionPage(
              isAsync: extraState['isAsync'] as bool? ?? false,
              isSigned: extraState['isSigned'] as bool? ?? false,
            ),
          );
        },
        path: '/inspection_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildRightPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: InspectionDetailPage(
              damageResponse: extraState['damageResponse'],
              inspection: extraState['inspection'] as JobInspectionResponseModelItem,
            ),
          );
        },
        path: '/inspection_detail_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;

          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: EditDetailsPage(
                odo: extraState['odo'],
                fuelLevel: extraState['fuelLevel'],
                jobInspectionId: extraState['jobInspectionId'] as int,
                inspection: extraState['inspection'] as JobInspectionResponseModelItem),
          );
        },
        path: '/edit_details_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SignMapView(),
          );
        },
        path: '/sign_map_view_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: ConditionImagePage(
              jobInspectionId: extraState['jobInspectionId'] as int,
            ),
            // child: const DenemeView(),
          );
        },
        path: '/condition_image_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: ItemCheckListPage(
              inspectionId: extraState['inspectionId'] as int,
            ),
          );
        },
        path: '/item_checklist_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DamagesPage(
              standarIds: extraState['standardIds'] as List<int>,
              jobInspectionId: extraState['jobInspectionId'] as int,
            ),
          );
        },
        path: '/damages_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;
          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: SignInspectionPage(
              inspection: extraState['inspection'] as JobInspectionResponseModelItem,
            ),
          );
        },
        path: '/sign_inspection_page',
      ),
      GoRoute(
        pageBuilder: (context, state) => buildDownPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignPage(),
        ),
        path: '/sign_page',
      ),
      GoRoute(
        pageBuilder: (context, state) {
          final extraState = state.extra as Map<String, dynamic>;

          return buildDownPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: FinishJobPage(
              isFuelView: extraState['isFuelView'] as bool?,
              isFeedBackView: extraState['isFeedBackView'] as bool?,
              feedbackInputAvailability: extraState['feedbackInputAvailability'] as FeedbackInputAvailability?,
            ),
          );
        },
        path: '/finish_job_page',
      ),
    ],
  );
}

CustomTransitionPage buildRightPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child),
  );
}

CustomTransitionPage buildDownPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child),
  );
}
