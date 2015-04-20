class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
    
  swagger_controller :products, 'Products'

  # GET /products
  # GET /products.json

  swagger_api :index do
    summary 'Fetches all Product items'
    notes 'This lists all the products'
  end
  
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  swagger_api :show do
    summary 'Returns a product'
    notes 'Returns a product'
    param :path, :id, :integer, :required, "Product ID"
    response :ok, "Success", :Product
    response :not_found
  end

  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  swagger_api :create do
    summary "Creates a new Product"
    param :form, :name, :string, :required, "Product name"
    param :form, :description, :string, :required, "Product decription"
    param :form, :price, :float, :required, "Product price"
    response :unauthorized
    response :not_acceptable
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT/PATCH /products/1
  # PUT/PATCH /products/1.json
  swagger_api :update do
    summary "Update an existing Product"
    param :path, :id, :string, :required, "Product ID"
    param :form, :name, :string, :optional, "Product name"
    param :form, :description, :string, :optional, "Product decription"
    param :form, :price, :float, :optional, "Product price"
    response :unauthorized
    response :not_acceptable
  end
  
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  swagger_api :delete do
    summary "Delete an existing Product"
    param :path, :id, :string, :required, "Product ID"
    response :unauthorized
    response :not_acceptable
  end
  
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price)
    end
end
