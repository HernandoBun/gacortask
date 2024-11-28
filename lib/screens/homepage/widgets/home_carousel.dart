import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gacortask/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselHome extends StatefulWidget {
  const CarouselHome({super.key});

  @override
  State<CarouselHome> createState() => _CarouselHomeState();
}

class _CarouselHomeState extends State<CarouselHome> {
  final List<String> urlImages = [
    Constants.carouselRoot,
    Constants.carouselRoot1,
    Constants.carouselRoot2,
    Constants.carouselRoot3,
    Constants.carouselRoot4,
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: urlImages.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = urlImages[index];
            return buildImage(urlImage, index);
          },
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
        ),
        buildIndicator(),
      ],
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.only(
          bottom: 12,
          right: 15,
          left: 15,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget buildIndicator() => Container(
        margin: const EdgeInsets.only(right: 280, bottom: 10),
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: urlImages.length,
          effect: const WormEffect(
            activeDotColor: Constants.colorBlue,
            dotColor: Constants.colorGrey7,
            dotHeight: 10,
            dotWidth: 10,
          ),
        ),
      );
}
