import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/view/search_page.dart';
import 'package:flutter/material.dart';

mixin HomeJobSearchMixin on State<HomeJobSearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {}

  List<JobsResponseModelItem> filterJob(
      List<JobsResponseModelItem> job, String searchText) {
    return job.where((jobs) {
      return jobs.vehicleId?.name != null &&
          jobs.vehicleId!.name!
              .toLowerCase()
              .contains(searchText.toLowerCase());
    }).toList();
  }
}
