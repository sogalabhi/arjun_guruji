// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'books_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BooksEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAllBooks,
    required TResult Function() fetchBookSummaries,
    required TResult Function(String title) fetchBookDetailsByTitle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAllBooks,
    TResult? Function()? fetchBookSummaries,
    TResult? Function(String title)? fetchBookDetailsByTitle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAllBooks,
    TResult Function()? fetchBookSummaries,
    TResult Function(String title)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchAllBooks value) fetchAllBooks,
    required TResult Function(FetchBookSummaries value) fetchBookSummaries,
    required TResult Function(FetchBookDetailsByTitle value)
        fetchBookDetailsByTitle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchAllBooks value)? fetchAllBooks,
    TResult? Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult? Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchAllBooks value)? fetchAllBooks,
    TResult Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BooksEventCopyWith<$Res> {
  factory $BooksEventCopyWith(
          BooksEvent value, $Res Function(BooksEvent) then) =
      _$BooksEventCopyWithImpl<$Res, BooksEvent>;
}

/// @nodoc
class _$BooksEventCopyWithImpl<$Res, $Val extends BooksEvent>
    implements $BooksEventCopyWith<$Res> {
  _$BooksEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchAllBooksImplCopyWith<$Res> {
  factory _$$FetchAllBooksImplCopyWith(
          _$FetchAllBooksImpl value, $Res Function(_$FetchAllBooksImpl) then) =
      __$$FetchAllBooksImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchAllBooksImplCopyWithImpl<$Res>
    extends _$BooksEventCopyWithImpl<$Res, _$FetchAllBooksImpl>
    implements _$$FetchAllBooksImplCopyWith<$Res> {
  __$$FetchAllBooksImplCopyWithImpl(
      _$FetchAllBooksImpl _value, $Res Function(_$FetchAllBooksImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchAllBooksImpl implements FetchAllBooks {
  const _$FetchAllBooksImpl();

  @override
  String toString() {
    return 'BooksEvent.fetchAllBooks()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchAllBooksImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAllBooks,
    required TResult Function() fetchBookSummaries,
    required TResult Function(String title) fetchBookDetailsByTitle,
  }) {
    return fetchAllBooks();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAllBooks,
    TResult? Function()? fetchBookSummaries,
    TResult? Function(String title)? fetchBookDetailsByTitle,
  }) {
    return fetchAllBooks?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAllBooks,
    TResult Function()? fetchBookSummaries,
    TResult Function(String title)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchAllBooks != null) {
      return fetchAllBooks();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchAllBooks value) fetchAllBooks,
    required TResult Function(FetchBookSummaries value) fetchBookSummaries,
    required TResult Function(FetchBookDetailsByTitle value)
        fetchBookDetailsByTitle,
  }) {
    return fetchAllBooks(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchAllBooks value)? fetchAllBooks,
    TResult? Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult? Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
  }) {
    return fetchAllBooks?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchAllBooks value)? fetchAllBooks,
    TResult Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchAllBooks != null) {
      return fetchAllBooks(this);
    }
    return orElse();
  }
}

abstract class FetchAllBooks implements BooksEvent {
  const factory FetchAllBooks() = _$FetchAllBooksImpl;
}

