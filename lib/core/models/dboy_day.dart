import 'package:equatable/equatable.dart';

class DboyDay extends Equatable {
  final String dId;
  final DateTime date;

  const DboyDay({
    required this.dId,
    required this.date,
  });
  @override
  List<Object?> get props => [dId, date];
}
