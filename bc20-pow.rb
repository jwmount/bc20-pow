# openblockchains/awesome-blockchains
# awesome-blockchains/blockchain.rb/blockchain_with_proof_of_work.rb
###########################
#  build your own blockchain from scratch in ruby!
#
#  to run use:
#    $ ruby ./blockchain_with_proof_of_work.rb


require "digest"    # for hash checksum digest function SHA256
require "pp"        # for pp => pretty printer


class Block

  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :nonce        ## proof of work if hash starts with leading zeros (00)
  attr_reader :hash

  def initialize(index, data, previous_hash)
    @index         = index
    @timestamp     = Time.now
    @data          = data
    @previous_hash = previous_hash
    @nonce, @hash  = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work( difficulty="00" )
    nonce = 0
    loop do
      hash = calc_hash_with_nonce( nonce )
      if hash.start_with?( difficulty )
        return [nonce,hash]    ## bingo! proof of work if hash starts with leading zeros (00)
      else
        nonce += 1             ## keep trying (and trying and trying)
      end
    end
  end

  def calc_hash_with_nonce( nonce=0 )
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + @index.to_s + @timestamp.to_s + @data + @previous_hash )
    sha.hexdigest
  end


  def self.first( data="Genesis" )    # create genesis (big bang! first) block
    ## uses index zero (0) and arbitrary previous_hash ("0")
    Block.new( 0, data, "0" )
  end

  def self.next( previous, data="Transaction Data..." )
    Block.new( previous.index+1, data, previous.hash )
  end

end  # class Block


#####
## let's get started
##   build a blockchain a block at a time

b0 = Block.first( "Genesis" )
b1 = Block.next( b0, "Transaction Data..." )
b2 = Block.next( b1, "Transaction Data......" )
b3 = Block.next( b2, "More Transaction Data..." )

blockchain = [b0, b1, b2, b3]

pp blockchain

