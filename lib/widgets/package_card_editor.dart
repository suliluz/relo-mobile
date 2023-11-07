import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;

import '../business_logic/enums/season_item.dart';

class PackageCardEditor extends StatefulWidget {
  const PackageCardEditor({super.key, required this.images, required this.season});

  final List<String> images;
  final SeasonItem season;

  @override
  State<PackageCardEditor> createState() => _PackageCardEditorState();
}

class _PackageCardEditorState extends State<PackageCardEditor> {
  int _imageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Image container with rounded corners on top
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageCarousel(),
            ),
            // Image count indicator to the bottom right
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                constraints: const BoxConstraints(minWidth: 50),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${_imageIndex + 1} / ${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Season indicator to the bottom right
            Positioned(
              bottom: 16,
              right: 16,
              child: season(),
            ),
            // View package button to the top left
            Positioned(
              top: 16,
              left: 16,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('View Package'),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Bustling New York City Life",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Location with icon
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "New York, USA",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    // Days
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "5 Days",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    // Customizable text label
                    Text(
                      "Customizable",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating average
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "4.5",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Edit button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Package Info'),
              ),
              const SizedBox(width: 8),
              // Bookings button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
                label: const Text('Bookings'),
              ),
              const SizedBox(width: 8),
              // Delete button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget imageCarousel() {
    final List<Widget> items = widget.images.map((String image) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();

    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            _imageIndex = index;
          });
        },
      ),
    );
  }

  Widget season() {
    IconData iconData = cupertino.CupertinoIcons.tree;
    String text = 'Spring';
    Color color = Colors.lightGreen.withOpacity(0.75);

    switch(widget.season) {
      case SeasonItem.summer:
        iconData = cupertino.CupertinoIcons.sun_max_fill;
        text = 'Summer';
        color = Colors.orange.withOpacity(0.75);
        break;
      case SeasonItem.autumn:
        iconData = cupertino.CupertinoIcons.wind;
        text = 'Autumn';
        color = Colors.brown.withOpacity(0.75);
        break;
      case SeasonItem.winter:
        iconData = cupertino.CupertinoIcons.snow;
        text = 'Winter';
        color = Colors.blue.withOpacity(0.75);
        break;
      default:
        iconData = cupertino.CupertinoIcons.tree;
        text = 'Spring';
        color = Colors.lightGreen.withOpacity(0.75);
        break;
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData, color: Colors.white, size: 20),
          Text(text, style: const TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}
