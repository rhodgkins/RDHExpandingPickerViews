Pod::Spec.new do |s|
  s.name = 'RDHExpandingPickerViews'
  s.version = '1.1.0'
  s.license = 'MIT'
  
  s.summary = 'Inline view that expands to show a UIPickerView/UIDatePickerView.'
  s.homepage = 'https://github.com/rhodgkins/RDHExpandingPickerViews'
  s.author = 'Rich Hodgkins'
  s.source = { :git => 'https://github.com/rhodgkins/RDHExpandingPickerViews.git', :tag => s.version.to_s }
  
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true

  s.platform = :ios, '8.0'
  s.source_files = 'RDHExpandingPickerViews/**/*.{h,m}'
  s.public_header_files = 'RDHExpandingPickerViews/DatePicker/**/*.h', 'RDHExpandingPickerViews/Picker**/*.h', 'RDHExpandingPickerViews/Internal/_RDHBaseExpandingPickerContainerView.h'
  
  s.screenshots = ['https://raw.github.com/rhodgkins/RDHExpandingPickerViews/master/Images/unexpanded.png',
                   'https://raw.github.com/rhodgkins/RDHExpandingPickerViews/master/Images/date.png',
                   'https://raw.github.com/rhodgkins/RDHExpandingPickerViews/master/Images/countdown.png',
                   'https://raw.github.com/rhodgkins/RDHExpandingPickerViews/master/Images/picker.png']

end
