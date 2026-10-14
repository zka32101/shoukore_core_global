/// 1台の端末を複数の子どもで共有する家庭向けの、子どもプロファイル。
/// `birthYear`は`AgeGate`の判定に使う想定（必須ではない）。
class Profile {
  const Profile({required this.id, required this.displayName, this.birthYear});

  final String id;
  final String displayName;
  final int? birthYear;
}
