import 'package:flutter/material.dart';

import '../../../shared/constants/app_assets.dart';
import 'contact_model.dart';

class ContactRepository {
  Future<List<ContactAction>> getActions() async {
    return const [
      ContactAction(
        title: 'Raise a Ticket',
        subtitle: 'Get help with your issues',
        icon: AppAssets.ticketIcon,
        destination: ContactActionDestination.raiseTicket,
      ),
      ContactAction(
        title: 'Ticket Status',
        subtitle: 'Track your existing tickets',
        icon: AppAssets.ticketStatusIcon,
        destination: ContactActionDestination.ticketStatus,
      ),
      ContactAction(
        title: "FAQ's",
        subtitle: 'Find answers instantly',
        icon: AppAssets.questionMarkIcon,
        destination: ContactActionDestination.faq,
      ),
      ContactAction(
        title: 'Email Us',
        subtitle: 'Reach us via email',
        icon: AppAssets.emailIcon,
      ),
      ContactAction(
        title: 'Live Chat',
        subtitle: 'Talk with our team',
        icon: AppAssets.chatIcon,
      ),
      ContactAction(
        title: 'Feedback',
        subtitle: 'Help us improve',
        icon: AppAssets.feedbackIcon,
      ),
    ];
  }

  Future<List<ContactInfo>> getContactInfo() async {
    return const [
      ContactInfo(
        title: 'Support Email',
        value: 'support@zodiacplus.com',
        icon: Icons.email_outlined,
      ),
      ContactInfo(
        title: 'Business Inquiries',
        value: 'business@zodiacplus.com',
        icon: Icons.business_outlined,
      ),
      ContactInfo(
        title: 'Contact Number',
        value: '+91 99988 77722',
        icon: Icons.call_outlined,
      ),
      ContactInfo(
        title: 'Address',
        value: 'New Delhi, India',
        icon: Icons.location_on_outlined,
      ),
    ];
  }

  Future<String> getWorkingHours() async {
    return '24/7 Anytime';
  }
}
