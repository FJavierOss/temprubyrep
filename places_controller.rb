# linea 90, ver el tema de las columnas extra para latitude y longitude. el tipo de dato es :decimal
class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :set_city, only: [:new, :create, :update, :edit]
  before_action :set_country, only: [:new, :create, :update, :edit]

  # GET /places
  # GET /places.json
  def index
    if params[:search]
      @places = Place.where('name ILIKE ?', "%#{params[:search]}%")
    else
      @city = City.find(params[:city_id])
      @places = @city.places
    end
  end

  def show
    @city = City.find(params[:city_id])
  end
  # GET /places/1
  # GET /places/1.json

  # GET /places/new
  def new
    @place = Place.new
    # @place.city_id =
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)
    @place.city_id = @city.id
    @place.country_id = @country.id
    respond_to do |format|
      if @place.save
        format.html { redirect_to country_city_path(@city.country_id, @city.id), notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to country_city_path(@city.country_id, @city.id), notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    def set_city
      @city = City.find(params[:city_id])
    end

    def set_country
      @country = Country.find(params[:country_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:name, :description, :image, :latitude, :longitude, :search)
    end
end
