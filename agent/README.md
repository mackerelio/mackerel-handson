---
title: ハンズオン概要
lang: ja-jp
---

![](https://mackerel.io/files/images/brand-assets/logo.svg)

# Mackerel Hands-On Seminar

Mackerel Hands-On Seminar へようこそ。

このハンズオンでは、mackerel-agentのインストールからブラウザ上でのグラフの確認、プラグインの便利な使い方などをガイドしていきます。

ワクワクする時間になれば幸いです。

## 事前準備

ハンズオンを実施いただくには以下の環境を事前に準備していただく必要があります。

- PC
  - WindowsまたはmacOS
  - ターミナルソフトを利用しますので、事前にインストールや設定などをお願いします。
    - Windows環境ではTeraTerm、MacはOS付属のターミナルやiTerm2をご利用ください。
- 外部へのSSH接続が可能なネットワーク環境
- この場で受信可能なメールアドレス
  - ハンズオン中に発生させるアラートの通知先としても利用します。
- SSHログインが可能なLinuxサーバー

## ハンズオン用のサーバー環境について

- 本ハンズオン以外でのご利用は禁止させていただいております。
- SSHログインには中継サーバーを経由した多段SSHでのログインが必要となります。
  - 中継サーバーの接続情報（IPアドレス、パスワード）に関しては別途お知らせします。

### macOSをお使いの方
macOS標準のターミナルやiTerm2などから以下のように接続してください。
```shell
ssh -J mackerel-handson-guest@<中継サーバーのIP> mackerel-handson-guest@<ハンズオンサーバーのIP>
```
- パスワードを求められますので、まず**中継サーバーのパスワード**を入力してください
- 続いて**ハンズオンサーバーのパスワード**を求められます。お間違えないようにご注意ください。

### Windowsをお使いの方
TeraTermなどのSSHクライアントから接続をしてください。

- まずはGUIかSSHで**中継サーバー**にログインしてください
```shell
ssh mackerel-handson-guest@<中継サーバーのIP>
```
- 中継サーバーログイン後に以下のコマンドで**ハンズオンサーバー**にログインしてください
```shell
ssh mackerel-handson-guest@<ハンズオンサーバーのIP>
```

## アジェンダ

- [オーガニゼーションを作成する](01_signup/readme.md)
- [エージェントをインストールする](02_install_agent/readme.md)
- [サービス／ロールでホスト管理をする](03_service_role/readme.md)
- [監視ルールを追加する](04_monitors/readme.md)
- [公式メトリックプラグインを導入する](05_metric_plugins/readme.md)
- [公式チェックプラグインを導入する](06_check_plugins/readme.md)
- [通知をカスタマイズする](07_notification/readme.md)
- [おまけ](09_extra/readme.md)
- [ホストを退役する](16_retire_host/readme.md)
