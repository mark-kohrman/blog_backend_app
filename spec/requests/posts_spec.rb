require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "should return all of the blog posts in the database" do

      user = User.create!(name: "Steve Perry", email: "steve@perry.com", password: "password")

      Post.create!(
        title: "cool things going on",
        body: "some real cool stuff happenin",
        image: "coolimage.com",
        user_id: user.id
      )

      Post.create!(
        title: "hi",
        body: "fun things",
        image: "fun.com",
        user_id: user.id
      )
      Post.create!(
        title: "coolio",
        body: "is a rapper",
        image: "coolioimage.com",
        user_id: user.id
        )
      Post.create!(
        title: "aljf;dsk",
        body: "s",
        image: "oo.com",
        user_id: user.id
        )
      Post.create!(
        title: "cool things",
        body: "some real cosdfsdhappenin",
        image: "coolimage.com",
        user_id: user.id
        )

        

      get "/api/posts"
      posts = JSON.parse(response.body)

      
      expect(response).to have_http_status(200)
      expect(posts.count).to eq(5)
    end
  end
  describe "get /posts/:id" do
    it "should return a specific post" do
      user = User.create!(name: "Marshall Mathers", email: "m&m@gmail.com", password: "password")

      post = Post.create!(
        title: "How to be a rapper",
        body: "rhymes and swag",
        image: "rap.com",
        user_id: user.id
      )

      get "/api/posts/#{post.id}"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post['title']).to eq("How to be a rapper")
    end
  end

  describe "POST /posts" do
    it "should create a new post" do
      user = User.create!(email: "bob@bob.com", password: "password", name: "bob knight")

      jwt = JWT.encode(
        {
          user: user.id,
          exp: 24.hours.from_now.to_i
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )

      post "/api/posts", params: {
        title: "Chillin",
        body: "Chillin and hanging",
        image: "lemonchill.com",
      }, headers: {
        "Authorization" => "Bearer #{jwt}"
      }

      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq('Chillin')
    end
  end
end
