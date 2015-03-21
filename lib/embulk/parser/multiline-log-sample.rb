module Embulk
  module Parser

    class MultilineLogSampleParserPlugin < ParserPlugin
      Plugin.register_parser("multiline-log-sample", self)

      # Regexp for first line of each log message
      # e.g. 2015-03-14 20:12:22,123 [ERROR] Book reader error
      #   1: date
      #   2: time
      #   3: log_level
      #   4: message
      REGEXP_FIRST_LINE = /^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2},\d{3}) \[([^\]]+)\] (.+)$/

      # Regexp for "Caused by" message of each log message
      #   1: caused_by
      #   2: caused_by_message
      REGEXP_CAUSED_BY = /^Caused by: ([^:]+)(?:: (.+))?$/

      def self.transaction(config, &control)
        # configuration code:
        parser_task = config.load_config(Java::LineDecoder::DecoderTask)

        task = {
          "decoder_task" => DataSource.from_java(parser_task.dump)
          # "property1" => config.param("property1", :string),
          # "property2" => config.param("property2", :integer, default: 0),
        }

        columns = [
          Column.new(0, "date", :string),
          Column.new(1, "time", :string),
          Column.new(2, "log_level", :string),
          Column.new(3, "message", :string),
          Column.new(4, "second_line", :string),
          Column.new(5, "third_line", :string),
          Column.new(6, "caused_by", :string),
          Column.new(7, "caused_by_message", :string),
        ]

        yield(task, columns)
      end

      def init
        # initialization code:
        # @property1 = task["property1"]
        # @property2 = task["property2"]

        @decoder_task = task.param("decoder_task", :hash).load_task(Java::LineDecoder::DecoderTask)
      end

      def read_new_line(decoder)
        begin
          line = decoder.poll
        rescue
          # At first time, java.lang.IllegalStateException is thrown
        end

        if line == nil
          return nil if decoder.nextFile == false
          read_new_line(decoder)
        else
          line
        end
      end

      def run(file_input)
        decoder = Java::LineDecoder.new(file_input.instance_eval { @java_file_input }, @decoder_task)

        line = read_new_line(decoder)

        loop do
          # Finish parser if the line is nil
          break if line.nil?

          # check if the line is "first line"
          md = line.match(REGEXP_FIRST_LINE)

          unless md
            line = read_new_line(decoder)
            next
          end

          # read second line
          second_line = read_new_line(decoder)

          # check if the line is "first line" or not
          if second_line.nil? or second_line.match(REGEXP_FIRST_LINE)
            page_builder.add([ md[1], md[2], md[3], md[4] ])

            # treat second line as next "first line"
            line = second_line
            next
          end

          # read third line
          third_line = read_new_line(decoder)

          # check if the line is "first line" or not
          if third_line.nil? or third_line.match(REGEXP_FIRST_LINE)
            page_builder.add([ md[1], md[2], md[3], md[4], second_line.strip ])

            # treat third line as next "first line"
            line = third_line
            next
          end

          # search "Caused by" message
          loop do
            other_line = read_new_line(decoder)

            if other_line.nil? or other_line.match(REGEXP_FIRST_LINE)
              page_builder.add([ md[1], md[2], md[3], md[4], second_line.strip, third_line.strip ])

              # treat third line as next "first line"
              line = other_line
              break
            end

            # check if the line is "Caused by" message
            md_caused = other_line.match(REGEXP_CAUSED_BY)

            if md_caused
              page_builder.add([ md[1], md[2], md[3], md[4], second_line.strip, third_line.strip, md_caused[1], md_caused[2] ])

              # read new line as next "first line"
              line = read_new_line(decoder)
              break
            end
          end
        end

        page_builder.finish
      end
    end

  end
end
