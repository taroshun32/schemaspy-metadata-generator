# SchemaSpy Metadata Generator

カラムの Comment を元に SchemaSpy 用のメタデータ (リレーション定義) を生成する

## 手順

ローカルの MySQL を Docker で立ち上げる
```shell
docker run --name mysql-local -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysql:8.0-oracle
```

MySQL に接続し、テーブルを作成する
```shell
mysql -h 127.0.0.1 -P 3306 -u root -ppassword < world.sql
```

metadata.xml を生成する
```shell
sh create_meta.sh
```

Docker イメージをビルドする
```shell
docker build -t my-schemaspy .
```

Docker コンテナを起動して DB 仕様書を出力する
```shell
docker run --name my-schemaspy --rm -v $PWD/schema:/output my-schemaspy
```
