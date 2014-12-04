class UnirestJourneyClient

 def get_recalls
  get JourneyUri.recalls
 end
 
 def get_recall_visit_header(recalls_uuid)
   get JourneyUri.recall_visit_header, recall_id: recalls_uuid, status:1, email_status:0
 end
 
 def get_recall_visit_productlist(recalls_visit_uuid)
   get JourneyUri.recall_visit_productlist, recall_visit_id: recalls_visit_uuid
 end
 
 def get_recall_visit_header_imgs(recalls_visit_uuid)
   get JourneyUri.recall_visit_header_image, recall_visit_id: recalls_visit_uuid
 end
 
 def get_recall_user_id(users_uuid)
   get JourneyUri.recall_visit_users(users_uuid)
 end
 
 def get_recall_user_info(userinfo_uuid)
   get JourneyUri.recall_visit_user_info, user_object_id: userinfo_uuid
 end
 
 def image_from_url(url)
    get JourneyUri.image(url)
 end
 
 def put_recall_visit_header(visit_id, parameters)
    put JourneyUri.put_recall_visit_header(visit_id), parameters
 end
 
 def get_consignment_visit_header
  get JourneyUri.consignment_visit_header, status:1, email_status:0
 end
 
  ##### Consignment ########

 def get_consignment_user_id(usersid_uuid)
   get JourneyUri.consignment_user_id(usersid_uuid)
 end
 
 def get_consignment_user_info(userinfo_uuid)
   get JourneyUri.consignment_visit_user_info, user_object_id: userinfo_uuid
 end
 
 def get_consignment_store_info(storeid_uuid)
   get JourneyUri.consignment_store_info(storeid_uuid)
 end
 
 def get_consignment_visit_productlist(consignment_visit_uuid)
   get JourneyUri.consignment_visit_productlist, consignment_visit_id: consignment_visit_uuid
 end
 
 def image_from_url(url)
    get JourneyUri.image(url)
 end
 
 def put_consignment_visit_header(visit_id, parameters)
       put JourneyUri.put_consignment_visit_header(visit_id), parameters

 end
 
 
 ################## MAPS STUDIO ############################
 
 def get_maps_studio_visit
  get JourneyUri.maps_studio_visit, status:1, email_status:0
 end
 
 def get_maps_studio_user_info(userinfo_uuid)
   get JourneyUri.maps_visit_user_info, user_object_id: userinfo_uuid
 end
 
 def get_maps_studio_productlist(maps_studio_visit_uuid)
   get JourneyUri.maps_studio_productlist, maps_studio_visit_id: maps_studio_visit_uuid
 end
 
 def put_maps_studio_visit(visit_id, parameters)
       put JourneyUri.put_maps_studio_visit(visit_id), parameters

 end
 
 def get_email_id
   email
 end
 
 
 
 
 private
  def auth
    {:user => JOURNEY_CONFIG['username'], :password => JOURNEY_CONFIG['password']}
  end
  
  def headers(options={})
    {content_type: 'json', accept: 'json'}.merge(options)
  end
  
  def get(uri, parameter=nil)
    Unirest.get uri, headers: headers, parameters: (parameter.nil? ? nil : JourneyUri.parameters(parameter)), auth: auth
  end
  
  def put(uri, parameters)
    Unirest.put uri, headers: headers, parameters: parameters.to_json, auth: auth  
  end
end