class WardsController < AdminController
  def index
    @wards = Ward.all
  end

  def new
    @ward = Ward.new
  end

  def edit
    @ward = Ward.find(params[:id])
  end

  def create
    @ward = Ward.new(params.require(:ward).permit(:name))
    if @ward.save
      redirect_to wards_path
    else
      render 'new'
    end
  end

  def update

  end

  def delete

  end
end
