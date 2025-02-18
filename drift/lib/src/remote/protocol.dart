// This is a drift-internal file
// ignore_for_file: constant_identifier_names, public_member_api_docs

import 'package:drift/drift.dart';

class DriftProtocol {
  const DriftProtocol();

  static const _tag_Request = 0;
  static const _tag_Response_success = 1;
  static const _tag_Response_error = 2;
  static const _tag_Response_cancelled = 3;

  static const _tag_NoArgsRequest_terminateAll = 0;

  static const _tag_ExecuteQuery = 3;
  static const _tag_ExecuteBatchedStatement = 4;
  static const _tag_RunTransactionAction = 5;
  static const _tag_EnsureOpen = 6;
  static const _tag_RunBeforeOpen = 7;
  static const _tag_NotifyTablesUpdated = 8;
  static const _tag_DirectValue = 10;
  static const _tag_SelectResult = 11;
  static const _tag_RequestCancellation = 12;
  static const _tag_ServerInfo = 13;

  static const _tag_BigInt = 'bigint';

  Object? serialize(Message message) {
    if (message is Request) {
      return [
        _tag_Request,
        message.id,
        encodePayload(message.payload),
      ];
    } else if (message is ErrorResponse) {
      return [
        _tag_Response_error,
        message.requestId,
        message.error.toString(),
        message.stackTrace?.toString(),
      ];
    } else if (message is SuccessResponse) {
      return [
        _tag_Response_success,
        message.requestId,
        encodePayload(message.response),
      ];
    } else if (message is CancelledResponse) {
      return [_tag_Response_cancelled, message.requestId];
    } else {
      return null;
    }
  }

  Message deserialize(Object message) {
    if (message is! List) throw const FormatException('Cannot read message');

    final tag = castInt(message[0]);
    final id = castInt(message[1]);

    switch (tag) {
      case _tag_Request:
        return Request(id, decodePayload(message[2]) as RequestPayload?);
      case _tag_Response_error:
        final stringTrace = message[3] as String?;

        return ErrorResponse(id, message[2] as Object,
            stringTrace != null ? StackTrace.fromString(stringTrace) : null);
      case _tag_Response_success:
        return SuccessResponse(
            id, decodePayload(message[2]) as ResponsePayload?);
      case _tag_Response_cancelled:
        return CancelledResponse(id);
    }

    throw const FormatException('Unknown tag');
  }

  dynamic encodePayload(dynamic payload) {
    if (payload == null) return payload;

    if (payload is NoArgsRequest) {
      return payload.index;
    } else if (payload is ExecuteQuery) {
      return [
        _tag_ExecuteQuery,
        payload.method.index,
        payload.sql,
        [for (final arg in payload.args) _encodeDbValue(arg)],
        payload.executorId,
      ];
    } else if (payload is ExecuteBatchedStatement) {
      return [
        _tag_ExecuteBatchedStatement,
        payload.stmts.statements,
        for (final arg in payload.stmts.arguments)
          [
            arg.statementIndex,
            for (final value in arg.arguments) _encodeDbValue(value),
          ],
        payload.executorId,
      ];
    } else if (payload is RunNestedExecutorControl) {
      return [
        _tag_RunTransactionAction,
        payload.control.index,
        payload.executorId,
      ];
    } else if (payload is EnsureOpen) {
      return [_tag_EnsureOpen, payload.schemaVersion, payload.executorId];
    } else if (payload is ServerInfo) {
      return [
        _tag_ServerInfo,
        payload.dialect.name,
      ];
    } else if (payload is RunBeforeOpen) {
      return [
        _tag_RunBeforeOpen,
        payload.details.versionBefore,
        payload.details.versionNow,
        payload.createdExecutor,
      ];
    } else if (payload is NotifyTablesUpdated) {
      return [
        _tag_NotifyTablesUpdated,
        for (final update in payload.updates)
          [
            update.table,
            update.kind?.index,
          ]
      ];
    } else if (payload is SelectResult) {
      // We can't necessary transport maps, so encode as list
      final rows = payload.rows;
      if (rows.isEmpty) {
        return const [_tag_SelectResult];
      } else {
        // Encode by first sending column names, followed by row data
        final result = <Object?>[_tag_SelectResult];

        final columns = rows.first.keys.toList();
        result
          ..add(columns.length)
          ..addAll(columns);

        result.add(rows.length);
        for (final row in rows) {
          for (final value in row.values) {
            result.add(_encodeDbValue(value));
          }
        }
        return result;
      }
    } else if (payload is RequestCancellation) {
      return [_tag_RequestCancellation, payload.originalRequestId];
    } else if (payload is PrimitiveResponsePayload) {
      return switch (payload.message) {
        final bool boolean => boolean,
        final int integer => [_tag_DirectValue, integer],
        _ => throw UnsupportedError('Unknown primitive response'),
      };
    }
  }

