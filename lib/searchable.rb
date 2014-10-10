module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def of_able_form(column_name)
      column_name.include? "able_type"
    end

    def normalize_search_term_for_SQL_search(search_term)
      if search_term.include?("*") || search_term.include?("?")
        # we replace the * and ? with % and _ and return the
        # string since it already contains search terms and
        # therefore we assume that if the user needed some wildcarding
        # they have put that in.
        return search_term.gsub('*', '%').gsub('?', '_')
      else
        # there are no wildcards and therefore we simply wrap the
        # string with %'s which are the SQL wildcard characters
        return "%" + search_term + "%"
      end
    end

    def search_for(search_term)
      normalized_search_term = normalize_search_term_for_SQL_search(search_term)
      
      query_string = self.columns.inject("") do |memo,c|
        if ((c.type == :string) && !of_able_form(c.name))
          if (memo == "")
            memo + "#{c.name} #{DATABASE_OPERATOR[:like_operator]} :qstring"
          else
            memo + " OR #{c.name} #{DATABASE_OPERATOR[:like_operator]} :qstring"
          end
        else
          memo
        end
      end

      self.where(query_string, qstring: normalized_search_term)
    end

  end
end
