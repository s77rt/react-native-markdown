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

  s.source_files    = ["ios/**/*.{h,m,mm,swift}", "cpp/**/*.{h,cpp}", "md4c/src/md4c.h", "md4c/src/md4c.c"]

  install_modules_dependencies(s)
end
