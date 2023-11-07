import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';

enum MediaSource {
  networkImage,
  fileImage,
  assetImage,
  networkVideo,
  fileVideo,
  assetVideo,
}

class MediaEditableItem extends StatefulWidget {
  MediaEditableItem({
    super.key,
    required this.source,
    required this.url,
    required this.onDelete,
    this.onClick,
  });

  final MediaSource source;
  final String url;
  final Function onDelete;
  final Function? onClick;

  @override
  State<MediaEditableItem> createState() => _MediaEditableItemState();
}

class _MediaEditableItemState extends State<MediaEditableItem> {
  ImageProvider? _imageProvider;
  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return _buildThumbnail();
  }

  _loadThumbnail() async {
    setState(() {
      isLoaded = false;
    });

    switch (widget.source) {
      case MediaSource.networkImage:
        _imageProvider = NetworkImage(widget.url);
        break;
      case MediaSource.fileImage:
        _imageProvider = FileImage(File(widget.url));
        break;
      case MediaSource.assetImage:
        _imageProvider = AssetImage(widget.url);
        break;
      case MediaSource.networkVideo:
      case MediaSource.fileVideo:
      case MediaSource.assetVideo:
        Uint8List? bytes;

        bytes = await VideoThumbnail.thumbnailData(
          video: widget.url,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 200,
          maxHeight: 150,
          quality: 100,
        );

        if (bytes == null) {
          _imageProvider = null;
        } else {
          _imageProvider = MemoryImage(bytes);
        }
        break;
    }

    setState(() {
      isLoaded = true;
    });
  }

  Widget _buildThumbnail() {
    if(!isLoaded) {
      return Container(
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => widget.onClick != null ? widget.onClick!() : null,
        child: Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: _imageProvider != null? DecorationImage(image: _imageProvider!, fit: BoxFit.cover,) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File type icon
              IconButton(
                onPressed: () {},
                icon: Icon(widget.source == MediaSource.networkImage || widget.source == MediaSource.fileImage || widget.source == MediaSource.assetImage ? Icons.image : Icons.videocam),
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white,),
                onPressed: () => widget.onDelete(),
              ),
            ],
          ),
        ),
      );
    }
  }
}
