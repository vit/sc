class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
	@edit_mode = true
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
#        format.html { redirect_to @page, notice: 'Page was successfully created.' }
#        format.json { render :show, status: :created, location: @page }
        format.html { redirect_to edit_page_path(@page), notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: edit_page_path(@page) }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
	def update
		respond_to do |format|
			puts "format: #{format.inspect}"
			data = page_params
			if data
				if @page.update(data)
					format.html { redirect_to @page, notice: 'Page was successfully updated.' }
					format.json { render :show, status: :ok, location: @page }
					format.js {}
				else
					format.html { render :edit }
					format.json { render json: @page.errors, status: :unprocessable_entity }
					format.js {}
				end
			else
				op = params[:op]
				case op
					when 'add_block'
						@after_id = params[:after_id]
						@after_part = params[:after_part]
						@block_type = params[:block_type]
						@part = @page.insert_part_after(@block_type, @after_part)
				#		@journal_submission.sm_submit! # '1234567'
						format.js { render 'pages/op/add_block' }
					when 'remove_block'
						@block_id = params[:block_id]
						@page.remove_part(@block_id)
						format.js { render 'pages/op/remove_block' }
					when 'save_part_content'
						@part_id = params[:part_id]
						content = params[:content]
						@page.save_part_content(@part_id, content)
						format.js { render 'pages/op/save_part_content' }
					when 'save_part_config'
						@part_id = params[:part_id]
						@part = @page.get_part @part_id
						config = params[:config]
						config = ActiveSupport::JSON.decode(config)
						@page.save_part_config(@part_id, config)
						format.js { render 'pages/op/save_part_config' }
				#	when 'revise'
				end
puts params
			end
		end
	end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      #params.require(:page).permit(:name)
      params.require(:page).permit(:name) rescue nil
    end
end
