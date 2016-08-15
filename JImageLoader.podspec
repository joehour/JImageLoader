Pod::Spec.new do |s|
s.name = "JImageLoader"
s.version = "1.0.9"
s.license = "MIT"
s.summary = "A asynchronous web image loader with CircleProgressView written in Swift."
s.homepage = "https://github.com/joehour/JImageLoader"
s.authors = { "joe" => "joemail168@gmail.com" }
s.source = { :git => "https://github.com/joehour/JImageLoader.git", :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = "8.0"
s.source_files = "JImageLoader/*.{swift}"
end
