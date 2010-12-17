require 'rake/testtask'

task :default => :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc "Build the gem"
task :build do
  opers = Dir.glob('*.gem')
  opers = ["rm #{ opers.join(' ') }"] unless opers.empty?
  opers << ["gem build rack-multipart_related.gemspec"]
  sh opers.join(" && ")
end

desc "Build and install the gem, removing old installation"
task :install => :build do
  gem = Dir.glob('*.gem').first
  if gem.nil?
    puts "could not install the gem"
  else
    sh "gem uninstall rack-multipart_related; gem install #{ gem }"
  end
end
