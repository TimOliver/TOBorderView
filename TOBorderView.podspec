Pod::Spec.new do |s|
  s.name     = 'TOBorderView'
  s.version  = '1.0.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A container view that displays a rounded rectangle background under the content.'
  s.homepage = 'https://github.com/TimOliver/TOBorderView'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOBorderView.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.platform = :ios, '13.0'
  s.source_files = 'TOBorderView/**/*.{h,m}'
end
