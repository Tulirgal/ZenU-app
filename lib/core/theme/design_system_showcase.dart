import 'package:flutter/material.dart';

import '../animation/animation_utils.dart';
import '../animation/app_curves.dart';
import '../animation/app_durations.dart';
import '../animation/app_transitions.dart';
import '../haptics/haptic_service.dart';
import '../panda/panda_controller.dart';
import '../panda/panda_state.dart';
import '../panda/panda_widget.dart';
import '../widgets/unified_back_button.dart';
import '../widgets/zenu_button.dart';
import '../widgets/zenu_card.dart';
import '../widgets/zenu_feedback.dart';
import '../widgets/zenu_input.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Development-only screen exercising the ZenU design system.
class DesignSystemShowcase extends StatefulWidget {
  const DesignSystemShowcase({super.key});

  @override
  State<DesignSystemShowcase> createState() => _DesignSystemShowcaseState();
}

class _DesignSystemShowcaseState extends State<DesignSystemShowcase> {
  final _panda = PandaController();
  final _input = TextEditingController();
  bool _chipSelected = true;
  bool _cardPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _panda.playGreetingSequence();
    });
  }

  @override
  void dispose() {
    _panda.dispose();
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Text('ZenU', style: AppTextStyles.display),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Design System Showcase',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Development only — foundation for future product screens.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Panda'),
            Center(child: PandaWidget(controller: _panda, size: 180)),
            const SizedBox(height: AppSpacing.md),
            ListenableBuilder(
              listenable: _panda,
              builder: (context, _) {
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: PandaState.values.map((state) {
                    final selected = _panda.state == state;
                    return ZenUChip(
                      label: state.label,
                      selected: selected,
                      onTap: () {
                        hapticService.selection();
                        _panda.setState(state);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Colors'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _swatch('primary', AppColors.primary),
                _swatch('primarySoft', AppColors.primarySoft),
                _swatch('primaryDark', AppColors.primaryDark),
                _swatch('secondary', AppColors.secondary),
                _swatch('secondarySoft', AppColors.secondarySoft),
                _swatch('background', AppColors.background),
                _swatch('surface', AppColors.surface),
                _swatch('textPrimary', AppColors.textPrimary),
                _swatch('success', AppColors.success),
                _swatch('warning', AppColors.warning),
                _swatch('error', AppColors.error),
                _swatch('info', AppColors.info),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Typography'),
            Text('Display', style: AppTextStyles.display),
            Text('Headline', style: AppTextStyles.headline),
            Text('Title', style: AppTextStyles.title),
            Text('Subtitle', style: AppTextStyles.subtitle),
            Text('Body — calm, readable, personal.', style: AppTextStyles.body),
            Text('Body medium', style: AppTextStyles.bodyMedium),
            Text('Body small', style: AppTextStyles.bodySmall),
            Text('Label', style: AppTextStyles.label),
            Text('Caption', style: AppTextStyles.caption),
            Text('Button', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Components'),
            ZenUButton(label: 'Primary button', onPressed: () {}),
            const SizedBox(height: AppSpacing.sm),
            ZenUSecondaryButton(label: 'Secondary button', onPressed: () {}),
            ZenUTextButton(label: 'Text button', onPressed: () {}),
            const SizedBox(height: AppSpacing.md),
            ZenUInput(
              controller: _input,
              label: 'Input',
              hint: 'Say something gentle…',
            ),
            const SizedBox(height: AppSpacing.md),
            ZenUCard(
              child: Text('ZenUCard — soft surface for interaction.', style: AppTextStyles.body),
            ),
            const SizedBox(height: AppSpacing.sm),
            ZenURecommendationCard(
              title: 'Take a breath',
              subtitle: 'A short reset when things feel loud.',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ZenUChip(
                  label: 'Calm',
                  selected: _chipSelected,
                  onTap: () => setState(() => _chipSelected = !_chipSelected),
                ),
                const ZenUChip(label: 'Focus'),
                const ZenUChip(label: 'Joy'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ZenUButton(
                  label: 'Modal',
                  expand: false,
                  onPressed: () => showZenUModal(
                    context: context,
                    title: 'ZenU Modal',
                    body: 'Soft dialog surface for confirmations.',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ZenUSecondaryButton(
                  label: 'Sheet',
                  expand: false,
                  onPressed: () => showZenUBottomSheet(
                    context: context,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bottom sheet', style: AppTextStyles.title),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Native sheet behavior with ZenU surfaces.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const UnifiedBackButton(section: 'Showcase'),
            const SizedBox(height: AppSpacing.md),
            const Center(child: ZenULoading(label: 'Loading')),
            ZenUEmptyState(
              title: 'Nothing here yet',
              message: 'Empty states stay warm and clear.',
              actionLabel: 'Got it',
              onAction: () {},
            ),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Motion'),
            GestureDetector(
              onTapDown: (_) => setState(() => _cardPressed = true),
              onTapUp: (_) => setState(() => _cardPressed = false),
              onTapCancel: () => setState(() => _cardPressed = false),
              child: AnimationUtils.scalePress(
                pressed: _cardPressed,
                child: ZenUCard(
                  child: Text(
                    'Press for spring scale (${AppDurations.fast.inMilliseconds}ms)',
                    style: AppTextStyles.body,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ZenUSecondaryButton(
              label: 'Open transition demo',
              onPressed: () {
                Navigator.of(context).push(
                  AppTransitions.fadeSlide(
                    page: const _TransitionDemoPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _sectionTitle('Haptics'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _hapticChip('Light', hapticService.light),
                _hapticChip('Medium', hapticService.medium),
                _hapticChip('Heavy', hapticService.heavy),
                _hapticChip('Selection', hapticService.selection),
                _hapticChip('Success', hapticService.success),
                _hapticChip('Warning', hapticService.warning),
                _hapticChip('Error', hapticService.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(text, style: AppTextStyles.title),
    );
  }

  Widget _swatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _hapticChip(String label, Future<void> Function() action) {
    return ZenUChip(
      label: label,
      onTap: () => action(),
    );
  }
}

class _TransitionDemoPage extends StatelessWidget {
  const _TransitionDemoPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UnifiedBackButton(section: 'Motion'),
              const SizedBox(height: AppSpacing.xl),
              Text('Fade + slide', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Curve: ease-out · Duration: page',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AnimationUtils.fadeIn(
                context: context,
                duration: AppDurations.slow,
                curve: AppCurves.easeOut,
                child: ZenUCard(
                  child: Text(
                    'Content arrives calmly — not abruptly.',
                    style: AppTextStyles.body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
