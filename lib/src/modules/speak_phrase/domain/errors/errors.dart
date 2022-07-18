abstract class IPhraseException {
  final String message;
  final StackTrace? stackTrace;

  const IPhraseException(this.message, [this.stackTrace]);
}

class DatasourcePhraseException extends IPhraseException {
  const DatasourcePhraseException(super.message, [super.stackTrace]);
}
