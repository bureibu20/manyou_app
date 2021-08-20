class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index

    if params[:sort_expired]
      @tasks = Task.order(expired_at: :desc).page(params[:page]).per(5)
    elsif params[:sort_priority]
      @tasks = Task.order(priority: :desc).page(params[:page]).per(5)
    elsif
      @tasks = Task.all
      @tasks = @tasks.page(params[:page]).per(5)
    end  
    

    if params[:search_title].present? && params[:search_status].present?
      @tasks = Task.all.search_title(params[:search_title]).search_status(params[:search_status]).page(params[:page])
    elsif params[:search_title].present?
      @tasks = Task.all.search_title(params[:search_title]).page(params[:page])
    elsif params[:search_status].present?
      @tasks = Task.all.search_status(params[:search_status]).page(params[:page])
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :expired_at, :status, :priority)
    end
end
