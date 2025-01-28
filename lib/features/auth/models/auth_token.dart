class AuthToken {
  final String accessToken;
  final String refreshTokens;

  AuthToken({
    required this.accessToken,
    required this.refreshTokens,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['accessToken'],
      refreshTokens: json['refreshTokens'],
    );
  }
}
