# 릴리스 빌드에서 android.util.Log 의 v/d/i 호출을 제거한다(작업지시서 L1).
# 앱·플러그인(서드파티 포함) 코드 모두에 적용된다. w/e 는 남으므로 값을 싣지 않는다.
# Flutter Gradle 플러그인이 release 에서 proguard-android-optimize.txt 와 함께 이 파일을 적용한다.
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}
