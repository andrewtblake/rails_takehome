class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities or /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    session[:activity_params] ||= {}
    @activity = Activity.new(session[:activity_params])
    @activity.current_step = session[:activity_step]
  end

  # GET /activities/1/edit
  def edit
    session[:activity_params].deep_merge!(activity_params) if params[:activity]
    @activity.current_step = session[:activity_step]
  end

  # POST /activities or /activities.json
  def create
    session[:activity_params].deep_merge!(activity_params)
    @activity = Activity.new(session[:activity_params])
    @activity.current_step = session[:activity_step]
    case params[:commit]
    when "Save"
      if @activity.all_valid?
        respond_to do |format|
          if @activity.save
            session[:activity_params] = nil
            session[:activity_step] = nil
            format.html { redirect_to activities_path, notice: "Activity was successfully created." }
            format.json { render :show, status: :created, location: @activity }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @activity.errors, status: :unprocessable_entity }
          end
        end
        return
      end
    when "Next"
      @activity.next_step if @activity.valid?
    when "Back"
      @activity.previous_step if @activity.valid?
    end
    session[:activity_step] = @activity.current_step
    redirect_to new_activity_path
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    session[:activity_params].deep_merge!(activity_params)
    @activity.current_step = session[:activity_step]
    case params[:commit]
    when "Save"
      respond_to do |format|
        if @activity.update(session[:activity_params])
          session[:activity_params] = nil
          session[:activity_step] = nil
          format.html { redirect_to activities_path, notice: "Activity was successfully updated." }
          format.json { render :show, status: :ok, location: @activity }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end
      return
    when "Next"
      @activity.next_step if @activity.valid?
    when "Back"
      @activity.previous_step if @activity.valid?
    end
    session[:activity_step] = @activity.current_step
    puts @activity.current_step.inspect
    redirect_to edit_activity_path
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_params
      params.require(:activity).permit(:name, :address, :starts_at, :ends_at)
    end
end
