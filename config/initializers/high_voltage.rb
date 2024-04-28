HighVoltage.configure do |config|
  config.route_drawer = HighVoltage::RouteDrawers::Root
  HighVoltage.configure do |config|
    config.home_page = 'top'
  end
end
