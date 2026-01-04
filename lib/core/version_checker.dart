import 'dart:convert';
import 'package:http/http.dart' as http;

/// Utility class to check for new tags/releases on GitHub
class VersionChecker {
  final String owner;
  final String repo;
  final String baseUrl;

  VersionChecker({
    required this.owner,
    required this.repo,
    this.baseUrl = 'https://api.github.com',
  });

  /// Check if there's a new tag after the given version
  /// Returns the latest tag if there's a newer one, null otherwise
  Future<String?> checkForNewTag(String currentVersion) async {
    try {
      final tags = await fetchAllTags();
      if (tags.isEmpty) return null;

      // Sort tags by version (semantic versioning)
      tags.sort((a, b) => _compareVersions(b, a));

      final latestTag = tags.first;
      final latestVersion = _normalizeVersion(latestTag);
      final currentVersionNormalized = _normalizeVersion(currentVersion);

      if (_compareVersions(latestVersion, currentVersionNormalized) > 0) {
        return latestTag;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch all tags from GitHub API
  Future<List<String>> fetchAllTags({int perPage = 100}) async {
    final List<String> allTags = [];
    int page = 1;

    while (true) {
      final url = Uri.parse(
        '$baseUrl/repos/$owner/$repo/tags?per_page=$perPage&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch tags: ${response.statusCode}',
        );
      }

      final List<dynamic> tags = json.decode(response.body);
      if (tags.isEmpty) break;

      for (var tag in tags) {
        allTags.add(tag['name'] as String);
      }

      // If we got fewer tags than perPage, we've reached the end
      if (tags.length < perPage) break;

      page++;
    }

    return allTags;
  }

  /// Get the latest tag
  Future<String?> getLatestTag() async {
    try {
      final tags = await fetchAllTags();
      if (tags.isEmpty) return null;

      // Sort tags by version
      tags.sort((a, b) => _compareVersions(b, a));
      return tags.first;
    } catch (e) {
      return null;
    }
  }

  /// Normalize version string (remove 'v' prefix, handle edge cases)
  String _normalizeVersion(String version) {
    // Remove 'v' prefix if present
    version = version.replaceFirst(RegExp(r'^v'), '');
    return version.trim();
  }

  /// Compare two version strings
  /// Returns: >0 if v1 > v2, 0 if v1 == v2, <0 if v1 < v2
  int _compareVersions(String v1, String v2) {
    v1 = _normalizeVersion(v1);
    v2 = _normalizeVersion(v2);

    final parts1 = v1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parts2 = v2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad with zeros to make same length
    while (parts1.length < parts2.length) parts1.add(0);
    while (parts2.length < parts1.length) parts2.add(0);

    for (int i = 0; i < parts1.length; i++) {
      if (parts1[i] > parts2[i]) return 1;
      if (parts1[i] < parts2[i]) return -1;
    }

    return 0;
  }
}

