module AWS
  module S3
    class InvalidAccessKeyId < ResponseError; end
    class NoSuchBucket < ResponseError; end
  end
end
