/// Role-Based Access Control Service
/// Manages permissions for different user roles (Staff, Manager, Admin)

library role_service;

class RoleService {
  /// User roles
  static const String roleStaff = 'Staff';
  static const String roleManager = 'Manager';
  static const String roleAdmin = 'Admin';

  /// Check if user is manager or above
  static bool isManagerOrAbove(String userRole) {
    return userRole == roleManager || userRole == roleAdmin;
  }

  /// Check if user has supreme authority (Admin)
  static bool isSupremeAuthority(String userRole) {
    return userRole == roleAdmin;
  }

  /// Check if user can manage billing
  static bool canManageBilling(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can delete cases
  static bool canDeleteCases(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can edit/delete a specific item
  /// Returns true if:
  /// - User is Manager or Admin (supreme authority), OR
  /// - User is the owner of the item
  static bool canEditItem({
    required String userRole,
    required String currentUserEmail,
    required String? itemOwnerEmail,
  }) {
    if (isManagerOrAbove(userRole)) {
      return true; // Managers have supreme authority
    }
    return currentUserEmail == itemOwnerEmail;
  }

  /// Check if user can view staff roster
  static bool canViewStaffRoster(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can assign tasks
  static bool canAssignTasks(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can manage cases
  static bool canManageCases(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can manage clients
  static bool canManageClients(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can approve timesheets/expenses
  static bool canApprove(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Check if user can toggle other staff check-in status
  static bool canToggleOtherStaffCheckIn(String userRole) {
    return isManagerOrAbove(userRole);
  }

  /// Get role display name
  static String getRoleDisplayName(String userRole) {
    switch (userRole) {
      case roleManager:
        return 'Manager';
      case roleAdmin:
        return 'IT Admin';
      case roleStaff:
      default:
        return 'Staff';
    }
  }

  /// Get role icon
  static String getRoleIcon(String userRole) {
    switch (userRole) {
      case roleManager:
        return '👔';
      case roleAdmin:
        return '🛡️';
      case roleStaff:
      default:
        return '👤';
    }
  }

  /// Check if a staff member can edit a case
  /// Returns true if:
  /// - User is Manager or Admin (supreme authority), OR
  /// - User is a responsible person on the case AND has been approved/is the case creator
  static bool canEditCase({
    required String userRole,
    required String currentUserEmail,
    required List<dynamic> responsiblePeople, // List of Responsibility objects
    required String? caseCreatedBy,
  }) {
    if (isManagerOrAbove(userRole)) {
      return true; // Managers have supreme authority
    }

    // Staff can edit if they created the case
    if (currentUserEmail == caseCreatedBy) {
      return true;
    }

    // Staff can edit if they are a responsible person on the case
    // Check if current user is in responsible people
    for (var person in responsiblePeople) {
      if (person is Map && person['staffEmail'] == currentUserEmail) {
        // User is responsible - they can edit their own work
        return true;
      }
    }

    return false;
  }

  /// Check if a staff member needs approval to edit a case
  /// Returns true if:
  /// - User is NOT Manager/Admin AND
  /// - User is NOT the case creator AND
  /// - There are other responsible people on the case
  static bool needsApprovalToEdit({
    required String userRole,
    required String currentUserEmail,
    required List<dynamic> responsiblePeople,
    required String? caseCreatedBy,
  }) {
    if (isManagerOrAbove(userRole)) {
      return false; // Managers don't need approval
    }

    if (currentUserEmail == caseCreatedBy) {
      return false; // Case creator doesn't need approval
    }

    // Check if there are other responsible people
    return responsiblePeople.isNotEmpty;
  }

  /// Get list of people who need to approve edits
  static List<String> getApprovalsRequired({
    required String currentUserEmail,
    required List<dynamic> responsiblePeople,
  }) {
    final approvers = <String>[];

    for (var person in responsiblePeople) {
      if (person is Map && person['staffEmail'] != currentUserEmail) {
        approvers.add(person['staffEmail']);
      }
    }

    return approvers;
  }

  /// Check if all required approvals have been received
  static bool hasAllApprovalsForEdit({
    required List<dynamic> responsiblePeople,
  }) {
    for (var person in responsiblePeople) {
      if (person is Map && person['isApprovalRequired'] == true) {
        if (person['hasApproved'] != true) {
          return false; // At least one required approval is missing
        }
      }
    }
    return true;
  }
}
