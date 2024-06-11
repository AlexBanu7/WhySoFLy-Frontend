import 'package:flutter/material.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/utils/utils.dart';

class ExpandableCategory extends StatefulWidget {

  final Category category;
  final bool leftSided;

  const ExpandableCategory({super.key, required this.category, required this.leftSided});

  @override
  _ExpandableElementState createState() => _ExpandableElementState();
}

class _ExpandableElementState extends State<ExpandableCategory> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: widget.leftSided ? Alignment.centerLeft : Alignment.centerRight,
        children: <Widget>[
          // Bottom Widget
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isExpanded ? MediaQuery.of(context).size.width - 40 : 80,
            height: 80,
            child: GestureDetector(
              onTap: () {
                if(_isExpanded){
                  Navigator.pushNamed(context, "/category-order", arguments: Category);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 3, // Border width
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: _isExpanded ? widget.leftSided? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40): EdgeInsets.zero,
                child: Text(
                  widget.category.name,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          // Top Widget
          Positioned(
            child: GestureDetector(
              onTap: _toggleExpand,
              child: Container(
                decoration: BoxDecoration(
                  color: hexToColor("#f5f5dc"),
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 4, // Border width
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 80,
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  widget.category.icon,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}