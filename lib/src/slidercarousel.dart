import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidercarousel/flutter_slidercarousel.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
part 'custom_layout.dart';

typedef void SliderCarouselOnTap(int index);

typedef Widget SliderCarouselDataBuilder(BuildContext context, dynamic data, int index);

/// default auto play
const int defaultAutoplayDelayMs = 3000;

///  Default auto play transition duration (in millisecond)
const int defaultAutoplayTransactionDuration = 300;


class SliderCarousel extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final double offsetCenter;
  final double scaleCenter;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ValueChanged<int> onIndexChanged;
  final bool autoplay;
  final int autoplayDelay;
  final bool autoplayDisableOnInteraction;
  final int duration;
  final Axis scrollDirection;
  final Curve curve;
  final bool loop;
  final int index;
  final SliderCarouselController controller;
  final SliderCarouselOnTap onTap;

  SliderCarousel({
    Key key,
    this.curve: Curves.ease,
    this.duration: defaultAutoplayTransactionDuration,
    this.controller,
    this.onIndexChanged,
    this.itemHeight,
    this.itemWidth,
    this.itemBuilder,
    this.index,
    this.loop: true,
    this.autoplay: false,
    this.autoplayDelay: defaultAutoplayDelayMs,
    this.autoplayDisableOnInteraction: true,
    @required this.itemCount,
    this.scrollDirection: Axis.horizontal,
    this.offsetCenter = 0.75,
    this.scaleCenter = 1.25,
    this.onTap,
  })  : super(key: key);

  factory SliderCarousel.children({
    List<Widget> children,
    bool autoplay: false,
    int autoplayDelay: defaultAutoplayDelayMs,
    bool autoplayDisableOnInteraction: true,
    int duration: defaultAutoplayTransactionDuration,
    ValueChanged<int> onIndexChanged,
    int index,
    bool loop: true,
    Curve curve: Curves.ease,
    Axis scrollDirection: Axis.horizontal,
    SliderCarouselController controller,
    Key key,
    double itemHeight,
    double itemWidth,
    double offsetCenter,
    double scaleCenter,
    SliderCarouselOnTap onTap,
  }) {
    assert(children != null, "children must not be null");

    return new SliderCarousel(
        itemHeight: itemHeight,
        itemWidth: itemWidth,
        autoplay: autoplay,
        autoplayDelay: autoplayDelay,
        autoplayDisableOnInteraction: autoplayDisableOnInteraction,
        duration: duration,
        onIndexChanged: onIndexChanged,
        index: index,
        curve: curve,
        scrollDirection: scrollDirection,
        controller: controller,
        loop: loop,
        key: key,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
        offsetCenter: offsetCenter,
        scaleCenter: scaleCenter,
        onTap: onTap,
        itemCount: children.length);
  }

  factory SliderCarousel.list({
    List list,
    CustomLayoutOption customLayoutOption,
    SliderCarouselDataBuilder builder,
    bool autoplay: false,
    int autoplayDelay: defaultAutoplayDelayMs,
    bool reverse: false,
    bool autoplayDisableOnInteraction: true,
    int duration: defaultAutoplayTransactionDuration,
    ValueChanged<int> onIndexChanged,
    int index,
    bool loop: true,
    Curve curve: Curves.ease,
    Axis scrollDirection: Axis.horizontal,
    SliderCarouselController controller,
    Key key,
    double itemHeight,
    double itemWidth,
    double offsetCenter,
    double scaleCenter,
    SliderCarouselOnTap onTap,
  }) {
    return new SliderCarousel(
        itemHeight: itemHeight,
        itemWidth: itemWidth,
        autoplay: autoplay,
        autoplayDelay: autoplayDelay,
        autoplayDisableOnInteraction: autoplayDisableOnInteraction,
        duration: duration,
        onIndexChanged: onIndexChanged,
        index: index,
        curve: curve,
        key: key,
        scrollDirection: scrollDirection,
        controller: controller,
        loop: loop,
        itemBuilder: (BuildContext context, int index) {
          return builder(context, list[index], index);
        },
        offsetCenter: offsetCenter,
        scaleCenter: scaleCenter,
        onTap: onTap,
        itemCount: list.length);
  }

  @override
  State<StatefulWidget> createState() {
    return new _SliderCarouselState();
  }
}

