import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBubble extends StatefulWidget {
  final String text;
  final bool isUser;

  const GlassBubble({super.key, required this.text, required this.isUser});

  @override
  State<GlassBubble> createState() => _GlassBubbleState();
}

class _GlassBubbleState extends State<GlassBubble> {
  String _displayedText = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.isUser) {
      _displayedText = widget.text;
    } else {
      _startTypewriter();
    }
  }

  void _startTypewriter() {
    int index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (index < widget.text.length) {
        if (mounted) {
          setState(() {
            _displayedText += widget.text[index];
            index++;
          });
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: widget.isUser 
                ? Colors.cyan.withOpacity(0.2) 
                : Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.cyan.withOpacity(0.2)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(widget.isUser ? 20 : 0),
                bottomRight: Radius.circular(widget.isUser ? 0 : 20),
              ),
            ),
            child: Text(
              _displayedText, 
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}