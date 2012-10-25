module RubySocketServer
  class ClientForSend
    @@clnt_socks = Hash.new
    @@clnt_addrs = Hash.new

    def initialize(clnt_sock, clnt_addr)
      @sock = clnt_sock
      @addr = clnt_addr
      @size = 0
    end

    def auth_confirm
      auth = @sock.recv(1024)
      auth_json = JSON.parse(auth)
      me = auth_json["Auth"]["user_id"]
      to = auth_json["Auth"]["receiver_id"]
      flag = auth_json["Auth"]["flag"]
    
      if flag.to_i == 0
        to = []
      elsif flag.to_i == 1
        to = []
      elsif flag.to_i == 2
      end
 
      @me = me 
      @to = to
      @flag = flag
      @@clnt_socks[me] = @sock
      @@clnt_addrs[me] = @addr
      @user = User.find(me)

      hash = Hash.new
      hash["auth"] = 1
      connected = JSON.generate(hash)
      @sock.puts(connected+'\r\n\r\n')
      @sock.flush
    end

    def run
      loop {
        disconnectFlag = 0
        d = []
        while true
          partial = @sock.recv(1024).chomp
  
          if partial == ""
            disconnectFlag = 1
            break
          end

          d << partial
          joined = d.join

          datas = joined.split("---------------------------14737809831466499882746641449")
          d = []
          for data in datas do
            if valid_json(data)
              data_json = JSON.parse(data)
              disconnect = data_json["Disconnect"]["disconnect"] 
              image = data_json["Msg"]["image"]
            
              if disconnect == '1'
                disconnectFlag = 1
                break
              end
            
              if 'NONE'.eql? image
                send_message(data_json)
              else
                send_image(data_json)
              end
            else
              d << data
            end  
          end
        end

        if disconnectFlag == 1
          disconnect
          break
        end
      }
    end

    def send_message(msg_json)
      timestamp = msg_json["Msg"]["timestamp"]
      friendChat = FriendChat.new(:message => msg_json["Msg"]["message"], :user_id => @me, :receiver_id => @to, :timestamp => timestamp, :image_id => 0)
      friendChat.save

      success_return(timestamp, friendChat.id)

      if @to.kind_of? Array
        t_arr = []
        to.count.times do |i|
          t_arr[i] = Thread.new { 
            if arr[to[i]] != nil 
              arr[to[i]].puts(data)
            else
            end
          }
        end 
        t_arr.each { |t| t.join }
      else
        if @@clnt_socks[@to] != nil
          msg_json["Msg"]["chat_id"] = friendChat.id
          msg_json["Msg"]["userName"] = @user.name
          msg_json["Msg"]["date"] = friendChat.created_at.to_s
          msg_json.delete("Auth")
          msg_json.delete("Disconnect")
          @@clnt_socks[@to].puts(JSON.generate(msg_json)+'\r\n\r\n')
          @@clnt_socks[@to].flush
        else
        end
      end
    end

    def send_image(img_json)
      timestamp = img_json["Msg"]["timestamp"]
      imageString = img_json["Msg"]["image"]
      message = img_json["Msg"]["message"]
      imageData = imageString.split("---------------------------36555627553666677664566663667")
      thumbnail = imageData[0]
      original = imageData[1]
  
      friendChat = FriendChat.new(:message => message, :user_id => @me, :receiver_id => @to, :timestamp => timestamp, :image_id => 0)
      friendChat.save

      friendChat.image_id = friendChat.id
      friendChat.save
  
      success_return(timestamp, friendChat.id)

      File.open("./public/images/thumbnail_#{friendChat.id}.jpeg", "wb", 0644) do |file|
        file.write(Base64::decode64(thumbnail.chomp))
      end
  
      File.open("./public/images/original_#{friendChat.id}.jpeg", "wb", 0644) do |file|
        file.write(Base64::decode64(original.chomp))
      end

      if @@clnt_socks[@to] != nil
        img_json["Msg"]["chat_id"] = friendChat.id
        img_json["Msg"]["userName"] = @user.name
        img_json["Msg"]["date"] = friendChat.created_at.to_s
        img_json["Msg"]["image"] = thumbnail.chomp
        img_json.delete("Auth")
        img_json.delete("Disconnect")
        @@clnt_socks[@to].puts(JSON.generate(img_json)+'\r\n\r\n')
        @@clnt_socks[@to].flush
      else
      end
    end

    def success_return(timestamp, chatId)
      hash = Hash.new
      hash["timestamp"] = timestamp
      hash["success"] = 1
      hash["chat_id"] = chatId
      success = JSON.generate(hash)
      @sock.puts(success+'\r\n\r\n')
      @sock.flush
    end

    def valid_json(json)
      begin
        JSON.parse(json)
        return true
      rescue Exception => e
        return false
      end
    end

    def disconnect
      @@clnt_socks.delete(@me)
      @@clnt_addrs.delete(@me)
    end

    def sock
      @sock
    end

    def addr
      @addr
    end
  end
end
