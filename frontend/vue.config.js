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
  },

  // TypeScript の設定を追加
  chainWebpack: config => {
    config.resolve.extensions
      .add('.ts')
      .add('.tsx');

    config.module
      .rule('ts')
      .test(/\.ts$/)
      .use('ts-loader')
      .loader('ts-loader')
      .options({
        appendTsSuffixTo: [/\.vue$/],
        transpileOnly: true // 高速化のため
      })
      .end();

    config.module
      .rule('vue')
      .use('vue-loader')
      .loader('vue-loader')
      .tap(options => {
        options.compilerOptions = {
          ...options.compilerOptions,
          isCustomElement: tag => tag.startsWith('ion-') // Ionic などカスタム要素を使用する場合
        };
        return options;
      });
  },

  // エントリポイントを main.ts に変更
  configureWebpack: {
    entry: './src/main.ts'
  }
})
