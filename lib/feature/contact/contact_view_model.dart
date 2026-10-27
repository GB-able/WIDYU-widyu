import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/feature/contact/contact_ui_event.dart';
import 'package:widyu/feature/contact/contact_ui_state.dart';

class ContactViewModel with ChangeNotifier {
  final MyPageRepository _repository;

  ContactUiState _uiState = const ContactUiState();
  ContactUiState get uiState => _uiState;

  final _uiEvent = StreamController<ContactUiEvent>.broadcast();
  Stream<ContactUiEvent> get uiEvent => _uiEvent.stream;

  ContactViewModel({required MyPageRepository repository})
      : _repository = repository {
    _fetchContact();
  }

  Future<void> updateRepresentativeContact(int memberId) async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.updateRepresentativeContact(memberId);
    if (result is Success) {
      await _fetchContact();
    } else {
      _uiEvent.add(const UpdateRepresentativeContactFailure());
    }
  }

  Future<void> _fetchContact() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchContact();
    if (result is Success) {
      final data = (result as Success<Contact>).data;
      _uiState = _uiState.copyWith(
        representative: data.representative,
        familyMembers: [...data.familyMembers]..sort((a, b) {
            if (a.isRepresentative == b.isRepresentative) return 0;
            return a.isRepresentative ? -1 : 1;
          }),
      );
    } else {
      _uiEvent.add(const FetchContactFailure());
    }
    _uiState = _uiState.copyWith(isLoading: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _uiEvent.close();
    super.dispose();
  }
}
