require 'rails_helper'

RSpec.describe JourneyUri, :type => :model do
  describe ".parameters(a: 1, b: true, c: false, d: 2)" do
    it {
      expect(
        JourneyUri.parameters(
          a: 1, 
          b: true, 
          c: false, 
          d: 2
        )
      ).to eq({
        "q[a]"=>"1", 
        "q[b]"=>"true", 
        "q[c]"=>"false", 
        "q[d]"=>"2"
      })
    }
  end

  describe ".image('/a/b/c')" do
    it {expect(JourneyUri.image('/a/b/c')).to eq(JOURNEY_CONFIG['base_uri'].sub('/api/v1','') + "/a/b/c")}
  end

  describe ".uri(table, uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.uri('table', '1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/table/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.uri('table')).to eq("#{JOURNEY_CONFIG['base_uri']}/table.json")}
    end
  end

  describe ".customer(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.customer('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/customer/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.customer).to eq("#{JOURNEY_CONFIG['base_uri']}/customer.json")}
    end
  end
  
  describe ".vehicle(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.vehicle('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/vehicle/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.vehicle).to eq("#{JOURNEY_CONFIG['base_uri']}/vehicle.json")}
    end
  end
  
  describe ".package_available(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.package_available('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/package_available/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.package_available).to eq("#{JOURNEY_CONFIG['base_uri']}/package_available.json")}
    end
  end
  
  describe ".recall_available(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.recall_available('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_available/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.recall_available).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_available.json")}
    end
  end
  
  describe ".recall_selected(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.recall_selected('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_selected/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.recall_selected).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_selected.json")}
    end
  end
  
  describe ".recall_item(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.recall_item('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_item/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.recall_item).to eq("#{JOURNEY_CONFIG['base_uri']}/recall_item.json")}
    end
  end
  
  describe ".package_selected(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.package_selected('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/package_selected/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.package_selected).to eq("#{JOURNEY_CONFIG['base_uri']}/package_selected.json")}
    end
  end
  
  describe ".preorder(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.preorder('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/preorder/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.preorder).to eq("#{JOURNEY_CONFIG['base_uri']}/preorder.json")}
    end
  end
  
  describe ".exterior_photo(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.exterior_photo('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/exterior_photo/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.exterior_photo).to eq("#{JOURNEY_CONFIG['base_uri']}/exterior_photo.json")}
    end
  end
  
  describe ".line_item(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.line_item('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/line_item/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.line_item).to eq("#{JOURNEY_CONFIG['base_uri']}/line_item.json")}
    end
  end
  
  describe ".data_model" do
    it {expect(JourneyUri.data_model).to eq("#{JOURNEY_CONFIG['base_uri']}/_datamodel.json")}
  end
  
  describe ".service_advisor(uuid=nil)" do
    context "with uuid='1234'" do
      it {expect(JourneyUri.service_advisor('1234')).to eq("#{JOURNEY_CONFIG['base_uri']}/service_advisor/1234.json")}
    end

    context "without uuid" do
      it {expect(JourneyUri.service_advisor).to eq("#{JOURNEY_CONFIG['base_uri']}/service_advisor.json")}
    end
  end

  describe ".payment_code" do
    it {expect(JourneyUri.payment_code).to eq("#{JOURNEY_CONFIG['base_uri']}/payment_method.json")}
  end

  describe ".damage_item" do
    it {expect(JourneyUri.damage_item).to eq("#{JOURNEY_CONFIG['base_uri']}/damage_item.json")}
  end


end