abstract class _SliderCarouselTimerMixin extends State<SliderCarousel> {
  Timer _timer;

  SliderCarouselController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    if (_controller == null) {
      _controller = new SliderCarouselController();
    }
    _controller.addListener(_onController);
    _handleAutoplay();
    super.initState();
  }

  void _onController() {
    switch (_controller.event) {
      case SliderCarouselController.START_AUTOPLAY:
        {
          if (_timer == null) {
            _startAutoplay();
          }
        }
        break;
      case SliderCarouselController.STOP_AUTOPLAY:
        {
          if (_timer != null) {
            _stopAutoplay();
          }
        }
        break;
    }
  }

  @override
  void didUpdateWidget(SliderCarousel oldWidget) {
    if (_controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller.removeListener(_onController);
        _controller = oldWidget.controller;
        _controller.addListener(_onController);
      }
    }
    _handleAutoplay();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.removeListener(_onController);
      //  _controller.dispose();
    }

    _stopAutoplay();
    super.dispose();
  }

  bool _autoplayEnabled() {
    return _controller.autoplay ?? widget.autoplay;
  }

  void _handleAutoplay() {
    if (_autoplayEnabled() && _timer != null) return;
    _stopAutoplay();
    if (_autoplayEnabled()) {
      _startAutoplay();
    }
  }

  void _startAutoplay() {
    assert(_timer == null, "Timer must be stopped before start!");
    _timer =
        Timer.periodic(Duration(milliseconds: widget.autoplayDelay), _onTimer);
  }

  void _onTimer(Timer timer) {
    _controller.next(animation: true);
  }

  void _stopAutoplay() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}

class _SliderCarouselState extends _SliderCarouselTimerMixin {
  int _activeIndex;

  TransformerPageController _pageController;

  Widget _wrapTap(BuildContext context, int index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        this.widget.onTap(index);
      },
      child: widget.itemBuilder(context, index),
    );
  }

  @override
  void initState() {
    _activeIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SliderCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    scheduleMicrotask(() {
      // So that we have a chance to do `removeListener` in child widgets.
      if (_pageController != null) {
        _pageController.dispose();
        _pageController = null;
      }
    });
    if (widget.index != null && widget.index != _activeIndex) {
      _activeIndex = widget.index;
    }
  }

  void _onIndexChanged(int index) {
    setState(() {
      _activeIndex = index;
    });
    if (widget.onIndexChanged != null) {
      widget.onIndexChanged(index);
    }
  }

  Widget _buildSliderCarousel() {
    IndexedWidgetBuilder itemBuilder;

    if (widget.onTap != null) {
      itemBuilder = _wrapTap;
    } else {
      itemBuilder = widget.itemBuilder;
    }
    return new _StackSliderCarousel(
      loop: widget.loop,
      itemWidth: widget.itemWidth,
      itemHeight: widget.itemHeight,
      itemCount: widget.itemCount,
      itemBuilder: itemBuilder,
      index: _activeIndex,
      curve: widget.curve,
      duration: widget.duration,
      onIndexChanged: _onIndexChanged,
      controller: _controller,
      scrollDirection: widget.scrollDirection,
      offsetCenter: widget.offsetCenter,
      scaleCenter: widget.scaleCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget sliderCarousel = _buildSliderCarousel();
    List<Widget> listForStack;
    if (listForStack != null) {
      return new Stack(
        children: listForStack,
      );
    }

    return sliderCarousel;
  }

}

