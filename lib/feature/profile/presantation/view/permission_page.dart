import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ferrisfwt/feature/profile/presantation/cubit/permissions_cubit.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitPermissions, StatePermissions>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.surface,
            title: Text('Permission Page', style: context.textTheme.titleSmall),
          ),
          body: Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: context.paddingAllLow,
                    child: Column(
                      children: [
                        PermissionWidget(
                          text: "Camera Permission",
                          condition: state.camera,
                          onTap: () async {
                            if (!state.camera) {
                              context.read<CubitPermissions>().requestCamera();
                              final permissionStatus =
                                  await Permission.camera.status;
                              if (permissionStatus.isDenied ||
                                  permissionStatus.isPermanentlyDenied) {
                                await openAppSettings();
                              }
                            }
                          },
                        ),
                        PermissionWidget(
                          text: 'Location Permission',
                          condition: state.location,
                          onTap: () async {
                            if (!state.location) {
                              context
                                  .read<CubitPermissions>()
                                  .requestLocation(context);
                              final permissionStatus =
                                  await Permission.location.status;
                              if (permissionStatus.isDenied ||
                                  permissionStatus.isPermanentlyDenied) {
                                await openAppSettings();
                              }
                            }
                          },
                        ),
                        PermissionWidget(
                          text: "Notification Permission",
                          condition: state.notification,
                          onTap: () async {
                            if (!state.notification) {
                              context
                                  .read<CubitPermissions>()
                                  .requestNotification();
                              final permissionStatus =
                                  await Permission.notification.status;
                              if (permissionStatus.isDenied ||
                                  permissionStatus.isPermanentlyDenied) {
                                await openAppSettings();
                              }
                            }
                          },
                        ),
                      ],
                    ),
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

class PermissionWidget extends StatelessWidget {
  final String text;
  final bool condition;
  final void Function()? onTap;

  const PermissionWidget({
    Key? key,
    required this.text,
    required this.onTap,
    required this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: context.dynamicHeight(0.07),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            const HorizontalSpace.small(),
            if (condition)
              const Icon(Icons.check, color: Colors.green)
            else
              const Icon(Icons.close, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