/// @nodoc
abstract class _$$FetchBookSummariesImplCopyWith<$Res> {
  factory _$$FetchBookSummariesImplCopyWith(_$FetchBookSummariesImpl value,
          $Res Function(_$FetchBookSummariesImpl) then) =
      __$$FetchBookSummariesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchBookSummariesImplCopyWithImpl<$Res>
    extends _$BooksEventCopyWithImpl<$Res, _$FetchBookSummariesImpl>
    implements _$$FetchBookSummariesImplCopyWith<$Res> {
  __$$FetchBookSummariesImplCopyWithImpl(_$FetchBookSummariesImpl _value,
      $Res Function(_$FetchBookSummariesImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchBookSummariesImpl implements FetchBookSummaries {
  const _$FetchBookSummariesImpl();

  @override
  String toString() {
    return 'BooksEvent.fetchBookSummaries()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchBookSummariesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAllBooks,
    required TResult Function() fetchBookSummaries,
    required TResult Function(String title) fetchBookDetailsByTitle,
  }) {
    return fetchBookSummaries();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAllBooks,
    TResult? Function()? fetchBookSummaries,
    TResult? Function(String title)? fetchBookDetailsByTitle,
  }) {
    return fetchBookSummaries?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAllBooks,
    TResult Function()? fetchBookSummaries,
    TResult Function(String title)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchBookSummaries != null) {
      return fetchBookSummaries();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchAllBooks value) fetchAllBooks,
    required TResult Function(FetchBookSummaries value) fetchBookSummaries,
    required TResult Function(FetchBookDetailsByTitle value)
        fetchBookDetailsByTitle,
  }) {
    return fetchBookSummaries(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchAllBooks value)? fetchAllBooks,
    TResult? Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult? Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
  }) {
    return fetchBookSummaries?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchAllBooks value)? fetchAllBooks,
    TResult Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchBookSummaries != null) {
      return fetchBookSummaries(this);
    }
    return orElse();
  }
}

abstract class FetchBookSummaries implements BooksEvent {
  const factory FetchBookSummaries() = _$FetchBookSummariesImpl;
}

/// @nodoc
abstract class _$$FetchBookDetailsByTitleImplCopyWith<$Res> {
  factory _$$FetchBookDetailsByTitleImplCopyWith(
          _$FetchBookDetailsByTitleImpl value,
          $Res Function(_$FetchBookDetailsByTitleImpl) then) =
      __$$FetchBookDetailsByTitleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title});
}

/// @nodoc
class __$$FetchBookDetailsByTitleImplCopyWithImpl<$Res>
    extends _$BooksEventCopyWithImpl<$Res, _$FetchBookDetailsByTitleImpl>
    implements _$$FetchBookDetailsByTitleImplCopyWith<$Res> {
  __$$FetchBookDetailsByTitleImplCopyWithImpl(
      _$FetchBookDetailsByTitleImpl _value,
      $Res Function(_$FetchBookDetailsByTitleImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
  }) {
    return _then(_$FetchBookDetailsByTitleImpl(
      null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FetchBookDetailsByTitleImpl implements FetchBookDetailsByTitle {
  const _$FetchBookDetailsByTitleImpl(this.title);

  @override
  final String title;

  @override
  String toString() {
    return 'BooksEvent.fetchBookDetailsByTitle(title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchBookDetailsByTitleImpl &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title);

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchBookDetailsByTitleImplCopyWith<_$FetchBookDetailsByTitleImpl>
      get copyWith => __$$FetchBookDetailsByTitleImplCopyWithImpl<
          _$FetchBookDetailsByTitleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchAllBooks,
    required TResult Function() fetchBookSummaries,
    required TResult Function(String title) fetchBookDetailsByTitle,
  }) {
    return fetchBookDetailsByTitle(title);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchAllBooks,
    TResult? Function()? fetchBookSummaries,
    TResult? Function(String title)? fetchBookDetailsByTitle,
  }) {
    return fetchBookDetailsByTitle?.call(title);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchAllBooks,
    TResult Function()? fetchBookSummaries,
    TResult Function(String title)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchBookDetailsByTitle != null) {
      return fetchBookDetailsByTitle(title);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchAllBooks value) fetchAllBooks,
    required TResult Function(FetchBookSummaries value) fetchBookSummaries,
    required TResult Function(FetchBookDetailsByTitle value)
        fetchBookDetailsByTitle,
  }) {
    return fetchBookDetailsByTitle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchAllBooks value)? fetchAllBooks,
    TResult? Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult? Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
  }) {
    return fetchBookDetailsByTitle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchAllBooks value)? fetchAllBooks,
    TResult Function(FetchBookSummaries value)? fetchBookSummaries,
    TResult Function(FetchBookDetailsByTitle value)? fetchBookDetailsByTitle,
    required TResult orElse(),
  }) {
    if (fetchBookDetailsByTitle != null) {
      return fetchBookDetailsByTitle(this);
    }
    return orElse();
  }
}

