import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class MeetingParticipator extends StatelessWidget{
  final String image;

  MeetingParticipator(this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: image,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}