import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMeView extends StatefulWidget {
  const AboutMeView({super.key});

  @override
  State<AboutMeView> createState() => _AboutMeViewState();
}

class _AboutMeViewState extends State<AboutMeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutMeTitle)),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _profileHeader(context, l10n),
              const SizedBox(height: 20),

              _infoCard(l10n.aboutMeSummary),
              _infoCard(l10n.aboutMeSkillsTitle, content: l10n.aboutMeSkills),
              _infoCard(
                l10n.aboutMeProjectsTitle,
                content: l10n.aboutMeProjects,
              ),

              const SizedBox(height: 24),

              _actionButtons(context, l10n),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  l10n.aboutMeFooter,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.aboutMeName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(l10n.aboutMeRole, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _infoCard(String title, {String? content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (content != null) ...[const SizedBox(height: 8), Text(content)],
          ],
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.code),
                label: Text(l10n.github),
                onPressed: () => _openLink('https://github.com/BugMaker69'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.business),
                label: Text(l10n.linkedin),
                onPressed: () => _openLink(
                  'https://www.linkedin.com/in/omar-elsaadany2002/',
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 12),
        // ElevatedButton.icon(
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: const Size.fromHeight(48),
        //   ),
        //   icon: const Icon(Icons.download),
        //   label: Text(l10n.downloadCV),
        //   onPressed: () => _openLink('https://example.com/omar_cv.pdf'),
        // ),
      ],
    );
  }
}
