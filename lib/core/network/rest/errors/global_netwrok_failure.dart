// import 'dart:async';


// class NetworkHelper {
//   NetworkHelper() : _isConnected = true {
//     onStatusChange.listen((state) {
//       _isConnected = state;
//     });
//   }
//   bool _isConnected;
//   bool get isConnected => _isConnected;

//   Stream<bool> get onStatusChange {
//     return InternetConnection().onStatusChange.map((status) {
//       return status == InternetStatus.connected;
//     });
//   }
// }