#!/usr/bin/env ruby
require 'net/imap'
#default code to 0

#3. for each emails
    #check title
    #if error
      #output message
      # set code to critical
#4 return code

imap_host = ARGV[0]
imap_username = ARGV[1]
imap_password = ARGV[2]

use_ssl = true

return_code = 0
imap = Net::IMAP.new(imap_host,{:ssl => use_ssl})
imap.login(imap_username, imap_password)
imap.select('INBOX')
imap.search(["NOT", "DELETED"],"ISO-8859-1").each do |message_id|
  envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
  if envelope.subject.to_s.include?("(with errors)")
    body = imap.fetch(message_id,"BODY[TEXT]")[0].attr["BODY[TEXT]"]
    puts body
    return_code = 2
  end

  
#  imap.store(message_id, "+FLAGS", [:Deleted])
end
imap.expunge()

imap.logout()
imap.disconnect()
Kernel.exit return_code