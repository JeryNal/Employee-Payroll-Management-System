# Employee Payroll Management System

A console-based Employee Payroll Management System written in MASM (Microsoft Macro Assembler) for Windows. This system allows you to manage employee records including their personal information, salary details, and department assignments.

## Features

- Add new employees with detailed information
- View all employee records
- Input validation for all fields
- Persistent storage using text files
- User-friendly console interface
- Department categorization

## Prerequisites

- Windows operating system
- MASM32 (Microsoft Macro Assembler)
- Administrator privileges for compilation

## Installation

1. Install MASM32:
   - Download MASM32 from the official website
   - Run the installer as administrator
   - Default installation path: `D:\masm32`

2. Clone or download this repository:
   ```
   git clone [repository-url]
   cd Employee-Payroll-Management-System
   ```

3. Build the project:
   - Open PowerShell as administrator
   - Navigate to the bin directory:
     ```
     cd bin
     ```
   - Run the build script:
     ```
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
└── README.md            # This file
```

## Usage

1. Run the program:
   ```
   .\payroll.exe
   ```

2. Main Menu Options:
   - 1: Add Employee
   - 2: View Employees
   - 3: Exit

3. Adding an Employee:
   - Enter employee name
   - Enter employee number (format: EMPXXX)
   - Enter salary
   - Enter job group
   - Select department (1-5):
     ```
     1. Software Development & Engineering
     2. Cybersecurity & Risk Management
     3. Cloud Computing & Infrastructure
     4. AI & Data Science
     5. IT Support & Managed Services
     ```

4. Viewing Employees:
   - Select option 2 from the main menu
   - View all saved employee records

## Data Storage

Employee records are stored in `employees.txt` in the bin directory. Each record contains:
- Employee name
- Employee number
- Salary
- Job group
- Department

## Input Validation

The system validates:
- Employee number format (EMPXXX)
- Salary (positive numbers only)
- Department selection (1-5)
- Required fields (no empty inputs)

## Error Handling

The system includes comprehensive error handling for:
- File operations
- Invalid inputs
- System errors
- User input validation

## Building from Source

To build the project from source:

1. Ensure MASM32 is installed correctly
2. Open PowerShell as administrator
3. Navigate to the bin directory
4. Run the build script:
   ```
   .\build_admin.ps1
   ```

## Troubleshooting

Common issues and solutions:

1. Build fails with "MASM not found":
   - Verify MASM32 installation
   - Check if MASM32 is installed in `D:\masm32`
   - Run PowerShell as administrator

2. Linker errors:
   - Ensure MASM32 library files exist
   - Check MASM32 installation
   - Verify library paths

3. Runtime errors:
   - Check file permissions
   - Ensure administrator privileges
   - Verify input format

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- MASM32 development team
- Windows API documentation
- Assembly language community

## Support

For support, please:
1. Check the troubleshooting section
2. Review the documentation
3. Create an issue in the repository

## Version History

- v1.0.0 (2024-03-19)
  - Initial release
  - Basic employee management features
  - File-based storage
  - Input validation 