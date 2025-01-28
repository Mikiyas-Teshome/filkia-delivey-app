part of 'home_navigation_bloc.dart';

abstract class HomeNavigationState extends Equatable {
  const HomeNavigationState();

  @override
  List<Object?> get props => [];
}

class HomeNavigationInitial extends HomeNavigationState {}

class HomeNavigationLoaded extends HomeNavigationState {
  final Widget screen;
  final String title;

  const HomeNavigationLoaded({
    required this.screen,
    required this.title,
  });

  @override
  List<Object?> get props => [screen, title];
}
