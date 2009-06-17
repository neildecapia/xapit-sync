require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Recipe do
  before(:each) do
    # we don't want to trigger the xapitsync command with these
    XapitSync.after_record_change { }
  end
  
  it "should make xapit change when created" do
    XapitChange.delete_all
    recipe = Recipe.create!(:name => "foo")
    change = XapitChange.first
    change.target_class.should == "Recipe"
    change.target_id.should == recipe.id
    change.operation.should == "create"
    change.index_attributes.should == recipe.xapit_index_attributes
    change.index_blueprint.text_attributes.should == recipe.class.xapit_index_blueprint.text_attributes
  end
  
  it "should make xapit change when updated" do
    recipe = Recipe.create!(:name => "foo")
    XapitChange.delete_all
    recipe.update_attribute(:name, "bar")
    change = XapitChange.first
    change.target_class.should == "Recipe"
    change.target_id.should == recipe.id
    change.operation.should == "update"
    change.index_attributes.should == recipe.xapit_index_attributes
    change.index_blueprint.text_attributes.should == recipe.class.xapit_index_blueprint.text_attributes
  end
  
  it "should make xapit change when destroyed" do
    recipe = Recipe.create!(:name => "foo")
    XapitChange.delete_all
    recipe.destroy
    change = XapitChange.first
    change.target_class.should == "Recipe"
    change.target_id.should == recipe.id
    change.operation.should == "destroy"
    change.index_attributes.should be_nil
    change.index_blueprint.should be_nil
  end
  
  it "should have a hash of all attributes which are for indexing" do
    Recipe.new(:name => "foo").xapit_index_attributes.should == { :id => nil, :name => "foo" }
  end
end