# 自己署名認証局

## これはなに？

OpenSSL で自己署名認証局を運用するためのスクリプトと設定ファイル一式です。

## はじめかた

必要なファイル、ディレクトリ、CA の秘密鍵と証明書を作成します。

```console
./ca.sh init
```

主に以下のファイルが出来上がります。

- PrivateRootCA/
  - cacert.pem <<<=== CA 証明書
  - private/
    - cakey.pem <<<=== CA 秘密鍵

### サーバ証明書の生成

```console
./ca.sh server
```

いくつか質問に回答します。

#### 質問(1) `Subject Alternative Name (e.g DNS:example.com):`

Subject Alternative Name を入力します。URL に合わせます（参考: https://www.openssl.org/docs/manmaster/man5/x509v3_config.html）。

入力例 1: `DNS:example.com`

入力例 2: `IP:1.2.3.4`

Google Chrome 58 移行で必須です。

#### 質問(2) `Country Name (2 letter code) [JP]:`

２文字国コードです。

#### 質問(3) `Organization Name (eg, company) []:`

組織名です。

#### 質問(4) `Common Name (e.g. server FQDN or YOUR name) []:aaa.bbb.com`

共通名です。URL に合わせます。

#### 質問(5) `Number of days to certify the cert for [365]:`

証明書の有効日数です。

### できあがるファイル

以下のファイルが出来上がります。

- private/
  - 日付.pem <<<=== 秘密鍵
- PrivateRootCA/
  - newcerts/
    - 数字.pem <<<=== 証明書
- export/
  - 日付.pem <<<=== 秘密鍵と証明書を含む PKCS12 ファイル

### クライアント証明書の生成

```console
./ca.sh client
```
