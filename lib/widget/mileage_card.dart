import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/distance_model.dart';

class MileageCard extends StatelessWidget {
  const MileageCard({super.key, required this.overviewData});

  final HomeTransportMemoryPageData overviewData;

  @override
  Widget build(BuildContext context) {
    final List<HomeMemoryMetric> metrics = overviewData.metrics;
    final String totalMileage = _metricValueFor(
      metrics,
      '总里程',
      fallback: '50km',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  overviewData.orderSummary ?? '累计运单1单',
                  style: TextStyle(
                    color: const Color(0xFF131A32),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7FA),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on_outlined,
                      size: 28.sp,
                      color: const Color(0xFFC78B4F),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '累计里程 $totalMileage',
                      style: TextStyle(
                        color: const Color(0xFF686F81),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          _MileageBar(label: '0–50km', valueText: overviewData.progressText50 ?? '0%'),
          SizedBox(height: 18.h),
          _MileageBar(label: '51–100km', valueText: overviewData.progressText100 ?? '0%'),
          SizedBox(height: 18.h),
          const _MileagePlaceholder(label: '101–200km'),
          SizedBox(height: 18.h),
          const _MileagePlaceholder(label: '>201km'),
        ],
      ),
    );
  }
}

class _MileageBar extends StatelessWidget {
  const _MileageBar({required this.label, required this.valueText});

  static final RegExp _percentPattern = RegExp(r'^(\d+(?:\.\d+)?)%$');

  final String label;
  final String valueText;

  @override
  Widget build(BuildContext context) {
    final double targetPercent = _resolvePercentValue();
    final double resolvedProgress = targetPercent / 100;

    return Row(
      children: <Widget>[
        SizedBox(
          width: 166.w,
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF686F81),
              fontSize: 26.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: resolvedProgress),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder:
                      (
                        BuildContext context,
                        double animatedProgress,
                        Widget? child,
                      ) {
                        final double animatedWidth =
                            constraints.maxWidth * animatedProgress;
                        return Stack(
                          children: <Widget>[
                            Container(
                              width: animatedWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFFCF8),
                                    Color(0xFFF8C67C),
                                    Color(0xFFF3B160),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: _resolveTextLeft(
                                animatedWidth,
                                constraints.maxWidth,
                              ),
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Text(
                                  _formatAnimatedValue(animatedProgress),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double _resolveProgress() {
    return _resolvePercentValue() / 100;
  }

  double _resolvePercentValue() {
    final RegExpMatch? match = _percentPattern.firstMatch(valueText.trim());
    if (match == null) {
      return 100;
    }
    return double.tryParse(match.group(1) ?? '') ?? 100;
  }

  double _resolveTextLeft(double animatedWidth, double maxWidth) {
    const double labelWidth = 72;
    const double trailingPadding = 18;
    final double desiredLeft = animatedWidth - labelWidth.w - trailingPadding.w;
    final double maxLeft = maxWidth - labelWidth.w - trailingPadding.w;
    if (desiredLeft < trailingPadding.w) {
      return trailingPadding.w;
    }
    if (desiredLeft > maxLeft) {
      return maxLeft;
    }
    return desiredLeft;
  }

  String _formatAnimatedValue(double animatedProgress) {
    final double targetValue = _resolvePercentValue();
    if (!_percentPattern.hasMatch(valueText.trim())) {
      return valueText;
    }
    final double resolvedProgress = _resolveProgress();
    final double animationFactor = resolvedProgress <= 0
        ? 0
        : (animatedProgress / resolvedProgress).clamp(0.0, 1.0);
    final double currentValue = targetValue * animationFactor;
    if (targetValue % 1 == 0) {
      return '${currentValue.round()}%';
    }
    return '${currentValue.toStringAsFixed(1)}%';
  }
}

class _MileagePlaceholder extends StatelessWidget {
  const _MileagePlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 166.w,
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF686F81),
              fontSize: 26.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 10.w),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, double animatedWidth, Widget? child) {
            return Container(
              width: animatedWidth,
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF2A33F),
                borderRadius: BorderRadius.circular(8.r),
              ),
            );
          },
        ),
        Expanded(
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F7),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 18.w),
            child: Text(
              '暂无',
              style: TextStyle(
                color: const Color(0xFF686F81),
                fontSize: 26.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _metricValueFor(
  List<HomeMemoryMetric> metrics,
  String label, {
  required String fallback,
}) {
  for (final HomeMemoryMetric item in metrics) {
    if (item.label == label) {
      return item.value;
    }
  }
  return fallback;
}
