class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @post = Post.new    #new action 에서 데려옴
  end

  def map
  end

  def map_data
      max = JSON.parse(params[:max]) #JSON_string => hash
      min = JSON.parse(params[:min]) #JSON_string => hash
      indices=JSON.parse(params[:indices]) #네이버맵에 이미 로딩되어있는 학교들의 id
      #{y:37.xxx, _lat:... ,x:xxxx, _lon:xxx}
      #@school =School.all.limit(100)
      school=School.where("(lat between ? and ?) and (lng between ? and ?)",min["_lat"],max["_lat"],min["_lng"],max["_lng"])
      #이 인덱스 들의 학교 제외코드
      school_id = school.map{|x| x.id}
      school_id -= indices #기존 네이버 맵에 로딩되이있지 않은 학교들의 id 들만 저장
      if school_id.length == 0
        school = []
      else
        #school_id에 존재하는 학교들만 school에서 빼내주면 됨
        school = school.select{|x| school_id.include? x.id}
      end

      respond_to do |format|
        #format.json{render json:@school} #데이터 주는 것
        format.json{render json:[school,school_id]} #데이터 주는 것
      end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new

  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to '/posts', notice: 'Post was successfully created.' } #
        format.json { render :show, status: :created, location: @post }
        format.js{} # javas일때는 js요청을 해야함  응답하는 포멧
      #별다른 명시를 하지 앟으념ㄴ create.js.erb를 반환하는다는 말
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
