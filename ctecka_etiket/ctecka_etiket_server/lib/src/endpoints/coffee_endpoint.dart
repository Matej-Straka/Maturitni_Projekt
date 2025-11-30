import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for coffee-related operations (mobile app)
class CoffeeEndpoint extends Endpoint {
  /// Get coffee by QR code
  Future<Coffee?> getCoffeeByQR(Session session, String qrCode) async {
    try {
      // Find QR code mapping
      final qrMapping = await QRCodeMapping.db.findFirstRow(
        session,
        where: (t) => t.qrCode.equals(qrCode) & t.isActive.equals(true),
      );

      if (qrMapping == null) {
        return null;
      }

      // Get the coffee
      final coffee = await Coffee.db.findById(session, qrMapping.coffeeId);
      return coffee;
    } catch (e) {
      session.log('Error getting coffee by QR: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get all active coffees
  Future<List<Coffee>> getAllCoffees(Session session) async {
    try {
      final coffees = await Coffee.db.find(session);
      return coffees;
    } catch (e) {
      session.log('Error getting all coffees: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Get coffee detail by ID
  Future<Coffee?> getCoffeeDetail(Session session, int coffeeId) async {
    try {
      final coffee = await Coffee.db.findById(session, coffeeId);
      return coffee;
    } catch (e) {
      session.log('Error getting coffee detail: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Create new coffee
  Future<Coffee> createCoffee(Session session, Coffee coffee) async {
    try {
      final created = await Coffee.db.insertRow(session, coffee);
      return created;
    } catch (e) {
      session.log('Error creating coffee: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Update coffee
  Future<Coffee> updateCoffee(Session session, Coffee coffee) async {
    try {
      final updated = await Coffee.db.updateRow(session, coffee);
      return updated;
    } catch (e) {
      session.log('Error updating coffee: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Delete coffee
  Future<bool> deleteCoffee(Session session, int coffeeId) async {
    try {
      final count = await Coffee.db.deleteWhere(session, where: (t) => t.id.equals(coffeeId));
      return count.isNotEmpty;
    } catch (e) {
      session.log('Error deleting coffee: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Get all QR codes
  Future<List<QRCodeMapping>> getAllQRCodes(Session session) async {
    try {
      final qrCodes = await QRCodeMapping.db.find(session);
      return qrCodes;
    } catch (e) {
      session.log('Error getting all QR codes: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Create QR code
  Future<QRCodeMapping> createQRCode(Session session, QRCodeMapping qrCode) async {
    try {
      final created = await QRCodeMapping.db.insertRow(session, qrCode);
      return created;
    } catch (e) {
      session.log('Error creating QR code: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Delete QR code
  Future<bool> deleteQRCode(Session session, int qrId) async {
    try {
      final count = await QRCodeMapping.db.deleteWhere(session, where: (t) => t.id.equals(qrId));
      return count.isNotEmpty;
    } catch (e) {
      session.log('Error deleting QR code: $e', level: LogLevel.error);
      return false;
    }
  }
}
