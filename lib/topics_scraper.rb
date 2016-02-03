require 'mechanize'

class TopicsScraper

  TEFLPEDIA = "http://teflpedia.com"

  # メイン関数
  def self.scrape
    @tags = []

    @agent = Mechanize.new
    page = @agent.get("#{TEFLPEDIA}/Category:Conversation_questions")
    page.search('.mw-content-ltr')[1].search('li').each do |category|
      scrape_category(category.at('a').attr('href'))
    end
  end


  private

  def self.scrape_category(url)
    page = @agent.get("#{TEFLPEDIA}#{url}")

    @tags.push page.title.split(' ')[0..-5].join(' ')
    puts
    p @tags

    h_stack = [1]
    page.at('#mw-content-text').children.each do |child|
      if child.name =~ /\Ah[1-6]\Z/
        tag_title = child.at('.mw-headline').inner_text
        if tag_title === "See also"
          break
        end

        new_h_num = child.name[1].to_i
        while h_stack[-1] >= new_h_num
          h_stack.pop
          @tags.pop
        end
        h_stack.push(new_h_num)
        @tags.push(tag_title)
      elsif child.name === "ul"
        puts
        p @tags
        child.children.each do |li|
          next if li.name != "li"
          @topic_title = []
          scrape_li(li)
        end
      end
    end


    while h_stack.length > 1
      h_stack.pop
      @tags.pop
    end

    @tags.pop
  end

  def self.scrape_li(li)
    child_ul =  li.at('ul')
    is_leaf = true
    topic_title_length = @topic_title.length
    li.children.each do |child|
      if child.text? && child.inner_text != "\n"
        @topic_title.push(child.inner_text.strip)
      elsif child.name === "ul"
        is_leaf = false
        child.children.each do |li|
          next if li.name != "li"
          scrape_li(li)
        end
      end
    end

    if is_leaf
      # Topic 登録
      topic = Topic.new
      topic.title = @topic_title.join(Topic::TITLE_SPLITTTER)
      topic.tags = @tags.uniq.join(",")
      topic.source = @agent.current_page.uri.to_s
      puts topic.title
      topic.save
    end
    while @topic_title.length > topic_title_length
      @topic_title.pop
    end
  end

end