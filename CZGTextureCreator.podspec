Pod::Spec.new do |s|
  s.name         = 'CZGTextureCreator'
  s.version      = '2.0.0'
  s.license      = 'MIT'
  s.summary      = 'A cocos2d class for drawing textures with Core Graphics and Core Text.'
  s.homepage     = 'https://github.com/czgarrett/CZGTextureCreator'
  s.authors      = {'Christopher Z. Garrett' => 'z@zworkbench.com'}
  s.source       = {:git => 'https://github.com/czgarrett/CZGTextureCreator.git', :tag => s.version.to_s}
  s.platform     = :ios, '7.0'
  s.source_files = 'Classes'
  s.requires_arc = true
  s.dependency 'DTCoreText', '~> 1.6'
  s.xcconfig   =  { 'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/cocos2d/external/kazmath/include"' }
end
