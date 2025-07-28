// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';


// GestureDetector settingModal(
//   InAppWebViewController contentController,
//   SettingsController settingsController,
//   BuildContext context,
// ) {
//   return GestureDetector(
//     onTap: () {
//     },
//     child: Container(
   
//       decoration: BoxDecoration(color: Colors.black38),
//       alignment: Alignment.center,
//       child: Container(
//         constraints: BoxConstraints(maxWidth: 400),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: EdgeInsets.all(20),
//         margin: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Font Size Slider
//             Text("تنظیم اندازه‌ی متن :"),
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 2,
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
//                 activeTrackColor: Theme.of(context).colorScheme.primary,
//                 inactiveTrackColor: Colors.grey.shade300,
//                 thumbColor: Theme.of(context).colorScheme.primary,
//               ),
//               child: Slider(
//                 value: settingsController.fontSize.value,
//                 min: 10,
//                 max: 30,
//                 divisions: 20,
//                 label: settingsController.fontSize.value.round().toString(),
//                 onChanged: (value) {
//                   settingsController.isApplying.value = true;
//                   settingsController.setFontSize(value);

//                   Future.delayed(Duration(milliseconds: 500), () {
//                     contentController
//                         .evaluateJavascript(
//                           source:
//                               """
//                                                 document.querySelectorAll('.text_style').forEach(function(el) {
//                                                   el.style.setProperty('font-size', '${value}px', 'important');
//                                                   });
//                                                 """,
//                         )
//                         .whenComplete(() {
//                           settingsController.isApplying.value = false;
//                         });
//                   });
//                 },
//               ),
//             ),

//             const Gap(20),
//             Text("تنظیم فاصله‌ی خطوط :"),
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 2,
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
//                 overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
//                 activeTrackColor: Theme.of(context).colorScheme.primary,
//                 inactiveTrackColor: Colors.grey.shade300,
//                 thumbColor: Theme.of(context).colorScheme.primary,
//               ),
//               child: Slider(
//                 value: settingsController.lineHeight.value,
//                 min: 1,
//                 max: 3,
//                 divisions: 10,
//                 label: settingsController.lineHeight.value.toStringAsFixed(1),
//                 onChanged: (value) {
//                   settingsController.isApplying.value = true;
//                   settingsController.setLineHeight(value);
//                   Future.delayed(Duration(milliseconds: 300), () {
//                     contentController
//                         .evaluateJavascript(
//                           source:
//                               """
//                                               document.querySelectorAll('.text_style').forEach(function(el) {
//                                                 el.style.setProperty('line-height', '$value', 'important');
//                                               });
//                                             """,
//                         )
//                         .whenComplete(() {
//                           settingsController.isApplying.value = false;
//                         });
//                   });
//                 },
//               ),
//             ),

//             const Gap(20),
//             Text("انتخاب قلم دلخواه :"),
//             const Gap(10),
//             // Font Type Dropdown
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: settingsController.fontFamily.value,
//                   isExpanded: true,
//                   items: const [
//                     DropdownMenuItem(value: 'لوتوس', child: Text("لوتوس")),
//                     DropdownMenuItem(value: 'البهيج', child: Text("البهيج")),
//                     DropdownMenuItem(value: 'دجلة', child: Text("دجلة")),
//                   ],
//                   onChanged: (value) async {
//                     settingsController.setFontFamily(value!);
//                     settingsController.isApplying.value = true;

//                     final css = await contentController.loadFont();

//                     Future.delayed(Duration(milliseconds: 500), () async {
//                       await contentController
//                           .evaluateJavascript(
//                             source:
//                                 """
//                                                   var style = document.getElementById('customFontStyle');
//                                                   if (!style) {
//                                                     style = document.createElement('style');
//                                                     style.id = 'customFontStyle';
//                                                     document.head.appendChild(style);
//                                                   }
//                                                   style.innerHTML = `$css`;

//                                                   document.querySelectorAll('.text_style').forEach(function(el) {
//                                                     el.style.setProperty('font-family', '$value', 'important');
//                                                   });
//                                                 """,
//                           );
//                       settingsController.isApplying.value = false;
//                     });
//                   },
//                 ),
//               ),
//             ),

//             const Gap(20),

//             // Background Color Selection
//             Text("انتخاب رنگ پس‌زمینه :"),
//             const Gap(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildColorCircle(
//                   Colors.white,
//                   settingsController,
//                   contentController,
//                 ),
//                 _buildColorCircle(
//                   Color(0xFFDAD0A7),
//                   settingsController,
//                   contentController,
//                 ),
//                 _buildColorCircle(
//                   Colors.grey,
//                   settingsController,
//                   contentController,
//                 ),
//               ],
//             ),
//             const Gap(10),
//             Obx(
//               () => settingsController.isApplying.value
//                   ? Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 16,
//                             height: 16,
//                             child: CustomLoader(size: 50, color: Colors.white),
//                           ),
//                           SizedBox(width: 8),
//                           Text("جاري تطبيق التغييرات..."),
//                         ],
//                       ),
//                     )
//                   : SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildColorCircle(
//   Color color,
//   SettingsController settingsController,
//   ContentController contentController,
// ) {
//   return GestureDetector(
//     onTap: () {
//       settingsController.isApplying.value = true;
//       settingsController.setBackgroundColor(color);
//       final hexColor = '#${color.value.toRadixString(16).substring(2)}';

//       Future.delayed(Duration(milliseconds: 300), () {
//         contentController.inAppWebViewController
//             .evaluateJavascript(
//               source:
//                   """
//         document.querySelectorAll('.book_page').forEach(function(el) {
//           el.style.setProperty('background-color', '$hexColor', 'important');
//         });
//       """,
//             )
//             .whenComplete(() {
//               settingsController.isApplying.value = false;
//             });
//       });
//     },
//     child: Column(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: settingsController.backgroundColor.value == color
//                   ? Colors.red
//                   : Colors.grey,
//               width: 1,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
