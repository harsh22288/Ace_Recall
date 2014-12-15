namespace :html_to_pdf do
  require 'pdfcrowd'
  require "base64"
  require 'net/smtp'
  desc "Converts HTML to PDF"
  task :convert => :environment do
    puts "Starting conversion"
    Rake::Task["html_to_pdf:html_pdf_convert"].invoke
    puts "Ending conversion"
  end

  task :html_pdf_convert => :environment do
    puts "Write your main logic for conversion here"
    journey_obj = UnirestJourneyClient.new
    get_html_string(journey_obj)
  end

  def get_html_string(journey_obj)
  client = Pdfcrowd::Client.new("accrete", "1cabeac1948fa82be5702cfdd6e0bf9d")
  #client = Pdfcrowd::Client.new("naveen05", "4d0ab2416de179d799b9fc8250f34a98")

  

  
  recalls_list = journey_obj.get_recalls.body
  recalls_list.each do |recall_info|
    recall_visit_header_list= journey_obj.get_recall_visit_header(recall_info["id"]).body

    recall_visit_header_list.each do |recall_visit_info|
 
      
      
      
      recall_user_id=journey_obj.get_recall_user_id(recall_visit_info["user_object_id"]).body
      recall_user_info= recall_visit_info["user_object_id"].nil? ? '' :journey_obj.get_recall_user_info(recall_visit_info["user_object_id"]).body
      #recall_visit_info["user_object_id"].nil? ? '' : 
      
      if !(recall_user_info.blank? || recall_user_info.empty?)
        firstname=recall_user_info[0]["firstname"]
        lastname=recall_user_info[0]["lastname"]
        fullname=firstname+lastname
      else
        fullname=''
      end  
      
      date_of_start=recall_visit_info["start_date"].nil? ? '': recall_visit_info["start_date"]
      date_of_end=recall_visit_info["end_date"].nil? ? '': recall_visit_info["end_date"]
      
      start_date=recall_visit_info["time_opened"].nil? ? '': recall_visit_info["time_opened"][0..9]
      start_time=recall_visit_info["time_opened"].nil? ? '': recall_visit_info["time_opened"][11..18]
      start_date_time = start_date+"," +start_time

      signoff_date= recall_visit_info["time_closed"].nil? ? '': recall_visit_info["time_closed"][0..9]
      signoff_time= recall_visit_info["time_closed"].nil? ? '':recall_visit_info["time_closed"][11..18]
      signoff_date_time = signoff_date +"," + signoff_time
    
      visit_time=recall_visit_info["total_visit_time"].nil? ? '':recall_visit_info["total_visit_time"];
       
      
      recallID=recalls_list[0]["recallID"].nil? ? '' : recalls_list[0]["recallID"]
      start_gps_lat=recall_visit_info["gps_opened"].nil? ? '': recall_visit_info["gps_opened"]["latitude"]
      start_gps_long=recall_visit_info["gps_opened"].nil? ? '': recall_visit_info["gps_opened"]["longitude"]
      
      close_gps_lat=recall_visit_info["gps_closed"].nil? ? '': recall_visit_info["gps_closed"]["latitude"]
      close_gps_long=recall_visit_info["gps_closed"].nil? ? '': recall_visit_info["gps_closed"]["longitude"]
       
       recall_visit_productlist=journey_obj.get_recall_visit_productlist(recall_visit_info["id"]).body
       store_name=recall_visit_productlist[0]["store_name"].nil? ? '' : recall_visit_productlist[0]["store_name"]

       sHTML=''
       sHTML= "<html><body>"
       sHTML+="<div><h2>Recall Visit Notification</h2></div>"    #<p style=\"font-size: 24px; text-align:centre\">Recall Visit Notification</p></div>
       sHTML+="<table width=\"100%\" >"
       sHTML+= "<tr><td width=\"40%\"> <p>Recall: #{recallID}</p>"
       sHTML+="<p>Start Date: #{recall_visit_info["start_date"]}</p><p>End Date: #{recall_visit_info["end_date"]}</p>"
       sHTML+= "<p> Rep: #{fullname}</p><p> Store: #{recall_visit_productlist[0]["store_name"]}</p> <p>Store Number: #{recall_visit_productlist[0]["storeID"]}</p></td>"
       sHTML+= "<td width=\"30%\"> <p> Visit Time Started: #{start_date_time} </p> <p>Visit Time Finsihed: #{signoff_date_time}</p>"
       sHTML+= "<p> Visit time total: #{visit_time}</p>"
       sHTML+= "<p>Visit Start Location: #{start_gps_lat} #{start_gps_long}</p>"
       sHTML+= "<p>Visit End Location: #{close_gps_lat} #{close_gps_long}</p></td>"
       #bbase64= "\"data:image/jpeg;base64, #{Base64.encode64("../tasks/ACE_2013_Logo.png")}\""
       #puts Base64.encode64("../tasks/ACE_2013_Logo.png") 
               
       #sImg= "<img hspace=\"3\" alt=\"\" src="+bbase64+" />"
       #sHTML+="<td width=\"30%\">#{sImg}</td>"



       sHTML+="<table width=\"100%\" border=\"1\" style=\"border-collapse: collapse\"> <thead style=\"background-color: #C0C0C0\"><th>Product</th><th>Barcode</th><th>To Recall</th><th>Recalled</th><th>Cost Price</th> <th>Stock Variance</th>"
       sHTML+="<th>Damaged</th> <th>Missing</th><th>Sold</th></thead>"
       iCount=0
       recall_visit_productlist.each do |recall_product|
         if(iCount%2==0)
          sHTML+="<tr style=\"background-color: #E0E0E0\"><td style=\"text-align: centre\">#{recall_product["style_desc"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["upc"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["to_recall_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["recalled_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["unit_cost"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["stock_variance"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["damaged_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["missing_quantity"]}</td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["sold"]} </td></tr>"
         else
          sHTML+="<tr><td style=\"text-align: centre\">#{recall_product["style_desc"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["upc"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["to_recall_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["recalled_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["unit_cost"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["stock_variance"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["damaged_quantity"]} </td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["missing_quantity"]}</td>"
          sHTML+="<td style=\"text-align: centre\">#{recall_product["sold"]} </td></tr>" 
         end
         iCount=iCount+1   
       end
      
    sHTML+="</table>"
    sHTML+="<h3>Recall Visit Transfer and Photos</h3>"
    
    recall_visit_header_imgs=recall_visit_info["id"].nil? ? '': journey_obj.get_recall_visit_header_imgs(recall_visit_info["id"]).body
    
    if !(recall_visit_header_imgs.nil? || recall_visit_header_imgs.empty?)
        transferNumber=recall_visit_header_imgs[0]["transfer_id"].nil? ? '': recall_visit_header_imgs[0]["transfer_id"]
        sHTML+="<h4> Transfer Number: #{transferNumber}</h4><table width=\"100%\">"
        
        sHTML += "<tr><td>Damaged </td><td >"
        sImg_Tag=''
    
        recall_visit_header_imgs.each do |recall_visit_photo_info|
        img_bin = recall_visit_photo_info["display_attachments"]["damaged_stock_photo"].nil? ? '' : journey_obj.image_from_url(recall_visit_photo_info ["display_attachments"]["damaged_stock_photo"]["thumbnail"]).body
          if !(img_bin.blank? || img_bin.empty?)
            img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(img_bin)}\""
            sImg_Tag="<img alt=\"\" src="+img_base64+" />"
            sHTML+=sImg_Tag
          end  
        end
        sHTML +="</td></tr>"
    
        
        sHTML += "<tr><td>Return Stock Box</td><td >"
        sImg_Tag=''
        recall_visit_header_imgs.each do |recall_visit_photo_info|
        return_stock_photo_bin = recall_visit_photo_info["display_attachments"]["return_stock_photo"].nil? ? '' : journey_obj.image_from_url(recall_visit_photo_info ["display_attachments"]["return_stock_photo"]["thumbnail"]).body
          if !(return_stock_photo_bin.blank? || return_stock_photo_bin.empty?)
            img_base64 = "\"data:image/jpeg;base64,#{Base64.encode64(return_stock_photo_bin)}\""
            sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
            sHTML+=sImg_Tag
          end  
        end
        sHTML +="</td></tr>"
        
        sHTML += "<tr><td>Packed Stock Box</td><td>"
        sImg_Tag=''
        recall_visit_header_imgs.each do |recall_visit_photo_info|
        packed_stock_photo_bin = recall_visit_photo_info["display_attachments"]["packed_stock_photo"].nil? ? '' : journey_obj.image_from_url(recall_visit_photo_info ["display_attachments"]["packed_stock_photo"]["thumbnail"]).body
         if !(packed_stock_photo_bin.blank? || packed_stock_photo_bin.empty?)
          img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(packed_stock_photo_bin)}\""
          sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
          sHTML+=sImg_Tag
         end 
        end
        sHTML +="</td></tr>"
        
        sHTML += "<tr><td>Zebra, ACE Sticker</td><td>"
        sImg_Tag=''
        recall_visit_header_imgs.each do |recall_visit_photo_info|
        sticker_photo_bin = recall_visit_photo_info["display_attachments"]["sticker_photo"].nil? ? '' : journey_obj.image_from_url(recall_visit_photo_info ["display_attachments"]["sticker_photo"]["thumbnail"]).body
        if !(sticker_photo_bin.blank? || sticker_photo_bin.empty?)
          img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(sticker_photo_bin)}\""
          sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
          sHTML+=sImg_Tag
         end 
    end
   end 
    sHTML +="</td></tr>"
    sHTML+="</table><p style=\"padding-top:20px\"><h3>Recall Sign-Off</p>"
    sHTML+="<table width=\"100%\"><tr><td>Staff Member Name</td><td>#{recall_visit_info["signoff_staff_name"]}</td></tr>"
    sHTML+="<tr><td>Staff Member Designation</td><td>#{recall_visit_info["signoff_staff_designation"]}</td></tr>"
    sHTML+="<tr><td>Staff Signature</td><td>"
    signature_photo_bin = recall_visit_info["display_attachments"]["signoff_staff_signature"].nil? ? '' : journey_obj.image_from_url(recall_visit_info ["display_attachments"]["signoff_staff_signature"]["thumbnail"]).body
    if !(signature_photo_bin.blank? || signature_photo_bin.empty?)
      img_base64 = "\"data:image/jpeg;base64, #{Base64.encode64(signature_photo_bin)}\""
      sImg_Tag="<img hspace=\"3\" alt=\"\" src="+img_base64+" />"
      sHTML+=sImg_Tag
    end
    sHTML+="</td></tr></table></html>"
    
    recall_id= recall_visit_info["recallID"].to_s
    visit_id= recall_visit_info["visit_id"].to_s
    visit=visit_id.to_s
    
    name_temp=recall_id + "_" + visit
    name="#{name_temp}.pdf"
    options = {
        :address => "smtp.gmail.com",
        :port => 587,
        :user_name => "accrete.aceretail@gmail.com",
        :password => 'accrete123',
        :authentication => 'plain',
        :enable_starttls_auto => true
      }

      Mail.defaults do
        delivery_method :smtp, options
      end

    file_path = "./tmp"
    #filename = "#{recall_id +"_"+ visit_id}.pdf"
    filename=name
    File.open("#{file_path}/#{filename}", 'wb') {|f| client.convertHtml(sHTML, f)}
    file_content = File.read("#{file_path}/#{filename}")
    encoded_content = Base64.encode64(file_content)
    Mail.deliver do
        from      'accrete.aceretail@gmail.com'
        to        "harsh22288@gmail.com"                        
        subject   'Recall Report'
        body      'PFA Recall Report'
        add_file :filename => filename, :content => file_content
        puts "****************MAIL SENT*************************"

        payload = {"recall_visit" => {"email_status"=>1}}
        journey_obj.put_recall_visit_header(recall_visit_info["id"], payload)
    end
   end #end of recalls_visit_header
  end   #end of recalls_list
 end   #end of def
end   #end of namespace
   

