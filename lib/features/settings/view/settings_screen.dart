import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppbar.littleAppBar(context, title: 'الإعدادات'),
          backgroundColor: const Color(0xFFF5F7FA),
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
                    child: _colorGradientPicker(context, state.gradientIndex),
                    delay: 250,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('نوع الخط'),
                    delay: 300,
                  ),
                  _animatedSection(
                    child: _fontFamilyCardSelector(context, state.fontFamily),
                    delay: 350,
                  ),
                  const SizedBox(height: 24),
                  _animatedSection(
                    child: _sectionTitle('لون الخلفية'),
                    delay: 400,
                  ),
                  _animatedSection(
                    child: _backgroundColorPicker(context, state.bgColorIndex),
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
            fontSize: 18,
            color: Colors.black87,
            fontFamily: 'Tajawal',
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _fontSizeSlider(BuildContext context, double fontSize) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: fontSize,
                min: 12,
                max: 30,
                divisions: 9,
                label: fontSize.toStringAsFixed(0),
                onChanged: (value) {
                  context.read<SettingsCubit>().updateFontSize(value);
                },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: lineHeight,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                label: lineHeight.toStringAsFixed(2),
                onChanged: (value) {
                  context.read<SettingsCubit>().updateLineHeight(value);
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                lineHeight.toStringAsFixed(2),
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

  Widget _colorGradientPicker(BuildContext context, int gradientIndex) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: SettingsCubit.backgrounds.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final isSelected = gradientIndex == index;
            return GestureDetector(
              onTap: () {
                context.read<SettingsCubit>().updateGradientIndex(index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isSelected ? 55 : 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: SettingsCubit.backgrounds[index],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: SettingsCubit.backgrounds[index][0]
                                  .withOpacity(0.3),
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

  Widget _fontFamilyCardSelector(BuildContext context, String fontFamily) {
    final fonts = ['جَزَلة', 'أميري', 'الكوفي', 'Tajawal'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            ...fonts.map((font) {
              return RadioListTile<String>(
                value: font,
                groupValue: fontFamily,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsCubit>().updateFontFamily(value);
                  }
                },
                title: Text(
                  font,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontFamily: font),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                activeColor: Colors.blueAccent,
                controlAffinity: ListTileControlAffinity.trailing,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _backgroundColorPicker(BuildContext context, int bgColorIndex) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(SettingsCubit.bgColorsPage.length, (index) {
            final color = SettingsCubit.bgColorsPage[index];
            final isSelected = bgColorIndex == index;
            return GestureDetector(
              onTap: () {
                context.read<SettingsCubit>().updateBgColorIndex(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSelected ? 48 : 42,
                height: isSelected ? 48 : 42,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? Colors.blueAccent : Colors.grey.shade300,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
              ),
            );
          }),
        ),
      ),
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
                      ? context
                          .read<SettingsCubit>()
                          .state
                          .primry
                          .withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: pageDirection == PageDirection.vertical
                        ? context.read<SettingsCubit>().state.primry
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.upAndDownArrows.image(width: 24),
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
                      ? context
                          .read<SettingsCubit>()
                          .state
                          .primry
                          .withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: pageDirection == PageDirection.horizontal
                        ? context.read<SettingsCubit>().state.primry
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
                        child: Assets.icons.upAndDownArrows.image(width: 24),
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
}

enum PageDirection { vertical, horizontal }
