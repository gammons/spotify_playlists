Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, 'ecea4dc6eaf84de1aaeb568cee03503d', 'f1719ac487164d298ff633dfc85c8fb9', scope: 'playlist-modify-public playlist-modify-private playlist-modify'
end
