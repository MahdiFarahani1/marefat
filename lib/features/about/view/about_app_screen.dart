import 'package:bookapp/core/extensions/widget_ex.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/scaffold/appbar.dart';
import 'package:flutter/material.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar.littleAppBar(context, title: ""),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                icon: Assets.newicons.commentInfo.path,
                title: "من نحن",
                content:
                    "نحن مجموعة من المهتمين بنشر المعرفة الدينية الأصيلة بلغة واضحة وميسّرة، معتمدة على نتاجات سماحة السيد محمد باقر السيستاني(دامت بركاته). نسعى إلى تقريب مفاهيم العقيدة والأخلاق والفكر الإسلامي إلى القارئ المعاصر بما يجيب عن أسئلته ويبدّد الشبهات المطروحة في عصرنا.",
              ),
              _buildSection(
                icon: Assets.newicons.eye.path,
                title: "رؤيتنا",
                content:
                    "أن يكون التطبيق منبرًا رائدًا يجمع بين الموثوقية والوضوح، ويُسهم في بناء وعي ديني راسخ، ويقدّم المعرفة بروح معاصرة وأصيلة معًا.",
              ),
              _buildSection(
                icon: Assets.newicons.taskChecklist.path,
                title: "مهمتنا",
                content:
                    "• توفير مقالات وأجوبة معرفية وعقائدية وأخلاقية بلغة مبسطة وعميقة.\n"
                    "• التصدي للشبهات الفكرية والمعرفية المعاصرة بروح علمية وهادئة.\n"
                    "• جمع ونشر كتب ومحاضرات وكراسات سماحة السيد محمد باقر السيستاني.\n"
                    "• دعم الباحثين والمهتمين بامتلاك رؤية أوضح حول الدين والهوية الإيمانية.",
              ),
              _buildSection(
                icon: Assets.newicons.commentHeart.path,
                title: "قيمنا",
                content:
                    "• الأصالة والدقة: اعتماد المصادر الموثوقة، مع الالتزام بالتحقيق العلمي الرصين.\n"
                    "• الوضوح واليسر: تبسيط الطرح وتيسير الفهم دون الإخلال بجوهر المضمون.\n"
                    "• المسؤولية والأمانة: تقديم المعرفة بما يراعي الصدق والموضوعية.\n"
                    "• العطاء والخدمة: جعل المعرفة الدينية في متناول الجميع، بروح خدمة صادقة وعطاء مستمر.",
              ),
              _buildSection(
                icon: Assets.newicons.teamCheck.path,
                title: "فريقنا",
                content:
                    "يتكوّن فريق التطبيق من مجموعة من طلبة العلم والمهتمين بالفكر الإسلامي، الذين يوحّدهم هدف نشر المعرفة الدينية، وإعانة الباحثين، وترسيخ الوعي والإيمان عند فئة الشباب.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String icon, required String title, required String content}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.tertiary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  icon,
                  width: 25,
                  height: 25,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
