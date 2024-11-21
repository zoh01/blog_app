int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  // Speed  = Distance / Time

  final readingTime = wordCount / 225;

  return readingTime.ceil();
}