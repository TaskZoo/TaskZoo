import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:number_precision/number_precision.dart';
import 'package:taskzoo/misc/theme_notifier.dart';

class WidgetsBindingx {
  static WidgetsBinding? get instance => WidgetsBinding.instance;
}

typedef String FormatValue(String value);

typedef Widget AnimatedSingleWidgetBuilder(
  Size size,
  String value,
  bool isNumber,
  Widget child,
);

typedef TextStyle ValueChangeTextStyle(TextStyle style);

typedef bool ValueColorCondition();

class ValueColor {
  ValueColorCondition condition;

  Color color;

  ValueColor({
    required this.condition,
    required this.color,
  });
}

class SingleDigitData {
  Size? size;

  List<ValueColor>? valueColors;

  bool prefixAndSuffixFollowValueColor;

  AnimatedSingleWidgetBuilder? builder;

  bool useTextSize;

  SingleDigitData({
    this.size,
    this.useTextSize = false,
    this.valueColors,
    this.prefixAndSuffixFollowValueColor = true,
    this.builder,
  });

  Widget? _buildChangeTextColorWidget(
    String val,
    TextStyle textStyle, [
    Key? key,
  ]) {
    final vc = _getLastValidValueColor();
    if (vc == null) return null;
    return Text(val, key: key, style: textStyle.copyWith(color: vc.color));
  }

  ValueColor? _getLastValidValueColor() {
    ValueColor? result;
    if (valueColors == null) return null;
    for (var vc in valueColors!) {
      if (vc.condition()) {
        result = vc;
      }
    }
    return result;
  }
}

class SingleDigitProvider extends InheritedWidget {
  const SingleDigitProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final SingleDigitData data;

  static SingleDigitData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SingleDigitProvider>()!
        .data;
  }

  static SingleDigitData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SingleDigitProvider>()
        ?.data;
  }

  @override
  bool updateShouldNotify(SingleDigitProvider oldWidget) {
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<SingleDigitData>('data', data, showName: false));
  }
}

class AnimatedDigitController extends ValueNotifier<num> {
  AnimatedDigitController(num initialValue) : super(initialValue);

  bool _dispose = false;
  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  void addValue(num newValue) {
    if (!_dispose) {
      value = NP.plus(value, newValue);
    }
  }

  void minusValue(num newValue) {
    if (!_dispose) {
      value = NP.minus(value, newValue);
    }
  }

  void timesValue(num newValue) {
    if (!_dispose) {
      value = NP.times(value, newValue);
    }
  }

  void divideValue(num newValue) {
    if (!_dispose) {
      value = NP.divide(value, newValue);
    }
  }

  void resetValue(num newValue) {
    if (!_dispose) {
      value = newValue;
    }
  }
}

class CustomAnimatedDigitWidget extends StatefulWidget {
  final AnimatedDigitController? controller;
  final num? value;
  late final TextStyle? _textStyle;
  final Duration duration;
  final Curve curve;
  final BoxDecoration? boxDecoration;
  final int fractionDigits;
  final bool enableSeparator;
  final String? separateSymbol;
  final int separateLength;
  final String decimalSeparator;
  final String? prefix;
  final String? suffix;
  final bool loop;
  final bool autoSize;
  final bool animateAutoSize;
  final List<ValueColor>? valueColors;
  Color textColor;
  final int textSize;
  ThemeNotifier themeNotifier;
  CustomAnimatedDigitWidget(
      {Key? key,
      TextStyle? textStyle,
      this.controller,
      this.value,
      this.duration = const Duration(milliseconds: 300),
      this.curve = Curves.easeInOut,
      this.boxDecoration,
      this.fractionDigits = 0,
      this.enableSeparator = false,
      this.separateSymbol = ",",
      this.separateLength = 3,
      this.decimalSeparator = '.',
      this.prefix,
      this.suffix,
      this.loop = true,
      this.autoSize = true,
      this.animateAutoSize = true,
      this.valueColors,
      required this.textColor,
      required this.themeNotifier,
      this.textSize = 16})
      : assert(separateLength >= 1,
            "@separateLength at least greater than or equal to 1"),
        assert(!(value == null && controller == null),
            "the @value & @controller cannot be null at the same time"),
        super(key: key) {
    if (themeNotifier.currentTheme == ThemeMode.light) {
      _textStyle =
          TextStyle(color: Colors.white, fontSize: textSize.toDouble());
      textColor = Colors.black;
    } else {
      _textStyle =
          TextStyle(color: Colors.white, fontSize: textSize.toDouble());
      textColor = Colors.white;
    }
  }

