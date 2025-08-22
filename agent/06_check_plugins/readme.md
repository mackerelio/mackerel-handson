---
title: 公式チェックプラグインを導入する
lang: ja-jp
---

# 公式チェックプラグインを導入する

公式チェックプラグインをインストールしてサーバーの状態を監視してみましょう。

## 公式プラグインをインストールする

監視対象サーバーで以下のコマンドを実行し、公式チェックプラグインをインストールします。

```shell
sudo yum install -y mackerel-check-plugins
```

完了したら、インストールされたプラグインを見てましょう。

```shell
ls /usr/bin/check-*
```

30近いプラグインがインストールされていることを確認していただけるかと思います！

チェックプラグインもGitHubリポジトリにてソースコードを公開しています。

- [https://github.com/mackerelio/go-check-plugins/](https://github.com/mackerelio/go-check-plugins/)

それではプロセス監視を行う`check-procs`をセットアップしてみましょう。

## プロセス監視をしてみる

インストールされたプラグインのうち check-procs プラグインでプロセス監視をしてみます。

現時点でホスト上ではシステムを構成する役割となるようなプログラムが動いていないため、httpd (Apache) をインストールしてWebサーバーとしてプロセス監視を設定してみます。

以下のコマンドでhttpdをインストールして特に設定などはせずにそのまま起動します。

```shell
sudo yum install -y httpd
sudo systemctl start httpd
```

念のため`ps`コマンドでhttpdプロセスが実行されていることを確認してください。

```shell
ps aux | grep httpd
root        5339  0.6  0.5  18388 11112 ?        Ss   10:14   0:00 /usr/sbin/httpd -DFOREGROUND
apache      5512  0.0  0.2  18044  4628 ?        S    10:14   0:00 /usr/sbin/httpd -DFOREGROUND
apache      5513  0.0  0.4 1708664 8260 ?        Sl   10:14   0:00 /usr/sbin/httpd -DFOREGROUND
apache      5514  0.0  0.4 1544760 8032 ?        Sl   10:14   0:00 /usr/sbin/httpd -DFOREGROUND
apache      5516  0.0  0.4 1544760 8024 ?        Sl   10:14   0:00 /usr/sbin/httpd -DFOREGROUND
mackere+   20875  0.0  0.1 222316  2200 pts/0    S+   10:14   0:00 grep --color=auto httpd
```

mackerel-agentの設定ファイル `/etc/mackerel-agent/mackerel-agent.conf` に設定を2行追記します。

以下のコマンドをターミナルで実行することで追記できます。

```shell
sudo sh << SCRIPT
cat >>/etc/mackerel-agent/mackerel-agent.conf <<'EOF';

[plugin.checks.proc_httpd]
command = ["check-procs", "--pattern", "httpd"]
EOF
SCRIPT
```

viなどのエディタで開いて以下の2行を追記しても構いません。

```toml
[plugin.checks.proc_httpd]
command = ["check-procs", "--pattern", "httpd"]
```

特にエラーなどが発生せず、再びコマンドが入力できる状態になっていれば成功です。（完了メッセージも表示されません）

確認して問題なければ、設定内容のシンタックスチェックを行い mackerel-agent を再起動します。

```shell
mackerel-agent configtest
sudo systemctl restart mackerel-agent
```

## プラグインを手動で実行してみる

以下のコマンドにより実行してみて、どのような結果が得られるか確認してみましょう。

```shell
check-procs --pattern httpd
```

以下のような結果が表示されればプラグインが正常に実行され、結果の1行目に`Procs OK`とあるようにプロセスが正常に稼働していることが確認できます。

```shell
Procs OK:
Found 5 matching processes; cmd /httpd/
```

チェックプラグインはコマンドを実行した終了ステータスで監視結果を表現します。check-procsコマンドを実行した直後に次のように終了ステータスを確認すると`0`となっていることがわかります。

```shell
echo $?
```

以下の仕様に沿ってプラグインを実装することで、チェック監視項目を強化できます。

- [チェックプラグイン仕様（チェック監視項目を追加する） - Mackerel ヘルプ](https://mackerel.io/ja/docs/entry/custom-checks#plugin)

それでは設定を反映したホストの詳細画面の上部／下部にある Monitors にチェック監視とその結果が反映されているか確認してみましょう。[ホスト](https://mackerel.io/my/hosts)からアクセスします。

![](./host_monitors.png)

Monitors に`proc_httpd`が追加されていることが確認できます。（スクリーンショットは画面下部）

## 監視対象プロセスを停止してみる

監視しているhttpdプロセスを停止してアラートの発報を確認してみましょう。

```shell
sudo systemctl stop httpd
```

アラートが発報される前に手動でプラグインを実行して監視結果がどのように変化するか確認してみます。

```shell
check-procs --pattern httpd
```

以下のように`Procs CRITICAL`と1行目が`OK`から`CRITICAL`に変わっていることが確認できます。

```shell
Procs CRITICAL:
Found 0 matching processes; cmd /httpd/
```

発報されたアラートを[アラート](https://mackerel.io/my/alerts)から確認してみます。

![](./alert.png)

アラートが確認できたら障害から復旧させてみましょう。

```shell
sudo systemctl start httpd
```

httpdプロセスを起動して数分するとアラートが自動的にクローズされることを確認します。

- 前: [公式メトリックプラグインを導入する](../05_metric_plugins/readme.md)
- 次: [通知をカスタマイズする](../07_notification/readme.md)
