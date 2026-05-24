class MockLocationStatus {
  final bool isMocked;
  final String? errorMessage;

  const MockLocationStatus({
    required this.isMocked,
    this.errorMessage,
  });

  factory MockLocationStatus.safe() =>
      const MockLocationStatus(isMocked: false);

  factory MockLocationStatus.mocked() =>
      const MockLocationStatus(isMocked: true);

  factory MockLocationStatus.error(String message) =>
      MockLocationStatus(isMocked: false, errorMessage: message);
}
