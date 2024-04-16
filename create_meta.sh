#!/bin/bash

# データベース接続設定
USER="root"
PASSWORD="password"
DATABASE="world"
HOST="127.0.0.1"

# metadata.xmlファイルを初期化
echo '<schemaMeta xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://schemaspy.org/xsd/6/schemameta.xsd" >' > metadata.xml
echo '    <tables>' >> metadata.xml

# SQLクエリを実行し、結果を行ごとに処理
mysql -h $HOST -u $USER -p$PASSWORD -D $DATABASE -sN -e \
"SELECT TABLE_NAME, COLUMN_NAME, COLUMN_COMMENT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '$DATABASE' AND COLUMN_COMMENT LIKE 'fk:%'" | \
while read TABLE_NAME COLUMN_NAME COLUMN_COMMENT
do
    # コメントから外部キーテーブルとカラムを抽出
    FK_TABLE=$(echo $COLUMN_COMMENT | cut -d':' -f2 | cut -d'.' -f1)
    FK_COLUMN=$(echo $COLUMN_COMMENT | cut -d':' -f2 | cut -d'.' -f2)

    # XMLファイルにリレーション情報を追加
    echo "        <table name=\"$TABLE_NAME\">" >> metadata.xml
    echo "            <column name=\"$COLUMN_NAME\">" >> metadata.xml
    echo "                <foreignKey table=\"$FK_TABLE\" column=\"$FK_COLUMN\" />" >> metadata.xml
    echo "            </column>" >> metadata.xml
    echo "        </table>" >> metadata.xml
done

# XMLファイルを閉じる
echo '    </tables>' >> metadata.xml
echo '</schemaMeta>' >> metadata.xml
