import 'package:blog_app/constants/utils/calculate_reading_time.dart';
import 'package:blog_app/constants/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'Written by : ${blog.posterName}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Date : ${formatDateBydMMMYYYY(blog.updatedAt)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
                const SizedBox(
                  height: 7,
                ),
                Text('Reading Time : ${calculateReadingTime(blog.content)} min(s)',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: NetworkImage(blog.imageUrl),
                    height: MediaQuery.of(context).size.height * .3,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20,),
                Text(blog.content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
