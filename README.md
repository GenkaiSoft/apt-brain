# apt-brain
## インストール
### Windows (ビルド済みバイナリ)
右の[Releases](https://github.com/GenkaiSoft/apt-brain/releases)から入手
### それ以外、Windows (ソースからビルド)
[Nimをインストール](https://nim-lang.org/install.html)する必要があります。<br>
#### nimbleパッケージとしてインストールする
- `nimble install apt_brain`
#### 任意の場所にインストールする :
- `git clone https://github.com/GenkaiSoft/apt-brain.git`
- `cd apt-brain`
- `nimble build -d:release` ※`-d:release`をつけないとデバッグビルドとなります
## 使用方法
`apt-brain install [パッケージ]`で、`[カレントディレクトリ]/アプリ/[パッケージ]`にインストールされます。<br>
例)`apt-brain install CERestor`※パッケージ名は大文字、小文字関係ありません。<br>
使い方の詳細は`apt-brain help`で調べてください。
