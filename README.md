# Slider Carousel

A new slider carousel widget with custom scaling and item spacing

## Example

    SliderCarousel(
      itemCount: 5,
      itemBuilder: (context, idx) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        );
      },
      offsetCenter: 0.75,
      scaleCenter: 1.25,
      itemWidth: 150,
      itemHeight: 150,
    );


![](https://github.com/devdanpre/flutter_slidercarousel/blob/main/example/images/screenshot.gif)



