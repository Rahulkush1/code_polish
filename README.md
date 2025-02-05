# CodePolish 🚀

**CodePolish** is a Ruby gem that provides automated code refactoring suggestions to improve code readability and performance.

## 📌 Installation

Add this line to your application's Gemfile:

```ruby
gem 'code_polish'
```

Then install it:

```sh
bundle install
```

Or install it manually:

```sh
gem install code_polish
```

---

## 📖 Usage

To analyze a Ruby file and get refactoring suggestions:

```ruby
require 'code_polish'

CodePolish::Refactor.analyze_code("path/to/your_file.rb")
```

For IRB (Interactive Ruby):

```sh
irb
```
```ruby
require 'code_polish'
CodePolish::Refactor.analyze_code("example.rb")
```

---

## 🔖 Versioning

This gem follows **Semantic Versioning (SemVer)**:
- **Major (`1.0.0`)** → Breaking changes
- **Minor (`0.2.0`)** → New features
- **Patch (`0.1.1`)** → Bug fixes

---

## 🤝 Contributing

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch`
3. Commit your changes: `git commit -m "Added a new feature"`
4. Push to GitHub: `git push origin feature-branch`
5. Create a **Pull Request**.

---

## 📝 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

---

## 📬 Contact

For issues or feedback, open an issue on [GitHub Issues](https://github.com/rahulkush1/code_polish/issues).

