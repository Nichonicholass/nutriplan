import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/food_recognition/food_recognition_service.dart';

class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  State<FoodScannerScreen> createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  final _service = FoodRecognitionService();
  final _picker = ImagePicker();

  String? _imagePath;
  bool _isAnalyzing = false;
  FoodRecognitionResult? _result;
  String? _errorMessage;

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    // Request permission
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final status = await permission.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(source == ImageSource.camera
                ? 'Izin kamera diperlukan'
                : 'Izin galeri diperlukan'),
            action: SnackBarAction(
              label: 'Pengaturan',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
      return;
    }

    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );
      if (file == null) return;

      setState(() {
        _imagePath = file.path;
        _result = null;
        _errorMessage = null;
        _isAnalyzing = true;
      });

      final result = await _service.analyzeImage(file.path);

      if (mounted) {
        setState(() {
          _result = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'Gagal menganalisis gambar. Coba lagi.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Scan Makanan',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header info
            _buildHeader(isDark).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            const SizedBox(height: 20),

            // Image preview area
            _buildImageArea(isDark).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Source picker buttons
            _buildSourceButtons(isDark).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 24),

            // Results
            if (_isAnalyzing) _buildAnalyzing(isDark).animate().fadeIn(),
            if (_errorMessage != null) _buildError(isDark),
            if (_result != null && !_isAnalyzing)
              _buildResults(isDark).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D9A3), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🤖', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Edge AI — On-Device',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Analisis Makanan Lokal',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'AI berjalan di HP Anda — tanpa internet',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageArea(bool isDark) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 48,
                  color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Foto atau pilih gambar makanan',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI akan mengenali makanan secara lokal',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSourceButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _SourceButton(
            icon: Icons.camera_alt_rounded,
            label: 'Kamera',
            color: AppColors.primary,
            onTap: () => _pickImage(ImageSource.camera),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SourceButton(
            icon: Icons.photo_library_rounded,
            label: 'Galeri',
            color: AppColors.secondary,
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzing(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Menganalisis gambar...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito',
              color: isDark ? AppColors.textPrimary : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ML Kit memproses di perangkat Anda',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Nunito',
              color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(bool isDark) {
    final result = _result!;

    if (!result.isFoodDetected && result.labels.isEmpty) {
      return _buildNoFoodFound(isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: result.isFoodDetected
                ? AppColors.success.withOpacity(0.15)
                : AppColors.warning.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result.isFoodDetected
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                size: 16,
                color: result.isFoodDetected
                    ? AppColors.success
                    : AppColors.warning,
              ),
              const SizedBox(width: 6),
              Text(
                result.isFoodDetected
                    ? 'Makanan Terdeteksi!'
                    : 'Terdeteksi (kepercayaan rendah)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Nunito',
                  color: result.isFoodDetected
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Hasil Deteksi On-Device',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'Nunito',
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Diproses langsung di HP — tidak ada data dikirim ke server',
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Nunito',
            color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
          ),
        ),

        const SizedBox(height: 12),

        ...result.labels.map((label) => _LabelCard(
              label: label,
              isDark: isDark,
            )),
      ],
    );
  }

  Widget _buildNoFoodFound(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('🔍', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            'Makanan tidak terdeteksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Nunito',
              color: isDark ? AppColors.textPrimary : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba foto dengan pencahayaan lebih baik atau jarak lebih dekat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Nunito',
              color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Nunito',
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabelCard extends StatelessWidget {
  final FoodLabelItem label;
  final bool isDark;

  const _LabelCard({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pct = label.confidence;
    final barColor = pct > 0.7
        ? AppColors.success
        : pct > 0.5
            ? AppColors.warning
            : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.indonesianName ?? label.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Nunito',
                        color: isDark ? AppColors.textPrimary : AppColors.textLight,
                      ),
                    ),
                    if (label.indonesianName != null)
                      Text(
                        label.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Nunito',
                          color: isDark ? AppColors.textMuted : AppColors.textLightSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${(pct * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Nunito',
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor:
                  isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 6,
            ),
          ),
          if (label.nutritionHint != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 13, color: AppColors.info),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label.nutritionHint!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'Nunito',
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
