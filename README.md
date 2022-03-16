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
