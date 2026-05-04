# Task Completion Checklist

## When a coding task is completed, always run:

### 1. Code Generation (if applicable)
```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 2. Testing
```bash
make test
```
This command:
- Runs `sh scripts/gen_coverage_test.sh`
- Executes `fvm flutter test --coverage --dart-define-from-file=dart_env/test.env`
- Generates HTML coverage report with `genhtml coverage/lcov.info -o coverage/html`
- Opens coverage report in browser

### 3. Linting and Formatting
```bash
fvm flutter analyze
```

### 4. Dependency Management
```bash
fvm flutter pub get
```

## Before Committing
1. Ensure all tests pass
2. Check code coverage meets requirements
3. Run analysis to fix any linting issues
4. Verify no sensitive information is committed
5. Update documentation if needed

## Environment-Specific Testing
- Development: Use `dart_env/dev.env`
- Production: Use `dart_env/prod.env`  
- Testing: Use `dart_env/test.env`

## Coverage Requirements
- Aim for high test coverage on business logic (providers, models)
- UI components should have basic widget tests
- Critical paths must be fully tested

## Documentation Updates
- Update CLAUDE.md if new patterns or conventions are introduced
- Add comments for complex business logic