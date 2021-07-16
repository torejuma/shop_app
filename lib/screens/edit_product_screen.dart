import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              SizedBox(height: 5,),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },
              ),
              SizedBox(height: 5,),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
