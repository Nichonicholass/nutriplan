import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

/// Result from on-device ML Kit image labeling.
class FoodRecognitionResult {
  final List<FoodLabelItem> labels;
  final bool isFoodDetected;

  const FoodRecognitionResult({
    required this.labels,
    required this.isFoodDetected,
  });
}

class FoodLabelItem {
  final String label;
  final double confidence;
  final String? indonesianName;
  final String? nutritionHint;

  const FoodLabelItem({
    required this.label,
    required this.confidence,
    this.indonesianName,
    this.nutritionHint,
  });
}

/// On-device food recognition using Google ML Kit (no internet needed).
/// All inference runs locally on the device — true edge computing.
class FoodRecognitionService {
  late final ImageLabeler _labeler;
  bool _disposed = false;

  FoodRecognitionService() {
    _labeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.4),
    );
  }

  // Labels from the base ML Kit model that relate to food
  static const _foodKeywords = {
    'food', 'dish', 'cuisine', 'recipe', 'ingredient', 'meal', 'snack',
    'rice', 'noodle', 'bread', 'soup', 'salad', 'fruit', 'vegetable',
    'meat', 'fish', 'egg', 'chicken', 'beef', 'pork', 'tofu', 'tempeh',
    'dessert', 'cake', 'cookie', 'beverage', 'drink', 'juice',
    'fried food', 'fast food', 'comfort food', 'street food', 'junk food',
    'bowl', 'plate', 'breakfast', 'lunch', 'dinner',
    'banana', 'apple', 'orange', 'mango', 'avocado', 'coconut',
    'potato', 'carrot', 'broccoli', 'corn', 'pepper', 'onion', 'garlic',
    'pasta', 'pizza', 'hamburger', 'sandwich', 'taco', 'sushi',
    'porridge', 'oatmeal', 'cereal', 'curry', 'stew', 'stir fry',
    'grilled food', 'roasted food', 'baked good', 'dairy product',
    'seafood', 'shrimp', 'crab', 'lobster',
  };

  // Translation + hints for common labels → Indonesian context
  static const _labelInfo = <String, (String, String)>{
    'rice':         ('Nasi',          'Karbohidrat ~130 kal/100g'),
    'noodle':       ('Mie',           'Karbohidrat ~138 kal/100g'),
    'egg':          ('Telur',         'Protein tinggi ~155 kal/butir besar'),
    'chicken':      ('Ayam',          'Protein tinggi ~165 kal/100g'),
    'fish':         ('Ikan',          'Protein tinggi ~80-120 kal/100g'),
    'tofu':         ('Tahu',          'Protein nabati ~76 kal/100g'),
    'tempeh':       ('Tempe',         'Protein nabati ~193 kal/100g'),
    'vegetable':    ('Sayuran',       'Rendah kalori, kaya serat'),
    'fruit':        ('Buah-buahan',   'Kaya vitamin, serat alami'),
    'bread':        ('Roti',          'Karbohidrat ~265 kal/100g'),
    'soup':         ('Sup/Soto',      'Rendah kalori, mengenyangkan'),
    'meat':         ('Daging',        'Protein tinggi ~250 kal/100g'),
    'fried food':   ('Makanan Goreng','Tinggi lemak, perhatikan porsi'),
    'dessert':      ('Dessert/Kue',   'Tinggi gula, konsumsi terbatas'),
    'snack':        ('Camilan',       'Perhatikan porsi'),
    'banana':       ('Pisang',        'Karbohidrat, kalium ~89 kal/buah'),
    'apple':        ('Apel',          'Serat tinggi ~95 kal/buah'),
    'avocado':      ('Alpukat',       'Lemak sehat ~160 kal/100g'),
    'potato':       ('Kentang',       'Karbohidrat ~77 kal/100g'),
    'corn':         ('Jagung',        'Karbohidrat ~86 kal/100g'),
    'seafood':      ('Seafood',       'Protein, Omega-3 tinggi'),
    'porridge':     ('Bubur',         'Mudah dicerna, rendah kalori'),
    'oatmeal':      ('Oatmeal',       'Serat tinggi, indeks glikemik rendah'),
    'curry':        ('Kari/Gulai',    'Kaya rempah'),
    'stir fry':     ('Tumisan',       'Sayuran bergizi, rendah kalori'),
    'grilled food': ('Makanan Bakar', 'Lebih sehat dari digoreng'),
    'dairy product':('Produk Susu',   'Kalsium tinggi'),
    'beverage':     ('Minuman',       'Perhatikan kandungan gula'),
    'juice':        ('Jus Buah',      'Vitamin tinggi, perhatikan gula'),
  };

  /// Analyze an image from a local file path.
  /// All processing runs entirely on-device — no network call.
  Future<FoodRecognitionResult> analyzeImage(String imagePath) async {
    if (_disposed) throw StateError('FoodRecognitionService has been disposed');

    final inputImage = InputImage.fromFilePath(imagePath);
    final rawLabels = await _labeler.processImage(inputImage);

    // Filter and enrich labels
    final foodLabels = <FoodLabelItem>[];
    for (final l in rawLabels) {
      final lower = l.label.toLowerCase();
      final isFood = _foodKeywords.contains(lower) ||
          _foodKeywords.any((k) => lower.contains(k));

      if (!isFood && l.confidence < 0.75) continue;

      final info = _labelInfo[lower];
      foodLabels.add(FoodLabelItem(
        label: l.label,
        confidence: l.confidence,
        indonesianName: info?.$1,
        nutritionHint: info?.$2,
      ));
    }

    foodLabels.sort((a, b) => b.confidence.compareTo(a.confidence));

    final isFoodDetected = foodLabels.any(
      (l) => _foodKeywords.contains(l.label.toLowerCase()) && l.confidence > 0.5,
    );

    return FoodRecognitionResult(
      labels: foodLabels.take(6).toList(),
      isFoodDetected: isFoodDetected,
    );
  }

  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _labeler.close();
    }
  }
}
