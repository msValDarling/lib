import 'package:flutter/material.dart';
import 'package:pmsna/models/nasa_model.dart';

class astroDetailScreen extends StatelessWidget {
  const astroDetailScreen({super.key, required this.nasaobj});

  final NasaModel nasaobj;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nasaobj.date!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(),
            ),
            SizedBox(
              height: 300.0,
              child: Image.network(
                nasaobj.date!,
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nasaobj.title!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    nasaobj.date!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    nasaobj.explanation!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    nasaobj.hdurl!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    nasaobj.mediaType!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    nasaobj.serviceVersion!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    nasaobj.url!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    nasaobj.copyright!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: 8.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
