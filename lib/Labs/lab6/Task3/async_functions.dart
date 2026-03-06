// ─── Task 3 : Dart Async Functions ────────────────────────────────────────────

// Part 1 – Takes a string and returns it preceded by "Hello "
String addHello(String user) {
  return 'Hello $user';
}

// Part 2 – Awaits fetchUsername() then passes the result to addHello()
Future<String> greetUser() async {
  var name = await fetchUsername();  // await the async fetch
  return addHello(name);             // compose greeting synchronously
}

// Part 3 – Awaits logoutUser() inside try/catch; returns result or error message
Future<String> sayGoodbye() async {
  try {
    var result = await logoutUser();                    // await async logout
    return '$result Thanks, see you next time';         // success path
  } catch (e) {
    return 'Failed';                                    // error path
  }
}

// ─── Provided helper functions (do not modify) ────────────────────────────────

const _halfSecond = Duration(milliseconds: 500);

Future<String> fetchUsername() =>
    Future.delayed(_halfSecond, () => 'Jean');

Future<String> logoutUser() =>
    Future.delayed(_halfSecond, _failOnce);

bool _logoutSucceeds = false;

String _failOnce() {
  if (_logoutSucceeds) {
    return 'Success!';
  } else {
    _logoutSucceeds = true;
    throw Exception('Logout failed');
  }
}

// ─── Main – runs all three parts and prints pass/fail ─────────────────────────
void main() async {
  print('Testing...');

  // Part 1 – addHello
  final part1 = addHello('Jerry');
  print('Part 1: ${part1 == 'Hello Jerry' ? 'PASSED' : 'FAILED – got: $part1'}');

  // Part 2 – greetUser
  final part2 = await greetUser();
  print('Part 2: ${part2 == 'Hello Jean' ? 'PASSED' : 'FAILED – got: $part2'}');

  // Part 3 – sayGoodbye (first call fails internally, second should succeed)
  _logoutSucceeds = false;          // reset flag for clean test run
  await sayGoodbye();               // consume the intentional failure
  final part3 = await sayGoodbye(); // this call should succeed
  print('Part 3: ${part3 == 'Success! Thanks, see you next time' ? 'PASSED' : 'FAILED – got: $part3'}');
}
