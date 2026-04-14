import 'package:flutter/material.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import 'demo_task_data.dart';

class PlannerBackdrop extends StatelessWidget {
  const PlannerBackdrop({super.key, required this.tint, required this.child});

  final Color tint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF08111D), NoirPalette.background],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BackdropGridPainter()),
            ),
          ),
          Positioned(
            top: -120,
            left: -100,
            child: _GlowOrb(color: tint, size: 360),
          ),
          Positioned(
            top: 120,
            right: -160,
            child: const _GlowOrb(color: NoirPalette.magenta, size: 320),
          ),
          Positioned(
            bottom: -120,
            left: 80,
            child: const _GlowOrb(color: NoirPalette.electricBlue, size: 280),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tint.withValues(alpha: 0.10),
                      Colors.transparent,
                      NoirPalette.cyan.withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _RainPainter())),
          ),
          child,
        ],
      ),
    );
  }
}

class PlannerScrollView extends StatelessWidget {
  const PlannerScrollView({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1200
        ? 36.0
        : width >= 900
        ? 28.0
        : 20.0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            128,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.accent,
    this.tags = const [],
    this.aside,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Color accent;
  final List<Widget> tags;
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(
                accent.withValues(alpha: 0.20),
                NoirPalette.panel,
              ),
              NoirPalette.panelSoft,
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.70)),
          boxShadow: [
            ...NoirPalette.glow(accent, blur: 34, spread: -8),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.34),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: _GlowOrb(color: accent, size: 170),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PanelLinePainter(
                    accent: accent.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(height: 2, width: 72, color: accent),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(width: 2, height: 40, color: accent),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = aside == null || constraints.maxWidth < 760;

                  final mainColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eyebrow.toUpperCase(),
                        style: textTheme.labelLarge?.copyWith(
                          color: accent,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: NoirPalette.textPrimary,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: NoirPalette.textSecondary,
                        ),
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(spacing: 8, runSpacing: 8, children: tags),
                      ],
                    ],
                  );

                  if (stacked) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mainColumn,
                        if (aside != null) ...[
                          const SizedBox(height: 20),
                          aside!,
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: mainColumn),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: aside!,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaperPanel extends StatelessWidget {
  const PaperPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.tint,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? tint;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final edge = tint ?? NoirPalette.electricBlue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    edge.withValues(alpha: 0.12),
                    NoirPalette.panel,
                  ),
                  NoirPalette.panelSoft,
                ],
              ),
          border: Border.all(color: edge.withValues(alpha: 0.42)),
          boxShadow: [
            ...NoirPalette.glow(edge, blur: 22, spread: -10),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PanelLinePainter(
                    accent: edge.withValues(alpha: 0.26),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(height: 2, width: 40, color: edge),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(width: 2, height: 26, color: edge),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(height: 2, width: 40, color: edge),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(width: 2, height: 26, color: edge),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = trailing != null && constraints.maxWidth < 720;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [NoirPalette.cyan, NoirPalette.magenta],
                ),
                boxShadow: [...NoirPalette.glow(NoirPalette.cyan, blur: 12)],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: NoirPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: NoirPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!stacked && trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            if (stacked && trailing != null) ...[
              const SizedBox(height: 12),
              trailing!,
            ],
          ],
        );
      },
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: NoirPalette.panelSoft.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NoirPalette.border.withValues(alpha: 0.92)),
        boxShadow: NoirPalette.glow(NoirPalette.cyan, blur: 12, spread: -8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: NoirPalette.cyan),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: NoirPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(tint.withValues(alpha: 0.14), NoirPalette.panel),
            NoirPalette.panelSoft,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tint.withValues(alpha: 0.42)),
        boxShadow: [...NoirPalette.glow(tint, blur: 18, spread: -8)],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: tint.withValues(alpha: 0.46)),
              boxShadow: NoirPalette.glow(tint, blur: 14, spread: -8),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: NoirPalette.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: NoirPalette.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressDonut extends StatelessWidget {
  const ProgressDonut({
    super.key,
    required this.progress,
    required this.value,
    required this.label,
    required this.tint,
    this.size = 132,
  });

  final double progress;
  final String value;
  final String label;
  final Color tint;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    tint.withValues(alpha: 0.16),
                    NoirPalette.panel,
                  ),
                  NoirPalette.panelSoft,
                ],
              ),
              border: Border.all(color: tint.withValues(alpha: 0.48)),
              boxShadow: [...NoirPalette.glow(tint, blur: 24, spread: -12)],
            ),
          ),
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                value: progress.clamp(0, 1).toDouble(),
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: NoirPalette.border,
                valueColor: AlwaysStoppedAnimation<Color>(tint),
              ),
            ),
          ),
          Container(
            width: size - 42,
            height: size - 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NoirPalette.backgroundRaised.withValues(alpha: 0.88),
              border: Border.all(
                color: NoirPalette.border.withValues(alpha: 0.8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: NoirPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: NoirPalette.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskPreviewCard extends StatelessWidget {
  const TaskPreviewCard({
    super.key,
    required this.task,
    this.onTap,
    this.compact = false,
    this.footer,
  });

  final DemoTask task;
  final VoidCallback? onTap;
  final bool compact;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = compact ? 10.0 : 12.0;
    final accent = task.accent;

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 10 : 12),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(
                  accent.withValues(alpha: task.isDone ? 0.08 : 0.14),
                  NoirPalette.panel,
                ),
                NoirPalette.panelSoft,
              ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: accent.withValues(alpha: 0.42)),
            boxShadow: [
              ...NoirPalette.glow(accent, blur: 20, spread: -10),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            overlayColor: WidgetStatePropertyAll(
              accent.withValues(alpha: 0.08),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(compact ? 14 : 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: compact ? 38 : 42,
                        height: compact ? 38 : 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(
                            alpha: task.isDone ? 0.12 : 0.16,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.42),
                          ),
                          boxShadow: NoirPalette.glow(
                            accent,
                            blur: 14,
                            spread: -8,
                          ),
                        ),
                        child: Icon(
                          task.isDone
                              ? Icons.check_rounded
                              : task.isImportant
                              ? Icons.star_rounded
                              : Icons.circle_outlined,
                          color: accent,
                          size: compact ? 18 : 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    task.titleOf(context),
                                    style: textTheme.titleMedium?.copyWith(
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: task.isDone
                                          ? NoirPalette.textMuted
                                          : NoirPalette.textPrimary,
                                    ),
                                  ),
                                ),
                                if (task.isImportant) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.42),
                                      ),
                                    ),
                                    child: Text(
                                      context.tr('重要', 'Priority'),
                                      style: textTheme.labelLarge?.copyWith(
                                        color: accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.noteOf(context),
                              maxLines: compact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: NoirPalette.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _TaskInfoChip(
                                  icon: Icons.event_outlined,
                                  label: task.dueLabelOf(context),
                                ),
                                if (task.reminderLabel != null)
                                  _TaskInfoChip(
                                    icon: Icons.notifications_none_rounded,
                                    label: task.reminderLabel!,
                                  ),
                                _TaskInfoChip(
                                  icon: Icons.timelapse_rounded,
                                  label: task.durationLabelOf(context),
                                ),
                              ],
                            ),
                            if (footer != null) ...[
                              const SizedBox(height: 14),
                              footer!,
                            ],
                          ],
                        ),
                      ),
                      if (onTap != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: NoirPalette.textSecondary,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LabeledInfoRow extends StatelessWidget {
  const LabeledInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: NoirPalette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium?.copyWith(
                color: valueColor ?? NoirPalette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskInfoChip extends StatelessWidget {
  const _TaskInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: NoirPalette.backgroundRaised.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: NoirPalette.border.withValues(alpha: 0.92)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: NoirPalette.cyan),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: NoirPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.24),
              color.withValues(alpha: 0.10),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _BackdropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = NoirPalette.grid.withValues(alpha: 0.24)
      ..strokeWidth = 1;

    for (double x = -20; x < size.width + 20; x += 72) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 24; y < size.height + 20; y += 88) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final skylinePaint = Paint()
      ..color = NoirPalette.cyan.withValues(alpha: 0.10)
      ..strokeWidth = 1.4;
    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.22),
      skylinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()
      ..color = NoirPalette.textPrimary.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double x = -size.height; x < size.width + size.height; x += 38) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height * 0.18, size.height),
        rainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PanelLinePainter extends CustomPainter {
  const _PanelLinePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent
      ..strokeWidth = 1;

    final y = size.height * 0.28;
    canvas.drawLine(Offset(size.width * 0.54, 0), Offset(size.width, y), paint);
    canvas.drawLine(
      Offset(size.width * 0.68, 0),
      Offset(size.width, size.height * 0.46),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.76, size.height),
      Offset(size.width, size.height * 0.66),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PanelLinePainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
