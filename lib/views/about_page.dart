import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/flyout_nav.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      drawer: const NavDrawer(),
      backgroundColor: const Color(0xFF16141a).withOpacity(.8),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.discord,
                  size: 30,
                ),
                title: const Text("Discord"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://discord.gg/usS8XgVYnF",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.twitter,
                  size: 30,
                ),
                title: const Text("Twitter"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://twitter.com/turbointerl9",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.instagram,
                  size: 30,
                ),
                title: const Text("Instagram"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://instagram.com/z4roc",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.github,
                  size: 30,
                ),
                title: const Text("Docs"),
                subtitle: const Text("Source Code"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://github.com/z4roc/flutter-valorant-store",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.circleDollarToSlot,
                  size: 30,
                ),
                title: const Text("Donate"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://ko-fi.com/zaroc",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Credits",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.github,
                  size: 30,
                ),
                title: const Text("@techchrism"),
                subtitle: const Text("valorant-api-docs"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://github.com/techchrism/valorant-api-docs",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.github,
                  size: 30,
                ),
                title: const Text("@NotOfficer"),
                subtitle: const Text("Inofficial Valorant API"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://github.com/NotOfficer",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.github,
                  size: 30,
                ),
                title: const Text("@Henrik-3"),
                subtitle: const Text("unofficial-valorant-api"),
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://github.com/Henrik-3/unofficial-valorant-api",
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              const Text(
                "Other links",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async => await launchUrl(
                  Uri.parse(
                      "https://support-valorant.riotgames.com/hc/en-us/articles/360045132434-Checking-Your-Purchase-History-"),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "How much money did I spend on Valorant?",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async => await launchUrl(
                  Uri.parse("https://twitter.com/ValorLeaks"),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Latest Skin and Bundle news via ValorLeaks on Twitter",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async => await launchUrl(
                  Uri.parse("https://valostore.zaroc.de/policy"),
                  mode: LaunchMode.externalApplication,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              /*TextButton(
                onPressed: () async {
                  await RiotService().reauthenticateUser();
                },
                child: const Text("Reauth"),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
