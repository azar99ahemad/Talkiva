import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/animated_mic_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/stt_provider.dart';

class STTScreen extends StatefulWidget {
  const STTScreen({super.key});

  @override
  State<STTScreen> createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<STTProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.sttTitle,
        showBackButton: true,
      ),
      body: Consumer<STTProvider>(
        builder: (context, provider, _) {
          if (provider.errorMessage != null && !provider.isAvailable) {
            return _buildErrorState(context, provider);
          }
          return _buildMainContent(context, provider);
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, STTProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_off, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? AppStrings.sttError,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => provider.initialize(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, STTProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Language selector
          _buildLanguageDropdown(provider),
          const SizedBox(height: 16),

          // Recognized text card
          Card(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 150),
              padding: const EdgeInsets.all(16),
              child: Text(
                provider.recognizedText.isEmpty
                    ? AppStrings.tapToSpeak
                    : provider.recognizedText,
                style: TextStyle(
                  fontSize: 18,
                  color: provider.recognizedText.isEmpty
                      ? Colors.grey
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confidence score
          if (provider.confidenceScore > 0) ...[
            Row(
              children: [
                const Text(AppStrings.confidence),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: provider.confidenceScore,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      provider.confidenceScore >= 0.8
                          ? AppColors.success
                          : provider.confidenceScore >= 0.5
                              ? AppColors.warning
                              : AppColors.error,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(provider.confidenceScore * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 24),

          // Mic button
          AnimatedMicButton(
            isListening: provider.isListening,
            onPressed: () {
              if (provider.isListening) {
                provider.stopListening();
              } else {
                provider.startListening();
              }
            },
            enabled: provider.isAvailable,
          ),
          const SizedBox(height: 8),
          Text(
            provider.isListening
                ? AppStrings.listeningStatus
                : AppStrings.notListening,
            style: TextStyle(
              color: provider.isListening ? AppColors.primary : Colors.grey,
              fontWeight: provider.isListening
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16),

          // Clear button
          OutlinedButton.icon(
            onPressed: provider.recognizedText.isEmpty
                ? null
                : provider.clearText,
            icon: const Icon(Icons.clear),
            label: const Text(AppStrings.clearText),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(STTProvider provider) {
    const locales = {
      'en_US': 'English (US)',
      'en_GB': 'English (UK)',
      'en_AU': 'English (Australia)',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: provider.selectedLocale,
            isExpanded: true,
            hint: const Text(AppStrings.selectLanguage),
            items: locales.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) provider.setLocale(val);
            },
          ),
        ),
      ),
    );
  }
}
