
[![Build Status](http://api.travis-ci.org/lucasfais/rack-multipart_related.png)](http://api.travis-ci.org/lucasfais/rack-multipart_related)

# Rack multipart/related middleware

Rack::MultipartRelated it's a **rack middleware** to parse **multipart/related** requests and rebuild a simple/merged parameters hash.

## What does it do?

When a ruby webserver receives a multipart/related request:

```bash
POST /users HTTP/1.1
Content-Type: multipart/related; boundary="the_boundary"; type="application/json"; start="json"

--the_boundary
Content-Type: application/json; charset=UTF-8
Content-Disposition: inline; name="json"\r

{"user":{"name": "Jhon", "avatar": "cid:avatar_image" }}
--the_boundary
Content-Type: image/png
Content-Disposition: inline; name="avatar_image"; filename="avatar.png"

<the binary content of image comes here>
--the_boundary--
```

The parameters hash arrives like this:

```ruby
{
  "json" => {
    :type => "application/json; charset=UTF-8", 
    :tempfile => <File:/var/folders/Iu/IuwHUNlZE8OaYMACfwiapE+++TI/-Tmp-/RackMultipart20101217-30578-l17vkd-0>, # The json content
    :head => "Content-Type: application/json; charset=UTF-8\r\nContent-Disposition: inline; name=\"json\"\r\n", 
    :name => "json"
  }, 
  "avatar_image" => {
    :type => "image/png", 
    :filename =>"image.png", 
    :tempfile => <File:/var/folders/Iu/IuwHUNlZE8OaYMACfwiapE+++TI/-Tmp-/RackMultipart20101217-30578-bt18q9-0>, # The binary content of image
    :head => "Content-Type: image/gif\r\nContent-Disposition: inline; name=\"avatar_image\"; filename=\"image.png\"\r\n", 
    :name =>"avatar_image"
  }
}
```

Pay attention that the second part of the 'request' (in our example, "avatar\_image") needs to be referenced in the first part (in the example, "json") as "cid:REFERENCE\_NAME\_OF\_THE\_SECOND\_PART"

Using this middleware, the hash above is parsed and rebuilt like the code below:

```ruby
{
  "user" => {
    "name" => "Jhon", 
    "avatar" => {
      :type => "image/png", 
      :filename =>"image.png", 
      :tempfile => <File:/var/folders/Iu/IuwHUNlZE8OaYMACfwiapE+++TI/-Tmp-/RackMultipart20101217-30578-bt18q9-0>, # The binary content of image
      :head => "Content-Type: image/gif\r\nContent-Disposition: inline; name=\"avatar_image\"; filename=\"image.png\"\r\n", 
      :name =>"avatar_image"
    }
  }
}
```
    
## Usage

### Rails apps

In your Gemfile:

```bash
gem 'rack-multipart_related'
```

In your environment.rb:

```ruby
require 'rack/multipart_related'
config.middleware.use Rack::MultipartRelated
```

### Non-Rails apps

Just 'use Rack::MultipartRelated' as any other middleware
    
## Restrictions

At this moment, this middleware only supports JSON in the start part.

## TODO

 * Support other formats to start part, like XML.
 
## Report bugs and suggestions

  * [Issue Tracker](https://github.com/lucasfais/rack-multipart_related/issues)

## Authors

 * [Lucas Fais](https://github.com/lucasfais)
 * [Marcelo Manzan](https://github.com/kawamanza)
 
## Contributors

 * [Eric Fer](https://github.com/ericfer)

## References

 * [RFC 2387](http://www.faqs.org/rfcs/rfc2387.html)
 * [Rails on rack](http://guides.rubyonrails.org/rails_on_rack.html)
 