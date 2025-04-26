import 'package:flutter/material.dart';
import 'package:paper_bulls/bloc/pnl/pnl_state.dart';
import 'package:paper_bulls/utils/theme.dart';

class ChartToggle extends StatelessWidget {
  final ChartHighlight chartHighlight;
  final Function(ChartHighlight) onToggleChanged;
  final bool showMedianCapital;
  final Function(bool) onMedianCapitalToggled;

  const ChartToggle({
    super.key,
    required this.chartHighlight,
    required this.onToggleChanged,
    required this.showMedianCapital,
    required this.onMedianCapitalToggled,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we're on a small screen
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    if (isSmallScreen) {
      // For very small screens, stack the toggle buttons vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleButton(
                context,
                'P&L',
                chartHighlight == ChartHighlight.pnl || chartHighlight == ChartHighlight.both,
                AppTheme.secondaryColor,
                () => _handleToggle(ChartHighlight.pnl),
              ),
              const SizedBox(width: 8),
              _buildToggleButton(
                context,
                'Capital',
                chartHighlight == ChartHighlight.capital || chartHighlight == ChartHighlight.both,
                AppTheme.primaryColor,
                () => _handleToggle(ChartHighlight.capital),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMedianToggle(context),
        ],
      );
    } else {
      // For larger screens, keep the original horizontal layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildToggleButton(
                context,
                'P&L',
                chartHighlight == ChartHighlight.pnl || chartHighlight == ChartHighlight.both,
                AppTheme.secondaryColor,
                () => _handleToggle(ChartHighlight.pnl),
              ),
              const SizedBox(width: 8),
              _buildToggleButton(
                context,
                'Capital',
                chartHighlight == ChartHighlight.capital || chartHighlight == ChartHighlight.both,
                AppTheme.primaryColor,
                () => _handleToggle(ChartHighlight.capital),
              ),
            ],
          ),
          _buildMedianToggle(context),
        ],
      );
    }
  }

  Widget _buildToggleButton(
    BuildContext context,
    String label,
    bool isActive,
    Color color,
    VoidCallback onTap,
  ) {
    // Check if we're on a small screen
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSmallScreen ? 10 : 12,
              height: isSmallScreen ? 10 : 12,
              decoration: BoxDecoration(
                color: color.withOpacity(isActive ? 1.0 : 0.4),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white70,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedianToggle(BuildContext context) {
    // Check if we're on a small screen
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return GestureDetector(
      onTap: () => onMedianCapitalToggled(!showMedianCapital),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 12,
          vertical: isSmallScreen ? 4 : 6
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showMedianCapital ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white70,
              size: isSmallScreen ? 14 : 16,
            ),
            SizedBox(width: isSmallScreen ? 3 : 4),
            Text(
              'Median',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white70,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleToggle(ChartHighlight highlight) {
    // If the same toggle is clicked again, toggle between single and both
    if ((highlight == ChartHighlight.pnl &&
         (chartHighlight == ChartHighlight.pnl || chartHighlight == ChartHighlight.both)) ||
        (highlight == ChartHighlight.capital &&
         (chartHighlight == ChartHighlight.capital || chartHighlight == ChartHighlight.both))) {
      // Toggle between single and both
      if (chartHighlight == ChartHighlight.both) {
        onToggleChanged(highlight);
      } else {
        onToggleChanged(ChartHighlight.both);
      }
    } else {
      // Different toggle clicked, activate it
      if (chartHighlight == ChartHighlight.both) {
        // If both are active, switch to just the clicked one
        onToggleChanged(highlight);
      } else {
        // If one is active, switch to both
        onToggleChanged(ChartHighlight.both);
      }
    }
  }
}
