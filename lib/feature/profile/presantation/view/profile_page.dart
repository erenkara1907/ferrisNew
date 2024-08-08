import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:ferrisfwt/product/widget/popup/question_popup.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.colorScheme.surfaceVariant,
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surfaceVariant,
            title: Text(
              "Profile",
              style: context.textTheme.headlineMedium,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: context.paddingAllDefault,
              child: Column(
                children: [
                  const VerticalSpace.small(),
                  Center(
                    child: SizedBox(
                      height: context.dynamicHeight(0.11),
                      width: context.dynamicWidth(0.2),
                      child: UserProfilPhoto(
                        radius: 39,
                      ),
                    ),
                  ),
                  const ProfilDetailText(),
                  const VerticalSpace.medium(),
                  Container(
                    decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        ProfilPageItem(
                            icon: "assets/images/icons/personal-data.svg",
                            onPressed: () {
                              context.push("/personal_data_page",
                                  extra: {"userModel": state.userModel});
                            },
                            title: "Personal Data"),
                        ProfilPageItem(
                            icon: "assets/images/icons/appearance.svg",
                            onPressed: () {
                              context.push("/apperance_page");
                            },
                            title: "Appearance"),
                      ],
                    ),
                  ),
                  const VerticalSpace.small(),
                  Container(
                      decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ProfilPageItem(
                              icon: "assets/images/icons/permissions.svg",
                              onPressed: () {
                                context.push("/permission_page");
                              },
                              title: "Permissions"),
                          ProfilPageItem(
                              icon: "assets/images/icons/privacy-policy.svg",
                              onPressed: () {},
                              title: "Privacy Policy"),
                        ],
                      )),
                  const VerticalSpace.small(),
                  Container(
                      decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          ProfilPageItem(
                              icon: "assets/images/icons/logout.svg",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => QuestionPopup(
                                        actionButtonText: 'Log out',
                                        title: 'Log out',
                                        description:
                                            'Are you sure you want to log out?"',
                                        actionButtonOnPressed: () async {
                                          final id = await FirebaseMessaging
                                              .instance
                                              .getToken();
                                          context.read<AuthBloc>().add(
                                              LogoutEvent(
                                                  deviceToken: id ?? ''));

                                          context.go('/sign_in_page');
                                        },
                                        iconPath:
                                            'assets/images/fr_logout.png'));
                              },
                              title: "Log Out"),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfilPageItem extends StatelessWidget {
  String title;

  void Function()? onPressed;

  String icon;

  ProfilPageItem({
    required this.icon,
    required this.onPressed,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: context.paddingAllDefault,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
            ),
            SizedBox(
              width: context.lowValue,
            ),
            Text(
              title,
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class UserProfilPhoto extends StatefulWidget {
  double? radius;

  UserProfilPhoto({
    Key? key,
    required this.radius,
  }) : super(key: key);

  @override
  State<UserProfilPhoto> createState() => _UserProfilPhotoState();
}

class _UserProfilPhotoState extends State<UserProfilPhoto> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Icon(
        Icons.person,
        size: widget.radius! * 2,
        color: context.theme.colorScheme.onSurface,
      ),
    );
  }
}

class ProfilDetailText extends StatelessWidget {
  const ProfilDetailText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.userModel == null) {
          return const LoadingProgress();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              state.userModel?.name ?? "Name",
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              state.userModel?.phone ?? "Phone",
              style: context.textTheme.bodySmall?.copyWith(fontSize: 10),
            )
          ],
        );
      },
    );
  }
}
