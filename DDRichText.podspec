Pod::Spec.new do |s|
  s.name         = "DDRichText"
  s.version      = "1.0.0"
  s.summary      = "Just like Weixin Moment and Weibo RichText"
  s.homepage     = "https://github.com/daiweilai/DDRichText"
  s.license      = "Apache License"
  s.author       = { "David Day" => "daiweilai@gmail.com" }
  s.source       = { :git => "https://github.com/daiweilai/DDRichText.git", :tag => 'v1.0.0'}
  s.source_files = 'DDRichTextLib','DDRichTextLib/**/*.{h,m}'
  s.requires_arc = true
  s.platform     = :ios, '7.0'
end