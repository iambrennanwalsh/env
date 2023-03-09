import Encore from '@symfony/webpack-encore'

if (!Encore.isRuntimeEnvironmentConfigured()) {
  Encore.configureRuntimeEnvironment(process.env.NODE_ENV || 'development')
}

Encore.setOutputPath('public/build/')
  .setPublicPath('/build')
  .addEntry('app', './assets/app.ts')
  .enableStimulusBridge('./assets/controllers.json')
  .splitEntryChunks()
  .enableSingleRuntimeChunk()
  .cleanupOutputBeforeBuild()
  .enableBuildNotifications()
  .enableSourceMaps(!Encore.isProduction())
  .enableVersioning(Encore.isProduction())
  .enableIntegrityHashes(Encore.isProduction())
  .enableBabelTypeScriptPreset()
  .enableReactPreset()
  .enablePostCssLoader(options => {
    options.postcssOptions = {
      plugins: ['postcss-preset-env']
    }
  })
  .configureImageRule({
    type: 'asset',
    filename: 'assets/[name].[hash:8][ext]',
    enabled: true
  })
  .configureFontRule({
    type: 'asset',
    enabled: true,
    filename: 'assets/[name].[hash:8][ext]'
  })

export default Encore.getWebpackConfig()
