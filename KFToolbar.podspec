Pod::Spec.new do |s|
  s.name             =  "KFToolbar"
  s.version          =  "0.1.2"
  s.license          =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary          =  "An NSView subview that handles KFToolbarItems."
  
  s.homepage         =  "https://pods.kf-interactive.com"
  s.authors          =  { "Rico Becker" => "rico.becker@kf-interactive.com", "Gunnar Herzog" => "gunnar.herzog@kf-interactive.com", "Markus Müller" => "mmlr@gmx.net" }
  s.source           =  { :git => "https://github.com/ricobeck/KFToolbar.git", :tag => s.version.to_s }
  
  s.platform         =  :osx, 10.7
  
  s.framework        =  'Foundation'
  s.requires_arc     =  true
  s.source_files     =  'KFToolbar/Sources/**/*.{h,m}'
  s.exclude_files = 'KFToolbar/Sources/Tests/*.{h,m}'
end
