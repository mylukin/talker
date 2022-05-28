import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_shop_app_example/features/products/bloc/products/products_bloc.dart';
import 'package:talker_shop_app_example/features/products/widgets/widgets.dart';
import 'package:talker_shop_app_example/repositories/products/products.dart';
import 'package:talker_shop_app_example/ui/ui.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _productsBloc = ProductsBloc(
    productsRepository: GetIt.instance<AbstractProductsRepository>(),
  );

  @override
  void initState() {
    _loadProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SHOPY',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        bloc: _productsBloc,
        builder: (context, state) {
          if (state is ProductsLoaded) {
            final products = state.products;
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: products.length,
              itemBuilder: (context, i) => ProductCard(
                product: products[i],
                onTap: () => _openProductScreen(context, products, i),
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          }
          if (state is ProductsLoadingFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Ops! Something not working',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'It is special error to check how logs working in differend ways of logic',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: _loadProducts,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.document_scanner),
        onPressed: () => _openTalekrScreen(context),
      ),
    );
  }

  void _openTalekrScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.talker,
    );
  }

  void _openProductScreen(BuildContext context, List<Product> products, int i) {
    Navigator.pushNamed(
      context,
      Routes.product,
      arguments: {
        'productId': products[i].id,
      },
    );
  }

  void _loadProducts() {
    _productsBloc.add(LoadProducts());
  }
}
