SERVER_HOST = '127.0.0.1'
SERVER_PORT = 54321

dgram = require 'dgram'
client = dgram.createSocket 'udp4'

stdin = process.openStdin();
stdin.setEncoding 'utf8'
stdin.on 'data', (input) ->
  message = new Buffer input;
  client.send message, 0, message.length, SERVER_PORT, SERVER_HOST;

client.on 'message', (message) ->
  process.stdout.write message.toString()