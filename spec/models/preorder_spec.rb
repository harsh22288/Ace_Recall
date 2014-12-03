require 'rails_helper'

RSpec.describe Preorder, :type => :model do

  describe "#initialize" do
    context 'when create the first object' do
      it 'should call .setup once' do
        expect(Preorder).to receive(:setup).once.and_call_original
        Preorder.new({})
      end
    end

    context 'when create the second object' do
      it 'should not call .setup' do
        Preorder.new({})
        expect(Preorder).to_not receive(:setup)
        Preorder.new({})
      end
    end
  end

  describe "attr_reader methods and instance methods" do
    before { @preorder = Preorder.new('name_a' => 1, 'name_b' => 2) }
    subject { @preorder }

    it { should respond_to(:journey_preorder_info) }
    it { should respond_to(:preorder_number) }
    it { should respond_to(:journey_obj) }
    it { should respond_to(:sap_obj) }
    it { should respond_to(:order_reason_uuid) }
    it { should respond_to(:cleanliness_interior_exterior) }
    it { should respond_to(:feul_tank) }
    it { should respond_to(:is_nil?) }
    it { should respond_to(:exists?) }
  end

  describe "dynamic methods implemented by #method_missing" do
    before { @preorder = Preorder.new('name_a' => 1, 'name_b' => [1, 3, 5]) }
    subject { @preorder }


    describe "xxx_present?" do
      it "should return true for initilized names" do
        @preorder.name_a_present?.should == true
      end

      it "should return false for uninitilized names" do
        @preorder.name_present?.should == false
      end
    end

    describe "xxx_nil?" do
      it "should return false for initilized names" do
        @preorder.name_a_nil?.should == false
      end

      it "should return true for uninitilized names" do
        @preorder.name_nil?.should == true
      end
    end

    describe "xxx_to_sapX" do
      it "should return X for included value" do
        @preorder.name_b_to_sapX(3).should == 'X'
      end

      it "should return '' for not included value" do
        @preorder.name_b_to_sapX(2).should == ''
      end

      it "should return '' for uninitilized names" do
        @preorder.name_to_sapX(3).should == ''
      end
    end

    describe "xxx_to_s" do
      it "should return the correct value for initilized name" do
        @preorder.name_b_to_s.should == [1, 3, 5]
      end

      it "should return '' for uninitilized names" do
        @preorder.name_to_s.should == ''
      end
    end

  end
end
