import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://192.168.203.52:5000'; // or Heroku URL
  final storage = FlutterSecureStorage();

  // ---------- USER ----------
  // Register User
  Future<bool> register(
      String name, String email, String password, File? imageFile) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');
      final request = http.MultipartRequest('POST', url)
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['password'] = password;

      // Attach image if provided
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        return true; // Registration successful
      } else {
        final responseBody = await response.stream.bytesToString();
        final error = jsonDecode(responseBody)['error'];
        print('Registration error: $error');
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Login User
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      return true;
    } else {
      return false;
    }
  }

  // Get User
  // Get User - already includes all fields, ensure 'image' is handled correctly
  Future<Map<String, dynamic>?> getUser() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error fetching user: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

// Update User (including image upload)
  Future<bool> updateUser(
      Map<String, dynamic> userData, File? imageFile) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) throw Exception('No token found');
      print('User Data: $userData'); // Debugging step

      final url = Uri.parse('$baseUrl/auth/user');
      final request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] = 'Bearer $token';

      // Add fields
      userData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add image file if provided
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      final response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('User updated successfully');
        return true;
      } else {
        print('Failed to update user. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Change Password
  Future<bool> changePassword(Map<String, String> data) async {
    final url = Uri.parse('$baseUrl/auth/change-password');
    try {
      String? token = await storage.read(key: 'token');

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Assuming success response is { success: true }
        final jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        // Handle error responses
        print('Failed to change password: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred while changing password: $e');
      return false;
    }
  }

  // 2FA Enable
  Future<Map<String, dynamic>?> enableTwoFactorAuth() async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/enable-2fa'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Typically returns QR code or secret
        return data;
      } else {
        print('Error enabling 2FA: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  // 2FA Disable
  Future<bool> disableTwoFactorAuth(String? token) async {
    try {
      String? tokenHeader = await storage.read(key: 'token');
      if (tokenHeader == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/disable-2fa'),
        headers: {
          'Authorization': 'Bearer $tokenHeader',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}), // Optional token verification
      );

      if (response.statusCode == 200) {
        return true; // 2FA disabled successfully
      } else {
        print('Error disabling 2FA: ${response.body}');
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> request2FAToken(String token) async {
    String? tokenHeader = await storage.read(key: 'token');
    if (tokenHeader == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/sendEmail2FA'),
      headers: {
        'Authorization': 'Bearer $tokenHeader',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      print('2FA token sent to email.');
    } else {
      print('Failed to send 2FA token: ${response.body}');
    }
  }

  // 2FA Verify
  Future<bool> verifyTwoFactorAuth(String token) async {
    try {
      String? tokenHeader = await storage.read(key: 'token');
      if (tokenHeader == null) throw Exception('No token found');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-2fa'),
        headers: {
          'Authorization': 'Bearer $tokenHeader',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        return true; // Verification successful
      } else {
        print('Error verifying 2FA: ${response.body}');
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // ------------------------------

  // ---------- TRANSACTIONS ----------
  // Fetch Transactions
  Future<List<dynamic>> getTransactions() async {
    String? token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Add New Transaction
  Future<bool> addTransaction(
      double amount, String category, String type, String date) async {
    String? token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'category': category,
        'type': type,
        'date': date,
      }),
    );

    return response.statusCode == 201;
  }
  // ------------------------------

  // ---------- REPORTS ----------
  // Fetch Income Report
  Future<double> getIncomeReport(String startDate, String endDate) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reports/income?start=$startDate&end=$endDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Ensure that the value is returned as a double
        return (data['totalIncome'] ?? 0.0).toDouble();
      } else {
        throw Exception('Failed to fetch income report: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Fetch Expense Report
  Future<double> getExpenseReport(String startDate, String endDate) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reports/expense?start=$startDate&end=$endDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Ensure that the value is returned as a double
        return (data['totalExpense'] ?? 0.0).toDouble();
      } else {
        throw Exception('Failed to fetch expense report: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Fetch Net Balance Report
  Future<double> getNetBalance(String startDate, String endDate) async {
    try {
      final income = await getIncomeReport(startDate, endDate);
      final expense = await getExpenseReport(startDate, endDate);
      return income - expense;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Fetch Chart Data
  Future<List<Map<String, dynamic>>> getChartData(
      String startDate, String endDate) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('$baseUrl/reports/chart-data?start=$startDate&end=$endDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Chart Data API Response: $data');
        var chartData =
            List<Map<String, dynamic>>.from(data['chartData'] ?? []);
        return chartData.map((item) {
          return {
            'date': item['date'],
            'income': (item['income'] ?? 0.0).toDouble(),
            'expense': (item['expense'] ?? 0.0).toDouble(),
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch chart data: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
  // ------------------------------
}
