import 'package:flutter/material.dart';

class Shape extends StatefulWidget {
  final ValueSetter<int> onAdd;
  final ValueSetter<int> onSubtract;
  final int position;

  Shape({Key? key, required this.onAdd, required this.onSubtract, required this.position})
      : super(key: key);

  @override
  _ShapeState createState() => _ShapeState();
}

class _ShapeState extends State<Shape> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: Colors.blue, // สามารถแก้ไขสีตามความต้องการ
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              widget.onAdd(widget.position);
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              widget.onSubtract(widget.position);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
