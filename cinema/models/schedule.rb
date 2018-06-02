class Schedule

  attr_accessor :times, :title, :name

  def initialize(options)
    @times = options['times']
    @title = options['title']
    @name = options['name']
  end

end
