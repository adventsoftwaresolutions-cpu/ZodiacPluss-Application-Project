import 'package:flutter/material.dart';

import 'section_card.dart';

class ProfilePhotoCard extends StatelessWidget {
  const ProfilePhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "5. Profile Photo",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Upload a professional looking photo.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xff6B7280),
            ),
          ),

          const SizedBox(height: 28),

          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F7FA),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffE4E8EE),
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 58,
                    color: Color(0xffB8C0CC),
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {},
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xff17B3A7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Center(
            child: Text(
              "JPG, PNG up to 5MB",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}