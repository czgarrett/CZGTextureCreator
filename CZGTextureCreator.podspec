Pod::Spec.new do |s|
  s.name         = 'CZGTextureCreator'
  s.version      = '0.9.0'
  s.license      = 'MIT'
  s.summary      = 'A cocos2d class for drawing textures with Core Graphics and Core Text.'
  s.homepage     = 'https://github.com/czgarrett/CZGTextureCreator'
  s.authors      = {'Christopher Z. Garrett' => 'z@zworkbench.com'}
  s.source       = {:git => 'https://github.com/czgarrett/CZGTextureCreator.git', :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.source_files = 'Classes'
  s.requires_arc = true
  s.dependency 'cocos2d', '~> 2.1'
  s.dependency 'DTCoreText', '~> 1.6'
end
