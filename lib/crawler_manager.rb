# frozen_string_literal: true
class CrawlerManager
  LOAD_PATH = '[[ -s "/usr/local/rvm/bin/rvm" ]] && source "/usr/local/rvm/bin/rvm";'
  CD_RAILS_DIR = 'cd /home/deployer/apps/transparency_assist/staging/current;'

  def initialize(debug: false, crawler_type: 'all', year: nil, category: nil)
    @debug = debug
    @crawler_type = crawler_type
    @year = year
    @category = category
  end

  def crawl
    Net::SSH.start(ENV.fetch('EC2_INSTANCE_HOST'), ENV.fetch('EC2_INSTANCE_USER')) do |ssh|
      ssh.exec!(LOAD_PATH + CD_RAILS_DIR + rake_command +
                ' >> /tmp/nohup.log & sleep 1 && exit')
    end
  end

  private

  def rake_command
    env_variables + ' nohup bundle exec rake crawl:' + crawler
  end

  def env_variables
    env = "RAILS_ENV=#{Rails.env}"
    return env unless @debug
    env + ' DEBUG=true'
  end

  def crawler
    crawler_with_args = @crawler_type
    return crawler_with_args unless @year
    if @category
      crawler_with_args + "[#{@year},#{@category}]"
    else
      crawler_with_args + "[#{@year}]"
    end
  end
end
