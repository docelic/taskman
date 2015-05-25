require "irb/completion"

IRB.conf[:PROMPT][:IRB]= {
	:PROMPT_I=>"Taskman> ",
	:PROMPT_C=>"...> ",
	:AUTO_INDENT=>true,
	:PROMPT_S=>"   > ",
	:RETURN  =>"#-> %s\n"
}
IRB.conf[:PROMPT_MODE]= :IRB
IRB.conf[:INSPECT_MODE]= false
IRB.conf[:CONTEXT_MODE]= 3
IRB.conf[:VERBOSE]= false
IRB.conf[:DEBUG]= 0

BEGIN {
        begin
                require "readline"
                (File.readlines ".irb_history").each do |l|
                        Readline::HISTORY.push l.chomp
                end if File.exists? ".irb_history"
                Readline.completion_append_character=""
        rescue
                puts "readline nonfunctional"
        end
}

END {
        begin
                File.open ".irb_history","w" do |f|
                        Readline::HISTORY.each do |l| f.puts l end
                end
        rescue
        end
}

require "yaml"
require 'benchmark'
require 'socket'

bnd= binding()
while ARGV and arg=ARGV.shift 
	x=IO.readlines(arg)
	x.each{| l| eval l, bnd} 
end 

include Math
Math::R2D= 180/PI
