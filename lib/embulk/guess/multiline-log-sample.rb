module Embulk
  module Guess

    # TODO implement guess plugin to make this command work:
    #      $ embulk guess -g "multiline-log-sample" partial-config.yml
    #
    #      Depending on the file format the plugin uses, you can use choose
    #      one of binary guess (GuessPlugin), text guess (TextGuessPlugin),
    #      or line guess (LineGuessPlugin).

    #require "embulk/parser/multiline-log-sample.rb"

    #class MultilineLogSampleParserGuessPlugin < GuessPlugin
    #  Plugin.register_guess("multiline-log-sample", self)
    #
    #  def guess(config, sample_buffer)
    #    if sample_buffer[0,2] == GZIP_HEADER
    #      guessed = {}
    #      guessed["type"] = "multiline-log-sample"
    #      guessed["property1"] = "guessed-value"
    #      return {"parser" => guessed}
    #    else
    #      return {}
    #    end
    #  end
    #end

    #class MultilineLogSampleParserGuessPlugin < TextGuessPlugin
    #  Plugin.register_guess("multiline-log-sample", self)
    #
    #  def guess_text(config, sample_text)
    #    js = JSON.parse(sample_text) rescue nil
    #    if js && js["mykeyword"] == "keyword"
    #      guessed = {}
    #      guessed["type"] = "multiline-log-sample"
    #      guessed["property1"] = "guessed-value"
    #      return {"parser" => guessed}
    #    else
    #      return {}
    #    end
    #  end
    #end

    #class MultilineLogSampleParserGuessPlugin < LineGuessPlugin
    #  Plugin.register_guess("multiline-log-sample", self)
    #
    #  def guess_lines(config, sample_lines)
    #    all_line_matched = sample_lines.all? do |line|
    #      line =~ /mypattern/
    #    end
    #    if all_line_matched
    #      guessed = {}
    #      guessed["type"] = "multiline-log-sample"
    #      guessed["property1"] = "guessed-value"
    #      return {"parser" => guessed}
    #    else
    #      return {}
    #    end
    #  end
    #end

  end
end
