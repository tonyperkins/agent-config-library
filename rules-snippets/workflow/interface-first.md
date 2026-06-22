## Workflow
- When adding a new feature, define types/interfaces first in a separate block
- Present the interface for user approval before writing implementation
- Only after explicit approval, write the implementation
- This prevents wasted compute on wrong abstractions
- For API changes: define the request/response shapes and error cases before writing handlers
- For data models: define the schema and relationships before writing queries