  dynamic decodePayload(dynamic encoded) {
    if (encoded == null) {
      return null;
    }
    if (encoded is bool) {
      return PrimitiveResponsePayload.bool(encoded);
    }

    int tag;
    List? fullMessage;

    if (isInt(encoded)) {
      tag = castInt(encoded);
    } else {
      fullMessage = encoded as List;
      tag = castInt(fullMessage[0]);
    }

    int readInt(int index) => castInt(fullMessage![index]);
    int? readNullableInt(int index) => switch (fullMessage![index]) {
          null => null,
          var other => castInt(other),
        };

    switch (tag) {
      case _tag_NoArgsRequest_terminateAll:
        return NoArgsRequest.terminateAll;
      case _tag_ExecuteQuery:
        final method = StatementMethod.values[readInt(1)];
        final sql = fullMessage![2] as String;
        final args = (fullMessage[3] as List).map(_decodeDbValue).toList();
        final executorId = readNullableInt(4);
        return ExecuteQuery(method, sql, args, executorId);
      case _tag_ExecuteBatchedStatement:
        final sql = (fullMessage![1] as List).cast<String>();
        final args = <ArgumentsForBatchedStatement>[];

        for (var i = 2; i < fullMessage.length - 1; i++) {
          final list = fullMessage[i] as List;
          args.add(
            ArgumentsForBatchedStatement(
              castInt(list[0]),
              [for (final encoded in list.skip(1)) _decodeDbValue(encoded)],
            ),
          );
        }

        final executorId = switch (fullMessage.last) {
          null => null,
          var other => castInt(other),
        };
        return ExecuteBatchedStatement(
            BatchedStatements(sql, args), executorId);
      case _tag_RunTransactionAction:
        final control = NestedExecutorControl.values[readInt(1)];
        return RunNestedExecutorControl(control, readNullableInt(2));
      case _tag_EnsureOpen:
        return EnsureOpen(readInt(1), readNullableInt(2));
      case _tag_ServerInfo:
        return ServerInfo(SqlDialect.values.byName(fullMessage![1] as String));
      case _tag_RunBeforeOpen:
        return RunBeforeOpen(
          OpeningDetails(readNullableInt(1), readInt(2)),
          readInt(3),
        );
      case _tag_NotifyTablesUpdated:
        final updates = <TableUpdate>[];
        for (var i = 1; i < fullMessage!.length; i++) {
          final encodedUpdate = fullMessage[i] as List;
          final kindIndex = switch (encodedUpdate[1]) {
            null => null,
            var other => castInt(other),
          };

          updates.add(
            TableUpdate(encodedUpdate[0] as String,
                kind: kindIndex == null ? null : UpdateKind.values[kindIndex]),
          );
        }
        return NotifyTablesUpdated(updates);
      case _tag_SelectResult:
        if (fullMessage!.length == 1) {
          // Empty result set, no data
          return const SelectResult([]);
        }

        final columnCount = readInt(1);
        final columns = fullMessage.sublist(2, 2 + columnCount).cast<String>();
        final rows = readInt(2 + columnCount);

        final result = <Map<String, Object?>>[];
        for (var i = 0; i < rows; i++) {
          final rowOffset = 3 + columnCount + i * columnCount;

          result.add({
            for (var c = 0; c < columnCount; c++)
              columns[c]: _decodeDbValue(fullMessage[rowOffset + c])
          });
        }
        return SelectResult(result);
      case _tag_RequestCancellation:
        return RequestCancellation(readInt(1));
      case _tag_DirectValue:
        return PrimitiveResponsePayload.int(castInt(encoded[1]));
    }

    throw ArgumentError.value(tag, 'tag', 'Tag was unknown');
  }

  dynamic _encodeDbValue(dynamic variable) {
    if (variable is List<int> && variable is! Uint8List) {
      return Uint8List.fromList(variable);
    } else if (variable is BigInt) {
      return [_tag_BigInt, variable.toString()];
    } else {
      return variable;
    }
  }

  Object? _decodeDbValue(Object? wire) {
    if (wire is List) {
      if (wire.length == 2 && wire[0] == _tag_BigInt) {
        return BigInt.parse(wire[1].toString());
      }

      return Uint8List.fromList(wire.cast());
    }
    return wire;
  }
}

sealed class Message {}

/// A request sent over a communication channel. It is expected that the other
/// peer eventually answers with a matching response.
final class Request extends Message {
  /// The id of this request.
  ///
  /// Ids are generated by the sender, so they are only unique per direction
  /// and channel.
  final int id;

  /// The payload associated with this request.
  final RequestPayload? payload;

  Request(this.id, this.payload);

  @override
  String toString() {
    return 'Request (id = $id): $payload';
  }
}

sealed class RequestPayload {}

sealed class ResponsePayload {}

final class SuccessResponse extends Message {
  final int requestId;
  final ResponsePayload? response;

  SuccessResponse(this.requestId, this.response);

  @override
  String toString() {
    return 'SuccessResponse (id = $requestId): $response';
  }
}

final class PrimitiveResponsePayload implements ResponsePayload {
  final Object message;

