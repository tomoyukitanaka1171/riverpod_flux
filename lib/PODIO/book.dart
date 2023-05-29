import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required String title,
    required String author,
  }) = _Book;

  const Book._();
}

@freezed
class BookSerializer with _$BookSerializer {
  const factory BookSerializer(
    String title,
    String author,
  ) = _BookSerializer;

  factory BookSerializer.fromJson(Map<String, dynamic> json) => _$BookSerializerFromJson(json);
}

@freezed
class BookResultSerializer with _$BookResultSerializer {
  const factory BookResultSerializer(@BookConverter() List<BookSerializer> books) = _BookResultSerializer;

  factory BookResultSerializer.fromJson(Map<String, dynamic> json) => _$BookResultSerializerFromJson(json);

  const BookResultSerializer._();

  List<Book> toPodio() => books
      .map((it) => Book(
            title: it.title,
            author: it.author,
          ))
      .toList();
}

class BookConverter implements JsonConverter<BookSerializer, Map<String, dynamic>> {
  const BookConverter();

  @override
  BookSerializer fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return BookSerializer.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(BookSerializer object) {
    // TODO: implement toJson
    return {};
  }
}
