import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/admin/pending_journal/repository/pending_journal_repository.dart';
import 'package:x_tour/admin/pending_post/repository/pending_post_repository.dart';
import 'package:x_tour/admin/user/auth/bloc/auth_bloc.dart';
import 'package:x_tour/admin/user/login/bloc/login_bloc.dart';
import 'package:x_tour/admin/user/repsitory/auth_repository.dart';
import 'package:x_tour/route/router.dart';

import 'admin/pending_journal/data/pending_journal_service.dart';
import 'admin/pending_post/data/pending_post_service.dart';
import 'admin/user/data/auth_service.dart';
import 'chopper convertor/chopper_convertor.dart';

void main() {
  final chopperClient = ChopperClient(
      baseUrl: Uri.parse("http://10.0.2.2:3000"),
      services: [PendingPostService.create(), PendingJournalService.create()],
      converter: ChopperConvetor());
  final chopperClient2 = ChopperClient(
      baseUrl: Uri.parse("http://10.0.2.2:3000"),
      services: [AuthService.create()],
      converter: const JsonConverter());
  PendingPostService pendingPostService =
      PendingPostService.create(chopperClient);
  PendingJournalService pendingJournalService =
      PendingJournalService.create(chopperClient);
  AuthService authService = AuthService.create(chopperClient2);

  AuthRepository authRepository = AuthRepository(authService: authService);
  AuthBloc authBloc = AuthBloc(authRepository: authRepository);
  authBloc..add(InitApp());

  LoginBloc loginBloc =
      LoginBloc(authBloc: authBloc, authRepository: authRepository);

  PendingJournalRepository pendingJournalRepository = PendingJournalRepository(
      pendingJournalService: pendingJournalService, authBloc: authBloc);
  PendingPostRepository pendingPostRepository = PendingPostRepository(
      pendingPostService: pendingPostService, authBloc: authBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: authBloc,
        ),
        BlocProvider.value(value: loginBloc),
      ],
      child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: pendingPostRepository,
            ),
            RepositoryProvider.value(value: pendingJournalRepository),
          ],
          child: AppRoute(
            authBloc: authBloc,
          )),
    ),
  );
}
