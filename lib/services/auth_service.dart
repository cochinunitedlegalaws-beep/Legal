import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import '../models/ModelProvider.dart';

class AuthService {
  /// Authenticate a user by email and password using Cognito
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {


      SignInResult? result;
      try {
        result = await Amplify.Auth.signIn(
          username: email.toLowerCase().trim(),
          password: password,
        );
      } on AuthException catch (e) {
        if (e is InvalidStateException && e.message.contains('already signed in')) {
          await Amplify.Auth.signOut();
          result = await Amplify.Auth.signIn(
            username: email,
            password: password,
          );
        } else if (e.toString().contains('UserNotConfirmedException') || e is UserNotConfirmedException) {
          return null;
        } else {
          rethrow;
        }
      }
      
      print('Sign In Result: ${result?.nextStep.signInStep}');
      
      if (result != null && result.nextStep.signInStep == AuthSignInStep.confirmSignInWithNewPassword) {
        print('Confirming new password silently...');
        result = await Amplify.Auth.confirmSignIn(confirmationValue: password);
        print('Confirm result: ${result.nextStep.signInStep}');
      }

      if (result != null && result.isSignedIn) {
        final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
        final accessToken = session.userPoolTokensResult.value.accessToken;
        final groups = accessToken.groups;
        
        String role = 'Staff';
        if (groups.contains('Admin') || email.toLowerCase() == 'admin@cochinunited.com') {
          role = 'Admin';
        } else if (groups.contains('Manager')) {
          role = 'Manager';
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
        await prefs.setString('user_role', role);
        
        // Fetch user from Users table to get name and id
        final req = ModelQueries.list(Users.classType, where: Users.EMAIL.eq(email));
        final res = await Amplify.API.query(request: req).response;
        String name = 'Unknown';
        String id = '0';
        
        if (res.data?.items.isNotEmpty == true) {
           final user = res.data!.items.first!;
           name = user.name ?? 'Unknown';
           id = user.id;
        }

        await prefs.setString('user_name', name);
        int? intId = int.tryParse(id);
        if (intId != null) {
          await prefs.setInt('current_user_id', intId);
        } else {
          await prefs.setString('current_user_id_string', id);
          await prefs.setInt('current_user_id', id.hashCode);
        }
        
        // TODO: In a real SaaS, fetch this from the user's profile in Cognito or Users table.
        String tenantId = 'TENANT_CUC_001'; 
        await prefs.setString('tenant_id', tenantId);

        return {
          'email': email,
          'role': role,
          'name': name,
          'id': id,
          'tenant_id': tenantId,
        };
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Update user's password using Cognito
  static Future<bool> updatePassword(String email, String newPassword) async {
    try {
      // In Cognito, update password requires old password. 
      // If we are admin, we can't do it here easily without admin reset.
      // Since this is just a stub, we print an error.
      print('Password update should be done via Amplify.Auth.updatePassword');
      return false;
    } catch (e) {
      print('Update password error: $e');
      return false;
    }
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  /// Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Get user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  /// Get user id
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_user_id');
  }

  /// Check if admin
  Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role?.toLowerCase() == 'admin';
  }

  /// Check if manager
  Future<bool> isManager() async {
    final role = await getUserRole();
    return role?.toLowerCase() == 'manager';
  }
}

