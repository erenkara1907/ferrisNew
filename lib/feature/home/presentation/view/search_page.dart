import 'package:ferrisfwt/feature/home/data/models/jobs/jobs_response_model_item.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/feature/home/presentation/mixin/home_job_search_mixin.dart';
import 'package:ferrisfwt/feature/home/presentation/view/home_page.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeJobSearchPage extends StatefulWidget {
  const HomeJobSearchPage({
    super.key,
  });

  @override
  _HomeJobSearchPageState createState() => _HomeJobSearchPageState();
}

class _HomeJobSearchPageState extends State<HomeJobSearchPage>
    with HomeJobSearchMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.surface,
        title: Text(
          'Search Job',
          style: context.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.colorScheme.primary,
            size: 16,
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: context.paddingAllDefault,
            child: Column(
              children: [
                Expanded(
                  child: ProductGridViewBuilderWidget(
                    jobModel: state.jobs,
                    itemCount: state.jobs.length,
                    crossAxisCount: 1,
                    controller: searchController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeSearchTextfieldSearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const HomeSearchTextfieldSearchWidget({
    this.controller,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Please enter job number',
          hintStyle: context.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.theme.colorScheme.outline,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class ProductGridViewBuilderWidget extends StatefulWidget {
  const ProductGridViewBuilderWidget({
    required this.jobModel,
    this.crossAxisCount,
    this.itemCount,
    super.key,
    this.physics,
    this.controller,
  });
  final ScrollPhysics? physics;
  final int? crossAxisCount;
  final List<JobsResponseModelItem> jobModel;
  final int? itemCount;
  final TextEditingController? controller;

  @override
  State<ProductGridViewBuilderWidget> createState() =>
      _ProductGridViewBuilderWidgetState();
}

class _ProductGridViewBuilderWidgetState
    extends State<ProductGridViewBuilderWidget> {
  List<JobsResponseModelItem> filteredJobModel = [];

  @override
  void initState() {
    filteredJobModel = widget.jobModel;
    super.initState();
  }

  void filterJobs(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredJobModel = widget.jobModel
            .where((job) => job.regNumber
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      } else {
        filteredJobModel = widget.jobModel;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeSearchTextfieldSearchWidget(
          controller: widget.controller,
          onChanged: filterJobs,
        ),
        const SizedBox(
          height: 20,
        ),
        if (widget.controller?.text.isEmpty == true)
          Column(
            children: [
              SizedBox(
                height: context.height * 0.2,
              ),
            ],
          )
        else
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
              physics: widget.physics ?? const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return index >= filteredJobModel.length
                    ? const CircularProgressIndicator.adaptive()
                    : CustomCard(
                        jobModel: filteredJobModel[index],
                        onChanged: null,
                      );
              },
              itemCount: filteredJobModel.length,
            ),
          ),
      ],
    );
  }
}
