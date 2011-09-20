class ClientsController < ApplicationController
  before_filter :ensure_admin
  before_filter :load_client, :only => [:show, :edit, :destroy, :update]
  before_filter :load_clients, :only => [:index, :create]
  
  def show
    render
  end
  
  def create
    @client = Client.new(params[:client])
    @client_user = ClientUser.new(params[:client_user].merge(:client => @client))
    if @client_user.valid? && @client.valid?
      @client_user.save
      @client.save
      redirect_to client_path(@client)
    else
      render :index
    end
  end
  
  def index
    @client_user = ClientUser.new
    @client_user.generate_password!
    @client = Client.new
    render
  end
  
  def edit
    render
  end
  
  def update
    if @client.update(params[:client]) || !@client.dirty?
      redirect_to client_path(@client)
    else
      render :edit
    end
  end
  
  def destroy
    if @client.destroy
      render_success
    else
      render_failure("Couldn't delete client which has invoices")
    end 
  end
  
  protected
  
  def load_client
    not_found and return unless @client = Client.get(params[:id])
  end
  
  def load_clients
    @clients = Client.all(:order => [:name])
  end
  
  def number_of_columns
    params[:action] == "show" || params[:action] == "edit" ? 1 : super
  end
end # Clients
