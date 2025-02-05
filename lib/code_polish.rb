# frozen_string_literal: true

require_relative "code_polish/version"

module CodePolish
  class Refactor
    def self.analyze_code(file_or_code)
      if File.exist?(file_or_code)
        code = File.read(file_or_code)
      else
        code = file_or_code  # Handle direct Ruby code
      end
      suggestions = suggest_refactoring(code)
      puts "Refactoring Suggestions:\n#{suggestions}"
    end

    private

    def self.suggest_refactoring(code)
      suggestions = []

      # 1️⃣ Use `map` instead of `each` + `push`
      suggestions << "Use `map` instead of `each` + `push`" if code.match?(/\.each\s*do\s*\|.*\|\s*.*\.push/)

      # 2️⃣ Use safe navigation operator `&.` for nil checks
      suggestions << "Use `&.` (safe navigation operator) for nil checks" if code.match?(/if .*\.nil\?/)

      # 3️⃣ Use `empty?` instead of `length == 0`
      suggestions << "Use `.empty?` instead of `.length == 0`" if code.match?(/\.length\s*==\s*0/)

      # 4️⃣ Use `present?` instead of `!blank?`
      suggestions << "Use `.present?` instead of `!blank?`" if code.match?(/!\s*.*\.blank\?/)

      # 5️⃣ Use `one?` instead of `select.count == 1`
      suggestions << "Use `.one?` instead of `.select.count == 1`" if code.match?(/\.select\{.*\}\.count\s*==\s*1/)

      # 6️⃣ Prefer `find_each` over `each` for large data sets
      suggestions << "Use `.find_each` instead of `.each` for large ActiveRecord queries" if code.match?(/\.each\s*\{\s*\|/)

      # 7️⃣ Avoid `Time.now`, prefer `Time.current` (Rails best practice)
      suggestions << "Use `Time.current` instead of `Time.now` for Rails apps" if code.match?(/Time\.now/)

      # 8️⃣ Avoid using `eval`, use `send` or `public_send`
      suggestions << "Avoid `eval`, use `send` or `public_send` instead" if code.match?(/eval\s*\(/)

      # 9️⃣ Avoid `puts` in production code, use `Rails.logger`
      suggestions << "Use `Rails.logger` instead of `puts` in production code" if code.match?(/puts/)

      # 🔟 Use `String#casecmp?` instead of `.downcase ==`
      suggestions << "Use `.casecmp?` instead of `.downcase ==` for case-insensitive string comparison" if code.match?(/\.downcase\s*==/)

      # 1️⃣1️⃣ Avoid `select.first`, use `detect` instead
      suggestions << "Use `.detect` instead of `.select.first`" if code.match?(/\.select\{.*\}\.first/)

      # 1️⃣2️⃣ Avoid using `for` loops, prefer `.each`
      suggestions << "Avoid `for` loops, use `.each` instead" if code.match?(/for\s+\w+\s+in\s+/)

      # 1️⃣3️⃣ Use `dig` instead of nested hash access
      suggestions << "Use `.dig` instead of nested hash access" if code.match?(/\[\s*:.*\]\s*\[\s*:.*\]/)

      # 1️⃣4️⃣ Prefer `pluck` over `map(&:attr)` for ActiveRecord
      suggestions << "Use `.pluck(:attr)` instead of `.map(&:attr)` for ActiveRecord queries" if code.match?(/\.map\(&:\w+\)/)

      # 1️⃣5️⃣ Avoid `each_with_index` when index is not needed
      suggestions << "Use `.each` instead of `.each_with_index` if index is not used" if code.match?(/\.each_with_index\s*\{.*\|\w+,\s*\|/)

      # 1️⃣6️⃣ Use `!exist?` instead of `nil?` for ActiveRecord
      suggestions << "Use `!record.exist?` instead of `record.nil?` in ActiveRecord" if code.match?(/\.nil\?\s*&&\s*.*\.exist\?/)

      # 1️⃣7️⃣ Prefer `unless` instead of `if !condition`
      suggestions << "Use `unless` instead of `if !condition`" if code.match?(/if\s+!\s+/)

      # 1️⃣8️⃣ Use `compact` to remove nil values instead of `select`
      suggestions << "Use `.compact` instead of `.select { |x| !x.nil? }`" if code.match?(/\.select\s*\{\s*\|.*\|\s*!.*\.nil\?\s*\}/)

      # 1️⃣9️⃣ Use `Array.wrap(value)` instead of `[value].flatten`
      suggestions << "Use `Array.wrap(value)` instead of `[value].flatten`" if code.match?(/\[.*\]\.flatten/)

      # 2️⃣0️⃣ Prefer `tap` for method chaining instead of `self`
      suggestions << "Use `.tap` instead of explicit `self` in method chaining" if code.match?(/self\./)

      # 🆕 **Future Enhancements**
      # ✅ Add more Rails-specific rules
      # ✅ Add more object-oriented programming (OOP) best practices
      # ✅ Add performance optimization suggestions

      # AI-based analysis (Optional)
      if ENV['OPENAI_API_KEY']
        response = call_openai(code)
        suggestions << response if response
      end

      suggestions.empty? ? "No improvements found." : suggestions.join("\n")
    end

    def self.call_openai(code)
      require 'openai'
      client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [{ role: "user", content: "Suggest refactoring for this Ruby code:\n#{code}" }],
          temperature: 0.7
        }
      )

      response.dig("choices", 0, "message", "content")
    rescue => e
      "AI analysis failed: #{e.message}"
    end
  end
end

