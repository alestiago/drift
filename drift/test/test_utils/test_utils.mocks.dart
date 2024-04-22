// Mocks generated by Mockito 5.4.4 from annotations
// in drift/test/test_utils/test_utils.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:drift/drift.dart' as _i5;
import 'package:drift/src/runtime/executor/helpers/delegates.dart' as _i2;
import 'package:drift/src/runtime/executor/helpers/results.dart' as _i3;
import 'package:drift/src/runtime/executor/stream_queries.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDbVersionDelegate_0 extends _i1.SmartFake
    implements _i2.DbVersionDelegate {
  _FakeDbVersionDelegate_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTransactionDelegate_1 extends _i1.SmartFake
    implements _i2.TransactionDelegate {
  _FakeTransactionDelegate_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQueryResult_2 extends _i1.SmartFake implements _i3.QueryResult {
  _FakeQueryResult_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DatabaseDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseDelegate extends _i1.Mock implements _i2.DatabaseDelegate {
  @override
  bool get isInTransaction => (super.noSuchMethod(
        Invocation.getter(#isInTransaction),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  set isInTransaction(bool? _isInTransaction) => super.noSuchMethod(
        Invocation.setter(
          #isInTransaction,
          _isInTransaction,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.DbVersionDelegate get versionDelegate => (super.noSuchMethod(
        Invocation.getter(#versionDelegate),
        returnValue: _FakeDbVersionDelegate_0(
          this,
          Invocation.getter(#versionDelegate),
        ),
        returnValueForMissingStub: _FakeDbVersionDelegate_0(
          this,
          Invocation.getter(#versionDelegate),
        ),
      ) as _i2.DbVersionDelegate);

  @override
  _i2.TransactionDelegate get transactionDelegate => (super.noSuchMethod(
        Invocation.getter(#transactionDelegate),
        returnValue: _FakeTransactionDelegate_1(
          this,
          Invocation.getter(#transactionDelegate),
        ),
        returnValueForMissingStub: _FakeTransactionDelegate_1(
          this,
          Invocation.getter(#transactionDelegate),
        ),
      ) as _i2.TransactionDelegate);

  @override
  _i4.FutureOr<bool> get isOpen => (super.noSuchMethod(
        Invocation.getter(#isOpen),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.FutureOr<bool>);

  @override
  _i4.Future<void> open(_i5.QueryExecutorUser? db) => (super.noSuchMethod(
        Invocation.method(
          #open,
          [db],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void notifyDatabaseOpened(_i5.OpeningDetails? details) => super.noSuchMethod(
        Invocation.method(
          #notifyDatabaseOpened,
          [details],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<_i3.QueryResult> runSelect(
    String? statement,
    List<Object?>? args,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #runSelect,
          [
            statement,
            args,
          ],
        ),
        returnValue: _i4.Future<_i3.QueryResult>.value(_FakeQueryResult_2(
          this,
          Invocation.method(
            #runSelect,
            [
              statement,
              args,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.QueryResult>.value(_FakeQueryResult_2(
          this,
          Invocation.method(
            #runSelect,
            [
              statement,
              args,
            ],
          ),
        )),
      ) as _i4.Future<_i3.QueryResult>);

  @override
  _i4.Future<int> runUpdate(
    String? statement,
    List<Object?>? args,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #runUpdate,
          [
            statement,
            args,
          ],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<int> runInsert(
    String? statement,
    List<Object?>? args,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #runInsert,
          [
            statement,
            args,
          ],
        ),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<void> runCustom(
    String? statement,
    List<Object?>? args,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #runCustom,
          [
            statement,
            args,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> runBatched(_i5.BatchedStatements? statements) =>
      (super.noSuchMethod(
        Invocation.method(
          #runBatched,
          [statements],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [DynamicVersionDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockDynamicVersionDelegate extends _i1.Mock
    implements _i2.DynamicVersionDelegate {
  @override
  _i4.Future<int> get schemaVersion => (super.noSuchMethod(
        Invocation.getter(#schemaVersion),
        returnValue: _i4.Future<int>.value(0),
        returnValueForMissingStub: _i4.Future<int>.value(0),
      ) as _i4.Future<int>);

  @override
  _i4.Future<void> setSchemaVersion(int? version) => (super.noSuchMethod(
        Invocation.method(
          #setSchemaVersion,
          [version],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [SupportedTransactionDelegate].
///
/// See the documentation for Mockito's code generation for more information.
class MockSupportedTransactionDelegate extends _i1.Mock
    implements _i2.SupportedTransactionDelegate {
  @override
  bool get managesLockInternally => (super.noSuchMethod(
        Invocation.getter(#managesLockInternally),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i4.FutureOr<void> startTransaction(
          _i4.Future<dynamic> Function(_i2.QueryDelegate)? run) =>
      (super.noSuchMethod(
        Invocation.method(
          #startTransaction,
          [run],
        ),
        returnValueForMissingStub: null,
      ) as _i4.FutureOr<void>);
}

/// A class which mocks [StreamQueryStore].
///
/// See the documentation for Mockito's code generation for more information.
class MockStreamQueries extends _i1.Mock implements _i6.StreamQueryStore {
  @override
  _i4.Stream<List<Map<String, Object?>>> registerStream(
          _i6.QueryStreamFetcher? fetcher) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerStream,
          [fetcher],
        ),
        returnValue: _i4.Stream<List<Map<String, Object?>>>.empty(),
        returnValueForMissingStub:
            _i4.Stream<List<Map<String, Object?>>>.empty(),
      ) as _i4.Stream<List<Map<String, Object?>>>);

  @override
  _i4.Stream<Set<_i5.TableUpdate>> updatesForSync(
          _i5.TableUpdateQuery? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatesForSync,
          [query],
        ),
        returnValue: _i4.Stream<Set<_i5.TableUpdate>>.empty(),
        returnValueForMissingStub: _i4.Stream<Set<_i5.TableUpdate>>.empty(),
      ) as _i4.Stream<Set<_i5.TableUpdate>>);

  @override
  void handleTableUpdates(Set<_i5.TableUpdate>? updates) => super.noSuchMethod(
        Invocation.method(
          #handleTableUpdates,
          [updates],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void markAsClosed(
    _i6.QueryStream? stream,
    void Function()? whenRemoved,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #markAsClosed,
          [
            stream,
            whenRemoved,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void markAsOpened(_i6.QueryStream? stream) => super.noSuchMethod(
        Invocation.method(
          #markAsOpened,
          [stream],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
