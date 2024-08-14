import 'package:ferrisfwt/product/mixin/network_mixin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/view/home_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:ferrisfwt/product/widget/spacer/dynamic_vertical_spacer.dart';

class TodayJobsView extends StatefulWidget {
  final HomeState homeState;
  const TodayJobsView({super.key, required this.homeState});

  @override
  State<TodayJobsView> createState() => _TodayJobsViewState();
}

class _TodayJobsViewState extends State<TodayJobsView> {
  JobsResponseModelItem? job;

  @override
  void initState() {
    super.initState();
    if (ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId !=
            null &&
        ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId !=
            "") {
      _initializeJob();
    }
  }

  void _initializeJob() async {
    final id =
        ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId;
    job = await ProductStateItems.hiveStorageManager
        .getJobWorkingOnModel(int.parse(id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homeState.status == ViewStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<JobsResponseModelItem> filteredJobs =
        widget.homeState.jobs.where((job) {
      return job.jobStatus != JobStatusEnum.completed;
    }).toList();

    List<JobsResponseModelItem> finishedJobs =
        widget.homeState.jobs.where((job) {
      return job.jobStatus == JobStatusEnum.completed;
    }).toList();

    List<JobsResponseModelItem> sortedJobs = List.from(filteredJobs);
    sortedJobs.sort((a, b) {
      bool aStarted =
          ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId ==
              a.id.toString();
      bool bStarted =
          ProductStateItems.hiveDatabaseManager.getUserModel()?.currentJobId ==
              b.id.toString();

      bool aDepartNow = a.jobStatus == JobStatusEnum.departNow;
      bool bDepartNow = b.jobStatus == JobStatusEnum.departNow;
      if (aStarted && !bStarted) {
        return -1;
      } else if (!aStarted && bStarted) {
        return 1;
      }
      if (aDepartNow && bDepartNow) {
        DateTime aDate = DateTime.parse(a.scheduleDate!);
        DateTime bDate = DateTime.parse(b.scheduleDate!);
        return aDate.compareTo(bDate);
      } else if (aDepartNow && !bDepartNow) {
        return -1;
      } else if (!aDepartNow && bDepartNow) {
        return 1;
      }
      return 0;
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          var connectivityResult = await hasNetwork();
          if (connectivityResult) {
            context.read<HomeBloc>().add(const GetJobs());
          }
        },
        child: widget.homeState.jobs.isEmpty ||
                widget.homeState.jobs.length == finishedJobs.length
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
                itemCount: widget.homeState.jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard(
                    onChanged: (value) async {
                      if (value == true) {
                        context.read<HomeBloc>().add(
                            ConfirmJob(widget.homeState.jobs[index].id, false));
                      }
                    },
                    jobModel: widget.homeState.jobs[index],
                    isToday: true,
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
