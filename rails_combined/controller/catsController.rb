class CatsController < ControllerBase
  def index
    @cats = Cat.all
  end

  def new
    @cat = Cat.new
    @human = Human.all
    render :new
  end

  def show

    @cat = Cat.find(params["cat_id"])
    render :show
  end

  def create
    @cat = Cat.new(params["cat"])

    if @cat.save
      flash["notice"] = ["You have successfully made a new cat!"]
      render :show
    else
      flash["errors"] = ["Invalid parameters"]
      render :new
    end
  end
end
