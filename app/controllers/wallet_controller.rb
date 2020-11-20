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
    @listtransactions = bitcoinRPC('listtransactions',[])
    render template: 'wallet/index'
  end

  def receive
    @newaddress = bitcoinRPC('getnewaddress',[])
    amount = params[:amount].to_s
    if amount != ""
      @uri = "bitcoin:" + @newaddress + "?amount=" + amount
    else
      @uri = "bitcoin:" + @newaddress
    end
    qrcode = RQRCode::QRCode.new(@uri, size: 10, level: :h)
    @qrcode = qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
    render template: 'wallet/receive'
  end

  def sendings

  end

  def sent
    address = params[:sending]['address']
    amount = params[:sending]['amount']
    if params[:sending]['fee'].empty?
      fee = 0.00001
    else
      fee = params[:sending]['fee']
    end
    @settxfee = bitcoinRPC('settxfee',[fee])
    @txid = bitcoinRPC('sendtoaddress',[address, amount])
    render template: 'wallet/sent'
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
