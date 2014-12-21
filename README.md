# PaperclipWatermark

## Description
This is a simple Paperclip processor to apply watermarks on Paperclip's images. The watermark will be resized to fit the base image.

Few options are available to specify the position and it opacity:
`watermark_distance_from_top`: specify the position from top in percentage
`watermark_position`: specify the position (NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast)
`watermark_dissolve`: specify the opacity

## Usage

```ruby
  # Paperclip image attachments
  has_attached_file :attachment, :processors => [:thumbnail, :watermark],
                    styles: {
                                 thumb: '250x250>',
                                 original: {
                                          geometry: '1280x1280>',
                                          watermark_dissolve: 22,
                                          watermark_distance_from_top: 90,
                                          watermark_path: "#{Rails.root}/public/images/logo.png"
                                  }
                               }

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paperclip_watermark'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip_watermark

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/paperclip_watermark/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
