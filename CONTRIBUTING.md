# Contributing to Employee Payroll Management System

Thank you for your interest in contributing to the Employee Payroll Management System! This document provides guidelines and instructions for contributing to the project.

## Development Setup

1. Install MASM32:
   - Download MASM32 from the official website
   - Run the installer as administrator
   - Default installation path: `D:\masm32`

2. Clone the repository:
   ```bash
   git clone https://github.com/JeryNal/Employee-Payroll-Management-System.git
   cd Employee-Payroll-Management-System
   ```

3. Build the project:
   ```powershell
   cd bin
   .\build_admin.ps1
   ```

## Project Structure

```
Employee Payroll Management System/
├── bin/                    # Binary files and build scripts
│   ├── build_admin.ps1    # Build script
│   └── payroll.exe        # Compiled executable
├── include/               # Include files
│   └── payroll.inc       # Constants and declarations
├── src/                  # Source code
│   └── payroll.asm      # Main program source
└── README.md            # Project documentation
```

## Code Style Guidelines

1. Assembly Code:
   - Use consistent indentation (4 spaces)
   - Add comments for complex operations
   - Follow MASM32 naming conventions
   - Use meaningful variable and label names

2. Build Scripts:
   - Use PowerShell best practices
   - Include error handling
   - Add descriptive comments

## Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes:
   - Follow the code style guidelines
   - Add tests if applicable
   - Update documentation

3. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

4. Push to your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

5. Create a Pull Request:
   - Go to the repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Add a description of your changes

## Testing

1. Build the project:
   ```powershell
   .\build_admin.ps1
   ```

2. Run the program:
   ```powershell
   .\payroll.exe
   ```

3. Test all features:
   - Add new employees
   - View employee records
   - Verify input validation
   - Check error handling

## Documentation

1. Update README.md if needed
2. Add comments to your code
3. Update any relevant documentation

## Reporting Issues

1. Check existing issues
2. Create a new issue:
   - Use a clear title
   - Describe the problem
   - Include steps to reproduce
   - Add system information

## Code Review Process

1. Pull requests will be reviewed for:
   - Code quality
   - Functionality
   - Documentation
   - Test coverage

2. Address review comments
3. Update your PR as needed

## Release Process

1. Version numbers follow semantic versioning
2. Create a release branch
3. Update version numbers
4. Create a GitHub release
5. Tag the release

## Contact

For questions or concerns:
- Create an issue
- Contact the maintainers
- Join the discussions

Thank you for contributing! 