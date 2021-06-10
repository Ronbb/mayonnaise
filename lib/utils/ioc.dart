import 'package:get/get.dart';
import 'package:mayonnaise/blocs/store/store_bloc.dart';

Future<void> initIoc() async {
  Get.put<StoreBloc>(StoreBloc());
}