abstract class FetchBookDetailsByTitle implements BooksEvent {
  const factory FetchBookDetailsByTitle(final String title) =
      _$FetchBookDetailsByTitleImpl;

  String get title;

  /// Create a copy of BooksEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchBookDetailsByTitleImplCopyWith<_$FetchBookDetailsByTitleImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BooksState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Book> books) booksLoaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Book> books)? booksLoaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Book> books)? booksLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(BooksLoaded value) booksLoaded,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(BooksLoaded value)? booksLoaded,
    TResult? Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(BooksLoaded value)? booksLoaded,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BooksStateCopyWith<$Res> {
  factory $BooksStateCopyWith(
          BooksState value, $Res Function(BooksState) then) =
      _$BooksStateCopyWithImpl<$Res, BooksState>;
}

/// @nodoc
class _$BooksStateCopyWithImpl<$Res, $Val extends BooksState>
    implements $BooksStateCopyWith<$Res> {
  _$BooksStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$BooksStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'BooksState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Book> books) booksLoaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Book> books)? booksLoaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Book> books)? booksLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(BooksLoaded value) booksLoaded,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(BooksLoaded value)? booksLoaded,
    TResult? Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(BooksLoaded value)? booksLoaded,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements BooksState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$BooksStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'BooksState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Book> books) booksLoaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Book> books)? booksLoaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Book> books)? booksLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(BooksLoaded value) booksLoaded,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(BooksLoaded value)? booksLoaded,
    TResult? Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(BooksLoaded value)? booksLoaded,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements BooksState {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$BooksLoadedImplCopyWith<$Res> {
  factory _$$BooksLoadedImplCopyWith(
          _$BooksLoadedImpl value, $Res Function(_$BooksLoadedImpl) then) =
      __$$BooksLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Book> books});
}

/// @nodoc
class __$$BooksLoadedImplCopyWithImpl<$Res>
    extends _$BooksStateCopyWithImpl<$Res, _$BooksLoadedImpl>
    implements _$$BooksLoadedImplCopyWith<$Res> {
  __$$BooksLoadedImplCopyWithImpl(
      _$BooksLoadedImpl _value, $Res Function(_$BooksLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? books = null,
  }) {
    return _then(_$BooksLoadedImpl(
      null == books
          ? _value._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
    ));
  }
}

/// @nodoc

class _$BooksLoadedImpl implements BooksLoaded {
  const _$BooksLoadedImpl(final List<Book> books) : _books = books;

  final List<Book> _books;
  @override
  List<Book> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  @override
  String toString() {
    return 'BooksState.booksLoaded(books: $books)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BooksLoadedImpl &&
            const DeepCollectionEquality().equals(other._books, _books));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_books));

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BooksLoadedImplCopyWith<_$BooksLoadedImpl> get copyWith =>
      __$$BooksLoadedImplCopyWithImpl<_$BooksLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Book> books) booksLoaded,
    required TResult Function(String message) error,
  }) {
    return booksLoaded(books);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Book> books)? booksLoaded,
    TResult? Function(String message)? error,
  }) {
    return booksLoaded?.call(books);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Book> books)? booksLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (booksLoaded != null) {
      return booksLoaded(books);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(BooksLoaded value) booksLoaded,
    required TResult Function(Error value) error,
  }) {
    return booksLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(BooksLoaded value)? booksLoaded,
    TResult? Function(Error value)? error,
  }) {
    return booksLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(BooksLoaded value)? booksLoaded,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (booksLoaded != null) {
      return booksLoaded(this);
    }
    return orElse();
  }
}

abstract class BooksLoaded implements BooksState {
  const factory BooksLoaded(final List<Book> books) = _$BooksLoadedImpl;

  List<Book> get books;

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BooksLoadedImplCopyWith<_$BooksLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$BooksStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'BooksState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Book> books) booksLoaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Book> books)? booksLoaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Book> books)? booksLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(BooksLoaded value) booksLoaded,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(BooksLoaded value)? booksLoaded,
    TResult? Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(BooksLoaded value)? booksLoaded,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements BooksState {
  const factory Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of BooksState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
