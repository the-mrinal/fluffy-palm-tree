import 'package:flutter/material.dart';

/// Color constants for the dual axis chart and related components.
/// This file centralizes all color definitions to make customization easier.
class ChartColors {
  // Background Colors
  /// The main background color of the PnL banner and chart area
  static const Color chartBackgroundColor = Color(0xFFE9DFC3); // Light beige

  // Grid and Border Colors
  /// Color for horizontal grid lines in the chart
  static const Color horizontalGridLineColor = Color(0xFF9E9E9E); // Grey
  /// Opacity for horizontal grid lines
  static const double horizontalGridLineOpacity = 0.3;
  /// Color for vertical grid lines in the chart
  static const Color verticalGridLineColor = Color(0xFF9E9E9E); // Grey
  /// Opacity for vertical grid lines
  static const double verticalGridLineOpacity = 0.2;
  /// Color for chart border
  static const Color chartBorderColor = Color(0xFF9E9E9E); // Grey
  /// Opacity for chart border
  static const double chartBorderOpacity = 0.3;

  // P&L Line Colors
  /// Color for the P&L line in the chart
  static const Color pnlLineColor = Color(0xFF22D39B); // Green
  /// Color for the dots on the P&L line
  static const Color pnlDotColor = Color(0xFF22D39B); // Green
  /// Color for the stroke around P&L dots
  static const Color pnlDotStrokeColor = Colors.white;
  /// Color for the area below the P&L line
  static const Color pnlAreaColor = Color(0xFF22D39B); // Green
  /// Opacity for the area below the P&L line
  static const double pnlAreaOpacity = 0.15;

  // Capital Bar Colors
  /// Color for the capital bars in the chart
  static const Color capitalBarColor = Color(0xFF3D5AF1); // Blue
  /// Opacity for the capital bars
  static const double capitalBarOpacity = 0.7;
  /// Color for the border of capital bars
  static const Color capitalBarBorderColor = Color(0xFF3D5AF1); // Blue

  // Median Line Colors
  /// Color for the median capital line
  static const Color medianLineColor = Colors.orange;
  /// Opacity for the median capital line
  static const double medianLineOpacity = 0.8;
  /// Color for the median line label text
  static const Color medianLineLabelColor = Color(0xFF0F172A); // Dark text

  // Tooltip Colors
  /// Background color for tooltips
  static const Color tooltipBackgroundColor = Colors.white;
  /// Border color for tooltips
  static const Color tooltipBorderColor = Color(0xFF9E9E9E); // Grey
  /// Opacity for tooltip border
  static const double tooltipBorderOpacity = 0.2;
  /// Text color for tooltips
  static const Color tooltipTextColor = Color(0xFF0F172A); // Dark text

  // Text Colors
  /// Primary text color for chart labels and titles
  static const Color chartTextColor = Color(0xFF0F172A); // Dark text
  /// Secondary text color for less important text
  static const Color chartSecondaryTextColor = Color(0xFF64748B); // Medium grey

  // Container Colors
  /// Background color for chart-related containers (e.g., trading mode indicator)
  static const Color containerBackgroundColor = Color(0xFF3D5AF1); // Blue
  /// Opacity for container backgrounds
  static const double containerBackgroundOpacity = 0.1;
  /// Border color for containers
  static const Color containerBorderColor = Color(0xFF3D5AF1); // Blue
  /// Opacity for container borders
  static const double containerBorderOpacity = 0.2;
  /// Text color for container content
  static const Color containerTextColor = Color(0xFF3D5AF1); // Blue
}
