# awscost-to-slack
 AWSの利用料金をslack通知するLambda関数

## 作成時に参考にさせていただいた記事
### LambdaでAWSの料金を毎日Slackに通知する（Python3）
https://qiita.com/isobecky74/items/88e8e0dcb0ee224a31e4

<br>

## 事前準備
### python(バージョン3.6以上)をインストール
参考サイト：https://prog-8.com/docs/python-env

### lambda-uploaderをインストール
```
pip install lambda-uploader 
```
### aws cliをインストール
```
pip install awscli
```

インストールができたらデプロイで使用するIAMユーザーの設定を行う
```
aws configure

# ※設定する内容
AWS Access Key ID [****]: {IAMユーザーのアクセスキー}
AWS Secret Access Key [****]: {IAMユーザーのアクセスキー}
Default region name [****]: {リージョンのコード}
Default output format [****]: text

# ※設定内容の確認
aws configure list
```
### AWSの設定
必ず[請求アラートの有効化](https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html#turning_on_billing_metrics)を行うこと

### Slackの設定
参考サイト：https://qiita.com/vmmhypervisor/items/18c99624a84df8b31008
- 通知用のチャンネルを用意する（例：#aws課金通知）
- Incoming Webhookアプリをインストール
- Incoming Webhookアプリで通知用チャンネルに投稿を行うWebhookURLを取得

<br>

## 始め方
### AWSのコンソールでawscost-to-slack用のLambda関数を一から作成

設定内容
```
# 名前
awscost_to_slack

# ランタイム
Python 3.x

# 実行ロール
新規 or 既存　で設定
関数作成後、ロールに`CloudWatchReadOnlyAccess`の権限を追加
```

<br>

### 設定ファイルの作成と編集
```
cp lambda.sample.json src/lambda.json 
vim src/lambda.json
```

書き換え例) 
src/lambda.json
```js
{
  "name": "awscost_to_slack",
  "description": "DESCRIPTION",
  "region": "ap-northeast-1", // AWSリージョンのコード
  "handler": "lambda_function.lambda_handler",
  "role": "arn:aws:iam::***:role/service-role/awscost_to_slack-role-***", // 実行ロールのARN
  "timeout": 6,
  "memory": 128
}
```

### 環境設定ファイルの作成と編集
```
cp variables.sample.conf variables.conf
vim src/lambda.json
```

書き換え例) 
variables.conf
```
slackPostURL="https://hooks.slack.com/services/*****"
slackChannel="#aws課金通知"
messageSubject="私のAWSアカウントの利用料金"
budgetDollar=50
```

### srcディレクトリの内容をlambda-uploaderでデプロイ
```
sh deploy.sh
```

### Lambda定期実行設定
CloudWatchのスケジュールイベントを定義して、Lambda関数をターゲットに指定する

### Slackで通知確認を行う
CloudWatchのスケジュールイベントの時刻に通知がきているか確認




