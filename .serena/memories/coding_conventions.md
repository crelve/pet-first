# Coding Conventions and Style Guide

## Naming Conventions
- **Classes**: PascalCase (e.g., `PointCardListItem`)
- **Variables**: camelCase (e.g., `searchController`)  
- **Files**: snake_case (e.g., `point_card_list_item.dart`)
- **Directories**: snake_case

## Component Guidelines
1. **Base Class**: Use `HookConsumerWidget` for components
2. **Spacing**: Use `hSpace()` and `wSpace()` instead of `SizedBox`
3. **Loading**: Use `Loading()` component instead of `CircularProgressIndicator`
4. **Colors**: Use `ColorUtility` methods instead of `withOpacity`

## State Management Pattern
- **Global State**: Managed with Riverpod providers
- **Local State**: Use Flutter Hooks (`useState`, `useTextEditingController`)
- **State Updates**: Use `ref.watch()` for reading, `ref.watch().notifier` for updates

## Code Organization
- **Barrel Exports**: Use centralized imports from `import/` directory
- **Immutable Models**: Use Freezed for data classes
- **Provider Pattern**: State notifiers extend appropriate base classes
- **Component Structure**: Organize by functionality in `component/` subdirectories

## Documentation
- Use comprehensive Japanese comments for classes and methods
- Follow JSDoc-style documentation for complex functions
- Document widget parameters and their purposes

## File Structure
- One class per file
- File names match class names in snake_case
- Group related files in appropriate subdirectories
- Use `part` files for generated code (e.g., `.freezed.dart`, `.g.dart`)

## Environment Configuration
- Use environment files: `dart_env/dev.env`, `dart_env/prod.env`, `dart_env/test.env`
- Access environment variables through appropriate providers
- Separate development and production configurations