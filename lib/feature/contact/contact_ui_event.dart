sealed class ContactUiEvent {
  const ContactUiEvent();
}

class FetchContactFailure extends ContactUiEvent {
  const FetchContactFailure();
}

class UpdateRepresentativeContactFailure extends ContactUiEvent {
  const UpdateRepresentativeContactFailure();
}
