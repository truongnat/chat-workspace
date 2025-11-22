import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class DissolvingMessageBubble extends StatefulWidget {
  final String message;
  final String time;
  final bool isSent;
  final Duration destructTimer;
  final VoidCallback? onDestroyed;

  const DissolvingMessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isSent,
    this.destructTimer = const Duration(seconds: 10),
    this.onDestroyed,
  });

  @override
  State<DissolvingMessageBubble> createState() => _DissolvingMessageBubbleState();
}

class _DissolvingMessageBubbleState extends State<DissolvingMessageBubble> {
  bool _isDissolving = false;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.destructTimer.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds == 0) {
          setState(() => _isDissolving = true);
          Future.delayed(const Duration(milliseconds: 1500), () {
            widget.onDestroyed?.call();
          });
        }
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: widget.isSent ? AppColors.primaryGradient : null,
          color: widget.isSent ? null : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(widget.isSent ? 16 : 4),
            bottomRight: Radius.circular(widget.isSent ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.isSent ? Colors.white : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: widget.isSent
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.time,
                  style: TextStyle(
                    color: widget.isSent
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_remainingSeconds}s',
                  style: TextStyle(
                    color: _remainingSeconds <= 3
                        ? AppColors.error
                        : widget.isSent
                            ? Colors.white.withOpacity(0.7)
                            : AppColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate(target: _isDissolving ? 1 : 0)
          .fadeOut(duration: 800.ms, curve: Curves.easeInOut)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(0.8, 0.8),
            duration: 800.ms,
            curve: Curves.easeInOut,
          )
          .blur(
            begin: const Offset(0, 0),
            end: const Offset(10, 10),
            duration: 800.ms,
          ),
    );
  }
}