abstract class _SubSliderCarousel extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final SliderCarouselController controller;
  final int duration;
  final Curve curve;
  final double itemWidth;
  final double itemHeight;
  final double offsetCenter;
  final double scaleCenter;
  final bool loop;
  final Axis scrollDirection;

  _SubSliderCarousel(
      {Key key,
      this.loop,
      this.itemHeight,
      this.itemWidth,
      this.duration,
      this.curve,
      this.itemBuilder,
      this.controller,
      this.index,
      this.itemCount,
      this.scrollDirection: Axis.horizontal,
      this.offsetCenter,
      this.scaleCenter,
      this.onIndexChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState();

  int getCorrectIndex(int indexNeedsFix) {
    if (itemCount == 0) return 0;
    int value = indexNeedsFix % itemCount;
    if (value < 0) {
      value += itemCount;
    }
    return value;
  }
}

class _StackSliderCarousel extends _SubSliderCarousel {
  _StackSliderCarousel({
    Key key,
    Curve curve,
    int duration,
    SliderCarouselController controller,
    ValueChanged<int> onIndexChanged,
    double itemHeight,
    double itemWidth,
    IndexedWidgetBuilder itemBuilder,
    int index,
    bool loop,
    int itemCount,
    Axis scrollDirection,
    double offsetCenter,
    double scaleCenter,
  }) : super(
            loop: loop,
            key: key,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            itemBuilder: itemBuilder,
            curve: curve,
            duration: duration,
            controller: controller,
            index: index,
            onIndexChanged: onIndexChanged,
            itemCount: itemCount,
            offsetCenter: offsetCenter,
            scaleCenter: scaleCenter,
            scrollDirection: scrollDirection);

  @override
  State<StatefulWidget> createState() {
    return new _StackViewState();
  }
}

class _StackViewState extends _CustomLayoutStateBase<_StackSliderCarousel> {
  List<double> scales;
  List<double> offsets;
  List<double> opacity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _updateValues() {
    if (widget.scrollDirection == Axis.horizontal) {
      double space = (_sliderWidth - widget.itemWidth) / 2;
      double spaceItem = scales[3]>1?(widget.itemWidth*(scales[3]-1))/2:0;
      offsets = [-space, space*widget.offsetCenter, -space*widget.offsetCenter, -spaceItem, _sliderWidth];
    } else {
      double space = (_sliderHeight - widget.itemHeight) / 2;
      double spaceItem = scales[3]>1?(widget.itemHeight*(scales[3]-1))/2:0;
      offsets = [-space, space*widget.offsetCenter, -space*widget.offsetCenter, -spaceItem, _sliderHeight];
    }
  }

  @override
  void didUpdateWidget(_StackSliderCarousel oldWidget) {
    _updateValues();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void afterRender() {
    super.afterRender();
    //length of the values array below
    _animationCount = 5;
    //Array below this line, '0' index is 1.0 ,witch is the first item show in SliderCarousel.
    _startIndex = -3;
    scales = [0.0, 1.0, 1.0, widget.scaleCenter, 0.0];
    opacity = [0.0, 1.0, 1.0, 1.0, 0.0];

    _updateValues();
  }

  @override
  Widget _buildItem(int i, int realIndex, double animationValue) {
    double s = _getValue(scales, animationValue, i);
    double f = _getValue(offsets, animationValue, i);
    double o = _getValue(opacity, animationValue, i);

    Offset offset = widget.scrollDirection == Axis.horizontal
        ? new Offset(f, 0.0)
        : new Offset(0.0, f);

    Alignment alignment = widget.scrollDirection == Axis.horizontal
        ? Alignment.centerLeft
        : Alignment.topCenter;

    return new Opacity(
      opacity: o,
      child: new Transform.translate(
        key: new ValueKey<int>(_currentIndex + i),
        offset: offset,
        child: new Transform.scale(
          scale: s,
          alignment: alignment,
          child: new SizedBox(
            width: widget.itemWidth ?? double.infinity,
            height: widget.itemHeight ?? double.infinity,
            child: widget.itemBuilder(context, realIndex),
          ),
        ),
      ),
    );
  }
}
