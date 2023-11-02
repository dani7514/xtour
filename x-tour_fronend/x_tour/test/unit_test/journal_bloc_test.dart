import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:x_tour/journal/bloc/load_journal_bloc.dart';
import 'package:x_tour/journal/models/journal.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/models/user.dart';

class MockJournalRepository extends Mock implements JournalRepository {
  @override
  Future<List<Journal>> getJournals(
      {required Map<String, dynamic> query}) async {
    return List.from(testJournals);
  }
}

class MockUserBloc extends Mock implements UserBloc {}

final User testUser = User(
  id: '1',
  password: 'testPassword',
  username: 'testUser',
  fullName: 'Test User',
  following: [],
  follower: [],
  posts: [],
  penddingPosts: [],
  journals: [],
  pendingJournal: [],
  bookmarkPosts: [],
  profilePicture: null,
);

final List<Journal> testJournals = [
  Journal(
    id: '1',
    title: 'Test Journal 1',
    link: "what",
    description: 'Test content 1',
    creator: null,
  ),
  Journal(
    id: '1',
    title: 'Test Journal 1',
    link: "what",
    description: 'Test content 1',
    creator: null,
  ),
];

void main() {
  late LoadJournalBloc loadJournalBloc;
  late MockJournalRepository mockJournalRepository;
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockJournalRepository = MockJournalRepository();
    mockUserBloc = MockUserBloc();
    loadJournalBloc = LoadJournalBloc(
      journalRepository: mockJournalRepository,
      userBloc: mockUserBloc,
    );
  });

  blocTest(
    'loadjournal emits journal loading state with the loaded journals',
    build: () => loadJournalBloc,
    act: (bloc) => bloc.add(LoadJournals()),
    expect: () => [
      JournalLoading(),
      JournalsLoaded(journals: testJournals),
    ],
  );

  // Add more tests as needed
}
