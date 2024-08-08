import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/profile/presantation/view/profile_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_horizontal_spacer.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';

class CustomProfileCard extends StatelessWidget {
  final JobsResponseModelItem jobModel;

  const CustomProfileCard({
    super.key,
    required this.jobModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.paddingAllDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserProfilPhoto(
                      radius: 21,
                    ),
                    const HorizontalSpace.xSmall(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobModel.driverId!.name.toString(),
                          style: context.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        // Text(
                        //   jobModel.driverId!.role!.name.toString(),
                        //   style: context.textTheme.bodySmall?.copyWith(
                        //       fontSize: 10, fontWeight: FontWeight.w500),
                        // ),
                      ],
                    ),
                  ],
                ),
                const VerticalSpace.small(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Driver Notes",
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const VerticalSpace.xxSmall(),
                    Text(
                      jobModel.notes == null ? "No notes" : jobModel.notes!,
                      style: context.textTheme.bodySmall,
                    )
                  ],
                ),
                const VerticalSpace.small(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
