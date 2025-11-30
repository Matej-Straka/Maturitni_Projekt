import 'package:serverpod/serverpod.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Start the server.
  await pod.start();

  // Future calls are disabled
  // pod.registerFutureCall(
  //   BirthdayReminder(),
  //   FutureCallNames.birthdayReminder.name,
  // );
  
  // await pod.futureCallWithDelay(
  //   FutureCallNames.birthdayReminder.name,
  //   Greeting(
  //     message: 'Hello!',
  //     author: 'Serverpod Server',
  //     timestamp: DateTime.now(),
  //   ),
  //   Duration(seconds: 5),
  // );
}

/// Names of all future calls in the server.
///
/// This is better than using a string literal, as it will reduce the risk of
/// typos and make it easier to refactor the code.
enum FutureCallNames { birthdayReminder }
