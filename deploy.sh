# デプロイコマンド
base_path=`cd $(dirname $0); pwd`

src_path="$base_path/src"

# variables.confから環境変数を更新
aws lambda update-function-configuration \
  --function-name awscost_to_slack \
  --environment \
    Variables={`cat variables.conf | tr -s "\n" | tr '\n' ',' | sed s/,$//`}

# srcディレクトリに移動
cd $src_path

# 古いパッケージのZIPが残ってたら消す
rm -f lambda_function.zip

# パッケージのZIPを作るために実行
lambda-uploader

# パッケージのZIPをデプロイ
aws lambda update-function-code \
--function-name awscost_to_slack \
--zip-file fileb://lambda_function.zip

# アップロードが終わったパッケージのZIPを消す
rm -f lambda_function.zip