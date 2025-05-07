#!/bin/bash
set -e

# 初回コンテナ起動時にdbがなければ作成
bundle exec rails db:prepare

# サーバー起動
exec "$@"