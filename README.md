# Simple Bitcoin Signet Wallet

準備中

## Bitcoin Core
Bitcoin Coreはbitcoindとも呼ばれる公式クライアントです。

### Bitcoin Core(bitcoind)のインストール

#### Macにbitcoindをインストール

ターミナルを開いて下記の通りコマンドを実行していきます。

bitcoindのVer.は適宜変更してください。

```
$ cd
$ wget https://bitcoin.org/bin/bitcoin-core-0.20.1/bitcoin-0.20.1-osx64.tar.gz
$ tar -zxvf bitcoin-0.20.1-osx64.tar.gz
$ cd bitcoin-0.20.1/bin/
$ sudo cp * /usr/local/bin
```

#### Ubuntuにbitcoindをインストール

ターミナルを開いて下記の通りコマンドを打っていきます。

bitcoindのVer.は適宜変更してください。

```
$ cd
$ wget https://bitcoin.org/bin/bitcoin-core-0.20.1/bitcoin-0.20.1-x86_64-linux-gnu.tar.gz
$ tar -zxvf bitcoin-0.20.1-x86_64-linux-gnu.tar.gz
$ cd bitcoin-0.20.1/bin/
$ sudo cp * /usr/local/bin
```
### bitcoindの起動

起動

```
$ bitcoind -signet -txindex -daemon
```
regtestはスタンドアロンのテストモード<br>
txindexはブロックチェーン上のトランザクションを全取得<br>
daemonはデーモン起動でコンソール上にログを吐きません。<br>

ログは下記に出力されます。

Macの場合
```
"/Users/${USER}/Library/Application Support/Bitcoin/signet/debug.log"
```

Ubuntuの場合

```
~/.bitcoin/signet/debug.log
```

ブロックチェーンの同期状況を見てみます。Regtestモードの最初は0ブロックしかありません。

```
$ bitcoin-cli -signet getblockchaininfo
```

停止するには下記コマンドを実行します。

```
$ bitcoin-cli -signet stop
```

### 設定ファイルにオプションをまとめる

いちいちオプションをつけて操作するのが面倒なので、設定ファイルにまとめましょう。

#### Macの場合

```
$ cd "/Users/${USER}/Library/Application Support/Bitcoin/"
```

#### Linuxの場合

```
$ cd ~/.bitcoin
```

#### Mac, Linux共通 

bitcoin.confを記載

下記を記述して保存

```
regtest=1
txindex=1
server=1
daemon=1
rpcuser=hoge
rpcpassword=hoge

[test]
rpcport=18332
port=18333
[regtest]
rpcport=18443
port=18444
[signet]
rpcport=38332
port=38333
```

起動してブロックチェーン情報を取得
```
$ bitcoind
$ bitcoin-cli getblockchaininfo
```

bitcoindを起動したままにして、Ruby on Railsの環境を整えていきます。
