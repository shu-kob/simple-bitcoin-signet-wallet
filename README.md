# Simple Bitcoin Signet Wallet

ソースコードやbitcoind起動オプションの変更で、MainnetやTestnet、Regtestでお使いいただくことも可能です。

## Bitcoin Core
Bitcoin Coreはbitcoindとも呼ばれるBitcoinの公式クライアントです。

### Bitcoin Core(bitcoind)のインストール

bitcoindのVer.は適宜変更してください。

SignetをサポートしているVer.はv0.21.0以降です。

#### Macにbitcoindをインストール

ターミナルを開いて下記の通りコマンドを実行していきます。

```
$ cd
$ wget https://bitcoin.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-osx64.tar.gz
$ tar -zxvf bitcoin-0.21.0-osx64.tar.gz
$ cd bitcoin-0.21.0/bin/
$ sudo cp * /usr/local/bin
```

#### Ubuntuにbitcoindをインストール

ターミナルを開いて下記の通りコマンドを実行していきます。

```
$ cd
$ wget https://bitcoin.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
$ tar -zxvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz
$ cd bitcoin-0.21.0/bin/
$ sudo cp * /usr/local/bin
```
### bitcoindの起動

起動

```
$ bitcoind -signet -txindex -daemon
```
signetはPoA型のテストネット<br>
txindexはブロックチェーン上のトランザクションを全取得<br>
daemonはデーモン起動。<br>

ログは下記に出力されます。

Macの場合
```
"/Users/${USER}/Library/Application Support/Bitcoin/signet/debug.log"
```

Ubuntuの場合

```
~/.bitcoin/signet/debug.log
```

ブロックチェーンの同期状況を見てみます。

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

```
$ nano bitcoin.conf
```

もしくは
```
$ nano bitcoin.conf
```

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

bitcoindを起動したままにして、Ruby on Railsの環境を整えていきます

## Ruby on Railsのインストール

### Macの場合

```
$ brew link autoconf
$ brew unlink autoconf && brew link autoconf
$ brew install rbenv ruby-build
$ brew update && brew upgrade ruby-build
$ rbenv install 2.6.5
# かなり時間がかかるので気長に待ちましょう
$ rbenv global 2.6.5
$ ruby -v
# 2.6.5であればOK
$ gem install bundler
$ bundle -v
$ gem install rails --version="~> 6.0.0"
$ rails -v
# 6系であればOK
$ git clone https://github.com/shu-kob/rails-bitcoin
$ cd rails-bitcoin
$ bundle install
$ brew install yarn
$ yarn install --check-files
$ rails s
```

### Ubuntuの場合

```
$ sudo apt-get update
$ sudo apt-get -y install git curl g++ make
$ sudo apt-get -y install zlib1g-dev libssl-dev libreadline-dev
$ sudo apt-get -y install libyaml-dev libxml2-dev libxslt-dev
$ sudo apt-get -y install sqlite3 libsqlite3-dev nodejs
$ cd
$ git clone git://github.com/sstephenson/rbenv.git .rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ exec $SHELL
$ mkdir -p ~/.rbenv/plugins
$ cd ~/.rbenv/plugins
$ git clone git://github.com/sstephenson/ruby-build.git
$ rbenv install 2.6.5
かなり時間がかかるので気長に待ちましょう
$ rbenv global 2.6.5
$ rbenv version
# 2.6.5であればOK
$ which ruby
# 例)/home/vagrant/.rbenv/shims/ruby などと返ってくればOK
$ ruby -v
# 2.6.5であればOK
$ gem install rails --version="~> 6.0.0"
$ rbenv rehash
$ rails -v
# 6系であればOK
$ git clone https://github.com/shu-kob/rails-bitcoin
$ cd rails-bitcoin
$ bundle install
$ sudo apt-get install yarn
$ sudo apt-get install npm
$ sudo npm install -g n
$ yarn install --check-files
$ rails s
```

### ブラウザにてRails画面が立ち上がっていることを確認 

http://localhost:3000/

## VagrantでUbuntuを起動している場合は以下

Vagrantfile
```
config.vm.network "private_network", ip: "192.168.33.10"
```
をコメントアウトして仮想マシンを起動して入る

```
vagrant up
vagrant ssh
```

http://192.168.33.10:3000/

## ソースコードをcloneしてアプリを起動

```
git clone https://github.com/shu-kob/simple-bitcoin-signet-wallet
```
### ブラウザにてアプリ画面が立ち上がっていることを確認

ローカルの場合

http://localhost:3000/

vagrantの場合

http://192.168.33.10:3000/

ブロック一覧画面が出ればOKです

## 外部のSignetツール

ブロックチェーンエクスプローラ
https://explorer.bc-2.jp/

Signet Faucet
https://signet.bc-2.jp/
