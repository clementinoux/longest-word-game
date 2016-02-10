class PlayersController < ApplicationController

require 'open-uri'
require 'json'

  def game
    @grid = []
    params[:grid_size].to_i.times do
      @grid << ("A".."Z").to_a.sample
    end
    @start_time = Time.now
  end

  RESULT = {
    message: "",
    translation: "",
    time: 0,
    score: 0
  }

  def score
    @attempt = params[:attempt]
    @end_time = Time.now
    RESULT[:time] = @end_time - Time.parse(params[:start_time])
    translation = {}
      api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{@attempt}"
      open(api_url) do |stream|
        translation = JSON.parse(stream.read)
        if translation.key?('term0')
          RESULT[:translation] = translation['term0']['PrincipalTranslations']["0"]['FirstTranslation']['term']
          RESULT[:score] = @attempt.size
          RESULT[:message] = "well done"
        else
          RESULT[:message] = "not an english word"
          RESULT[:translation] = nil
          RESULT[:score] = 0
        end
      end
    @result = RESULT
  end

end







