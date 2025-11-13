import 'package:equatable/equatable.dart';

class AddReviewRequest extends Equatable {
  final int? rating;
  final String? comment;

  const AddReviewRequest({this.rating, this.comment});

  factory AddReviewRequest.fromJson(Map<String, dynamic> json) {
    return AddReviewRequest(
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'rating': rating, 'comment': comment};

  @override
  List<Object?> get props => [rating, comment];
}
