const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,

  // 開発用サーバーに関する設定
  devServer: {
    // プロキシ設定
    proxy: {
      // '/api' で始まるパスへのリクエストを、Railsサーバーに転送するための設定
      '/api': {
        // 転送先のRailsサーバーのURL
        target: 'http://localhost:3000',
        // オリジン（ドメインやポート）が異なるサーバーへのリクエストを許可する
        changeOrigin: true,
      }
    }
  }
})
