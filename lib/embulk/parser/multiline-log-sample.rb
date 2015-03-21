module Embulk
  module Parser

    class MultilineLogSampleParserPlugin < ParserPlugin
      Plugin.register_parser("multiline-log-sample", self)

      def self.transaction(config, &control)
        # configuration code:
        parser_task = config.load_config(Java::LineDecoder::DecoderTask)

        task = {
          "decoder_task" => DataSource.from_java(parser_task.dump)
          # "property1" => config.param("property1", :string),
          # "property2" => config.param("property2", :integer, default: 0),
        }

        columns = [
          Column.new(0, "line", :string),
          # Column.new(0, "example", :string),
          # Column.new(1, "column", :long),
          # Column.new(2, "name", :double),
        ]

        yield(task, columns)
      end

      def init
        # initialization code:
        # @property1 = task["property1"]
        # @property2 = task["property2"]

        @decoder_task = task.param("decoder_task", :hash).load_task(Java::LineDecoder::DecoderTask)
      end

      def run(file_input)
        decoder = Java::LineDecoder.new(file_input.instance_eval { @java_file_input }, @decoder_task)

        while decoder.nextFile
          while line = decoder.poll
            page_builder.add([line])
          end
        end

        # while file = file_input.next_file
        #   file.each do |buffer|
        #     # parsering code
        #     record = ["col1", 2, 3.0]
        #     page_builder.add(record)
        #   end
        # end

        page_builder.finish
      end
    end

  end
end
