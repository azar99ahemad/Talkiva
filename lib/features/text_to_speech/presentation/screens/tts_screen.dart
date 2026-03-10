import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/tts_provider.dart';

class TTSScreen extends StatefulWidget {
  const TTSScreen({super.key});

  @override
  State<TTSScreen> createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TTSProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.ttsTitle,
        showBackButton: true,
      ),
      body: Consumer<TTSProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text input
                TextField(
                  controller: _textController,
                  maxLines: 6,
                  minLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: AppStrings.enterText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: provider.updateText,
                ),
                const SizedBox(height: 16),

                // Play / Pause / Stop
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlButton(
                      icon: Icons.play_arrow,
                      label: AppStrings.play,
                      onPressed: provider.inputText.isEmpty || provider.isSpeaking
                          ? null
                          : provider.speak,
                    ),
                    const SizedBox(width: 12),
                    _controlButton(
                      icon: Icons.pause,
                      label: AppStrings.pause,
                      onPressed: provider.isSpeaking ? provider.pause : null,
                    ),
                    const SizedBox(width: 12),
                    _controlButton(
                      icon: Icons.stop,
                      label: AppStrings.stop,
                      onPressed:
                          provider.isSpeaking || provider.isPaused
                              ? provider.stop
                              : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Speed selector
                const Text(
                  AppStrings.speed,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildSpeedChips(provider),
                const SizedBox(height: 16),

                // Language dropdown
                const Text(
                  AppStrings.selectLanguage,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildLanguageDropdown(provider),
                const SizedBox(height: 16),

                // Pitch slider
                Row(
                  children: [
                    const Text(
                      AppStrings.pitch,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(provider.pitch.toStringAsFixed(1)),
                  ],
                ),
                Slider(
                  value: provider.pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  onChanged: provider.setPitch,
                ),
                const SizedBox(height: 8),

                // Volume slider
                Row(
                  children: [
                    const Text(
                      AppStrings.volume,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const Spacer(),
                    Text('${(provider.volume * 100).toStringAsFixed(0)}%'),
                  ],
                ),
                Slider(
                  value: provider.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: provider.setVolume,
                ),

                // Voice selector
                if (provider.availableVoices.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.selectVoice,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _buildVoiceDropdown(provider),
                ],

                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _buildSpeedChips(TTSProvider provider) {
    final speeds = {
      AppStrings.slow: 0.25,
      AppStrings.normal: 0.5,
      AppStrings.fast: 1.0,
    };
    return Wrap(
      spacing: 8,
      children: speeds.entries.map((e) {
        final selected = (provider.speechRate - e.value).abs() < 0.01;
        return ChoiceChip(
          label: Text(e.key),
          selected: selected,
          onSelected: (_) => provider.setSpeechRate(e.value),
        );
      }).toList(),
    );
  }

  Widget _buildLanguageDropdown(TTSProvider provider) {
    const languages = ['en-US', 'en-GB'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: provider.selectedLanguage,
            isExpanded: true,
            items: languages
                .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                .toList(),
            onChanged: (val) {
              if (val != null) provider.setLanguage(val);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceDropdown(TTSProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: provider.selectedVoice,
            isExpanded: true,
            hint: const Text('Select voice'),
            items: provider.availableVoices
                .map((v) => DropdownMenuItem<String>(
                      value: v.toString(),
                      child: Text(v.toString()),
                    ))
                .toList(),
            onChanged: provider.setVoice,
          ),
        ),
      ),
    );
  }
}
