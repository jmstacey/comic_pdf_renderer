Comic Strip PDF Renderer
=========

Create a PDF of comic strips [or other images] with variable size pages to eliminate white margins

Program takes a folder of images and renders them into a PDF document with pages of variable sizes which eliminates the white border. This is extremely useful with comic strips which typically consist of a sequence of images meant to be viewed in order.

Features
-----------

* Accepts PNG and JPEG image sequences
* Renders images in PDF document, one image per page, variable size, without margins
	
Requirements
--------------

* Homebrew
* Ruby 2
* ImageMagic
* Prawn, RMagic, image_size

Install (OS X)
-----------

* Install OS X Developer CLI Tools
* Install Homebrew
* Install Ruby 2
* Install ImageMagick `brew install imagemagick`
* Install gem dependencies `gem install prawn image_size rmagick`

Usage
-----------

    Usage: comic_strip_pdf_renderer.rb TITLE ROOT_PATH
            TITLE           The name of the comic strip, and the PDF filename to be used when written to disk.
            ROOT_PATH       The directory containing the image sequence to be rendered into PDF.

Copyright
------------

Copyright (c) 2014 Jon Stacey. All Rights Reserved. 

I grant the right of modification and redistribution of this program under the following conditions:
* All use is for non-commercial purposes [i.e. personal or academic]
* All redstributions must include this copyright notice and header
* You must make your source code changes available with your redistribution [especially when redistributed in binary form]

Disclaimer
------------

This script is provided "AS-IS" with no warranty or guarantees.
