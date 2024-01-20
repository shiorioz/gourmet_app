# gourmet_app

##### レストラン情報アプリ

### 作者

shiorioz

### アプリ名

Gourmet App

#### コンセプト

近くのお店を簡単に見つける

<!-- #### こだわったポイント -->

<!-- ### 公開したアプリの URL（Store にリリースしている場合） -->
<!-- https://apps.apple.com/jp/app/xxxx -->

### 該当プロジェクトのリポジトリ URL（GitHub,GitLab など Git ホスティングサービスを利用されている場合）

https://github.com/shiorioz/gourmet_app

## 開発環境

### 開発環境

VSCode 1.85.1

### 開発言語

Flutter 3.16.7  
Dart 3.2.4

## 動作確認済み端末・OS
### 動作対象 OS
iOS 16  
Android 13 (APIレベル33)

<!-- ## 開発期間 -->
<!-- 10日間 -->

## アプリケーション機能

### 機能一覧

- レストラン検索：ホットペッパーグルメサーチ API を使用して、現在地周辺の飲食店を検索する。
- ジャンル検索：ホットペッパーグルメサーチ API を使用して、ジャンルを指定して飲食店を検索する。
- レストラン情報取得：ホットペッパーグルメサーチ API を使用して、飲食店の詳細情報を取得する。

### 画面一覧

- 検索画面 ：条件を指定してレストランを検索する。
- 一覧画面 ：検索結果の飲食店を一覧表示する。
- 詳細画面 ：飲食店の詳細を表示する。

### 使用している API,SDK,ライブラリなど

#### API

- ホットペッパーグルメサーチ API
- GoogleMap API

#### ライブラリ

- Http
- Geocoding
- google_maps_flutter
- Google Fonts
- Font Awesome
- xml
- infinite scroll pagination
- envied
- build runner
- icons_launcher

### ディレクトリ構成

    lib
    ├── components      // 再利用するウィジェットを格納するディレクトリ
    ├── pages           // 画面を格納するディレクトリ
    ├── services        // ビジネスロジックやデータアクセスロジック、API通信などを格納するディレクトリ
    ├── models          // データモデルを格納するディレクトリ
    ├── env             // 環境変数を管理するディレクトリ
    ├── constant.dart   // アプリ全体で共通して使用する定数を定義するファイル
    └── main.dart

<!-- ### アドバイスして欲しいポイント -->
