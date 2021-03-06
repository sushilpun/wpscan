# WPScan - WordPress Security Scanner
# Copyright (C) 2012-2013
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class CustomOptionParser < OptionParser

  attr_reader :symbols_used

  def initialize(banner = nil, width = 32, indent = ' ' * 4)
    @results         = {}
    @symbols_used    = []
    super(banner, width, indent)
  end


  # param Array(Array) or Array options
  def add(options)
    if options.is_a?(Array)
      if options[0].is_a?(Array)
        options.each do |option|
          add_option(option)
        end
      else
        add_option(options)
      end
    else
      raise "Options must be at least an Array, or an Array(Array). #{options.class} supplied"
    end
  end

  # param Array option
  def add_option(option)
    if option.is_a?(Array)
      option_symbol = CustomOptionParser::option_to_symbol(option)

      unless @symbols_used.include?(option_symbol)
        @symbols_used << option_symbol

        self.on(*option) do |arg|
          @results[option_symbol] = arg
        end
      else
        raise "The option #{option_symbol} is already used !"
      end
    else
      raise "The option must be an array, #{option.class} supplied : '#{option}'"
    end
  end

  # return Hash
  def results(argv = default_argv)
    self.parse!(argv) if @results.empty?

    @results
  end

  protected
  # param Array option
  def self.option_to_symbol(option)
    option_name = nil

    option.each do |option_attr|
      if option_attr =~ /^--/
        option_name = option_attr
        break
      end
    end

    if option_name
      option_name = option_name.gsub(/^--/, '').gsub(/-/, '_').gsub(/ .*$/, '')
      :"#{option_name}"
    else
      raise "Could not find the option name for #{option}"
    end
  end
end
