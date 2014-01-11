#!/usr/bin/env ruby

require 'bindata'
require 'celluloid/io'
require './messages.rb'

class EchoServer
  include Celluloid::IO
  finalizer :finalize

  def initialize(host, port)
    puts "*** Starting server on #{host}:#{port}"
    @server = TCPServer.new(host, port)
    async.run
  end

  def finalize
    @server.close if @server
  end

  def run
    loop { async.handle_connection @server.accept }
  end

  def read_raw(socket)
    raw = socket.readpartial(4096)
    puts raw.unpack('C*').inspect
    raw
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"
    SSLRequest.read(socket)
    BinData::String.new('N').write(socket)
    msg = StartupMessage.read(socket)
    puts msg.inspect
    AuthenticationOk.new.write(socket)
    ReadyForQuery.new.write(socket)
    msg = Query.read(socket)
    puts msg.inspect
    loop { read_raw(socket) }
  rescue EOFError
    puts "*** #{host}:#{port} disconnected"
    socket.close
  end
end

supervisor = EchoServer.supervise("127.0.0.1", 9876)
trap("INT") { supervisor.terminate; exit }
sleep
