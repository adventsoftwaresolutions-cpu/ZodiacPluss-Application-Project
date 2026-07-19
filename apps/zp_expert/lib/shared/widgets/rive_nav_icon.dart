import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../constants/app_assets.dart';

class RiveNavIconController {
  VoidCallback? _playCallback;

  void play() => _playCallback?.call();
}

class RiveNavIcon extends StatefulWidget {
  const RiveNavIcon({
    required this.artboard,
    required this.stateMachineName,
    required this.color,
    required this.controller,
    super.key,
  });

  final String artboard;
  final String stateMachineName;
  final Color color;
  final RiveNavIconController controller;

  @override
  State<RiveNavIcon> createState() => _RiveNavIconState();
}

class _RiveNavIconState extends State<RiveNavIcon> {
  static Future<void>? _riveInitialization;
  static FileLoader? _fileLoader;
  static _RiveNavIconState? _playingIcon;

  ViewModelInstance? _viewModelInstance;
  Timer? _animationTimer;
  bool _isInitialized = false;
  bool _playWhenLoaded = false;

  late final VoidCallback _playCallback = play;

  @override
  void initState() {
    super.initState();
    widget.controller._playCallback = _playCallback;
    _initialize();
  }

  @override
  void didUpdateWidget(covariant RiveNavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller._playCallback == _playCallback) {
        oldWidget.controller._playCallback = null;
      }
      widget.controller._playCallback = _playCallback;
    }
    if (oldWidget.color != widget.color) {
      _applyAppearance();
    }
  }

  Future<void> _initialize() async {
    await (_riveInitialization ??= RiveNative.init());
    _fileLoader ??= FileLoader.fromAsset(
      AppAssets.navIconAnimation,
      riveFactory: Factory.flutter,
    );

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  void _applyAppearance() {
    _viewModelInstance?.color('color')?.value = widget.color;
    _viewModelInstance?.number('strokeWidth')?.value = 5;
  }

  void play() {
    if (!identical(_playingIcon, this)) {
      _playingIcon?._stop();
      _playingIcon = this;
    }

    _animationTimer?.cancel();
    final active = _viewModelInstance?.boolean('active');
    if (active == null) {
      _playWhenLoaded = true;
      return;
    }

    _playWhenLoaded = false;
    active.value = false;
    active.value = true;
    _animationTimer = Timer(const Duration(seconds: 1), _stop);
  }

  void _stop() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _playWhenLoaded = false;
    _viewModelInstance?.boolean('active')?.value = false;

    if (identical(_playingIcon, this)) {
      _playingIcon = null;
    }
  }

  @override
  void dispose() {
    if (widget.controller._playCallback == _playCallback) {
      widget.controller._playCallback = null;
    }
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.square(dimension: 26);
    }

    return SizedBox.square(
      dimension: 26,
      child: IgnorePointer(
        child: RiveWidgetBuilder(
          fileLoader: _fileLoader!,
          artboardSelector: ArtboardNamed(widget.artboard),
          stateMachineSelector: StateMachineNamed(widget.stateMachineName),
          dataBind: DataBind.auto(),
          onFailed: (Object error, StackTrace stackTrace) {
            debugPrint('Unable to load navbar Rive icon: $error');
          },
          onLoaded: (state) {
            _viewModelInstance = state.viewModelInstance;
            _applyAppearance();
            _viewModelInstance?.boolean('active')?.value = false;
            if (_playWhenLoaded) {
              play();
            }
          },
          builder: (BuildContext context, state) {
            return switch (state) {
              RiveLoaded(:final controller) => RiveWidget(
                  controller: controller,
                  fit: Fit.contain,
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
