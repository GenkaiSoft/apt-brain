# apt-brain
## インストール
### Windows (ビルド済みバイナリ)
右のReleasesから入手
### それ以外、Windows (ソースからビルド)
Nimをインストールする必要があります。<br>
#### nimbleパッケージとしてインストールする
- `nimble install https://github.com/GenkaiSoft/apt-brain.git`を実行する
#### 任意の場所にインストールする :
- `git clone https://github.com/GenkaiSoft/apt-brain.git`
- `cd apt-brain`
- `nimble build -d:release`
## 使用方法
`apt-brain install [パッケージ]`で、`[カレントディレクトリ]/アプリ/[パッケージ]`にインストールされます。<br>
例)`apt-brain install CERestor`※パッケージ名は大文字、小文字関係ありません。<br>
使い方の詳細は`apt-brain help`で調べてください。
## ビルド
Nimをインストールする必要があります。<br>
### デバッグビルド
- `nimble build`
### リリースビルド
- `nimble build -d:release`
