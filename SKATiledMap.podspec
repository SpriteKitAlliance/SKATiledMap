Pod::Spec.new do |s|
  s.name     = 'SKATiledMap'
  s.version  = '0.2.2'
  s.license  = 'MIT'
  s.summary  = 'SKATiledMap is a simple solution for creating a map using the free Tiled Map Editor and supportes .tmx and .json formats.'
  s.homepage = 'http://spritekitalliance.com/'
  s.social_media_url = 'https://twitter.com/SKADevs'
  s.authors  = {
                 'Norman Croan'  => 'ncroan@gmail.com', 
                 'Ben Kane'      => 'ben.kane27@gmail.com',
                 'Max Kargin'    => 'maksym.kargin@gmail.com',
                 'Skyler Lauren' => 'skyler@skymistdevelopment.com',
                 'Marc Vandehey' => 'marc.vandehey@gmail.com' 
               }
  s.source   = { 
                 :git => 'https://github.com/SpriteKitAlliance/SKATiledMap.git',
                 :tag => s.version.to_s 
               }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'SKATiledMap'
  s.frameworks  = 'SpriteKit', 'UIKit'
  s.xcconfig       = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/"' }
end