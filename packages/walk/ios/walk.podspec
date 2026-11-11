Pod::Spec.new do |s|
  s.name = 'walk'
  s.version = '0.0.1'
  s.summary = 'Step count bridge for Widyu.'
  s.description = 'CoreMotion pedometer queries usable from background Flutter engines.'
  s.homepage = 'https://widyu.store'
  s.license = { :type => 'Proprietary' }
  s.author = { 'Widyu' => 'dev@widyu.store' }
  s.source = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'
  s.frameworks = 'CoreMotion'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
