import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_navigation_event.dart';
part 'home_navigation_state.dart';

class HomeNavigationBloc
    extends Bloc<HomeNavigationEvent, HomeNavigationState> {
  HomeNavigationBloc() : super(HomeNavigationInitial()) {
    on<HomeMenuSelected>(_onMenuSelected);
  }

  void _onMenuSelected(
    HomeMenuSelected event,
    Emitter<HomeNavigationState> emit,
  ) {
    emit(HomeNavigationLoaded(screen: event.screen, title: event.title));
  }
}
