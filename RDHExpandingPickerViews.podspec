Pod::Spec.new do |s|
  s.name = 'RDHExpandingPickerViews'
  s.version = '0.1.0'
  s.license = 'MIT'
  
  s.summary = 'Inline view that expands to show a UIPickerView/UIDatePickerView.'
  s.homepage = 'https://github.com/rhodgkins/RDHExpandingPickerViews'
  s.author = 'Rich Hodgkins'
  s.source = { :git => 'https://github.com/rhodgkins/RDHExpandingPickerViews.git', :tag => s.version.to_s }
  
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true

  s.platform = :ios, '7.0'
  s.source_files = 'RDHExpandingPickerViews/**/*.{h,m}'
  s.private_header_files = '**/Internal/**/*'

end
