module PgWire

  class StartupMessage < BinData::Record

    VER_SSL = 80877103
    VER_CANCEL = 80877102

    endian :big
    uint32 :len
    uint32 :version
    buffer :misc, length: lambda { len - 8 } do
      choice :alt, selection: lambda { version == VER_CANCEL ? 1 : 0 } do
        array 0, read_until: :eof do
          stringz :name
          stringz :val
        end
        struct 1 do
          uint32 :pid
          uint32 :secret
        end
      end
    end

    def ssl?
      version == VER_SSL
    end

    def cancel?
      version == VER_CANCEL
    end
  end

  class CmdQuery < BinData::Record
    stringz :query
  end

  class Command < BinData::Record
    endian :big
    string :code, length: 1
    uint32 :len
    choice :cmd, selection: :code do
      cmd_query 'Q'
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
end
