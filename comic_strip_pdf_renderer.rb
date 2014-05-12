#!/usr/bin/env ruby

# =Comic Strip PDF Renderer
#
# Version:: 1.0 | May 11, 2014
# Author:: Jon Stacey
# Email:: jon@jonsview.com
# Website:: http://jonsview.com
#
# ==Description
# Create a PDF of comic strips [or other images] with variable size pages to eliminate white margins
#
# Program takes a folder of images and renders them into a PDF document
# with pages of variable sizes which eliminates the white border.
# This is extremely useful with comic strips which typically consist
# of a sequence of images meant to be viewed in order.
#
# ==Installation (on OS X)
# 1. Install OS X Developer tools
# 2. Install Homebrew
# 3. Install Ruby 2
# 4. Install ImageMagic `brew install imagemagick`
# 5. Install gems `gem install prawn image_size rmagick`
#
# ==Assumptions
# No image manipulations are desired, and the target device is capable of opening
# and displaying PDFs with variable size pages. The user has ample memory to handle
# the largest comic strip rendering entirely in memory.
#
# ==Usage
# ruby comic_strip_pdf_renderer.rb TITLE ROOT_PATH
#
# TITLE - the name of the comic and the name of the PDF document that will be written to disk
# ROOT_PATH = the directory that contains the comic image sequence
#
# ==License
# Copyright (c) 2014 Jon Stacey. All rights reserved.
#
# I grant the right of modification and redistribution of this program under the following conditions:
#   1. All use is for non-commercial purposes [i.e. personal or academic]
#   2. All redstributions must include this copyright notice and header
#   3. You must make your source code changes available with your redistribution [especially when redistributed in binary form]
#
# ==Disclaimer
# This script is provided "AS-IS" with no warranty or guarantees.
#
# ==Changelog
# 0.1 - 5/11/2014: Initial commit

require 'date'
require 'prawn'
require 'RMagick'
require 'image_size'

class ComicStripRenderer

  SUPPORTED_IMAGE_FORMATS = ['JPG', 'JPEG', 'PNG']

  def initialize(title, root_path, order = :sort)
    @title = title
    @order = order
    @root  = root_path
  end

  def render
    strips = Dir.glob(File.join(@root, '*')).send(@order)
    pdf    = Prawn::Document.new(page_size: ImageSize.new(File.open(strips.first).read).size, margin: 0)

    strips.each_with_index do |strip, index|
      size = ImageSize.new(File.open(strip).read).size
      pdf.start_new_page(size: size) unless index == 0
      image = Magick::Image.read(strip).first
      raise "Unsupported image format (only PNG and JPG are supported)" unless SUPPORTED_IMAGE_FORMATS.include?(image.format)
      pdf.image StringIO.new(image.to_blob)
      puts "Added #{strip}"
    end

    pdf.outline.define do
      section(@title.to_s, destination: 2) do
        strips.each_with_index { |strip, index| page(title: File.basename(strip, File.extname(strip)), destination:  index + 1) }
      end
    end

    puts "Rendering PDF document"
    pdf.render_file File.join(@root, @title + '.pdf')
    puts "Done! PDF document written to #{File.join(@root, @title + '.pdf')}"
  end

end

class Array

  # Method which sort an array composed of strings with embedded numbers by
  # the 'natural' representation of numbers inside a string.
  # Original source: http://zijab.blogspot.com/2007/05/natural-order-string-comparison-for.html
  def sort_by_natural_order

    reg_number = /\d+/

    # We call the sort method of the Array class.
    self.sort do |str1, str2|

      # We try to find an embedded number
      a = str1.match(reg_number)
      b = str2.match(reg_number)

      # If there is no number
      if [a,b].include? nil
        str1 <=> str2
      else
        while true
          begin
            # We compare strings before the number. If there
            # are equal, we will have to compare the numbers
            if (comp = a.pre_match <=> b.pre_match) == 0
              # If the numbers are equal
              comp = (a[0] == b[0]) ? comp = a[0] + a.post_match <=> b[0] + b.post_match :
                                      comp = a[0].to_i <=> b[0].to_i
            end

            str1, str2 = a.post_match, b.post_match
            a = str1.match(reg_number)
            b = str2.match(reg_number)
          rescue
            break
          end
        end
        comp
      end
    end
  end
  # Same as 'natcmp' but replace in place.
  def sort_by_natural_order!
    self.replace(sort_by_natural_order)
  end

end

renderer = ComicStripRenderer.new(ARGV[0], ARGV[1], :sort_by_natural_order)
renderer.render