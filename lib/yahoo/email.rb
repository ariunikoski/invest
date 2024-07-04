module Yahoo
  require 'net/imap'
  require 'mail'
  require'base64'
  require 'nokogiri'

  class Email
    def initialize
      @messages = []
      imap_server = 'imap.mail.yahoo.com'
      username = 'unikoski@yahoo.com'
      #password = 'hya531GY'
      password = 'mmowoaxpiheqqldi'

      # Connect to the IMAP server
      ssl_val = Rails.application.config.verify_email_ssl ? true : { verify_mode: OpenSSL::SSL::VERIFY_NONE }
      imap = Net::IMAP.new(imap_server, port: 993, ssl: ssl_val)

      imap.login(username, password)

      # Select the INBOX mailbox
      imap.select('INBOX')

      # Search for the most recent emails
      latest_emails = imap.search(['ALL']).last(5)
 
      # Retrieve the subjects of the most recent 5 emails
      latest_emails.each do |email_id|
        msg_data = imap.fetch(email_id, 'ENVELOPE').first
        msg = msg_data.attr['ENVELOPE']
        
        mail_body = get_mail_body(imap, email_id)
        encoded_text = msg.subject || ' - No subject -'
        subject = decode_mime_encoded_string(encoded_text)

        name = decode_mime_encoded_string(msg.from[0].name)
        
        datetime = DateTime.parse(msg.date)
        formatted_datetime = datetime.strftime("%Y-%m-%d")

        
        @messages << { from: name, date: formatted_datetime, subject: subject, body: mail_body }
      end
      imap.logout
      imap.disconnect
    end  #initialize
    
    def get_mail_body(imap, email_id)
      return '...later, buddy.'
      msg = imap.fetch(email_id, 'RFC822').first.attr['RFC822']
      mail = Mail.read_from_string(msg)
      if mail.multipart?
        text_part = mail.text_part
        html_part = mail.html_part
        return text_part.body.decoded.force_encoding('UTF-8') if text_part
        return extract_text_from_html(html_part.body.decoded) if html_part
        # >>> return html_part.body.decoded if html_part
        return 'Not text or html part found in multipart'
      else
        return mail.body.decoded.force_encoding('UTF-8')
      end
    end
      
    def extract_text_from_html(html_string)
      doc = Nokogiri::HTML(html_string)
      text = doc.at('body').inner_text.strip
      text.gsub!('\r\n', '\n')
      text.gsub!('\t', ' ')
      text.gsub!(/(\s*\n\s*)+/, "\n")
      text.force_encoding('UTF-8')
    end
      
    def decode_mime_encoded_string(encoded_string)
      # Split the encoded string into parts separated by the equals sign ('=')
      parts = encoded_string.split('=?UTF-8')

      # Initialize an empty array to store decoded characters
      decoded_string = []

      # Iterate over the parts
      parts.each do |part|
        # If the part starts with '?Q?', it's "Q" encoded
        if part.start_with?('?Q?')
          # Remove '?Q?' from the part
          part = part[3..-1]

          # Split the part into hexadecimal characters
          hex_chars = part.split('=')

          # Convert each hexadecimal character to its integer value and then to its UTF-8 representation
          decoded_chars = []
          hex_chars.each do |hh|
          	hh_start = hh[0..1]
          	hh_end = hh[2..-1]
          	# - no non ascii.... decoded_chars << hh_start.hex.chr(Encoding::UTF_8)
          	decoded_chars << hh_end.gsub('_', ' ').sub(/\?\z/, '') if hh_end
          end

          # Join the decoded characters and append them to the decoded string array
          decoded_string << decoded_chars.join('')
        # If the part starts with '?B?', it's "B" encoded
        elsif part.start_with?('?B?')
          # Remove '?B?' from the part
          part = part[3..-1]
    
          # Decode the part using Base64
          decoded_part = Base64.decode64(part).force_encoding('utf-8')
    
          # Append the decoded part to the decoded string array
          decoded_string << decoded_part
        else
          # If the part is not encoded, append it to the decoded string array
          decoded_string << part
        end
      end

      # Join the decoded string array to get the final decoded string
      decoded_string.join('')
    end

    def get_messages
      @messages.reverse
    end

  end  #class
end #module