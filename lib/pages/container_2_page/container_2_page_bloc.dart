import 'package:bloc/bloc.dart';

import 'container_2_page_event.dart';
import 'container_2_page_state.dart';

class Container_2_pageBloc extends Bloc<Container_2_pageEvent, Container_2_pageState> {
  Container_2_pageBloc() : super(Container_2_pageState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<Container_2_pageState> emit) async {
    emit(state.clone());
  }
}
