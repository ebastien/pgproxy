class SSLRequest < BinData::Record
  endian :big
  uint32 :len, asserted_value: 8
  uint32 :code, asserted_value: 80877103
end

class StartupMessage < BinData::Record
  endian :big
  uint32 :len
  uint32 :version
  buffer :misc, length: lambda { len - 8 } do
    array :params, read_until: :eof do
      stringz :name
      stringz :val
    end
  end
end

class AuthenticationOk < BinData::Record
  endian :big
  string :cmd, length: 1, asserted_value: 'R'
  uint32 :len, asserted_value: 8
  uint32 :status, asserted_value: 0
end

class ReadyForQuery < BinData::Record
  endian :big
  string :cmd, length: 1, asserted_value: 'Z'
  uint32 :len, asserted_value: 5
  string :status, length: 1, asserted_value: 'I'
end

class Query < BinData::Record
  endian :big
  string :cmd, length: 1, asserted_value: 'Q'
  uint32 :len
  stringz :query
end
