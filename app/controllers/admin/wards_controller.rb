class Admin::WardsController < AdminController
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
      redirect_to admin_wards_path
    else
      render 'new'
    end
  end

  def update
    @ward = Ward.find(params[:id])
    if @ward.update(params.require(:ward).permit(:name))
      redirect_to admin_wards_path
    else
      render 'edit'
    end
  end

  def delete

  end
end
