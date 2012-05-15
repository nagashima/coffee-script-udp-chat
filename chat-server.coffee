SERVER_HOST = '127.0.0.1'
SERVER_PORT = 54321
LOGOUT_TIME_LIMIT = 10;
CLIENT_GC_INTERVAL = 1000;

dgram = require 'dgram'
server = dgram.createSocket 'udp4'
clients = {}

time = () ->
  return Math.round(new Date().getTime() / 1000)

class Client
  constructor: (@address, @port) ->
    @id = @address + ":" + @port
    @time = time()

setInterval ->
  for id, client of clients
    if time() - client.time > LOGOUT_TIME_LIMIT
      delete clients[id];
, CLIENT_GC_INTERVAL

addClient = (rinfo) ->
  client = new Client(rinfo.address, rinfo.port)
  clients[client.id] = client;

processMessage = (message) ->
  str = message.toString().replace(/[\n\r]/g, "")
  if str.length > 0
    for id, client of clients
      response = new Buffer(id + ":> " + str + "\n")
      server.send response, 0, response.length, client.port, client.address

server.on "message", (message, rinfo) ->
  addClient(rinfo)
  processMessage(message)

server.on "listening", () ->
    address = server.address()
    console.log "server listening " + address.address + ":" + address.port

server.bind SERVER_PORT, SERVER_HOST;