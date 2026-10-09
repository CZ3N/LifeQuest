/// Formats a date the way Life Quest shows it everywhere in the app, e.g.
/// "September 18, 2026". Written by hand instead of adding the intl
/// package, since this one format is all the MVP needs.
String formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
