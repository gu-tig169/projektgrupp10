import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

Widget starRating(double rating) {
  return SmoothStarRating(
    size: 16,
    filledIconData: Icons.star,
    isReadOnly: true,
    color: Colors.orange,
    borderColor: Colors.orange,
    halfFilledIconData: Icons.star_half,
    defaultIconData: Icons.star_border,
    starCount: 5,
    allowHalfRating: true,
    spacing: 2.0,
    rating: rating,
  );
}
