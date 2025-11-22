import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_colors.dart';

class VideoCallScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  const VideoCallScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOn = true;
  bool _isSpeakerOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote video (full screen)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.background.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.contactName[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.contactName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connecting...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Local video preview (top right)
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.electricBlue, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: AppColors.surfaceLight,
                  child: const Center(
                    child: Icon(
                      LucideIcons.user,
                      color: AppColors.textTertiary,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.white,
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    '00:00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.userPlus),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? LucideIcons.micOff : LucideIcons.mic,
                    onPressed: () => setState(() => _isMuted = !_isMuted),
                    isActive: !_isMuted,
                  ),
                  _buildControlButton(
                    icon: _isCameraOn ? LucideIcons.video : LucideIcons.videoOff,
                    onPressed: () => setState(() => _isCameraOn = !_isCameraOn),
                    isActive: _isCameraOn,
                  ),
                  _buildControlButton(
                    icon: LucideIcons.phoneOff,
                    onPressed: () => context.pop(),
                    isActive: false,
                    isEndCall: true,
                  ),
                  _buildControlButton(
                    icon: _isSpeakerOn ? LucideIcons.volume2 : LucideIcons.volumeX,
                    onPressed: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                    isActive: _isSpeakerOn,
                  ),
                  _buildControlButton(
                    icon: LucideIcons.moreVertical,
                    onPressed: () {},
                    isActive: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    bool isEndCall = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isEndCall
            ? AppColors.error
            : isActive
                ? AppColors.surface
                : AppColors.surfaceLight,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: isEndCall
            ? Colors.white
            : isActive
                ? Colors.white
                : AppColors.textTertiary,
        iconSize: 28,
        onPressed: onPressed,
      ),
    );
  }
}
