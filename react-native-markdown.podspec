require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name            = "react-native-markdown"
  s.version         = package["version"]
  s.summary         = package["description"]
  s.description     = package["description"]
  s.homepage        = package["homepage"]
  s.license         = package["license"]
  s.platforms       = { :ios => "16.0" }
  s.author          = package["author"]
  s.source          = { :git => "", :tag => "#{s.version}" }

  s.source_files    = ["ios/**/*.{h,m,mm,swift}"]
  
  s.subspec 'parser' do |sp|
    sp.source_files = ["cpp/parser/**/*.{h,cpp}", "md4c/src/md4c.h", "md4c/src/md4c.c"]
    sp.compiler_flags  = '-DMD4C_USE_UTF16 -fshort-wchar'
  end

  install_modules_dependencies(s)
end
