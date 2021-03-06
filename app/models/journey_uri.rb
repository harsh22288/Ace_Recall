class JourneyUri < ActiveRecord::Base
  BASE_URI = "#{JOURNEY_CONFIG['base_uri']}"
  
  def self.parameters(p)
    Hash[ p.map {|k, v| ["q[#{k}]", v.to_s]} ]
  end
  
  def self.image(path)
    (BASE_URI+path).gsub! '/api/v1',''

  end
  
  def self.uri(table, uuid=nil)
    puts "#{BASE_URI}/#{table}#{'/'+uuid if uuid}.json"
    "#{BASE_URI}/#{table}#{'/'+uuid if uuid}.json"
  end
  
  def self.recalls(uuid=nil)
    uri("recall", uuid)
  end
  
  def self.recall_visit_header(uuid=nil)
    uri("recall_visit", uuid)
  end
  
  def self.recall_visit_productlist(uuid=nil)
    uri("recall_visit_product", uuid)
  end
  
  def self.recall_visit_header_image(uuid=nil)
    uri("recall_visit_transfer_photo", uuid)
  end
  
  def self.recall_visit_users(uuid=nil)
    uri("user_object", uuid)
  end
  
  def self.recall_visit_user_info(uuid=nil)
    uri("userinfo", uuid)
  end
  
  def self.put_recall_visit_header(uuid=nil)
    uri("recall_visit", uuid)
  end
 ######## CONSIGNMENT ##########
  def self.consignment_visit_header(uuid=nil)
    uri("consignment_visit", uuid)
  end
  
  def self.consignment_user_id(uuid=nil)
    uri("user_object", uuid)
  end
  
  def self.consignment_visit_user_info(uuid=nil)
    uri("userinfo", uuid)
  end
  
  def self.consignment_store_info(uuid=nil)
    uri("store", uuid)
  end
  
  def self.consignment_visit_productlist(uuid=nil)
    uri("consignment_visit_product", uuid)
  end
  
  def self.put_maps_studio_visit(uuid=nil)
    uri("maps_studio_visit", uuid)
  end
  
  ############## MAPS STUDIO #############]
  
  def self.maps_studio_visit(uuid=nil)
    uri("maps_studio_visit", uuid)
  end
  
  def self.maps_visit_user_info(uuid=nil)
    uri("userinfo", uuid)
  end
  
  def self.maps_studio_productlist(uuid=nil)
    uri("maps_studio_visit_product", uuid)
  end
   
  ############## COMZTEK #############

  def self.comztek_visit(uuid=nil)
    uri("comztek_visit", uuid)
  end
  
  def self.comztek_visit_user_info(uuid=nil)
    uri("userinfo", uuid)
  end
  
  def self.comztek_visit_productlist(uuid=nil)
    uri("comztek_visit_product", uuid)
  end
  
  def self.data_model
    uri("_datamodel")
  end
  
  def self.put_comztek_visit(uuid=nil)
    uri("comztek_visit", uuid)
  end
  
  
  
end