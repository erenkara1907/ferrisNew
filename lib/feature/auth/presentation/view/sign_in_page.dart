import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/button/custom_app_button.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          Positioned(
            top: context.dynamicHeight(0.28),
            left: context.dynamicWidth(0.27),
            child: Image.asset("assets/images/Group.png"),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onSecondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              width: context.dynamicWidth(1),
              height: context.dynamicHeight(0.5),
              child: Padding(
                padding: context.paddingAllDefault,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const VerticalSpace.medium(),
                    Text(
                      "Explore the app",
                      style: context.textTheme.headlineLarge,
                    ),
                    const VerticalSpace.small(),
                    Center(
                        child: Text(
                      "Deliver and collect vehicles directly from customers across mainland UK",
                      style: context.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )),
                    const VerticalSpace.medium(),
                    CustomAppButton(
                        text: "Sign in",
                        ontap: () {
                          context.push("/login_page");
                        })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
