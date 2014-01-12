#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

require 'bindata'
require 'celluloid/io'
require 'pg_wire.rb'

class PgServer
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

  def read_msg(fmt, socket)
    msg = fmt.read socket
    puts msg.inspect
    msg
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    puts "*** Received connection from #{host}:#{port}"
    msg = read_msg(PgWire::StartupMessage, socket)
    raise EOFError, "Cancel" if msg.cancel?
    if msg.ssl?
      BinData::String.new('N').write(socket)
      msg = read_msg(PgWire::StartupMessage, socket)
    end
    PgWire::AuthenticationOk.new.write(socket)
    PgWire::ReadyForQuery.new.write(socket)
    msg = read_msg(PgWire::Command, socket)
    loop { read_raw(socket) }
  rescue EOFError
    puts "*** #{host}:#{port} disconnected"
    socket.close
  end
end

supervisor = PgServer.supervise("0.0.0.0", 5432)
trap("INT") { supervisor.terminate; exit }
sleep
