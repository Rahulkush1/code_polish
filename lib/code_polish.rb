# frozen_string_literal: true

require_relative "code_polish/version"

module CodePolish
  # This class provides methods to analyze and suggest refactoring improvements
  # for Ruby code based on best practices.
  class Refactor
    REFACTOR_RULES = {
      /\.each\s*do\s*\|.*\|\s*.*\.push/ => "Use `map` instead of `each` + `push`",
      /if .*\.nil\?/ => "Use `&.` (safe navigation operator) for nil checks",
      /\.length\s*==\s*0/ => "Use `.empty?` instead of `.length == 0`",
      /!\s*.*\.blank\?/ => "Use `.present?` instead of `!blank?`",
      /\.select\{.*\}\.count\s*==\s*1/ => "Use `.one?` instead of `.select.count == 1`",
      /\.each\s*\{\s*\|/ => "Use `.find_each` instead of `.each` for large ActiveRecord queries",
      /Time\.now/ => "Use `Time.current` instead of `Time.now` for Rails apps",
      /eval\s*\(/ => "Avoid `eval`, use `send` or `public_send` instead",
      /puts/ => "Use `Rails.logger` instead of `puts` in production code",
      /\.downcase\s*==/ => "Use `.casecmp?` instead of `.downcase ==`",
      /\.select\{.*\}\.first/ => "Use `.detect` instead of `.select.first`",
      /for\s+\w+\s+in\s+/ => "Avoid `for` loops, use `.each` instead",
      /\[\s*:.*\]\s*\[\s*:.*\]/ => "Use `.dig` instead of nested hash access",
      /\.map\(&:\w+\)/ => "Use `.pluck(:attr)` instead of `.map(&:attr)` for ActiveRecord queries",
      /\.each_with_index\s*\{.*\|\w+,\s*\|/ => "Use `.each` instead of `.each_with_index` if index is not used",
      /\.nil\?\s*&&\s*.*\.exist\?/ => "Use `!record.exist?` instead of `record.nil?` in ActiveRecord",
      /if\s+!\s+/ => "Use `unless` instead of `if !condition`",
      /\.select\s*\{\s*\|.*\|\s*!.*\.nil\?\s*\}/ => "Use `.compact` instead of `.select { |x| !x.nil? }`",
      /\[.*\]\.flatten/ => "Use `Array.wrap(value)` instead of `[value].flatten`",
      /self\./ => "Use `.tap` instead of explicit `self` in method chaining"
    }.freeze

    def self.analyze_code(file_or_code)
      code = File.exist?(file_or_code) ? File.read(file_or_code) : file_or_code
      suggestions = suggest_refactoring(code)
      puts "Refactoring Suggestions:\n#{suggestions}"
    end

    def self.suggest_refactoring(code)
      suggestions = REFACTOR_RULES.map { |pattern, message| message if code.match?(pattern) }.compact
      suggestions.empty? ? "No improvements found." : suggestions.join("\n")
    end
  end
end
