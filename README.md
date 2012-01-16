##  highlight-code ##

### Rationale ###
When I write blog posts and tutorials I include many code samples and apply syntax highlighting to increase readability. For that I use Alex Gorbatchev's excellent [SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/) Javascript library. But if I am interested in creating eBooks the challenge is to maintain the highlighting. Since the markup needs to be all inclusive, I need a "pre-processor" to take my markup and apply syntax highlighting so that the final XHTML can be used for the eBook. 

highlight-code is a small Ruby utility which will take a XHTML document as input and apply syntax highlighting and save the resulting XHTML in an output file.

### Why a new library? ###
Actually this is really a command line utility built "on the shoulders of giants", i.e. [Nokogiri](http://nokogiri.org/) and [CodeRay](http://coderay.rubychan.de/). "They" do the heavy lift, I am just assembling them into a utility to help me apply syntax highlighting to XHTML markup containing code samples (in pre/code tags).

### Installation ###

	gem install highlight-code

### Simple Usage ###

	highligh-code test.xhtml

### Syntax ###

	highlight-code XHTMLFILEPATH [OPTIONS]

	XHTMLFILEPATH: The .xhtml file containing the code to highlight

	OPTIONS:
		-c, --css-path PATH/TO/CSS/FILES 	path for the coderay.css (default same location as the input file)
		-e, --extension EXTENSION        	extension for the processed / output file (default: .highlighted.xhtml)
		-t, --tag TAG                    	type of tag (pre or code) containing the code to highlight 
											(note: the css class must follow the syntax: brush: language, e.g. brush: ruby)
											(default: both)
		-h, --help                       	help

