import 'package:flutter/material.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:get_it/get_it.dart';

const _radius = Radius.circular(4);
const _borderRadius = BorderRadius.all(_radius);
const _height = 36.0;
final _defaultBackgroundColour = Colors.white.withOpacity(0.1);
final _queueService = GetIt.instance<QueueService>();

class PresetChips extends StatefulWidget {
  const PresetChips({
    Key? key,
    required this.type,
    required this.values,
    required this.activeValue,
    this.onTap,
    this.mainColour,
    this.onPressed,
  }) : super(key: key);

  // for future preset types other than "speed"
  final String type;

  final List<double> values;
  final double activeValue;
  final Function()? onTap;
  final Color? mainColour; // used for different background colours
  final Function()? onPressed;

  @override
  State<PresetChips> createState() => _PresetChipsState();
}

class _PresetChipsState extends State<PresetChips> {
  @override
  Widget build(BuildContext context) {
    var nowActiveValue = widget.activeValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(widget.values.length, (index) {
            final currentValue = widget.values[index];
            var newValue = "x$currentValue";

            return PresetChip(
              value: newValue,
              backgroundColour: currentValue == nowActiveValue
                  ? widget.mainColour?.withOpacity(0.4)
                  : widget.mainColour?.withOpacity(0.1),
              isTextBold: currentValue == 1.0,
              width: 55.0,
              onTap: () {
                setState(() {
                  nowActiveValue = currentValue;
                });
                _queueService.setPlaybackSpeed(currentValue);
                widget.onPressed!();
              },
            );
          }),
        ),
      ),
    );
  }
}

class PresetChip extends StatelessWidget {
  const PresetChip({
    Key? key,
    required this.width,
    this.value = "",
    this.onTap,
    this.backgroundColour,
    this.isTextBold,
  }) : super(key: key);

  final double width;
  final String value;
  final void Function()? onTap;
  final Color? backgroundColour;
  final bool? isTextBold;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = backgroundColour ?? _defaultBackgroundColour;
    final color = Theme.of(context).textTheme.bodySmall?.color ?? Colors.white;

    return SizedBox(
      width: width,
      height: _height,
      child: Material(
        color: backgroundColor,
        borderRadius: _borderRadius,
        child: InkWell(
            onTap: onTap,
            borderRadius: _borderRadius,
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                    color: color,
                    overflow: TextOverflow.ellipsis,
                    fontWeight:
                        isTextBold! ? FontWeight.w700 : FontWeight.normal),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
    );
  }
}
