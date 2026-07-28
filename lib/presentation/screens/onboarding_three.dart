import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/infrastructure/data_sources/app_dataSource.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes/app_pages.dart';
import '../widgets/onboarding_card_widget.dart';
import '../widgets/top_header_widget.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  void _navigateToHome(BuildContext context) {
    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final items = OnboardingModel.onboardingPages;
    final pageController = PageController(initialPage: 0);

    return BlocProvider(
      create: (_) => OnboardingCubit(totalPages: items.length),
      child: Scaffold(
        backgroundColor: AppColors.primaryOrange,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final cubit = context.read<OnboardingCubit>();

                return Column(
                  children: [
                    const SizedBox(height: 32),
                    const TopHeaderWidget(),
                    const Spacer(),
                    OnboardingCardWidget(
                      items: items,
                      pageController: pageController,
                      currentIndex: state.currentIndex,
                      onPageChanged: cubit.onPageChanged,
                      onSkip: () => _navigateToHome(context),
                      onNext: () {
                        if (state.isLastPage) {
                          _navigateToHome(context);
                        } else {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 36),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
