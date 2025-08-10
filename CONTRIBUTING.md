# Contributing to LeapChucker

Thank you for your interest in contributing to LeapChucker! We welcome contributions from the community and are grateful for your help in making this library better.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct. Please be respectful and constructive in all interactions.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to see if the problem has already been reported. When you create a bug report, please include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples and code snippets
- Describe the behavior you observed and what you expected
- Include environment details (iOS version, device, Xcode version, etc.)

### Suggesting Features

Feature requests are welcome! Please provide:

- A clear and descriptive title
- A detailed description of the proposed feature
- Use cases and examples of how it would be used
- Any implementation ideas you might have

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the coding standards below
3. **Add tests** for any new functionality
4. **Update documentation** as needed
5. **Ensure all tests pass**
6. **Submit a pull request**

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/LeapChucker.git
   cd LeapChucker
   ```

2. Open the project in Xcode:
   ```bash
   open Package.swift
   ```

3. Build and test:
   ```bash
   swift build
   swift test
   ```

## Coding Standards

### Swift Style Guide

- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Use `// MARK:` comments to organize code sections
- Prefer `let` over `var` when possible
- Use trailing closures when appropriate

### Code Organization

- Keep files focused on a single responsibility
- Use extensions to organize related functionality
- Group related functions and properties together
- Add `// MARK:` comments for major sections

### Documentation

- All public APIs must have documentation comments
- Use proper Swift documentation syntax with `///`
- Include parameter descriptions and return value information
- Provide usage examples for complex APIs

### Testing

- Write unit tests for new functionality
- Maintain or improve test coverage
- Test edge cases and error conditions
- Use descriptive test names that explain what is being tested

## Project Structure

```
LeapChucker/
├── Sources/
│   └── LeapChucker/
│       ├── LeapChuckerLogger.swift      # Main logger class
│       ├── LeapChuckerInterceptor.swift # URLProtocol implementation
│       ├── NetworkLoggerView.swift      # Main SwiftUI view
│       ├── View+LeapChucker.swift       # SwiftUI extensions
│       ├── NetworkRequest.swift         # Data models
│       └── Storage/                     # Storage implementation
├── Tests/
│   └── LeapChuckerTests/
├── Package.swift
├── README.md
└── CHANGELOG.md
```

## Commit Messages

Use clear and descriptive commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

Examples:
```
Add shake-to-show functionality

Fix memory leak in network interceptor

Update documentation for custom URLSession configuration

Closes #123
```

## Release Process

1. Update version numbers in relevant files
2. Update CHANGELOG.md with new features and fixes
3. Create a new release on GitHub
4. Tag the release with semantic versioning (e.g., v1.0.0)

## Questions?

If you have questions about contributing, please:

1. Check the existing documentation
2. Search through existing issues
3. Create a new issue with the "question" label

## Recognition

Contributors will be recognized in the project's README and release notes. Thank you for helping make LeapChucker better!

## License

By contributing to LeapChucker, you agree that your contributions will be licensed under the MIT License.
