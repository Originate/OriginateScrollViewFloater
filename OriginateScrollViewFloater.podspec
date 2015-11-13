Pod::Spec.new do |s|
  s.name             = "OriginateScrollViewFloater"
  s.version          = "0.0.4"
  s.summary          = "A customizable UIScrollView floater element."
  s.homepage         = "https://github.com/Originate/OriginateScrollViewFloater"
  s.license          = 'MIT'
  s.author           = { "Allen Wu" => "allen.wu@originate.com" }
  s.source           = { :git => "https://github.com/Originate/OriginateScrollViewFloater.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.frameworks = 'UIKit'
end
