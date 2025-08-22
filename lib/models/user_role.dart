enum UserRole {
  parent,
  child,
  psychologist;

  String get displayName {
    switch (this) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.child:
        return 'Child';
      case UserRole.psychologist:
        return 'Psychologist';
    }
  }

  String get route {
    switch (this) {
      case UserRole.parent:
        return '/parent';
      case UserRole.child:
        return '/child';
      case UserRole.psychologist:
        return '/psychologist';
    }
  }

  static UserRole fromString(String role) {
    final cleanRole = role.toLowerCase().trim();
    switch (cleanRole) {
      case 'parent':
        return UserRole.parent;
      case 'child':
        return UserRole.child;
      case 'psychologist':
        return UserRole.psychologist;
      default:
        print('Warning: Invalid role "$role", defaulting to parent');
        return UserRole.parent; // Default to parent instead of throwing
    }
  }
}
