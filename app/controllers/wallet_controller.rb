require 'bitcoin'
require 'net/http'
require 'json'
Bitcoin.chain_params = :testnet
RPCUSER="hoge"
RPCPASSWORD="hoge"
HOST="localhost"
PORT=38332
require 'rqrcode'

class WalletController < ApplicationController
  def index
    @balance = bitcoinRPC('getbalance',[])
    render template: 'wallet/index'
  end

  def receive
    @newaddress = bitcoinRPC('getnewaddress',[])
    render template: 'wallet/receive'
  end

  private
	def bitcoinRPC(method,param)
		http = Net::HTTP.new(HOST, PORT)
    request = Net::HTTP::Post.new('/')
    request.basic_auth(RPCUSER,RPCPASSWORD)
    request.content_type = 'application/json'
    request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
    JSON.parse(http.request(request).body)["result"]
  end
end
