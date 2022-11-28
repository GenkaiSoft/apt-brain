# インストール
右のReleasesから入手するか、<br>
`nimble install https://github.com/GenkaiSoft/apt-brain.git`を実行する
# 使用方法
`apt-brain install [パッケージ]`で、`[カレントディレクトリ]/アプリ/[パッケージ]`にインストールされます。<br>
例)`apt-brain install CERestor`※パッケージ名は大文字、小文字関係ありません。<br>
使い方の詳細は`apt-brain help`で調べてください。
# ビルド
Nimをインストールする必要があります。<br>
`nimble build`<br>
リリースビルド:`nimble build -d:release`
