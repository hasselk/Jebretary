class InstancesController < ApplicationController
  
  respond_to :html, :js


  def index
  end

  def create
    #raise params.inspect
    #/home/sujimichi/Share/KSPv0.19.1
    #r:\\Games\\KSPv0.19.1
    #params[:full_path] = "r:\\Games\\KSPv0.19.1"
    #params[:full_path] = "/home/sujimichi/Share/KSPv0.19.1"
    
    full_path = params[:full_path]
    if full_path.include?("/")
      full_path = full_path.split("/")
    elsif full_path.include?("\\")
      full_path = full_path.split("\\")
    else
      full_path = "error"
    end

    @instance = Instance.new(:full_path => full_path.to_json)

    begin
      files = Dir.open(File.join(full_path)).to_a
      raise "nothing found" if files.blank?
    rescue
      @instance.errors.add(:base, "couldn't open directory")
    end
    @instance.errors.add(:base, "Couldn't locate KSP.exe") if !files.blank? && !files.include?("KSP.exe")


    respond_with(@instance) do |f|      
      if @instance.errors.empty?
        @instance.save
        f.js { }
      else
        f.html { render :action => "new", :status => 422 }
      end
    end
  end

  def show
    @instance = Instance.find(params[:id])
    @campaigns = @instance.campaigns.includes(:craft)
    

  end
end
