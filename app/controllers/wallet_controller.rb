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
    error = ""
    @balance = bitcoinRPC('getbalance',[])
    @count = 100
    @skip = 0
    @listtransactions = bitcoinRPC('listtransactions',["*",@count,@skip])
    if @error == "exception"
      render template: 'wallet/bitcoinderror'
    else
      render template: 'wallet/index'
    end
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
    @balance = bitcoinRPC('getbalance',[])
    if @balance == "exception"
      render template: 'wallet/bitcoinderror'
    else
      render template: 'wallet/send'
    end
  end

  def sent
    address = params[:sending]['address']
    amount = params[:sending]['amount']
    if params[:sending]['fee'].empty?
      fee = 0.000001
    else
      fee = params[:sending]['fee']
    end

    @balance = bitcoinRPC('getbalance',[])

    if amount.to_d < 0.00000294
      @message = "dust"
    elsif @balance.to_d < amount.to_d + fee.to_d
      @message = "over"
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
    begin
      JSON.parse(http.request(request).body)["result"]
    rescue => e
      @error = "exception"
    end
  end
end
