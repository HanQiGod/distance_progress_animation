import 'package:flutter/cupertino.dart';

enum HomeTransportMemoryCardType { overview, progress }

class HomeTransportMemoryPageData {
  const HomeTransportMemoryPageData.overview({
    required this.title,
    required this.orderSummary,
    required this.metrics,
  }) : type = HomeTransportMemoryCardType.overview,
       monthIncome = null,
       totalPayable = null,
       consumedAmount = null,
       progressColor = null,
       statusBackgroundColor = null,
       statusIconColor = null,
       statusLeadingIcon = null,
       statusLabel = null,
       statusAmountText = null,
       statusSubtitle = null,
       progressText50 = null,
       progressText100 = null;

  const HomeTransportMemoryPageData.progress({
    required this.title,
    required this.monthIncome,
    required this.totalPayable,
    required this.consumedAmount,
    required this.progressColor,
    required this.statusBackgroundColor,
    required this.statusIconColor,
    required this.statusLeadingIcon,
    required this.statusLabel,
    this.statusAmountText,
    required this.statusSubtitle,
    required this.progressText50,
    required this.progressText100,
  }) : type = HomeTransportMemoryCardType.progress,
       orderSummary = null,
       metrics = const <HomeMemoryMetric>[];

  final HomeTransportMemoryCardType type;
  final String title;
  final String? orderSummary;
  final List<HomeMemoryMetric> metrics;
  final double? monthIncome;
  final double? totalPayable;
  final double? consumedAmount;
  final Color? progressColor;
  final Color? statusBackgroundColor;
  final Color? statusIconColor;
  final IconData? statusLeadingIcon;
  final String? statusLabel;
  final String? statusAmountText;
  final String? statusSubtitle;
  final String? progressText50;
  final String? progressText100;

  bool get isOverview => type == HomeTransportMemoryCardType.overview;

  double get remainingAmount {
    final double total = totalPayable ?? 0;
    final double consumed = consumedAmount ?? 0;
    return (total - consumed).clamp(0, double.infinity);
  }

  double get progress {
    final double total = totalPayable ?? 0;
    final double consumed = consumedAmount ?? 0;
    if (total <= 0) {
      return 0;
    }
    return (consumed / total).clamp(0, 1);
  }
}

class HomeMemoryMetric {
  const HomeMemoryMetric({required this.label, required this.value});

  final String label;
  final String value;
}

class HomeMemoryData {
  const HomeMemoryData({required this.memoryPages});

  final List<HomeTransportMemoryPageData> memoryPages;

  String get memoryTitle => memoryPages.first.title;

  HomeTransportMemoryPageData get primaryProgressPage {
    return memoryPages.firstWhere(
      (HomeTransportMemoryPageData page) => !page.isOverview,
      orElse: () => memoryPages.first,
    );
  }
}
