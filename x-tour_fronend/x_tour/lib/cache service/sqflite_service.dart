import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../journal/models/journal.dart';
import '../posts/models/post.dart';
import '../user/models/user.dart';

class SqfliteService {
  Database? _database;

  Future<void> initSqflite() async {
    final databasePath = await getDatabasesPath();
    final pathToDatabase = path.join(databasePath, 'my_database.db');
    _database = await openDatabase(pathToDatabase, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE users (
            _id TEXT PRIMARY KEY,
            password TEXT,
            username TEXT,
            fullName TEXT,
            following TEXT,
            follower TEXT,
            posts TEXT,
            penddingPosts TEXT,
            journals TEXT,
            pendingJournal TEXT,
            bookmarkPosts TEXT,
            profilePicture TEXT,
            role TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE bookmarked_posts (
            _id TEXT PRIMARY KEY,
            story TEXT,
            description TEXT,
            likes TEXT,
            creator TEXT,
            images TEXT,
            comments TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE searched_posts (
            _id TEXT PRIMARY KEY,
            story TEXT,
            description TEXT,
            likes TEXT,
            creator TEXT,
            images TEXT,
            comments TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE pending_posts (
            _id TEXT PRIMARY KEY,
            story TEXT,
            description TEXT,
            likes TEXT,
            creator TEXT,
            images TEXT,
            comments TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE approved_posts (
            _id TEXT PRIMARY KEY,
            story TEXT,
            description TEXT,
            likes TEXT,
            creator TEXT,
            images TEXT,
            comments TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE feeds (
            _id TEXT PRIMARY KEY,
            story TEXT,
            description TEXT,
            likes TEXT,
            creator TEXT,
            images TEXT,
            comments TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE journals (
            _id TEXT PRIMARY KEY,
            creator TEXT,
            title TEXT,
            link TEXT,
            image TEXT,
            description TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE pending_journals (
            _id TEXT PRIMARY KEY,
            creator TEXT,
            title TEXT,
            link TEXT,
            image TEXT,
            description TEXT
          )
          ''');
      await db.execute('''
          CREATE TABLE approved_journals (
            _id TEXT PRIMARY KEY,
            creator TEXT,
            title TEXT,
            link TEXT,
            image TEXT,
            description TEXT
          )
          ''');
    });
  }

  Future<void> addUser(User user) async {
    await _database!.delete('users');
    await _database!.insert('users', user.toMap());
  }

  Future<void> addBookmarkedPost(Posts post) async {
    await _database!.insert('bookmarked_posts', post.toMap());
  }

  Future<void> addSearchedPost(Posts post) async {
    await _database!.insert('searched_posts', post.toMap());
  }

  Future<void> addPendingPost(Posts post) async {
    await _database!.insert('pending_posts', post.toMap());
  }

  Future<void> addApprovedPost(Posts post) async {
    await _database!.insert('approved_posts', post.toMap());
  }

  Future<void> addFeedPost(Posts post) async {
    await _database!.insert('feeds', post.toMap());
  }

  Future<void> addJournal(Journal journal) async {
    await _database!.insert('journals', journal.toMap());
  }

  Future<void> addPendingJournal(Journal journal) async {
    await _database!.insert('pending_journals', journal.toMap());
  }

  Future<void> addApprovedJournal(Journal journal) async {
    await _database!.insert('approved_journals', journal.toMap());
  }

  Future<void> addBookmarkedPosts(List<Posts> posts, [remove = true]) async {
    if (remove) await _database!.delete('bookmarked_posts');
    for (var post in posts) {
      await _database!.insert('bookmarked_posts', post.toMap());
    }
  }

  Future<void> addSearchedPosts(List<Posts> posts, [remove = true]) async {
    if (remove) await _database!.delete('searched_posts');
    for (var post in posts) {
      await _database!.insert('searched_posts', post.toMap());
    }
  }

  Future<void> addPendingPosts(List<Posts> posts, [remove = true]) async {
    if (remove) await _database!.delete('pending_posts');
    for (var post in posts) {
      await _database!.insert('pending_posts', post.toMap());
    }
  }

  Future<void> addApprovedPosts(List<Posts> posts, [remove = true]) async {
    if (remove) await _database!.delete('approved_posts');
    for (var post in posts) {
      await _database!.insert('approved_posts', post.toMap());
    }
  }

  Future<void> addFeedPosts(List<Posts> posts, [remove = true]) async {
    if (remove) await _database!.delete('feeds');
    for (var post in posts) {
      await _database!.insert('feeds', post.toMap());
    }
  }

  Future<void> addJournals(List<Journal> journals, [remove = true]) async {
    if (remove) await _database!.delete('journals');
    for (var journal in journals) {
      await _database!.insert('journals', journal.toMap());
    }
  }

  Future<void> addPendingJournals(List<Journal> journals,
      [remove = true]) async {
    if (remove) await _database!.delete('pending_journals');
    for (var journal in journals) {
      await _database!.insert('pending_journals', journal.toMap());
    }
  }

  Future<void> addApprovedJournals(List<Journal> journals,
      [remove = true]) async {
    if (remove) await _database!.delete('approved_journals');
    for (var journal in journals) {
      await _database!.insert('approved_journals', journal.toMap());
    }
  }

  Future<List<User>> getUsers() async {
    final userList = <User>[];
    final result = await _database?.query('users') ?? [];
    result.forEach((row) {
      final user = User.fromMap(row);
      userList.add(user);
    });
    return userList;
  }

  Future<List<Posts>> getBookmarkedPosts() async {
    final postList = <Posts>[];
    final result = await _database!.query('bookmarked_posts');
    result.forEach((row) {
      final post = Posts.fromMap(row);
      postList.add(post);
    });
    return postList;
  }

  Future<List<Posts>> getSearchedPosts() async {
    final postList = <Posts>[];
    final result = await _database!.query('searched_posts');
    result.forEach((row) {
      final post = Posts.fromMap(row);
      postList.add(post);
    });
    return postList;
  }

  Future<List<Posts>> getPendingPosts() async {
    final postList = <Posts>[];
    final result = await _database!.query('pending_posts');
    result.forEach((row) {
      final post = Posts.fromMap(row);
      postList.add(post);
    });
    return postList;
  }

  Future<List<Posts>> getApprovedPosts() async {
    final postList = <Posts>[];
    final result = await _database!.query('approved_posts');
    result.forEach((row) {
      final post = Posts.fromMap(row);
      postList.add(post);
    });
    return postList;
  }

  Future<List<Posts>> getFeedPosts() async {
    final postList = <Posts>[];
    final result = await _database!.query('feeds');
    result.forEach((row) {
      final post = Posts.fromMap(row);
      postList.add(post);
    });
    return postList;
  }

  Future<List<Journal>> getJournals() async {
    final journalList = <Journal>[];
    final result = await _database!.query('journals');
    result.forEach((row) {
      final journal = Journal.fromMap(row);
      journalList.add(journal);
    });
    return journalList;
  }

  Future<List<Journal>> getPendingJournals() async {
    final journalList = <Journal>[];
    final result = await _database!.query('pending_journals');
    result.forEach((row) {
      final journal = Journal.fromMap(row);
      journalList.add(journal);
    });
    return journalList;
  }

  Future<List<Journal>> getApprovedJournals() async {
    final journalList = <Journal>[];
    final result = await _database!.query('approved_journals');
    result.forEach((row) {
      final journal = Journal.fromMap(row);
      journalList.add(journal);
    });
    return journalList;
  }

  Future<User?> getUser() async {
    final results = await getUsers();
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<Posts?> getBookmarkedPost(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'bookmarked_posts',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Posts.fromMap(results.first);
    }
    return null;
  }

  Future<Posts?> getSearchedPost(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'searched_posts',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Posts.fromMap(results.first);
    }
    return null;
  }

  Future<Posts?> getPendingPost(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'pending_posts',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Posts.fromMap(results.first);
    }
    return null;
  }

  Future<Posts?> getApprovedPost(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'approved_posts',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Posts.fromMap(results.first);
    }
    return null;
  }

  Future<Posts?> getFeedPost(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'feeds',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Posts.fromMap(results.first);
    }
    return null;
  }

  Future<Journal?> getJournal(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'journals',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Journal.fromMap(results.first);
    }
    return null;
  }

  Future<Journal?> getPendingJournal(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'pending_journals',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Journal.fromMap(results.first);
    }
    return null;
  }

  Future<Journal?> getApprovedJournal(String id) async {
    final List<Map<String, dynamic>> results = await _database!.query(
      'approved_journals',
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return Journal.fromMap(results.first);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _database!.update(
      'users',
      user.toMap(),
      where: '_id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> updateBookmarkedPost(Posts post) async {
    await _database!.update(
      'bookmarked_posts',
      post.toMap(),
      where: '_id = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> updateSearchedPost(Posts post) async {
    await _database!.update(
      'searched_posts',
      post.toMap(),
      where: '_id = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> updatePendingPost(Posts post) async {
    await _database!.update(
      'pending_posts',
      post.toMap(),
      where: '_id = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> updateApprovedPost(Posts post) async {
    await _database!.update(
      'approved_posts',
      post.toMap(),
      where: '_id = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> updateFeedPost(Posts post) async {
    await _database!.update(
      'feeds',
      post.toMap(),
      where: '_id = ?',
      whereArgs: [post.id],
    );
  }

  Future<void> updateJournal(Journal journal) async {
    await _database!.update(
      'journals',
      journal.toMap(),
      where: '_id = ?',
      whereArgs: [journal.id],
    );
  }

  Future<void> updatePendingJournal(Journal journal) async {
    await _database!.update(
      'pending_journals',
      journal.toMap(),
      where: '_id = ?',
      whereArgs: [journal.id],
    );
  }

  Future<void> updateApprovedJournal(Journal journal) async {
    await _database!.update(
      'approved_journals',
      journal.toMap(),
      where: '_id = ?',
      whereArgs: [journal.id],
    );
  }

  Future<void> deleteUser(String id) async {
    await _database!.delete('users', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteBookmarkedPost(String id) async {
    await _database!
        .delete('bookmarked_posts', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteSearchedPost(String id) async {
    await _database!
        .delete('searched_posts', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deletePendingPost(String id) async {
    await _database!.delete('pending_posts', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteApprovedPost(String id) async {
    await _database!
        .delete('approved_posts', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteFeedPost(String id) async {
    await _database!.delete('feeds', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteJournal(String id) async {
    await _database!.delete('journals', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deletePendingJournal(String id) async {
    await _database!
        .delete('pending_journals', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteApprovedJournal(String id) async {
    await _database!
        .delete('approved_journals', where: '_id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    await _database!.delete('users');
    await _database!.delete('bookmarked_posts');
    await _database!.delete('searched_posts');
    await _database!.delete('pending_posts');
    await _database!.delete('approved_posts');
    await _database!.delete('feeds');
    await _database!.delete('journals');
    await _database!.delete('pending_journals');
    await _database!.delete('approved_journals');
  }
}
