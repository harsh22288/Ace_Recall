APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
JOURNEY_CONFIG = APP_CONFIG['journey']