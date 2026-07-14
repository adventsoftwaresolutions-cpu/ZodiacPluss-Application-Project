import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import 'widgets/contact_body.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: ContactBody(),
      ),
    );
  }
}