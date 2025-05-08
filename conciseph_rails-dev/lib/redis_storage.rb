class RedisStorage
  attr_accessor :redis

  def initialize
    @redis = Redis.new
  end

  def del(key)
    @redis.del(key)
  end

  def setex_with_expiry(key, value, expiry_seconds)
    @redis.setex(key, expiry_seconds, value)
  end

  delegate :get, to: :redis

  delegate :set, to: :redis

  delegate :expire, to: :redis
end