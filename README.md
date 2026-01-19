# CMakeによる外部公開ライブラリパッケージの作成テスト

CMakeのコンフィグモードによる外部公開用のライブラリパッケージを作成するテスト環境。  
本リポジトリは、ビルド環境に Docker コンテナを利用し、コンテナの生成から、  
必要リソース群の取得、ビルドの実行まで行う環境となっている。  
コンテナはエフェメラルに動作(都度起動し終了時に破棄)する。  
また、コンテナ内のユーザー権限はホスト側のユーザーで動作する。

## ライブラリパッケージ構成のポイント

作成したライブラリを利用する際、find_package() によるパッケージの指定と、  
target_link_libraries() でライブラリの指定のみで公開ヘッダーのディレクトリ指定と  
リンクが自動的にされるようにするには以下のポイントが必要。

- set_target_properties() で PUBLIC_HEADER の指定
- target_include_directories() で PUBLIC 指定かつ  
  ビルド時とインストール時のインクルードディレクトリの切り替え
- install() で PUBLIC_HEADER のインストール

## ファイル構成

```text
test-cmake-library/
|-- docker/ ....................... x86-64 Ubuntu 開発環境他
|-- cmake/ ........................ CMakeモジュール
|-- src/ .......................... ライブラリソース
|   |-- CMakeLists.txt ............ ライブラリ作成用CMakeファイル
|   |-- config.cmake.in ........... CMakeコンフィグ生成テンプレート
|   |-- executor.cpp .............. ライブラリ
|   `-- executor.hpp .............. ライブラリ公開ヘッダー
|-- test/ ......................... テスト用アプリ
|   |-- CMakeLists.txt ............ 利用側CMakeファイル
|   `-- main.cpp .................. テストアプリ
|-- compose.yaml .................. Docker compose による開発環境設定
|-- GNUmakefile ................... Docker compose を使った開発/実行環境の操作用
|-- Makefile ...................... 開発環境上におけるビルド処理(cmake呼び出し)等
`-- README.md ..................... 本書
```

## 環境構成

Ubuntu 24.04コンテナ環境(Docker)に以下のパッケージが導入されている。

- CMake (kiteware)
- gRPC
- Protobuf
- Python向けprotocツール用Pythonパッケージ (grpcio-tools)
- GoogleTest

## ビルドと実行テスト

ライブラリのビルド(インストール):

```console
make build
```

テスト用アプリのビルド(インストール):

```console
make build-test
```

テスト用アプリの実行:
※Ctrl+cで終了

```console
$ make launch
docker compose run --rm sdk make -f Makefile  launch
/home/takano/work/tests/test-cmake-library/targets/x86_64-linux-gnu/install/bin/lib_test_app
OnStarting()
RunOnce()
RunOnce()
RunOnce()
RunOnce()
^COnTerminating()
```

以上。
