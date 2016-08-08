module CoreExtensions
  module Numeric

    # Adds a general format method that belongs in more than one class and
    # is more a utility function belonging to the SPISU-format more than
    # anything else.
    #
    # @author Michael Litton
    module SPISU
      def spisu_format
        ("%.2f" % self).gsub(".","")
      end
    end
  end
end