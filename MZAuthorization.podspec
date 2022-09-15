Pod::Spec.new do |spec|
  spec.name         = "MZAuthorization"
  spec.version      = "0.0.3"
  spec.summary      = "Swift应用权限授权申请统一处理"
  spec.homepage     = "https://github.com/1691665955/MZAuthorization"
  spec.authors         = { 'MZ' => '1691665955@qq.com' }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.source = { :git => "https://github.com/1691665955/MZAuthorization.git", :tag => spec.version}
  spec.platform     = :ios, "9.0"
  spec.swift_version = '5.0'
  spec.source_files  = "MZAuthorization/MZAuthorization/*"
end
