#
# SonarQube
# Copyright (C) 2009-2016 SonarSource SA
# mailto:contact AT sonarsource DOT com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

require 'nokogiri'

# = XmlMini Nokogiri implementation
module ActiveSupport
  module XmlMini_Nokogiri #:nodoc:
    extend self

    # Parse an XML Document string into a simple hash using libxml / nokogiri.
    # string::
    #   XML Document string to parse
    def parse(string)
      if string.blank?
        {}
      else
        doc = Nokogiri::XML(string)
        raise doc.errors.first if doc.errors.length > 0
        doc.to_hash
      end
    end

    module Conversions
      module Document
        def to_hash
          root.to_hash
        end
      end

      module Node
        CONTENT_ROOT = '__content__'.freeze

        # Convert XML document to hash
        #
        # hash::
        #   Hash to merge the converted element into.
        def to_hash(hash = {})
          node_hash = {}

          # Insert node hash into parent hash correctly.
          case hash[name]
            when Array then hash[name] << node_hash
            when Hash  then hash[name] = [hash[name], node_hash]
            when nil   then hash[name] = node_hash
            else raise "Unexpected error during hash insertion!"
          end

          # Handle child elements
          children.each do |c|
            if c.element?
              c.to_hash(node_hash)
            elsif c.text? || c.cdata?
              node_hash[CONTENT_ROOT] ||= ''
              node_hash[CONTENT_ROOT] << c.content
             end
          end

          # Remove content node if it is blank and there are child tags
          if node_hash.length > 1 && node_hash[CONTENT_ROOT].blank?
            node_hash.delete(CONTENT_ROOT)
          end

          # Handle attributes
          attribute_nodes.each { |a| node_hash[a.node_name] = a.value }

          hash
        end
      end
    end

    Nokogiri::XML::Document.send(:include, Conversions::Document)
    Nokogiri::XML::Node.send(:include, Conversions::Node)
  end
end
