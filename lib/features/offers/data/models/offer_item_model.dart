/// Immutable data class representing an offer/service/package.
/// Mock data for now — ready to be populated from API endpoint.
class OfferItem {
  final String title;
  final String description;
  final String status;
  final String provider;
  final double cost;
  final String currency;
  final String imagePath;
  final String packageNumber;
  final String duration;
  final String location;
  final String googleMapsUrl;
  final String aboutText;
  final List<String> availableTimes;

  const OfferItem({
    required this.title,
    required this.description,
    required this.status,
    required this.provider,
    required this.cost,
    required this.currency,
    required this.imagePath,
    required this.packageNumber,
    required this.duration,
    required this.location,
    required this.googleMapsUrl,
    required this.aboutText,
    required this.availableTimes,
  });
}
