Pod::Spec.new do |s|
  s.name             = 'MixinAPI'
  s.version          = '0.1.0'
  s.summary          = 'Access and manage your wallet on Mixin Network'

  s.description      = <<-DESC
The Mixin Network based wallet allows for the rapid construction of decentralized wallets, decentralized on-chain exchanges, and other products.
                       DESC

  s.homepage         = 'https://github.com/MixinNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wuyueyang' => 'wuyueyang@mixin.one' }
  s.source           = { :git => 'https://github.com/MixinNetwork/bot-api-swift-client', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Mixin_Network'

  s.ios.deployment_target = '13.0'

  s.source_files = 'MixinAPI/Foundation/*', 'MixinAPI/Crypto/*', 'MixinAPI/Model/**/*', 'MixinAPI/API/**/*'

  s.dependency 'Sodium'
end