  PrimitiveResponsePayload.bool(bool this.message);
  PrimitiveResponsePayload.int(int this.message);
}

final class ErrorResponse extends Message {
  final int requestId;
  final Object error;
  final StackTrace? stackTrace;

  ErrorResponse(this.requestId, this.error, [this.stackTrace]);

  @override
  String toString() {
    return 'ErrorResponse (id = $requestId): $error at $stackTrace';
  }
}

final class CancelledResponse extends Message {
  final int requestId;

  CancelledResponse(this.requestId);

  @override
  String toString() {
    return 'Previous request $requestId was cancelled';
  }
}

/// A request without further parameters
enum NoArgsRequest implements RequestPayload {
  /// Close the background isolate, disconnect all clients, release all
  /// associated resources
  terminateAll,
}

enum StatementMethod {
  custom,
  deleteOrUpdate,
  insert,
  select,
}

/// Sent from the client to run a sql query. The server replies with the
/// result.
final class ExecuteQuery implements RequestPayload {
  final StatementMethod method;
  final String sql;
  final List<dynamic> args;
  final int? executorId;

  ExecuteQuery(this.method, this.sql, this.args, [this.executorId]);

  @override
  String toString() {
    if (executorId != null) {
      return '$method: $sql with $args (@$executorId)';
    }
    return '$method: $sql with $args';
  }
}

/// Requests a previous request to be cancelled.
///
/// Whether this is supported or not depends on the server and its internal
/// state. This request will be immediately be acknowledged with a null
/// response, which does not indicate whether a cancellation actually happened.
final class RequestCancellation implements RequestPayload {
  final int originalRequestId;

  RequestCancellation(this.originalRequestId);

  @override
  String toString() {
    return 'Cancel previous request $originalRequestId';
  }
}

/// Sent from the client to run [BatchedStatements]
final class ExecuteBatchedStatement implements RequestPayload {
  final BatchedStatements stmts;
  final int? executorId;

  ExecuteBatchedStatement(this.stmts, [this.executorId]);
}

enum NestedExecutorControl {
  /// When using [beginTransaction], the [RunNestedExecutorControl.executorId]
  /// refers to the executor starting the transaction. The server must reply
  /// with an int representing the created transaction executor.
  beginTransaction,
  commit,
  rollback,

  /// This does not start a transaction, but requests a [QueryExecutor] which
  /// has exclusive control over the parent executor (meaning that no queries
  /// go through on the parent executor until the returned child executor is
  /// closed with [endExclusive]).
  ///
  /// See also: [QueryExecutor.beginExclusive], which the server calls to
  /// implement this.
  startExclusive,
  endExclusive,
}

/// Sent from the client to commit or rollback a transaction as well as managing
/// an exclusive sub-executor.
final class RunNestedExecutorControl implements RequestPayload {
  final NestedExecutorControl control;
  final int? executorId;

  RunNestedExecutorControl(this.control, this.executorId);

  @override
  String toString() {
    return 'RunTransactionAction($control, $executorId)';
  }
}

/// Sent from the client to the server. The server should open the underlying
/// database connection, using the [schemaVersion].
final class EnsureOpen implements RequestPayload {
  final int schemaVersion;
  final int? executorId;

  EnsureOpen(this.schemaVersion, this.executorId);

  @override
  String toString() {
    return 'EnsureOpen($schemaVersion, $executorId)';
  }
}

class ServerInfo implements RequestPayload {
  final SqlDialect dialect;

  ServerInfo(this.dialect);

  @override
  String toString() {
    return 'ServerInfo($dialect)';
  }
}

/// Sent from the server to the client when it should run the before open
/// callback.
final class RunBeforeOpen implements RequestPayload {
  final OpeningDetails details;
  final int createdExecutor;

  RunBeforeOpen(this.details, this.createdExecutor);

  @override
  String toString() {
    return 'RunBeforeOpen($details, $createdExecutor)';
  }
}

/// Sent to notify that a previous query has updated some tables. When a server
/// receives this message, it replies with `null` but forwards a new request
/// with this payload to all connected clients.
final class NotifyTablesUpdated implements RequestPayload {
  final List<TableUpdate> updates;

  NotifyTablesUpdated(this.updates);

  @override
  String toString() {
    return 'NotifyTablesUpdated($updates)';
  }
}

class SelectResult implements ResponsePayload {
  /// Each [Object] in [rows] is one of: [String], [int], [double], [BigInt],
  /// `List<int>`.
  final List<Map<String, Object?>> rows;

  const SelectResult(this.rows);
}

const _isDart2Wasm = bool.fromEnvironment('dart.tool.dart2wasm');

int castInt(Object? source) {
  if (_isDart2Wasm) {
    return (source as num).toInt();
  } else {
    return source as int;
  }
}

bool isInt(Object? source) {
  if (_isDart2Wasm) {
    return switch (source) {
      int _ => true,
      double jsDouble => jsDouble.toInt() == jsDouble,
      _ => false,
    };
  } else {
    return source is int;
  }
}
