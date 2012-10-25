module RubySocketServer
  class ServerSocket
    def initialize(port, ip_addr)
      Thread.abort_on_exception = true
      @serv_sock = Socket.new(AF_INET, SOCK_STREAM, 0)
      @serv_addr = Socket.sockaddr_in(port, ip_addr)
      @serv_sock.bind(@serv_addr)
      @serv_sock.listen(5)
    end

    def run
      loop {
        Thread.new(@serv_sock.accept) do |clnt|
          @client = ClientForSend.new(clnt[0], clnt[1])
          @client.auth_confirm
  
          @client.run
        end
      }
      @serv_sock.close
    end
  end
end
