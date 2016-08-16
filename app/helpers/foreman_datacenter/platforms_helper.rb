module ForemanDatacenter
  module PlatformsHelper
    def rpc_clients_for_select
      Platform::RPC_CLIENTS.zip(Platform::RPC_CLIENTS)
    end
  end
end
