namespace :maps_studio do
  require 'pdfcrowd'
  require 'mail'
  require 'net/smtp'
  desc "Maps Studio PDF"
  task :convert => :environment do
    puts "Converting....."
    Rake::Task["maps_studio:maps_studio_convert"].invoke
    puts "Ending conversion......"
  end
  
  task :maps_studio_convert => :environment do
    puts "Write your main logic for Maps conversion here"
    journey_obj = UnirestJourneyClient.new
    get_html_string_maps(journey_obj)
  end
  
  def get_html_string_maps(journey_obj)
    client = Pdfcrowd::Client.new("accrete", "1cabeac1948fa82be5702cfdd6e0bf9d")
    #client = Pdfcrowd::Client.new("naveen05", "4d0ab2416de179d799b9fc8250f34a98")

    maps_studio_visit = journey_obj.get_maps_studio_visit.body
  
    maps_studio_visit.each do |maps_studio_info|
    #recall_visit_header_list= journey_obj.get_recall_visit_header(recall_info["id"]).body
    #puts recall_visit_header_list
    
    
     
    
    maps_user_info = maps_studio_info["user_object_id"].nil? ? '' :journey_obj.get_maps_studio_user_info(maps_studio_info["user_object_id"]).body
      #recall_visit_info["user_object_id"].nil? ? '' : 
      
      if !(maps_user_info.blank? || maps_user_info.empty?)
        firstname=maps_user_info[0]["firstname"]
        lastname=maps_user_info[0]["lastname"]
        fullname=firstname+lastname
      else
        fullname=''
      end  


    vendor=maps_studio_info["vendor_name"].nil? ? '': maps_studio_info["vendor_name"]
    
    maps_studio_productlist=journey_obj.get_maps_studio_productlist(maps_studio_info["id"]).body
    store=maps_studio_productlist[0]["store_name"].nil? ? '': maps_studio_productlist[0]["store_name"]
    storeID=maps_studio_productlist[0]["storeID"].nil? ? '': maps_studio_productlist[0]["storeID"]

    #puts consignment_visit_productlist
    sHTML=''
    sHTML= "<html><body>"
    sHTML+="<div><p style=\"font-size: 24px; text-align:centre\">Maps Studio Visit Notification</p></div>"
    sHTML+="<table width=\"100%\" >"
    sHTML+="<tr><td width=\"40%\"><p>Vendor: #{vendor}"
    sHTML+= "<p> Rep: #{fullname}</p><p> Store: #{store}</p> <p>Store Number: #{storeID}</p></td>"
    #puts consignment_info["start_time"]
    
    start_date=maps_studio_info["start_time"].nil? ? '': maps_studio_info["start_time"][0..9]
    start_time=maps_studio_info["start_time"].nil? ? '': maps_studio_info["start_time"][11..18]
    start_date_time = start_date+"," +start_time

    signoff_date=maps_studio_info["signoff_time"].nil? ? '': maps_studio_info["signoff_time"][0..9]
    signoff_time=maps_studio_info["signoff_time"].nil? ? '': maps_studio_info["signoff_time"][11..18]
    signoff_date_time = signoff_date +"," + signoff_time
    
    visit_time=maps_studio_info["total_visit_time"].nil? ? '': maps_studio_info["total_visit_time"];
    start_gps_lat=maps_studio_info["start_gps"].nil? ? '': maps_studio_info["start_gps"]["latitude"]
    start_gps_long=maps_studio_info["start_gps"].nil? ? '': maps_studio_info["start_gps"]["longitude"]
      
    close_gps_lat=maps_studio_info["signoff_gps"].nil? ? '': maps_studio_info["signoff_gps"]["latitude"]
    close_gps_long=maps_studio_info["signoff_gps"].nil? ? '': maps_studio_info["signoff_gps"]["longitude"]   
    
    sHTML+= "<td width=\"30%\"><p> Visit Time Started: #{start_date_time} </p> <p>Visit Time Finsihed: #{signoff_date_time}</p>"
    sHTML+= "<p> Visit time total: #{visit_time}</p>"
    sHTML+= "<p>Visit Start Location: #{start_gps_lat} #{start_gps_long}</p>"
    sHTML+= "<p>Visit End Location: #{close_gps_lat} #{close_gps_long}</p></td></tr></table>"
     #bbase64= "\"data:image/jpeg;base64, #{Base64.encode64("../tasks/ACE_2013_Logo.png")}\""
     #puts Base64.encode64("../tasks/ACE_2013_Logo.png") 
             
     #sImg= "<img hspace=\"3\" alt=\"\" src="+bbase64+" />"
     #sHTML+="<td width=\"30%\">#{sImg}</td>"
  
  
  
    sHTML+="<table width=\"100%\" border=\"1\" style=\"border-collapse: collapse\"> <thead style=\"background-color: #C0C0C0\">"
    sHTML+="<th>Product</th> <th>Barcode</th> <th>Model Stock</th> <th>Bays</th> <th>Stock</th> <th>Variance</th>"
    sHTML+="<th>Cover Damage</th>  <th>Security Tag</th> <th>RRP</th> <th>Price Displayed</th></thead>"
    
    iCount=0   
    maps_studio_productlist.each do |maps_studio_product|
      
        rrp=maps_studio_product["recommended_retail_price"].nil? ? '0': maps_studio_product["recommended_retail_price"]
        rp=rrp.to_i
        rrps="%.2f" % rp
        
        prcdp=maps_studio_product["price_displayed"].nil? ? '0': maps_studio_product["price_displayed"]
        pr=prcdp.to_i
        prcdps="%.2f" % prcdp
          
      if(iCount%2==0)  
        sHTML+="<tr style=\"background-color: #E0E0E0\"><td style=\"text-align: centre\">#{maps_studio_product["product_description"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["product_barcode"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["model_stock"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["bays"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["current_stock_on_hand"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["variance"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["cover_damage"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["security_tag"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{rrps}</td>"
        sHTML+="<td style=\"text-align: centre\">#{prcdps} </td>"
      else
        sHTML+="<tr><td style=\"text-align: centre\">#{maps_studio_product["product_description"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["product_barcode"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["model_stock"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["bays"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["current_stock_on_hand"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["variance"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["cover_damage"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{maps_studio_product["security_tag"]} </td>"
        sHTML+="<td style=\"text-align: centre\">#{rrps}</td>"
        sHTML+="<td style=\"text-align: centre\">#{prcdps} </td>" 
      end 
      iCount=iCount+1 
    end
      
    sHTML+="</table>"
    sHTML+="<h3>Photos</h3>"
    
    #recall_visit_header_imgs=journey_obj.get_recall_visit_header_imgs(recall_visit_info["id"]).body
    #sHTML+="<h4> Transfer Number: #{recall_visit_header_imgs[0]["transfer_id"]}</h4><table width=\"100%\">"
    
    sHTML += "<table width=\"100%\"><tr><td>Before Photo</td><td >"
    sImg_Tag=''
    before_photo_bin = maps_studio_info["display_attachments"]["before_photo"].nil? ? '' : journey_obj.image_from_url(maps_studio_info["display_attachments"]["before_photo"]["thumbnail"]).body
    if !(before_photo_bin.blank? || before_photo_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(before_photo_bin)}\""
      sImg_Tag="<img alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"

 
    sHTML += "<tr><td>Top Left After Photo</td><td >"
    sImg_Tag=''
    after_photo1_bin=maps_studio_info["display_attachments"]["after_photo1"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["after_photo1"]["thumbnail"]).body
    if !(after_photo1_bin.blank? || after_photo1_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(after_photo1_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Top Right After Photo</td><td>"
    sImg_Tag=''
    after_photo2_bin=maps_studio_info["display_attachments"]["after_photo2"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["after_photo2"]["thumbnail"]).body
    if !(after_photo2_bin.blank? || after_photo2_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo2_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag

    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Bottom Left After Photo</td><td>"
    sImg_Tag=''
    after_photo3_bin=maps_studio_info["display_attachments"]["after_photo3"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["after_photo3"]["thumbnail"]).body
    if !(after_photo3_bin.blank? || after_photo3_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo3_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Bottom Right After Photo</td><td>"
    sImg_Tag=''
    after_photo4_bin=maps_studio_info["display_attachments"]["after_photo4"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["after_photo4"]["thumbnail"]).body
    if !(after_photo4_bin.blank? || after_photo4_bin.empty?)
      after_photo4_bin=journey_obj.image_from_url(maps_studio_info ["display_attachments"]["after_photo4"]["thumbnail"]).body
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(after_photo4_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end  
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Tube Bin Photo</td><td>"
    sImg_Tag=''
    tube_photo_bin=maps_studio_info["display_attachments"]["tube_bin_photo"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["tube_bin_photo"]["thumbnail"]).body
    if !(tube_photo_bin.blank? || tube_photo_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(tube_photo_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML +="</td></tr>"
    
    sHTML += "<tr><td>Return Stock Photo 1</td><td>"

    return_stock_photo_1=maps_studio_info["display_attachments"]["return_stock_photo_1"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["return_stock_photo_1"]["thumbnail"]).body
    if !(return_stock_photo_1.blank? || return_stock_photo_1.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(return_stock_photo_1)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML +="</td></tr>"

    sHTML += "<tr><td>Return Stock Photo 2</td><td>"
    
    return_stock_photo_2=maps_studio_info["display_attachments"]["return_stock_photo_2"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["return_stock_photo_2"]["thumbnail"]).body
    if !(return_stock_photo_2.blank? || return_stock_photo_2.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(return_stock_photo_2)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML +="</td></tr>"
  
    sHTML += "<tr><td>Damaged Stock Photo 1</td><td>"
    damaged_stock_photo_1=maps_studio_info["display_attachments"]["damaged_stock_photo_1"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["damaged_stock_photo_1"]["thumbnail"]).body
    if !(damaged_stock_photo_1.blank? || damaged_stock_photo_1.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(damaged_stock_photo_1)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML +="</td></tr>"

    sHTML += "<tr><td>Damaged Stock Photo 2</td><td>"
    damaged_stock_photo_2=maps_studio_info["display_attachments"]["damaged_stock_photo_2"].nil? ? '' : journey_obj.image_from_url(maps_studio_info ["display_attachments"]["damaged_stock_photo_2"]["thumbnail"]).body
    if !(damaged_stock_photo_2.blank? || damaged_stock_photo_2.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(damaged_stock_photo_2)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML +="</td></tr></table>"
 
    
    #sHTML+="</table><p style=\"page-break-after:always; padding-top:20px\"><h3>Recall Sign-Off</p>"
    sHTML+="<table width=\"100%\" style=\"margin-top: 20px\"><tr><td>Staff Member Name</td><td>#{maps_studio_info["signoff_manager_name"]}</td></tr>"
    sHTML+="<tr><td>Staff Signature</td><td>"
    signature_photo_bin=maps_studio_info["display_attachments"]["signoff_manager_signature"].nil? ? '' :journey_obj.image_from_url(maps_studio_info["display_attachments"]["signoff_manager_signature"]["thumbnail"]).body
    img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(signature_photo_bin)}\""
    sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
    sHTML+=sImg_Tag
    sHTML+="</td></tr></table></html>"
    
    
    visit_id=maps_studio_info["visit_id"]
    
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
        subject   'Maps Studio Report'
        body      'PFA Maps Studio Report'
        add_file :filename => filename, :content => file_content
        puts "****************MAIL SENT*************************"

        payload = {"maps_studio_visit" => {"email_status"=>1}}
        journey_obj.put_maps_studio_visit(maps_studio_info["id"], payload)
      end
   end #end of recalls_visit_header
  end
end 