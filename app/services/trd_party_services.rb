class TrdPartyServices
  def self.response_conversion(response)
    status = response.status
    data = JSON.parse(response.body, symbolize_names: true)

    {status: status, data: data}
  end
end
