require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("monit.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["monit.gemspec"] do
  system "gem build monit.gemspec"
  system "gem install monit-#{Monit::VERSION}.gem"
end
