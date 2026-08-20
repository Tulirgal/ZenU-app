/// Shared presentation states for the ZenU Panda companion.
enum PandaState {
  idle,
  greeting,
  happy,
  calm,
  thinking,
  listening,
  encouraging,
  celebrating,
  concerned,
  sad,
  sleeping,
  loading,
  success,
  error,
}

extension PandaStateLabel on PandaState {
  String get label {
    switch (this) {
      case PandaState.idle:
        return 'Idle';
      case PandaState.greeting:
        return 'Greeting';
      case PandaState.happy:
        return 'Happy';
      case PandaState.calm:
        return 'Calm';
      case PandaState.thinking:
        return 'Thinking';
      case PandaState.listening:
        return 'Listening';
      case PandaState.encouraging:
        return 'Encouraging';
      case PandaState.celebrating:
        return 'Celebrating';
      case PandaState.concerned:
        return 'Concerned';
      case PandaState.sad:
        return 'Sad';
      case PandaState.sleeping:
        return 'Sleeping';
      case PandaState.loading:
        return 'Loading';
      case PandaState.success:
        return 'Success';
      case PandaState.error:
        return 'Error';
    }
  }
}