  @override
  _CustomAnimatedDigitWidgetState createState() {
    return _CustomAnimatedDigitWidgetState();
  }
}

class _CustomAnimatedDigitWidgetState extends State<CustomAnimatedDigitWidget>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;
  SingleDigitData? _singleDigitData;
  bool _dirty = false;
  Color previousColor = Colors.black;

  late TextStyle style;

  num get currentValue => widget.controller?.value ?? widget.value!;

  final List<_AnimatedSingleWidget> _widgets = [];

  num _value = 0.0;

  num get value => _value;

  set value(num newValue) {
    _value = newValue;
    if (mounted) {
      setState(() {});
    }
  }

  bool get isNegative => _value.isNegative;

  @override
  void initState() {
    super.initState();
    WidgetsBindingx.instance?.addObserver(this);
    widget.controller?.addListener(_updateValue);
    widget.themeNotifier.addListener(_onThemeChanged);

    value = currentValue;

    style = TextStyle(
      color: widget.textColor,
      fontSize: widget.textSize.toDouble(),
    );

    if (previousColor != widget.textColor) {
      previousColor = widget.textColor;
    }
  }

  void _onThemeChanged() {
    setState(() {
      // Update properties based on the new theme value
      _markNeedRebuild();
      if (widget.themeNotifier.currentTheme == ThemeMode.light) {
        widget.textColor = Colors.black;
      } else {
        widget.textColor = Colors.white;
      }
    });
  }

  String _getFormatValueAsString() {
    return _formatNum(
      _value.toString(),
      fractionDigits: widget.fractionDigits,
    );
  }

  void _updateValue() {
    value = currentValue;
  }

  void _markNeedRebuild() {
    _widgets.clear();
    _dirty = true;
    _updateValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mq = MediaQuery.maybeOf(context);
    final sdp = SingleDigitProvider.maybeOf(context);
    if (_mediaQueryData != mq || _singleDigitData != sdp) {
      _markNeedRebuild();
    }
    _mediaQueryData = mq;
    _singleDigitData = sdp;
  }

  @override
  void reassemble() {
    super.reassemble();
    _markNeedRebuild();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    _markNeedRebuild();
  }

  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
    _markNeedRebuild();
  }

  String _formatNum(String numstr, {int fractionDigits = 2}) {
    String result;
    final String _numstr = isNegative ? numstr.replaceFirst("-", "") : numstr;
    final List<String> numSplitArr = num.parse(_numstr).toString().split('.');
    if (numSplitArr.length < 2) {
      numSplitArr.add("".padRight(fractionDigits, '0'));
    }
    if (!widget.enableSeparator && fractionDigits < 1) {
      result = numSplitArr.first;
    }
    final List<String> digitList =
        List.from(numSplitArr.first.characters, growable: false);
    if (widget.enableSeparator) {
      int len = digitList.length - 1;
      final separateSymbol = widget.separateSymbol ?? "";
      if (separateSymbol.isNotEmpty) {
        for (int index = 0, i = len; i >= 0; index++, i--)
          if (index % widget.separateLength == 0 && i != len)
            digitList[i] += separateSymbol;
      }
    }

    if (fractionDigits > 0) {
      List<String> fractionList = List.from(numSplitArr.last.characters);
      if (fractionList.length > fractionDigits) {
        fractionList =
            fractionList.take(fractionDigits).toList(growable: false);
      } else {
        final padRightLen = fractionDigits - fractionList.length;

        fractionList.addAll(List.generate(padRightLen, (index) => "0"));
      }
      final strbuff = StringBuffer()
        ..writeAll(digitList)
        ..write(widget.decimalSeparator)
        ..writeAll(fractionList);
      result = strbuff.toString();
    } else {
      result = digitList.join('');
    }

    return result;
  }

  @override
  void didUpdateWidget(CustomAnimatedDigitWidget oldWidget) {
    widget.controller?.removeListener(_updateValue);
    super.didUpdateWidget(oldWidget);
    widget.controller?.addListener(_updateValue);
    if (widget.controller == null) {
      _updateValue();
    }
  }

  @override
  void dispose() {
    WidgetsBindingx.instance?.removeObserver(this);
    widget.controller?.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.valueColors != null) {
      _singleDigitData = SingleDigitData(
        useTextSize: true,
        valueColors: widget.valueColors,
      );
    }

    if (_dirty) {
      _rebuild();
    } else {
      _update();
    }
    _dirty = false;

    if (_singleDigitData != null) {
      return SingleDigitProvider(
        data: _singleDigitData!,
        child: _build(),
      );
    }

    return _build();
  }

  Widget _build() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefix != null) _buildChangeTextColorWidget(widget.prefix!),
        _buildNegativeSymbol(),
        ..._widgets,
        if (widget.suffix != null) _buildChangeTextColorWidget(widget.suffix!),
      ],
    );
  }

  Widget _buildChangeTextColorWidget(String val) {
    Widget result = Text(val, style: style);
    final sdd = _singleDigitData;
    if (sdd == null || !sdd.prefixAndSuffixFollowValueColor) return result;
    return sdd._buildChangeTextColorWidget(val, style) ?? result;
  }

  void _rebuild([String? value]) {
    _widgets.clear();
    String newValue = value ?? _getFormatValueAsString();
    for (var i = 0; i < newValue.length; i++) {
      _addAnimatedSingleWidget(newValue[i]);
    }
  }

  void _update() {
    String newValue = _getFormatValueAsString();
    final int lenNew = newValue.length;
    final int lenOld = _widgets.length;
    if (value == 0 || lenNew == lenOld) {
      if (lenNew < lenOld) {
        _widgets.removeRange(
            lenNew - 1,
            (lenOld - lenNew) +
                widget.fractionDigits +
                (widget.fractionDigits > 0 ? 1 : 0));
      }
      for (var i = 0; i < (lenNew == 0 ? 1 : lenNew); i++) {
        final String curr = newValue[i];
        _setValue(_widgets[i].key, curr);
      }
    } else {
      _rebuild(newValue);
    }
  }

  Widget _buildNegativeSymbol() {
    final String symbolKey = "_AdwChildSymbol";
    Widget secondChild = _singleDigitData?._buildChangeTextColorWidget(
            "-", style, ValueKey(symbolKey)) ??
        Text("-", key: ValueKey(symbolKey), style: style);
    return AnimatedCrossFade(
      key: ValueKey("_AdwAnimaNegativeSymbol"),
      firstChild: Text("", key: ValueKey(symbolKey), style: style),
      secondChild: secondChild,
      sizeCurve: widget.curve,
      firstCurve: widget.curve,
      secondCurve: widget.curve,
      duration: widget.duration,
      reverseDuration: widget.duration,
      crossFadeState:
          isNegative ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  void _setValue(Key? _aswsKey, String value) {
    assert(_aswsKey != null);
    if (_aswsKey is GlobalKey<_AnimatedSingleWidgetState>) {
      _aswsKey.currentState?.setValue(value);
    }
  }

  void _addAnimatedSingleWidget(String value) {
    _widgets.add(_buildSingleWidget(value));
  }

  _AnimatedSingleWidget _buildSingleWidget(String value) {
    TextStyle textStyle = TextStyle(
        color: widget.textColor, fontSize: widget.textSize.toDouble());
    return _AnimatedSingleWidget(
      initialValue: value,
      textStyle: textStyle,
      boxDecoration: widget.boxDecoration,
      duration: widget.duration,
      curve: widget.curve,
      textScaleFactor: _mediaQueryData?.textScaleFactor,
      singleDigitData: _singleDigitData,
      loop: widget.loop,
      autoSize: widget.autoSize,
      animateAutoSize: widget.animateAutoSize,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', currentValue.toDouble()));
  }
}

class _AnimatedSingleWidget extends StatefulWidget {
  final TextStyle textStyle;

  final Duration duration;

  final Curve curve;

  final BoxDecoration? boxDecoration;

  final String initialValue;

  final double? textScaleFactor;

  final SingleDigitData? singleDigitData;

  final bool loop;

  final bool autoSize;

  final bool animateAutoSize;

  _AnimatedSingleWidget({
    required this.initialValue,
    required this.textStyle,
    required this.duration,
    required this.curve,
    this.boxDecoration,
    this.textScaleFactor,
    this.singleDigitData,
    this.loop = false,
    this.autoSize = false,
    this.animateAutoSize = false,
  }) : super(key: GlobalKey<_AnimatedSingleWidgetState>());

  @override
  State<StatefulWidget> createState() {
    return _AnimatedSingleWidgetState();
  }
}

class _AnimatedSingleWidgetState extends State<_AnimatedSingleWidget> {
  @override
  void initState() {
    super.initState();
    data = widget.singleDigitData;
    currentValue = widget.initialValue;
    _initSize();
    _animateTo();
  }

  SingleDigitData? data;

  bool get canAutoSize => data?.size == null;

  bool get loop => widget.loop;

  TextStyle get _textStyle => widget.textStyle;

  BoxDecoration? get _boxDecoration => widget.boxDecoration;

  Duration get _duration => widget.duration;

  Curve get _curve => widget.curve;

  late final ScrollController scrollController = ScrollController();

  Size valueSize = Size.zero;

  double scrollOffset = 0.0;

  String oldValue = "0";

  String _currentValue = "0";

  String get currentValue => _currentValue;

  set currentValue(String val) {
    oldValue = _currentValue;
    _currentValue = val;
    _checkValue();
    if (canAutoSize && widget.autoSize) {
      _initSize();
      setState(() {});
    }
  }

  void setValue(String newValue) {
    currentValue = newValue;
    _animateTo();
  }

  bool get isNumber => _isNumber;
  bool _isNumber = true;

  void _checkValue() {
    _isNumber = int.tryParse(_currentValue, radix: 10) != null;
  }

  Size _initSize() {
    if (widget.singleDigitData != null) {
      if (widget.singleDigitData!.size != null && !data!.useTextSize) {
        return valueSize = widget.singleDigitData!.size!;
      }
    }
    return valueSize = _getTextSize(currentValue);
  }

  Size _getTextSize(String text) {
    final window = WidgetsBindingx.instance?.window;
    final fontWeight = window?.accessibilityFeatures.boldText ?? false
        ? FontWeight.bold
        : _textStyle.fontWeight == FontWeight.bold
            ? FontWeight.bold
            : FontWeight.normal;
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: widget.autoSize ? text : (isNumber ? "0" : text),
        style: _textStyle.copyWith(fontWeight: fontWeight),
      ),
      textScaleFactor: widget.textScaleFactor ?? window?.textScaleFactor ?? 1.0,
    );
    painter.layout();
    return painter.size;
  }

  void _animateTo() {
    if (isNumber && oldValue != currentValue) {
      WidgetsBindingx.instance?.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          _scrollTo();
        }
      });
    }
  }

  Future<void> _scrollTo() async {
    _computeScrollOffset();
    await scrollController.animateTo(
      scrollOffset,
      duration: _duration,
      curve: _curve,
    );
  }

  void _computeScrollOffset() {
    final int? n = int.tryParse(currentValue);
    if (n == null) return;
    if (loop) {
      final int? c = int.tryParse(oldValue);
      if (c != null) {
        final value = c > n ? 10 - c + n : n - c;
        scrollOffset += value * valueSize.height;
      }
    } else {
      scrollOffset = n * valueSize.height;
    }
  }

  @override
  void dispose() {
    if (loop || isNumber) scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget child = Center(
      widthFactor: 1.0,
      child: _build(),
    );
    if (widget.autoSize && widget.animateAutoSize) {
      child = AnimatedContainer(
        width: valueSize.width,
        height: valueSize.height,
        decoration: _boxDecoration,
        child: child,
        duration: _duration,
      );
    } else {
      child = Container(
        width: valueSize.width,
        height: valueSize.height,
        decoration: _boxDecoration,
        child: child,
      );
    }
    return AbsorbPointer(
      absorbing: true,
      child: child,
    );
  }

  Widget _build() {
    if (isNumber) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: _buildDigitScrollContainer(),
      );
    }
    return _buildSingleWidget(currentValue);
  }

  Widget _buildDigitScrollContainer() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: loop ? null : 10,
      itemExtent: valueSize.height,
      itemBuilder: (_, i) {
        final val = loop ? i % 10 : i;
        return _buildSingleWidget(val.toString());
      },
    );
  }

  Widget defaultBuildSingleWidget(String val) {
    return Text(val, style: _textStyle);
  }

  Widget _buildSingleWidget(String val) {
    Widget child = defaultBuildSingleWidget(val);
    if (data == null) return child;
    final SingleDigitData sdd = data!;
    child = sdd._buildChangeTextColorWidget(val, _textStyle) ?? child;
    if (sdd.builder != null) {
      child = sdd.builder!(valueSize, val, isNumber, child);
    }
    if (!sdd.useTextSize && sdd.size != null) {
      child = SizedBox.fromSize(
        size: valueSize,
        child: child,
      );
    }
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}
