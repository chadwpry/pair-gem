module Pair
  APPLICATION_NAME = "Pair"
  APPLICATION_DOMAIN = "www.pairmill.com"

  ICON_APPLICATION = "http://#{APPLICATION_DOMAIN}/images/emblem-earth.png"
  ICON_SESSION_JOIN = "http://#{APPLICATION_DOMAIN}/images/pair-network-join.png"
  ICON_SESSION_PART = "http://#{APPLICATION_DOMAIN}/images/pair-network-part.png"
end

require "pair/version"

require "pair/os"
require "pair/config"
require "pair/notification"
require "pair/api"
require "pair/session"
