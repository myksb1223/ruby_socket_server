ruby_socket_server
===================

This is simple chat server program using ruby.<br />
You can use this code with iOS client project & android client project.<br />
iOS client project and android client project will upload soon.<br />

How to Use?
===================

Create database and files.

<pre><code>rails g ruby_socket_server<br />rake db:migrate
</code></pre>

Create server information.

<pre><code>server = Server.new<br />server.ip_addr = "127.0.0.1" #your host ip<br />server.port = 8080 #open port
</code></pre>

Create user information.

<pre><code>user = User.new<br />user.name = "Kim"<br />...
</code></pre>

*   You can create many users for test.
*   This server program needs two users at least.

Finally, Start server.

<pre><code>ruby lib/server_start.rb</code></pre>