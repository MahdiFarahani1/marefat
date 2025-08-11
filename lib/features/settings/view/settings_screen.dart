import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppbar.littleAppBar(context, title: 'الإعدادات'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _animatedSection(
                    child: _sectionTitle('حجم الخط'),
                    delay: 0,
                  ),
                  _animatedSection(
                    child: _fontSizeSlider(context, state.fontSize),
                    delay: 50,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('تباعد الأسطر'),
                    delay: 100,
                  ),
                  _animatedSection(
                    child: _lineHeightSlider(context, state.lineHeight),
                    delay: 150,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('ألوان المظهر'),
                    delay: 200,
                  ),
                  _animatedSection(
                    child: _colorIconsPicker(context, state.primrayIndex),
                    delay: 250,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('نوع الخط'),
                    delay: 300,
                  ),
                  _animatedSection(
                    child: _fontFamilyCardSelector(
                        context, state.fontFamily, state),
                    delay: 350,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('لون الخلفية'),
                    delay: 400,
                  ),
                  _animatedSection(
                    child: _backgroundColorPicker(context),
                    delay: 450,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('عرض الصفحة'),
                    delay: 500,
                  ),
                  _animatedSection(
                    child: _pageDirectionToggle(context, state.pageDirection),
                    delay: 550,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _animatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _fontSizeSlider(BuildContext context, double fontSize) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 7),
                    activeTrackColor: Theme.of(context).primaryColor,
                    thumbColor: Theme.of(context).primaryColor,
                    valueIndicatorColor: Theme.of(context).primaryColor,
                    valueIndicatorTextStyle: TextStyle(color: Colors.white)),
                child: Slider(
                  value: fontSize,
                  min: 10,
                  max: 26,
                  divisions: 9,
                  label: fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    context.read<SettingsCubit>().updateFontSize(value);
                  },
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                fontSize.toStringAsFixed(0),
                key: ValueKey(fontSize),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineHeightSlider(BuildContext context, double lineHeight) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 7),
                    activeTrackColor: Theme.of(context).primaryColor,
                    thumbColor: Theme.of(context).primaryColor,
                    valueIndicatorColor: Theme.of(context).primaryColor,
                    valueIndicatorTextStyle: TextStyle(color: Colors.white)),
                child: Slider(
                  value: lineHeight,
                  min: 1.0,
                  max: 3.0,
                  divisions: 15,
                  label: lineHeight.toStringAsFixed(1),
                  onChanged: (value) {
                    context.read<SettingsCubit>().updateLineHeight(value);
                  },
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                lineHeight.toStringAsFixed(1),
                key: ValueKey(lineHeight),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorIconsPicker(BuildContext context, int gradientIndex) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: backgrounds.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final isSelected = gradientIndex == index;
            return GestureDetector(
              onTap: () {
                context.read<SettingsCubit>().updateGradientIndex(index);
                context.read<SettingsCubit>().updateDarkMode(false);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isSelected ? 55 : 50,
                  decoration: BoxDecoration(
                    color: backgrounds[index],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: backgrounds[index].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: isSelected
                        ? Border.all(color: Colors.blueAccent, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _fontFamilyCardSelector(
      BuildContext context, String fontFamily, SettingsState state) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: state.fontFamily,
        isExpanded: true,
        items: const [
          DropdownMenuItem(value: 'لوتوس', child: Text("لوتوس")),
          DropdownMenuItem(value: 'البهيج', child: Text("البهيج")),
          DropdownMenuItem(value: 'دجلة', child: Text("دجلة")),
        ],
        onChanged: (value) async {
          context.read<SettingsCubit>().updateFontFamily(value!);

          // final css =
          //     await context.read<ContentCubit>().loadFont(state.fontFamily);

          Future.delayed(Duration(milliseconds: 500), () async {
            // await inAppWebViewController
            //     .evaluateJavascript(
            //   source: """
            //                           var style = document.getElementById('customFontStyle');
            //                           if (!style) {
            //                             style = document.createElement('style');
            //                             style.id = 'customFontStyle';
            //                             document.head.appendChild(style);
            //                           }
            //                           style.innerHTML = `$css`;

            //                           document.querySelectorAll('.text_style').forEach(function(el) {
            //                             el.style.setProperty('font-family', '$value', 'important');
            //                           });
            //                         """,
            // );
          });
        },
      ),
    );
  }

  Widget _backgroundColorPicker(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          margin: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCicle(Colors.white, state, context),
                  _buildCicle(Color(0xFFDAD0A7), state, context),
                  _buildCicle(Colors.grey, state, context),
                ]),
          ),
        );
      },
    );
  }

  Widget _pageDirectionToggle(
      BuildContext context, PageDirection pageDirection) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // عمودي
          Expanded(
            child: InkWell(
              onTap: () {
                context
                    .read<SettingsCubit>()
                    .updatePageDirection(PageDirection.vertical);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: pageDirection == PageDirection.vertical
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: pageDirection == PageDirection.vertical
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.upAndDownArrows.image(
                          width: 24,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                      const SizedBox(width: 6),
                      const Text('عمودي'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // أفقي
          Expanded(
            child: InkWell(
              onTap: () {
                context
                    .read<SettingsCubit>()
                    .updatePageDirection(PageDirection.horizontal);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: pageDirection == PageDirection.horizontal
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: pageDirection == PageDirection.horizontal
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: 1.5708,
                        child: Assets.icons.upAndDownArrows.image(
                            width: 24,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      const SizedBox(width: 6),
                      const Text('أفقي'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCicle(
      Color color, SettingsState settingState, BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        final hexColor = '#${color.value.toRadixString(16).substring(2)}';

        context.read<SettingsCubit>().updateBgColor(color, hexColor);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: settingState.pageColor == color ? Colors.red : Colors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }
}

enum PageDirection { vertical, horizontal }
