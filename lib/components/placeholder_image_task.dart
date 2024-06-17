import 'package:flutter/material.dart';
import 'package:sekuya_family_mobile_app/constants.dart';

class PlaceholderImageTaskApp extends StatelessWidget {
  const PlaceholderImageTaskApp({super.key, this.label, this.imageProof = ''});

  final String imageProof;

  final String? label;

  @override
  Widget build(BuildContext context) {
    return PlaceholderImageTask(label: label, imageProof: imageProof);
  }
}

class PlaceholderImageTask extends StatefulWidget {
  const PlaceholderImageTask({super.key, this.label, this.imageProof = ''});

  final String? label;
  final String imageProof;

  @override
  State<PlaceholderImageTask> createState() => _PlaceholderImageTaskState();
}

class _PlaceholderImageTaskState extends State<PlaceholderImageTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: widget.imageProof.isNotEmpty
            ? DecorationImage(image: NetworkImage(widget.imageProof))
            : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: greyColor,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imageProof.isEmpty
            ? [
                Text(
                  widget.label ?? 'Add Image',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (widget.label != 'Add Image')
                  const Icon(Icons.add, color: Colors.white)
              ]
            : [],
      ),
    );
  }
}
