# Noteshred

Official gem for interacting with the NoteShred API

**Please note this gem is currently under development, please check back for updates**
## Installation

Add this line to your application's Gemfile:

    gem 'noteshred'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install noteshred

## Setup

If you're not using Rails, you'll need to require noteshred first:
```ruby
require 'noteshred'
```
Set your API key:
```ruby
Noteshred.api_key = '6935629729ae6869c98799936591'
```
## Creating Notes

Notes require a few basic properties as a minimum.
We will create a note with the bare minimum options.  
```ruby
note = Noteshred::Note.new
note.title = 'Super Secret Note'
note.content = 'Hey there, here is the info'
note.password = 'password098'
note.create

#=> "{"token":"af3222afb4","title":"Super Secret Note","email":"freddy@fingers.com","email_hash":"1590fee271427e2e4fe2f8099b12c835","content":"Hey there, here is the info","shred_by":"2014-12-01T21:33:50-08:00","is_shredded":false,"shred_method":1,"has_attachment":false,"created_at":"2014-11-24T21:33:50-08:00","created_by":"Freddy Fingers","hint":null,"activities":[]}"
```

### Options
Title, content and password are the minimum options required for a note. This will create a new that will shred after being read once.

There are other options which can be set to enable various features.

<table>
  <tr>
    <th>Option</th>
    <th>Type</th>
    <th>Description</td>
  </tr>
  <tr>
    <td style="text-align: center">**hint**</td>
    <td style="text-align: center">sting</td>
    <td>
      Setting a hint will add a message to any notification you sent to users regarding the note which can be used to include information about how to guess the password. The hint is set as a string. [Read More Here](https://www.noteshred.com/blog/password-hints)
    </td>
  </tr>
  <tr>
    <td style="text-align: center">**recipients**</td>
    <td style="text-align: center">array</td>
    <td>
      The recipients option takes an array of email addresses of which each email address will be emailed with details of how to access the note and the included hint message if set.
    </td>
  </tr>
</table>

## Contributing

1. Fork it ( http://github.com/<my-github-username>/noteshred/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
