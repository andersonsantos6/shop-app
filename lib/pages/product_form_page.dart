import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

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
    final newProduct = Product(
        id: Random().nextDouble().toString(),
        description: _formData['description'] as String,
        imageUrl: _formData['imageurl'] as String,
        isFavotrite: false,
        price: _formData['price'] as double,
        name: _formData['name'] as String);
    print(newProduct.name);
    print(newProduct.description);
    print(newProduct.id);
    print(newProduct.price);
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
        title: Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
                      return 'Nome é obrigatório!';
                    }
                    if (name.trim().length < 3) {
                      return 'Nome precisa no mínimo de 3 letras!';
                    }
                    return null;
                  },
                  onSaved: (name) => _formData['name'] = name ?? ''),
              TextFormField(
                  onSaved: (price) =>
                      _formData['price'] = double.parse(price ?? '0'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFoucs,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocus);
                  },
                  decoration: InputDecoration(labelText: 'Preço'),
                  validator: (_price) {
                    final priceString = _price ?? '';
                    final price = double.tryParse(priceString) ?? -1;

                    if (price <= 0) {
                      return 'Informe um preço válido!';
                    }
                    return null;
                  }),
              TextFormField(
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'Nome é obrigatório!';
                  }
                  if (description.trim().length < 10) {
                    return 'Descrição precisa no mínimo de 10 letras!';
                  }
                  return null;
                },
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Descrição'),
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
                          return 'Informe uma Url válida!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a Url')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
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
