Pod::Spec.new do |s|
s.name         = "SLCWalker"
s.version      = "1.0.6"
s.summary      = "The animation is loaded in a chained manner. The following functions are classified by MARK"
s.homepage     = "https://github.com/WeiKunChao/SLCWalker.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WeiKunChao" => "17736289336@163.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/WeiKunChao/SLCWalker.git", :tag => "1.0.6" }
s.source_files  = "SLCWalker/**/*.swift"
s.requires_arc = true
s.swift_version = "5.0"
end
