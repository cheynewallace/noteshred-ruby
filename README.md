# Noteshred

Official gem for interacting with the noteshred.com API

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
note.title    = 'Super Secret Note'
note.content  = 'Hey there, here is the info'
note.password = 'password098'
note.create

#=> "{"token":"af3222afb4","title":"Super Secret Note","email":"freddy@fingers.com","email_hash":"1590fee271427e2e4fefe4faf12c835","content":"Hey there, here is the info","shred_by":"2014-12-01T21:33:50-08:00","is_shredded":false,"shred_method":1,"has_attachment":false,"created_at":"2014-11-24T21:33:50-08:00","created_by":"Freddy Fingers","hint":null,"activities":[]}"
```

### Options
Title, content and password are the minimum options required for a note. This will create a new that will shred after being read once.

There are other options which can be set to enable various features.


|Option |Type |Description|
|-------|-----|-----------|
|hint  |string|Setting a hint will add a message to any notification you sent to users regarding the note which can be used to include information about how to guess the password. The hint is set as a string. [Read More Here](https://www.noteshred.com/blog/password-hints)|
|recipients|array|The recipients option takes an array of email addresses of which each email address will be emailed with details of how to access the note and the included hint message if set.|

## Pushing Encrypted Notes
Pushing a note is much like creating a note except that the encryption is performed locally from the gem and the encrypted contents are simply pushed to the server to be stored.
This is an additional measure of security for those that are concerned about wire tapping or man in the middle attacks.

```ruby
note = Noteshred::Note.new
note.title    = 'Super Secret Note'
note.content  = 'Hey there, here is the info'
note.password = 'password098'
note.encrypt

#=> <Noteshred::Note:0x007fe6a5878c30 @title="Super Secret Note", @content=nil, @password=nil, @encrypted_content="2SM3tjApUErFIqo96pKnliOEGEu16y9NAAovADZeALs=\n", @encrypted_content_iv="UiK2yPbKQ4Lo5M3zagvxHA==\n", @encrypted_content_salt="7388b02e588ef54aa34486d9c79234e8", @version=4, @password_hash="$2a$10$Fvb9Q/5YTyDe6hGH/JQtceC9RB1J9BVqqc0y4K1EDo0Cwqsq1Nd6a">

```

calling **.encrypt** on the note will clear any sensitive content and populate the encrypted content fields with IV and salt.  
To push the note to the server, simply call push on the note.

```ruby
note.push
```

###Please note
We occasionally adjust the encryption algorithms and handling on the server for security reasons and as newer techniques become known. By using the push functionality you will not automatically use the latest encryption as we release it, but instead will be locked into using the most recent version available within this gem.

For example, we are currently at encryption version 4. This is available both on the server and within the gem. If we release a version 5, anyone using the standard "note.create" method will automatically use version 5 as we will default everyone to this when creating new notes on the server, where as if you are using the "note.push" method you will still be encrypting notes using version 4 until we release an updated gem.

## Sharing Notes
Sharing a note with someone will email them with details on how to access the note.

If they have a NoteShred account it will also create a "shared note" which will appear within their user dashboard under the "Shared With Me" section.

To share a note, you need to know the note id (also known as the token) and the persons email address.
Comments are optional

Multiple recipients can be shared with by using a comma separated string of email addresses.

```ruby
Noteshred::Note.share('7561ab7fbd','someguy@gmail.com','Here is the information you requested')
#=> {"message"=>"Notification sent", "status"=>"accepted"}
```

## Requesting Information
Requests let you receive information from someone without the need for them to have a NoteShred account. Think of it like creating a blank note and asking someone else to fill it in for you.
This person will be able to open a password protected link and enter some information to be encrypted which is then sent back to you in the form of a regular note, after which you will see it appear in your note list and can access using the password you originally defined. [Read More About Requests Here](https://www.noteshred.com/blog/information-request)

```ruby
request = Noteshred::Request.new
request.recipient_email = 'john@company.com'
request.password        = 'xyzabc123#%'
request.message         = 'Please send me the credentials for server-x'
request.create
```

## Contributing

1. Fork it ( http://github.com<my-github-username>/noteshred/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
