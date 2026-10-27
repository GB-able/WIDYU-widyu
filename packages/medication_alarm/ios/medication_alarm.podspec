Pod::Spec.new do |s|
  s.name = 'medication_alarm'
  s.version = '0.1.0'
  s.summary = 'Persistent medication alarms for Widyu.'
  s.description = 'AlarmKit scheduling, legacy notifications and durable launch routing.'
  s.homepage = 'https://widyu.store'
  s.license = { :type => 'Proprietary' }
  s.author = { 'Widyu' => 'dev@widyu.store' }
  s.source = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'Sounds/*.caf'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'
  s.weak_frameworks = 'AlarmKit'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
