
import 'package:clean_architecture_ttd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  late final NetworkInfoImpl networkInfoImpl;
  late final MockDataConnectionChecker mockDataConnectionChecker;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });
  group('isConnected', () {
    //should return something when something called
    test('should FORWARD the call to DataConnectionChecker.hasConnection',
        () async {
      //arrange
      //to have same object pointing to same location inside the memory we use bellow variable
      final tHasConnectionFunction = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFunction);
      //act
      final result = networkInfoImpl.isConnected;
      //verify interactions with mockObjects
      verify(mockDataConnectionChecker.hasConnection);
      //assert
      //to compare executed result is same object which means networkInfoImpl.isConnected FORWARDS the DataConnectionChecker.hasConnection

      expect(result, tHasConnectionFunction);
    });
  });
}
