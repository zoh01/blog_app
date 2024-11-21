import 'package:blog_app/constants/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;

  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog,)));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(20).copyWith(bottom: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: blog.topics
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Chip(
                          label: Text(e),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Text(
              blog.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const Spacer(),
            Text(
              '${calculateReadingTime(blog.content)} mins',
            )
          ],
        ),
      ),
    );
  }
}
