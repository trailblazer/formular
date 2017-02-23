module Formular
  class Path < Array
    # name #attribute without model...
    # [User, :name] => user[name] #regular attribute
    # [User, roles: 0, :name] => user[roles][][name]
    def to_encoded_name
      map.with_index do |segment, i|
        first_or_last = i == 0 || i == size

        if first_or_last
          segment.is_a?(Array) ? "#{segment.first}[]" : segment
        else
          segment.is_a?(Array) ? "[#{segment.first}][]" : "[#{segment}]"
        end
      end.join('')
    end

    # need to inject the index in here... else we will end up with the same ids
    # [User, :name] => user_name #regular attribute
    # [User, roles: 0, :name] => user_roles_0_name
    def to_encoded_id
      map { |segment| segment.is_a?(Array) ? segment.join('_') : segment }.join('_')
    end
  end # class Attributes
end # module Formular
