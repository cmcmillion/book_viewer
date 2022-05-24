require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @table_of_contents = File.readlines "data/toc.txt"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home # layout.erb is used by default here
end

get "/chapters/:number" do
  number = params[:number].to_i
  @title = "Chapter #{number}: #{@table_of_contents[number - 1]}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter, layout: :layout
end

get "/search" do 
  @title = "Search"
  @query = params["query"]
  erb :search
end

helpers do
  def in_paragraphs(chapter_content)
    chapter_content.split("\n\n").map do |para|
      "<p>" + para + "</p>"
    end.join
  end

  def matching_chapters(query)
    return nil if query == nil
    (1..12).each_with_object([]) do |num, arr|
      @chapter_text = File.read("data/chp#{num}.txt")
      arr << num if @chapter_text.include?(query)
    end
  end
end

not_found do
  redirect "/"
end





