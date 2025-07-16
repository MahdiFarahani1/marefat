import 'package:bookapp/config/theme/app_colors.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  double _fontSize = 18;
  double _lineHeight = 1.5;
  String _fontFamily = 'جَزَلة';
  int _gradientIndex = 0;
  int _bgColorIndex = 2;
  int _pageDirection = 1;

  final List<List<Color>> _gradients = [
    [Color(0xFF283048), Color(0xFF859398)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    [Color(0xFFFFB75E), Color(0xFFED8F03)],
    [Color(0xFF56CCF2), Color(0xFF2F80ED)],
    [Color(0xFF00C9FF), Color(0xFF92FE9D)],
  ];
  final List<String> _fonts = ['جَزَلة', 'أميري', 'الكوفي', 'Tajawal'];
  final List<Color> _bgColors = [
    Color(0xFFB0BEC5),
    Color(0xFFFFF3CD),
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: _fontSizeSlider(),
                delay: 50,
              ),
              const SizedBox(height: 24),
              _animatedSection(
                child: _sectionTitle('تباعد الأسطر'),
                delay: 100,
              ),
              _animatedSection(
                child: _lineHeightSlider(),
                delay: 150,
              ),
              const SizedBox(height: 24),
              _animatedSection(
                child: _sectionTitle('ألوان المظهر'),
                delay: 200,
              ),
              _animatedSection(
                child: _colorGradientPicker(),
                delay: 250,
              ),
              const SizedBox(height: 24),
              _animatedSection(
                child: _sectionTitle('نوع الخط'),
                delay: 300,
              ),
              _animatedSection(
                child: _fontFamilyCardSelector(),
                delay: 350,
              ),
              const SizedBox(height: 24),
              _animatedSection(
                child: _sectionTitle('لون الخلفية'),
                delay: 400,
              ),
              _animatedSection(
                child: _backgroundColorPicker(),
                delay: 450,
              ),
              const SizedBox(height: 24),
              _animatedSection(
                child: _sectionTitle('عرض الصفحة'),
                delay: 500,
              ),
              _animatedSection(
                child: _pageDirectionToggle(),
                delay: 550,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400),
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
      onEnd: () {},
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

  Widget _fontSizeSlider() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: _fontSize,
                min: 12,
                max: 30,
                divisions: 9,
                label: _fontSize.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() => _fontSize = value);
                },
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Text(
                _fontSize.toStringAsFixed(0),
                key: ValueKey(_fontSize),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineHeightSlider() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: _lineHeight,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                label: _lineHeight.toStringAsFixed(2),
                onChanged: (value) {
                  setState(() => _lineHeight = value);
                },
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Text(
                _lineHeight.toStringAsFixed(2),
                key: ValueKey(_lineHeight),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorGradientPicker() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _gradients.length,
          separatorBuilder: (_, __) => SizedBox(width: 16),
          itemBuilder: (context, index) {
            final isSelected = _gradientIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _gradientIndex = index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: isSelected ? 55 : 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _gradients[index],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _gradients[index][0].withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: isSelected
                        ? Border.all(color: Colors.blueAccent, width: 3)
                        : null,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _fontFamilyCardSelector() {
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
                groupValue: _fontFamily,
                onChanged: (value) {
                  if (value != null) setState(() => _fontFamily = value);
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

  Widget _backgroundColorPicker() {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_bgColors.length, (index) {
            final color = _bgColors[index];
            final isSelected = _bgColorIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => _bgColorIndex = index);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
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
                            offset: Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child:
                    isSelected ? Icon(Icons.check, color: Colors.white) : null,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _pageDirectionToggle() {
    PageDirection dire = PageDirection.horizontal; // تغییر بده به state واقعی

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // عمودی
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() =>
                    dire = PageDirection.vertical); // ← ست کردن استیت واقعی
              },
              child: Container(
                decoration: BoxDecoration(
                  color: dire == PageDirection.vertical
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dire == PageDirection.vertical
                        ? AppColors.primary
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
                setState(() =>
                    dire = PageDirection.horizontal); // ← ست کردن استیت واقعی
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: dire == PageDirection.horizontal
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dire == PageDirection.horizontal
                        ? AppColors.primary
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
                          child: Assets.icons.upAndDownArrows.image(width: 24)),
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
