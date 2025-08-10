import 'package:bookapp/features/content_books/bloc/content/content_cubit.dart';
import 'package:bookapp/features/content_books/repository/dataBase.dart';
import 'package:bookapp/features/settings/bloc/settings_cubit.dart';
import 'package:bookapp/features/settings/bloc/settings_state.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TextSettingsDialog {
  Future<void> show(BuildContext context,
      InAppWebViewController inAppWebViewController) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => ContentCubit(
              context: context,
              bookId: '1',
              settingsCubit: SettingsCubit(),
              repository: BookDatabaseHelper()),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: EsaySize.width(context),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: 30,
                              height: 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: context
                                      .read<SettingsCubit>()
                                      .state
                                      .primry),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "🛠 إعدادات النص",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),

                                // Font Size
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("حجم الخط"),
                                    Text(state.fontSize.toStringAsFixed(0)),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 2,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 8),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 12),
                                    activeTrackColor:
                                        Theme.of(context).colorScheme.primary,
                                    inactiveTrackColor: Colors.grey.shade300,
                                    thumbColor:
                                        Theme.of(context).colorScheme.primary,
                                    valueIndicatorTextStyle:
                                        TextStyle(color: Colors.white),
                                  ),
                                  child: Slider(
                                    value: state.fontSize,
                                    min: 10,
                                    max: 26,
                                    divisions: 20,
                                    label: state.fontSize.round().toString(),
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeStateApply(true);
                                      context
                                          .read<SettingsCubit>()
                                          .updateFontSize(value);
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        inAppWebViewController
                                            .evaluateJavascript(
                                          source: """
                                                                                          document.querySelectorAll('.text_style').forEach(function(el) {
                                                                                            el.style.setProperty('font-size', '${value}px', 'important');
                                                                                            });
                                                                                          """,
                                        ).whenComplete(() {
                                          context
                                              .read<SettingsCubit>()
                                              .changeStateApply(false);
                                        });
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Line Height
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("تباعد الأسطر"),
                                    Text(state.lineHeight.toStringAsFixed(1)),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    valueIndicatorTextStyle:
                                        TextStyle(color: Colors.white),
                                    trackHeight: 2,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 8),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 12),
                                    activeTrackColor:
                                        Theme.of(context).colorScheme.primary,
                                    inactiveTrackColor: Colors.grey.shade300,
                                    thumbColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: Slider(
                                    value: state.lineHeight,
                                    min: 1,
                                    max: 3,
                                    divisions: 10,
                                    label: state.lineHeight.toStringAsFixed(1),
                                    onChanged: (value) {
                                      context
                                          .read<SettingsCubit>()
                                          .changeStateApply(true);
                                      context
                                          .read<SettingsCubit>()
                                          .updateLineHeight(value);
                                      Future.delayed(
                                          Duration(milliseconds: 300), () {
                                        inAppWebViewController
                                            .evaluateJavascript(
                                          source: """
                                                              document.querySelectorAll('.text_style').forEach(function(el) {
                                                                el.style.setProperty('line-height', '$value', 'important');
                                                              });
                                                            """,
                                        ).whenComplete(() {
                                          context
                                              .read<SettingsCubit>()
                                              .changeStateApply(false);
                                        });
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Font Family
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('نوع الخط')),
                                const SizedBox(height: 8),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state.fontFamily,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'لوتوس', child: Text("لوتوس")),
                                      DropdownMenuItem(
                                          value: 'البهيج',
                                          child: Text("البهيج")),
                                      DropdownMenuItem(
                                          value: 'دجلة', child: Text("دجلة")),
                                    ],
                                    onChanged: (value) async {
                                      context
                                          .read<SettingsCubit>()
                                          .updateFontFamily(value!);
                                      context
                                          .read<SettingsCubit>()
                                          .changeStateApply(true);
                                      final css = await context
                                          .read<ContentCubit>()
                                          .loadFont(state.fontFamily);

                                      Future.delayed(
                                          Duration(milliseconds: 500),
                                          () async {
                                        await inAppWebViewController
                                            .evaluateJavascript(
                                          source: """
                                                                  var style = document.getElementById('customFontStyle');
                                                                  if (!style) {
                                                                    style = document.createElement('style');
                                                                    style.id = 'customFontStyle';
                                                                    document.head.appendChild(style);
                                                                  }
                                                                  style.innerHTML = `$css`;
                                  
                                                                  document.querySelectorAll('.text_style').forEach(function(el) {
                                                                    el.style.setProperty('font-family', '$value', 'important');
                                                                  });
                                                                """,
                                        ).whenComplete(
                                          () {
                                            context
                                                .read<SettingsCubit>()
                                                .changeStateApply(false);
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Background Color
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("لون الخلفیة")),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildColorCircle(Colors.white,
                                        inAppWebViewController, state, context),
                                    _buildColorCircle(Color(0xFFDAD0A7),
                                        inAppWebViewController, state, context),
                                    _buildColorCircle(Colors.grey,
                                        inAppWebViewController, state, context),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    "إغلاق",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                ),
                                EsaySize.gap(10),
                                AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: context
                                            .read<SettingsCubit>()
                                            .state
                                            .isApplying
                                        ? 1.0
                                        : 0.0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: EsaySize.width(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: LoadingAnimationWidget
                                                  .threeArchedCircle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 16)),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'جاري التحميل...',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildColorCircle(
      Color color,
      InAppWebViewController inAppWebViewController,
      SettingsState settingState,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsCubit>().changeStateApply(true);
        context.read<SettingsCubit>().updateBgColor(color);
        final hexColor = '#${color.value.toRadixString(16).substring(2)}';

        Future.delayed(Duration(milliseconds: 300), () {
          inAppWebViewController.evaluateJavascript(
            source: """
        document.querySelectorAll('.book_page').forEach(function(el) {
          el.style.setProperty('background-color', '$hexColor', 'important');
        });
      """,
          ).whenComplete(() {
            context.read<SettingsCubit>().changeStateApply(false);
          });
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    settingState.pageColor == color ? Colors.red : Colors.grey,
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
