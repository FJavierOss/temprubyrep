class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  # GET /countries.json
  def index
    if params[:search]
      #################### Aqui se agrega linea, esto se utiliza para que cuando
      #################### en la pagina del search se busque varios paises, estos
      #################### se muestren de 3 por pagina
      @countries = Country.where('headline ILIKE ?', "%#{params[:search]}%").paginate(:page => params[:page], per_page: 3)
    else
      #################### Aqui se agrega linea, esto se utiliza para que cuando
      #################### poder mostrar cierta cantidad de paises en la ruta countries
      #################### se muestren de 3 por pagina
      @countries = Country.paginate(:page => params[:page], per_page: 3)
    end
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    #################### Aqui se agrega linea, esto se utiliza para que en el show
    #################### del country se maneje la cantidad de ciudades que aparecen
    @cities = @country.cities.paginate(:page => params[:page], per_page: 3)
  end

  # GET /countries/new
  def new
    @country = Country.new
  end

  # GET /countries/1/edit
  def edit
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params)

    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: 'Country was successfully created.' }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: 'Country was successfully updated.' }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Country was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def follows
    @user = current_user
    @country = Country.find(params[:id])
    @user.follow!(@country)
    redirect_to country_path
  end

  def unfollows
    @user = current_user
    @country = Country.find(params[:id])
    @user.unfollow!(@country)
    redirect_to country_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:headline, :context, :image, :search)
    end
end
