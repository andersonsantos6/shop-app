import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFoucs = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrl = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrl.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFoucs.dispose();
    _imageUrl.removeListener(updateImage);
    _descriptionFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(_formData).catchError((error) {
      return showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content: Text('Ocorreu um erro ao salvar o produto.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  )
                ],
              ));
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          )
        ],
        title: Text('Formul??rio de Produto'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                        initialValue: _formData['name']?.toString(),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFoucs);
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                        ),
                        validator: (_name) {
                          final name = _name ?? '';

                          if (name.trim().isEmpty) {
                            return 'Nome ?? obrigat??rio!';
                          }
                          if (name.trim().length < 3) {
                            return 'Nome precisa no m??nimo de 3 letras!';
                          }
                          return null;
                        },
                        onSaved: (name) => _formData['name'] = name ?? ''),
                    TextFormField(
                        initialValue: _formData['price']?.toString(),
                        onSaved: (price) =>
                            _formData['price'] = double.parse(price ?? '0'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFoucs,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        decoration: InputDecoration(labelText: 'Pre??o'),
                        validator: (_price) {
                          final priceString = _price ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Informe um pre??o v??lido!';
                          }
                          return null;
                        }),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      validator: (_description) {
                        final description = _description ?? '';

                        if (description.trim().isEmpty) {
                          return 'Nome ?? obrigat??rio!';
                        }
                        if (description.trim().length < 10) {
                          return 'Descri????o precisa no m??nimo de 10 letras!';
                        }
                        return null;
                      },
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocus,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'Descri????o'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.url,
                            maxLines: 3,
                            focusNode: _imageUrl,
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            onSaved: (imageUrl) =>
                                _formData['imageurl'] = imageUrl ?? '',
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? '';
                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma Url v??lida!';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'Url da Imagem'),
                            onFieldSubmitted: (_) => _submitForm(),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a Url')
                              : Image.network(_imageUrlController.text),
                          margin: EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
