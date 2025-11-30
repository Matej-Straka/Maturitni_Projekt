/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/coffee_endpoint.dart' as _i3;
import '../endpoints/upload_endpoint.dart' as _i4;
import '../greeting_endpoint.dart' as _i5;
import 'package:ctecka_etiket_server/src/generated/coffee.dart' as _i6;
import 'package:ctecka_etiket_server/src/generated/qr_code.dart' as _i7;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'coffee': _i3.CoffeeEndpoint()
        ..initialize(
          server,
          'coffee',
          null,
        ),
      'upload': _i4.UploadEndpoint()
        ..initialize(
          server,
          'upload',
          null,
        ),
      'greeting': _i5.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'createCoffee': _i1.MethodConnector(
          name: 'createCoffee',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'composition': _i1.ParameterDescription(
              name: 'composition',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'moreInfo': _i1.ParameterDescription(
              name: 'moreInfo',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'videoUrl': _i1.ParameterDescription(
              name: 'videoUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageUrl': _i1.ParameterDescription(
              name: 'imageUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).createCoffee(
            session,
            params['username'],
            params['password'],
            params['name'],
            params['description'],
            params['composition'],
            params['moreInfo'],
            params['videoUrl'],
            params['imageUrl'],
          ),
        ),
        'updateCoffee': _i1.MethodConnector(
          name: 'updateCoffee',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'coffeeId': _i1.ParameterDescription(
              name: 'coffeeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'composition': _i1.ParameterDescription(
              name: 'composition',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'moreInfo': _i1.ParameterDescription(
              name: 'moreInfo',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'videoUrl': _i1.ParameterDescription(
              name: 'videoUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageUrl': _i1.ParameterDescription(
              name: 'imageUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).updateCoffee(
            session,
            params['username'],
            params['password'],
            params['coffeeId'],
            params['name'],
            params['description'],
            params['composition'],
            params['moreInfo'],
            params['videoUrl'],
            params['imageUrl'],
          ),
        ),
        'deleteCoffee': _i1.MethodConnector(
          name: 'deleteCoffee',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'coffeeId': _i1.ParameterDescription(
              name: 'coffeeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).deleteCoffee(
            session,
            params['username'],
            params['password'],
            params['coffeeId'],
          ),
        ),
        'assignQRCode': _i1.MethodConnector(
          name: 'assignQRCode',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'qrCode': _i1.ParameterDescription(
              name: 'qrCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'coffeeId': _i1.ParameterDescription(
              name: 'coffeeId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).assignQRCode(
            session,
            params['username'],
            params['password'],
            params['qrCode'],
            params['coffeeId'],
          ),
        ),
        'getAllQRMappings': _i1.MethodConnector(
          name: 'getAllQRMappings',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllQRMappings(
            session,
            params['username'],
            params['password'],
          ),
        ),
        'deleteQRMapping': _i1.MethodConnector(
          name: 'deleteQRMapping',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mappingId': _i1.ParameterDescription(
              name: 'mappingId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).deleteQRMapping(
            session,
            params['username'],
            params['password'],
            params['mappingId'],
          ),
        ),
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'adminUsername': _i1.ParameterDescription(
              name: 'adminUsername',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminPassword': _i1.ParameterDescription(
              name: 'adminPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newUsername': _i1.ParameterDescription(
              name: 'newUsername',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).createUser(
            session,
            params['adminUsername'],
            params['adminPassword'],
            params['newUsername'],
            params['newPassword'],
            params['email'],
            params['role'],
          ),
        ),
        'getAllUsers': _i1.MethodConnector(
          name: 'getAllUsers',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllUsers(
            session,
            params['username'],
            params['password'],
          ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).login(
            session,
            params['username'],
            params['password'],
          ),
        ),
        'uploadFileBase64': _i1.MethodConnector(
          name: 'uploadFileBase64',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileDataBase64': _i1.ParameterDescription(
              name: 'fileDataBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileType': _i1.ParameterDescription(
              name: 'fileType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).uploadFileBase64(
            session,
            params['username'],
            params['password'],
            params['fileName'],
            params['fileDataBase64'],
            params['fileType'],
          ),
        ),
        'getAllMedia': _i1.MethodConnector(
          name: 'getAllMedia',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAllMedia(
            session,
            params['username'],
            params['password'],
          ),
        ),
        'deleteMedia': _i1.MethodConnector(
          name: 'deleteMedia',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'mediaId': _i1.ParameterDescription(
              name: 'mediaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).deleteMedia(
            session,
            params['username'],
            params['password'],
            params['mediaId'],
          ),
        ),
      },
    );
    connectors['coffee'] = _i1.EndpointConnector(
      name: 'coffee',
      endpoint: endpoints['coffee']!,
      methodConnectors: {
        'getCoffeeByQR': _i1.MethodConnector(
          name: 'getCoffeeByQR',
          params: {
            'qrCode': _i1.ParameterDescription(
              name: 'qrCode',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).getCoffeeByQR(
            session,
            params['qrCode'],
          ),
        ),
        'getAllCoffees': _i1.MethodConnector(
          name: 'getAllCoffees',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint)
                  .getAllCoffees(session),
        ),
        'getCoffeeDetail': _i1.MethodConnector(
          name: 'getCoffeeDetail',
          params: {
            'coffeeId': _i1.ParameterDescription(
              name: 'coffeeId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).getCoffeeDetail(
            session,
            params['coffeeId'],
          ),
        ),
        'createCoffee': _i1.MethodConnector(
          name: 'createCoffee',
          params: {
            'coffee': _i1.ParameterDescription(
              name: 'coffee',
              type: _i1.getType<_i6.Coffee>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).createCoffee(
            session,
            params['coffee'],
          ),
        ),
        'updateCoffee': _i1.MethodConnector(
          name: 'updateCoffee',
          params: {
            'coffee': _i1.ParameterDescription(
              name: 'coffee',
              type: _i1.getType<_i6.Coffee>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).updateCoffee(
            session,
            params['coffee'],
          ),
        ),
        'deleteCoffee': _i1.MethodConnector(
          name: 'deleteCoffee',
          params: {
            'coffeeId': _i1.ParameterDescription(
              name: 'coffeeId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).deleteCoffee(
            session,
            params['coffeeId'],
          ),
        ),
        'getAllQRCodes': _i1.MethodConnector(
          name: 'getAllQRCodes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint)
                  .getAllQRCodes(session),
        ),
        'createQRCode': _i1.MethodConnector(
          name: 'createQRCode',
          params: {
            'qrCode': _i1.ParameterDescription(
              name: 'qrCode',
              type: _i1.getType<_i7.QRCodeMapping>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).createQRCode(
            session,
            params['qrCode'],
          ),
        ),
        'deleteQRCode': _i1.MethodConnector(
          name: 'deleteQRCode',
          params: {
            'qrId': _i1.ParameterDescription(
              name: 'qrId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['coffee'] as _i3.CoffeeEndpoint).deleteQRCode(
            session,
            params['qrId'],
          ),
        ),
      },
    );
    connectors['upload'] = _i1.EndpointConnector(
      name: 'upload',
      endpoint: endpoints['upload']!,
      methodConnectors: {
        'uploadFile': _i1.MethodConnector(
          name: 'uploadFile',
          params: {
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'fileType': _i1.ParameterDescription(
              name: 'fileType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['upload'] as _i4.UploadEndpoint).uploadFile(
            session,
            params['fileName'],
            params['fileData'],
            params['fileType'],
          ),
        ),
        'deleteFile': _i1.MethodConnector(
          name: 'deleteFile',
          params: {
            'fileUrl': _i1.ParameterDescription(
              name: 'fileUrl',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['upload'] as _i4.UploadEndpoint).deleteFile(
            session,
            params['fileUrl'],
          ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['greeting'] as _i5.GreetingEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
  }
}
