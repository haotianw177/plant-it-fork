import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddPlantImageHeader extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;

  const AddPlantImageHeader({
    super.key,
    required this.species,
    required this.env,
  });

  @override
  State<AddPlantImageHeader> createState() => _AddPlantImageHeaderState();
}

class _AddPlantImageHeaderState extends State<AddPlantImageHeader> {
  String? _url;

  @override
  void initState() {
    super.initState();
    if (widget.species.id != null) {
      _url =
          "${widget.env.http.backendUrl}image/content/${widget.species.imageId}";
    } else if (widget.species.imageUrl != null) {
      _url =
          "${widget.env.http.backendUrl}proxy?url=${widget.species.imageUrl}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          _url ?? "${widget.env.http.backendUrl}image/content/non-existing-id",
      httpHeaders: {
        "Key": widget.env.http.key!,
      },
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      fit: BoxFit.cover,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        effect: skeletonizerEffect,
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/no-image.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return Container(
          color: const Color.fromRGBO(24, 44, 37, 1),
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/no-image.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          padding: EdgeInsets.all(_url == null ? 100 : 0),
          decoration: _url == null
              ? BoxDecoration(
                  color: const Color.fromRGBO(24, 44, 37, 1),
                )
              : null,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: _url == null ? BoxFit.contain : BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
