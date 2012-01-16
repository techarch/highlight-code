require "rubygems"
require "bundler/setup"

require 'FileUtils'
require 'nokogiri'
require 'coderay'

class CodeHighlighter
	attr_accessor :doc, :code_nodes, :output_file_path, :options

	CODERAY_CSS_FILE_NAME = "coderay.css"
	HIGHLIGHTED_EXTENSION = ".highlighted.xhtml"
	
	def initialize(options = { })
		self.code_nodes = Array.new
		self.output_file_path = nil
		self.options = options
		return self
	end

	def self.parse(path, options = { })
		ch = CodeHighlighter.new options
		ch.parse path
		ch
	end
	
	def self.highlight(path, options = { })
		ch = CodeHighlighter.parse path, options
		return nil unless ch.doc
		
		begin
			ch.highlight
			ch.save
		rescue Object => ex
			puts "Cannot highlight #{path} due to: #{ex}"
		end
		
		@output_file_path
	end
	
	def parse (path)
		begin
			# get the file contents
			@path = path
			puts "Parsing #{@path}"
			f = File.open(@path)
			
			# parse the file
			@doc = Nokogiri::XML(f)
			
			# find code/pre or both tag(s)
			tag = @options[:tag] || 'both'
			tag = 'code,pre' if tag == 'both'
			@code_nodes = doc.css(tag)
			puts "Found #{@code_nodes.length} nodes"
		rescue Object => ex
			puts "Cannot open #{path} due to: #{ex}"
		ensure
			f.close
		end
	end
	
	def highlight
		puts "Highlight with options: #{@options}"
		
		@code_nodes.each do | code_node |
			brush = code_node['class']
			brush_spec = brush ? brush.split(' ') : [ ]
			language_code = (brush_spec.count > 1) ? brush_spec.last : "N/A"
			
			if language_code != "N/A"
				puts "Found node #{language_code} #{code_node.text}"
				
				# Highlight the code 
				highlighted_code = CodeRay.scan(code_node.text.strip, language_code.to_sym).div(:css => :class, :tab_width => 4, :line_numbers => :inline)

				# Transform the pre node into a div
				code_node.name = "div"
				code_node['class'] = "code"
				code_node.content=  ''
				
				highlighted_code_node = Nokogiri::XML(highlighted_code)
				code_node.add_child highlighted_code_node.children.first
			else
				puts "Found unrecognizable language in source: #{code_node.text}"				
			end #if
		end #each
	end #def
	
	def include_css
		code_ray_css_node = @doc.css("link[href*='" + CODERAY_CSS_FILE_NAME + "']")
		return unless code_ray_css_node.count == 0
		
		src_css_file_path	= File.dirname(__FILE__) + '/../resources/' + CODERAY_CSS_FILE_NAME

		dest_directory			= File.dirname(@path)
		css_path = @options[:csspath] || dest_directory
		dest_css_file_path	= dest_directory + '/' + CODERAY_CSS_FILE_NAME
		FileUtils.copy_file(src_css_file_path, dest_css_file_path)
		puts "Created the CSS file: #{dest_css_file_path}"
		
		code_ray_css_node = Nokogiri::XML::Node.new "link", @doc
		code_ray_css_node['rel'] = 'stylesheet'
		code_ray_css_node['type'] = 'text/css'
		code_ray_css_node['href'] = CODERAY_CSS_FILE_NAME
		
		head_node = @doc.css('head').first
		unless head_node
			head_node = Nokogiri::XML::Node.new "head", @doc
			body_node = @doc.css('body').first
			body_node.add_child head_node
		end
		
		head_node.add_child code_ray_css_node
		puts "Added CSS: #{code_ray_css_node}"
	end
	
	def save
		include_css
		
		begin
			extension = @options[:extension] || HIGHLIGHTED_EXTENSION
			@output_file_path = @path + extension
			puts "Saving result to #{@output_file_path} ..."
			f = File.open(@output_file_path, "w")
			f.write(@doc.to_xhtml)
		rescue Object => ex
			puts "Cannot save the result to #{@path} due to: #{ex}"
		ensure
			f.close
		end
	end
	
end #class

