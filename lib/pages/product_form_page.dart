import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFoucs);
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFoucs,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                decoration: InputDecoration(labelText: 'Preço'),
              ),
              TextFormField(
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
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
