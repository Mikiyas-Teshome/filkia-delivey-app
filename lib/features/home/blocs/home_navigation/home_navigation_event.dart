part of 'home_navigation_bloc.dart';

abstract class HomeNavigationEvent extends Equatable {
  const HomeNavigationEvent();

  @override
  List<Object?> get props => [];
}

class HomeMenuSelected extends HomeNavigationEvent {
  final Widget screen;
  final String title;

  const HomeMenuSelected({
    required this.screen,
    required this.title,
  });

  @override
  List<Object?> get props => [screen, title];
}
