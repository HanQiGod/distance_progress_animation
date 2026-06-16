import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/distance_model.dart';
import '../widget/mileage_card.dart';

class DistanceProgressAnimationPage extends StatefulWidget {
  const DistanceProgressAnimationPage({super.key});

  @override
  State<DistanceProgressAnimationPage> createState() =>
      _DistanceProgressAnimationPageState();
}

class _DistanceProgressAnimationPageState
    extends State<DistanceProgressAnimationPage> {
  HomeMemoryData memoryData = const HomeMemoryData(
    memoryPages: <HomeTransportMemoryPageData>[
      HomeTransportMemoryPageData.progress(
        title: '运输记忆',
        monthIncome: 15000,
        totalPayable: 3000,
        consumedAmount: 4000,
        progressColor: Color(0xFF10B28B),
        statusBackgroundColor: Color(0xFFEAF8EF),
        statusIconColor: Color(0xFF22B458),
        statusLeadingIcon: Icons.check_circle_outline_rounded,
        statusLabel: '成本已达标',
        statusSubtitle: '',
        progressText50: '100%',
        progressText100: '66%',
      ),
    ],
  );

  late HomeTransportMemoryPageData _overviewData;

  @override
  void initState() {
    super.initState();

    _overviewData = memoryData.memoryPages.firstWhere(
      (HomeTransportMemoryPageData item) => item.isOverview,
      orElse: () => memoryData.memoryPages.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('距离进度动画')),
      body: Column(
        children: [
          SizedBox(height: 100.h),
          MileageCard(overviewData: _overviewData),
          SizedBox(height: 24.h),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                HomeMemoryData memoryData = HomeMemoryData(
                  memoryPages: <HomeTransportMemoryPageData>[
                    HomeTransportMemoryPageData.progress(
                      title: '运输记忆',
                      monthIncome: 15000,
                      totalPayable: 3000,
                      consumedAmount: 4000,
                      progressColor: Color(0xFF10B28B),
                      statusBackgroundColor: Color(0xFFEAF8EF),
                      statusIconColor: Color(0xFF22B458),
                      statusLeadingIcon: Icons.check_circle_outline_rounded,
                      statusLabel: '成本已达标',
                      statusSubtitle: '',
                      progressText50: '${(Random().nextDouble() * 100).toStringAsFixed(2)}%',
                      progressText100: '${(Random().nextDouble() * 100).toStringAsFixed(2)}%',
                    ),
                  ],
                );

                _overviewData = memoryData.memoryPages.firstWhere(
                  (HomeTransportMemoryPageData item) => item.isOverview,
                  orElse: () => memoryData.memoryPages.first,
                );
              });
            },
            child: Container(
              height: 80.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.w),
              ),
              alignment: Alignment.center,
              child: Text("重启"),
            ),
          ),
        ],
      ),
    );
  }
}
