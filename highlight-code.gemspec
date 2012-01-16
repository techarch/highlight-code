# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "highlight-code/version"

Gem::Specification.new do |s|
  s.name        = "highlight-code"
  s.version     = HighlightCode::VERSION
  s.authors     = ["Philippe Monnet"]
  s.email       = ["techarch@monnet-usa.com"]
  s.homepage    = "http://blog.monnet-usa.com/"
  s.summary     = %q{highlight-code is a small Ruby utility which will take a XHTML document as input and apply syntax highlighting and save the resulting XHTML in an output file.}
  s.description = <<-EOF
  highlight-code will help you post-process an XHTML document containing code examples in pre or code tags so that the code is highlighted. The pre and code tags need to follow the class conventions from Alex Gorbatchev's SyntaxHighlighter (http://alexgorbatchev.com/SyntaxHighlighter/) Javascript library. The resulting file can be used for an eBook. 
  EOF
  s.licenses = ['MIT']
  s.rubyforge_project = "highlight-code"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.1'
  # specify any dependencies here; for example:
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "coderay"
end
