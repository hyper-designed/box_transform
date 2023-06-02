import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Box Transform Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 400,
    height: 300,
  );

  late Rect rect2 = Rect.fromCenter(
    center: const Offset(200, 150),
    width: 200,
    height: 100,
  );

  late Rect clampingRect = (Offset.zero & MediaQuery.of(context).size);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          TransformableBox(
            rect: rect,
            clampingRect: clampingRect,
            onChanged: (result, event) {
              setState(() {
                rect = result.rect;
              });
            },
            contentBuilder: (context, rect, flip) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/image1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    TransformableBox(
                      rect: rect2,
                      clampingRect:
                          Rect.fromLTWH(0, 0, rect.width, rect.height),
                      onChanged: (result, event) {
                        setState(() {
                          rect2 = result.rect;
                        });
                      },
                      contentBuilder:
                          (BuildContext context, Rect rect, Flip flip) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/image2.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
