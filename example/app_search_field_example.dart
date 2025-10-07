import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';

// Example model for autocomplete
class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});
}

class AppSearchFieldExample extends StatefulWidget {
  const AppSearchFieldExample({super.key});

  @override
  State<AppSearchFieldExample> createState() => _AppSearchFieldExampleState();
}

class _AppSearchFieldExampleState extends State<AppSearchFieldExample> {
  // Mock data
  final List<User> _allUsers = List.generate(
    50,
    (index) => User(
      id: 'user_$index',
      name: 'User ${index + 1}',
      email: 'user${index + 1}@example.com',
    ),
  );

  Future<List<User>> _searchUsers(String query) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    return _allUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Field Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // * Example 1: Basic search (live search)
            Text('1. Basic Live Search', style: context.textTheme.titleMedium),
            const SizedBox(height: 8),
            const AppSearchField(
              name: 'basic_search',
              hintText: 'Search...',
              label: 'Basic Search',
            ),
            const SizedBox(height: 24),

            // * Example 2: Autocomplete with default item builder
            Text(
              '2. Autocomplete (Default Style)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<User>(
              name: 'autocomplete_default',
              hintText: 'Search users...',
              label: 'Search Users',
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              onItemSelected: (user) {
                debugPrint('Selected: ${user.name} (${user.id})');
              },
            ),
            const SizedBox(height: 24),

            // * Example 3: Autocomplete with custom item builder
            Text(
              '3. Autocomplete (Custom Item)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<User>(
              name: 'autocomplete_custom',
              hintText: 'Search users...',
              label: 'Search Users (Custom)',
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemBuilder: (context, user) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: context.colors.primary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onItemSelected: (user) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${user.name}')),
                );
              },
              initialItemsToShow: 5,
              itemsPerLoadMore: 5,
              enableLoadMore: true,
              suggestionsMaxHeight: 400,
            ),
            const SizedBox(height: 24),

            // * Example 4: Autocomplete without load more
            Text(
              '4. Autocomplete (No Load More)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<User>(
              name: 'autocomplete_no_load_more',
              hintText: 'Search users...',
              label: 'Search (No Load More)',
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              enableLoadMore: false,
              initialItemsToShow: 10,
              onItemSelected: (user) {
                debugPrint('Selected: ${user.name}');
              },
            ),
            const SizedBox(height: 24),

            // * Example 5: With custom debounce
            Text(
              '5. Custom Debounce (1 second)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<User>(
              name: 'autocomplete_debounce',
              hintText: 'Search users...',
              label: 'Search (1s debounce)',
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              debounceMilliseconds: 1000,
              onItemSelected: (user) {
                debugPrint('Selected: ${user.name}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
