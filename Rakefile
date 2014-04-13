hard_coded_gem_filename="graph-theory-0.0.1.gem"#todo - version on cmd-line maybe?

task :default=>:dev

# during dev, auto-rebuild please
task :dev=>[:rebuild,:test]{ puts "DEV MODE HOOOO!" }

# during prod - i dunno, do cool stuff
# TODO
task :prod do
	puts "I'm unimplemented thank you very much!"
end

task :test do
	puts "Running all tests!"
	Dir.glob("specs/**/*.rb").each do |spec_file|
		puts "Running #{spec_file}"
		system "rspec #{spec_file}"
	end
end

task :rebuild => :clean do
	puts "Rebuilding ..."
	puts " *** WARNING *** - gem version is currently hardcoded!"
	system "gem build graph-theory.gemspec"
	system "gem install #{hard_coded_gem_filename}"
	
end

task :clean do
	puts "Cleaning ..."
	File.delete(hard_coded_gem_filename) if File.exists?(hard_coded_gem_filename)
	# TODO - uninstall the gem every time?
end
