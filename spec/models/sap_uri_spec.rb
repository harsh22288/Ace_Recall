require 'rails_helper'

RSpec.describe SapUri, :type => :model do

  describe ".customers" do
    it { expect(SapUri.customers).to eq("#{SAP_CONFIG['base_uri']}/ZACC_CUSTOMER_SERVICE_SRV_01/CUSTOMERCOLLECTION") }
  end
  
  describe ".customer(cust_id)" do
    it { expect(SapUri.customer('cid')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_CUSTOMER_SERVICE_SRV_01/CUSTOMERCOLLECTION('cid')") }
  end
  
  describe ".vehicles" do
    it { expect(SapUri.vehicles).to eq("#{SAP_CONFIG['base_uri']}/ZACC_VEHICLE_SERVICE_SRV/VEHICLESet") }
  end
  
  describe ".vehicle(vehicle_id)" do
    it { expect(SapUri.vehicle('vid')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_VEHICLE_SERVICE_SRV/VEHICLESet('vid')") }
  end
  
  describe ".recall(vhvin)" do
    it { expect(SapUri.recall('vin')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_VEHICLE_RECALL_SERVICE_SRV/RECALLSet?$format=json&$filter=Vhvin eq 'vin'") }
  end
  
  describe ".recall_line_item(recall_number)" do
    it { expect(SapUri.recall_line_item('recallno')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_RECALL_VEHICLE_SERVICE_SRV/RECALLBOMSet/?$format=json&$filter=InClmno eq 'recallno'") }
  end
  
  describe ".packages" do
    it { expect(SapUri.packages).to eq("#{SAP_CONFIG['base_uri']}/ZACC_PACKAGE_LIST_SERVICE_SRV/PACKAGELISTCOLLECTION") }
  end
  
  describe ".packagebom" do
    it { expect(SapUri.packagebom).to eq("#{SAP_CONFIG['base_uri']}/ZACC_PACKAGE_BOM_SERVICE_SRV/PACKAGEBOMSet?$format=json") }
  end
  
  describe ".preorders" do
    it { expect(SapUri.preorders).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_SERVICE_SRV/ORDERCOLLECTIONSet") }
  end
  
  describe ".preorder(preorder_num)" do
    it { expect(SapUri.preorder('pono')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_SERVICE_SRV/ORDERCOLLECTIONSet('pono')") }
  end
  
  describe ".package_attachment(id=nil)" do
    context "with parameter" do
      it { expect(SapUri.package_attachment('id')).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_ATTACH_FILE_SERVICE_SRV/ATTACHSet") }
    end
  
    context "without parameter" do
      it { expect(SapUri.package_attachment).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_ATTACH_FILE_SERVICE_SRV/ATTACHSet") }
    end
  end
  
  describe ".recall_update" do
    it { expect(SapUri.recall_update).to eq("#{SAP_CONFIG['base_uri']}/ZACC_VEHICLE_RECALL_SERVICE_SRV/RECALLSet") }
  end
  
  describe ".add_package" do
    it { expect(SapUri.add_package).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_ADD_PACK_SERVICE_SRV/PACKADDSet") }
  end
  
  describe ".order_copy" do
    it { expect(SapUri.order_copy).to eq("#{SAP_CONFIG['base_uri']}/ZACC_ORDER_UPDATE_SERVICE_SRV/ORDERCOPYSet") }
  end
end
