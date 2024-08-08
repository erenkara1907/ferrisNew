import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/view/home_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TomorrowJobsView extends StatefulWidget {
  final HomeState homeState;
  const TomorrowJobsView({super.key, required this.homeState});
  @override
  State<TomorrowJobsView> createState() => _TomorrowJobsViewState();
}

class _TomorrowJobsViewState extends State<TomorrowJobsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(GetJobTomorrow());
        },
        child: widget.homeState.jobsTomorrow.isEmpty
            ? Center(
                child: ListView(
                  children: [
                    Image.asset(
                      'assets/images/fr_empty_job.png',
                      width: 130,
                      height: 130,
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.03),
                    ),
                    Text(
                      'No jobs found. Please contact the administrator.',
                      style: context.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: widget.homeState.jobsTomorrow.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard(
                    onChanged: null,
                    jobModel: widget.homeState.jobsTomorrow[index],
                    isToday: false,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const VerticalSpace.small();
                },
              ),
      ),
    );
  }
}
