xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "BradChen.com"
  xml.id "http://www.bradchen.com/"
  xml.link "href" => "http://www.bradchen.com/"
  xml.link "href" => "http://www.bradchen.com/open-sourcefeed.xml",
           "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "Brad Chen" }

  blog.articles[0..9].each do |article|
    if ! article.tags.include? 'open source' then
      next
    end

    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "Article Author" }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end