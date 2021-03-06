require "rails_helper"

RSpec.describe GenerateDocModel do
  include LoadDataspec
  include GenerateDocModel
  describe "generate models for each data source" do
    Project.delete_all
    let(:project_path) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) { create_project(project_path) }
    
    it "should create models for all sources" do
      expect(GenerateDocModel.gen_classname(project.datasources.first)).to eq("TweetPeopleTwitterUser")
    end

    it "should generate a document class" do
      expect(GenerateDocModel.gen_doc_class(project.datasources.first).to_s).to eq("GenerateDocModel::TweetPeopleTwitterUser")
    end

    it "should save mappings correctly in the class" do
      cl = GenerateDocModel.gen_doc_class(project.datasources.first)
      mappings = cl.mappings.to_hash[:tweet_people_twitter_user][:properties][:name]
      intended = {:type=>"string", :analyzer=>"english", :term_vector=>"with_positions_offsets_payloads"}
      expect(mappings).to eq(intended)
    end

    Project.delete_all
  end
end
