require 'open-uri'
class NewsController < ApplicationController
  # GET /news
  # GET /news.json
  def index
    @news = News.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
    @news = News.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/new
  # GET /news/new.json
  def new
    @news = News.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1/edit
  def edit
    @news = News.find(params[:id])
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(params[:news])

    @people = Signup.all

    respond_to do |format|
      if @news.save

        @people.each do |e|

          emailAddress = e.email

          #Article information
          encoded1 = URI::encode(@news.description)
          encoded2 = URI::encode(@news.title)
          encoded3 = URI::encode(@news.name)

          description = encoded1.gsub(' ','%%%20')
          title = encoded2.gsub(' ','%%%20')
          name = encoded3.gsub(' ','%%%20')
          twitterName = "http://twitter.com/#{@news.twitter}"

          #Set email content. 
          subject = "More%20local%20tech%20news"
          header = "Submitted%20on%20www.OurTechHub.com"
          share = "Please%20help%20the%20Puerto%20Rican%20tech%20community%20by%20sharing%20this:"
          unsubscribe = "To%20unsubscribe%20email:%20justin@customerdevlabs.com"

          #Social Links
          bitly = Bitly.new('rjgonzo','R_e5e13a8afae46931a3091994f4b844d7')

          #Twitter
          twitter = "https://twitter.com/intent/tweet?text=#{description}&url=#{@news.url}"
          twitter_url = bitly.shorten(twitter)
          twitter_final = twitter_url.shorten

          #Facebook
          facebook = "http://www.facebook.com/sharer.php?s=100&p[url]=#{@news.url}&p[title]=#{title}&p[summary]=#{description}"
          fb_url = bitly.shorten(facebook)
          fb_final = fb_url.shorten

          message = "#{header}%0D%0DTitle:%0D%0D#{title}%0D%0DDescription:%0D%0D#{description}%0D%0D#{@news.url}%0D%0DSent%20by:%20#{name},%20#{twitterName}%0D%0D#{share}%0D%0DFacebook:%20#{fb_final}%20,%20Twitter:%20#{twitter_final}%0D%0D#{unsubscribe}"
          email = "https://sendgrid.com/api/mail.send.json?api_user=rgonzalez&api_key=123456&to=#{emailAddress}&toname=Influencer&subject=#{subject}&text=#{message}&from=#{@news.email}&fromname=#{name}"

          #Send email to request signature (with Sendgrid)  
          ap 'Email Data'
          ap email
          HTTParty.get(email)
      end

        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render json: @news, status: :created, location: @news, :callback => params[:callback] }
      else
        format.html { render action: "new" }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    @news = News.find(params[:id])

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news = News.find(params[:id])
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url }
      format.json { head :no_content }
    end
  end
end
