namespace :comztek_studio do
  require 'pdfcrowd'
  require 'mail'
  require 'net/smtp'
  desc "Comztek Studio PDF"
  
  task :convert => :environment do
    puts "Converting Comztek....."
    Rake::Task["comztek_studio:comztek_studio_convert"].invoke
    puts "Ending conversion comztek......"
  end
  
  task :comztek_studio_convert => :environment do
    puts "Write your main logic for Comztek conversion here"
    journey_obj = UnirestJourneyClient.new
    get_html_string_comztek(journey_obj)
  end
  
  def get_html_string_comztek(journey_obj)
    #client = Pdfcrowd::Client.new("accrete", "1cabeac1948fa82be5702cfdd6e0bf9d")
    client = Pdfcrowd::Client.new("naveen05", "4d0ab2416de179d799b9fc8250f34a98")

    comztek_visit = journey_obj.get_comztek_visit.body
  
    comztek_visit.each do |comztek_visit_info|
    #recall_visit_header_list= journey_obj.get_recall_visit_header(recall_info["id"]).body
    #puts recall_visit_header_list
    
    
     
    
      comztek_user_info = comztek_visit_info["user_object_id"].nil? ? '' :journey_obj.get_comztek_user_info(comztek_visit_info["user_object_id"]).body
      #recall_visit_info["user_object_id"].nil? ? '' : 
      
      if !(comztek_user_info.blank? || comztek_user_info.empty?)
        firstname=comztek_user_info[0]["firstname"]
        lastname=comztek_user_info[0]["lastname"]
        fullname=firstname+lastname
      else
        fullname=''
      end  


    vendor=comztek_visit_info["vendor_name"].nil? ? '': comztek_visit_info["vendor_name"]
    
    comztek_visit_productlist=journey_obj.get_comztek_visit_productlist(comztek_visit_info["id"]).body
    store=comztek_visit_productlist[0]["store_name"].nil? ? '': comztek_visit_productlist[0]["store_name"]
    storeID=comztek_visit_productlist[0]["storeID"].nil? ? '': comztek_visit_productlist[0]["storeID"]

    #puts consignment_visit_productlist
    sHTML=''
    sHTML= "<html><body>"
    sHTML+="<div><p style=\"font-size: 24px; text-align:centre\">Comztek Visit Notification</p></div>"
    sHTML+="<table width=\"100%\" >"
    sHTML+="<tr><td width=\"40%\"><p>Vendor: #{vendor}"
    sHTML+= "<p> Rep: #{fullname}</p><p> Store: #{store}</p> <p>Store Number: #{storeID}</p></td>"
    #puts consignment_info["start_time"]
    
    start_date=comztek_visit_info["start_time"].nil? ? '': comztek_visit_info["start_time"][0..9]
    start_time=comztek_visit_info["start_time"].nil? ? '': comztek_visit_info["start_time"][11..18]
    start_date_time = start_date+"," +start_time

    signoff_date=comztek_visit_info["signoff_time"].nil? ? '': comztek_visit_info["signoff_time"][0..9]
    signoff_time=comztek_visit_info["signoff_time"].nil? ? '': comztek_visit_info["signoff_time"][11..18]
    signoff_date_time = signoff_date +"," + signoff_time
    
    visit_time=comztek_visit_info["total_visit_time"].nil? ? '': comztek_visit_info["total_visit_time"];
    start_gps_lat=comztek_visit_info["start_gps"].nil? ? '': comztek_visit_info["start_gps"]["latitude"]
    start_gps_long=comztek_visit_info["start_gps"].nil? ? '': comztek_visit_info["start_gps"]["longitude"]
      
    close_gps_lat=comztek_visit_info["signoff_gps"].nil? ? '': comztek_visit_info["signoff_gps"]["latitude"]
    close_gps_long=comztek_visit_info["signoff_gps"].nil? ? '': comztek_visit_info["signoff_gps"]["longitude"]   
    
    sHTML+= "<td width=\"30%\"><p> Visit Time Started: #{start_date_time} </p> <p>Visit Time Finsihed: #{signoff_date_time}</p>"
    sHTML+= "<p> Visit time total: #{visit_time}</p>"
    sHTML+= "<p>Visit Start Location: #{start_gps_lat} #{start_gps_long}</p>"
    sHTML+= "<p>Visit End Location: #{close_gps_lat} #{close_gps_long}</p></td></tr></table>"
     #bbase64= "\"data:image/jpeg;base64, #{Base64.encode64("../tasks/ACE_2013_Logo.png")}\""
     #puts Base64.encode64("../tasks/ACE_2013_Logo.png") 
             
     #sImg= "<img hspace=\"3\" alt=\"\" src="+bbase64+" />"
     #sHTML+="<td width=\"30%\">#{sImg}</td>"
  
  
  
    sHTML+="<table width=\"100%\" border=\"1\" style=\"border-collapse: collapse\"> <thead style=\"background-color: #C0C0C0\">"
    sHTML+="<th>Item Code</th> <th>Item Name</th> <th>SOH Dispo</th> <th>On Floor Count</th> <th>Damaged</th> <th>Price Correct</th>"
    sHTML+="<th>ICASA Sticker</th>  <th>Add ICASA Sticker</th></thead>"
    
    iCount=0   
    comztek_visit_productlist.each do |comztek_visit_product|
      
      journey_data_model = journey_obj.get_data_model.body["objects"]["comztek_visit_product"]["attributes"]["price_correct"]["options"]
      price_correct = journey_data_model[comztek_visit_product["price_correct"]]
      puts price_correct
      
      journey_data_model = journey_obj.get_data_model.body["objects"]["comztek_visit_product"]["attributes"]["icasa_stocker"]["options"]
      icasa_stocker = journey_data_model[comztek_visit_product["icasa_stocker"]]
      puts icasa_stocker
      
      journey_data_model = journey_obj.get_data_model.body["objects"]["comztek_visit_product"]["attributes"]["add_icasa"]["options"]
      add_icasa = journey_data_model[comztek_visit_product["add_icasa"]]
      puts add_icasa
        
          
      if(iCount%2==0)  
        sHTML+="<tr style=\"background-color: #E0E0E0\"><td style=\"text-align: centre\">#{comztek_visit_product["item_code"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["item_name"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["soh_dispo"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["on_floor_count"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["damaged"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{price_correct} </td>"
        sHTML+="<td style=\"text-align: centre\">#{icasa_stocker} </td>"
        sHTML+="<td style=\"text-align: centre\">#{add_icasa}</td></tr>"
      else
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["item_code"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["item_name"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["soh_dispo"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["on_floor_count"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{comztek_visit_product["damaged"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{price_correct} </td>"
        sHTML+="<td style=\"text-align: centre\">#{icasa_stocker} </td>"
        sHTML+="<td style=\"text-align: centre\">#{add_icasa}</td></tr>" 
      end 
      iCount=iCount+1 
    end
      
    sHTML+="</table>"
    sHTML+="<h3>Photos</h3>"
    
    #recall_visit_header_imgs=journey_obj.get_recall_visit_header_imgs(recall_visit_info["id"]).body
    #sHTML+="<h4> Transfer Number: #{recall_visit_header_imgs[0]["transfer_id"]}</h4><table width=\"100%\">"
    
    sHTML += "<table width=\"100%\"><tr><td>Before Photo</td><td >"
    sImg_Tag=''
    before_photo_bin = comztek_visit_info["display_attachments"]["before_photo"].nil? ? '' : journey_obj.image_from_url(comztek_visit_info["display_attachments"]["before_photo"]["thumbnail"]).body
    if !(before_photo_bin.blank? || before_photo_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(before_photo_bin)}\""
      sImg_Tag="<img alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"

 
    sHTML += "<tr><td>Top Left After Photo</td><td >"
    sImg_Tag=''
    after_photo1_bin=comztek_visit_info["display_attachments"]["after_photo1"].nil? ? '' : journey_obj.image_from_url(comztek_visit_info ["display_attachments"]["after_photo1"]["thumbnail"]).body
    if !(after_photo1_bin.blank? || after_photo1_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(after_photo1_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Top Right After Photo</td><td>"
    sImg_Tag=''
    after_photo2_bin=comztek_visit_info["display_attachments"]["after_photo2"].nil? ? '' : journey_obj.image_from_url(comztek_visit_info ["display_attachments"]["after_photo2"]["thumbnail"]).body
    if !(after_photo2_bin.blank? || after_photo2_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo2_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag

    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Bottom Left After Photo</td><td>"
    sImg_Tag=''
    after_photo3_bin=comztek_visit_info["display_attachments"]["after_photo3"].nil? ? '' : journey_obj.image_from_url(comztek_visit_info ["display_attachments"]["after_photo3"]["thumbnail"]).body
    if !(after_photo3_bin.blank? || after_photo3_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo3_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Bottom Right After Photo</td><td>"
    sImg_Tag=''
    after_photo4_bin=comztek_visit_info["display_attachments"]["after_photo4"].nil? ? '' : journey_obj.image_from_url(comztek_visit_info ["display_attachments"]["after_photo4"]["thumbnail"]).body
    if !(after_photo4_bin.blank? || after_photo4_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo4_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    
    sHTML +="</table>"
 
    
    #sHTML+="</table><p style=\"page-break-after:always; padding-top:20px\"><h3>Recall Sign-Off</p>"
    sHTML+="<table width=\"100%\" style=\"margin-top: 20px\"><tr><td>Staff Member Name</td><td>#{comztek_visit_info["signoff_manager_name"]}</td></tr>"
    sHTML+="<tr><td>Staff Signature</td><td>"
    signature_photo_bin=comztek_visit_info["display_attachments"]["signoff_manager_signature"].nil? ? '' :journey_obj.image_from_url(comztek_visit_info["display_attachments"]["signoff_manager_signature"]["thumbnail"]).body
    img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(signature_photo_bin)}\""
    sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
    sHTML+=sImg_Tag
    sHTML+="</td></tr></table></html>"
    
    
    visit_id=comztek_visit_info["visitid"]
    
    name_temp="#{visit_id}.pdf"

    puts "******************SENDING MAIL****************"
      options = {
        :address => "smtp.gmail.com",
        :port => 587,
        :user_name =>"notifications@accretesol.com",
        :password => 'Notify2014Accrete$$',
        :authentication => 'plain',
        :enable_starttls_auto => true
      }

      Mail.defaults do
        delivery_method :smtp, options
      end
      
      #puts "#{consignment_user_info[0]["email"]}"
      file_path = "./tmp"
      filename = name_temp
      #filename="sample.pdf"
      File.open("#{file_path}/#{filename}", 'wb') {|f| client.convertHtml(sHTML, f)}
      puts filename
      file_content = File.read("#{file_path}/#{filename}")
      encoded_content = Base64.encode64(file_content)
      #email=journey_obj.get_email_id
      #puts email

      Mail.deliver do
        from      'notifications@accretesol.com'
        to        "nick@accretesol.com"   
        subject   'Comztek Report'
        body      File.read('./tmp/body.txt')
        add_file :filename => filename, :content => file_content
        puts "****************MAIL SENT*************************"

        payload = {"comztek_visit" => {"email_status"=>1}}
        journey_obj.put_comztek_visit(comztek_visit_info["id"], payload)
      end
   end
  end
end
