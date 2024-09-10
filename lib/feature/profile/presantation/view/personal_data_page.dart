import 'package:ferrisfwt/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/loading/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_change_email.dart';
import 'package:ferrisfwt/feature/profile/presantation/subView/personal_data_change_phone_number.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/profile_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';

class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == ViewStatus.loading || state.userModel == null) {
          return const Center(
            child: LoadingProgress(),
          );
        }
        return Scaffold(
          backgroundColor: context.theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            leading: BackButton(
              onPressed: () {
                context.go("/profile_page");
              },
            ),
          ),
          body: Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ProfilPageItem(
                          icon: "assets/images/icons/personal-data.svg",
                          onPressed: null,
                          title: state.userModel!.name.toString()),
                      const ProfileCustomDivider(),
                      ProfilPageItem(
                        icon: "assets/images/icons/phone.svg",
                        onPressed: null,
                        title: state.userModel!.phone.toString(),
                      ),
                      const ProfileCustomDivider(),
                      ProfilPageItem(
                        icon: "assets/images/icons/at-symbol.svg",
                        onPressed: null,
                        title: state.userModel!.email.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<dynamic> ChangeEmail(BuildContext context) {
  bool isValidEmail(String email) {
    return email.contains('@');
  }

  return showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: 0.9,
    context: context,
    builder: (BuildContext context) {
      return const PersonalChangeEmail();
    },
  );
}

Future<dynamic> ChangePhoneNumber(BuildContext context) {
  return showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 0.9,
      context: context,
      builder: (BuildContext context) {
        return const ChangePersonalPhoneNumber();
      });
}

class ProfileCustomDivider extends StatelessWidget {
  const ProfileCustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingHorizontalDefault,
      child: Divider(
        color: context.theme.colorScheme.inversePrimary,
        height: 1,
      ),
    );
  }
}
