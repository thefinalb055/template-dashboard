# Engineering Conventions

This document outlines the conventions we use when developing Visor OS.

## Core Principles
> WHEN WRITING CODE YOU MUST FOLLOW THESE CONVENTIONS 

1. Write simple, verbose code over terse, dense code
2. Every function must have a corresponding test - if not, note it in comments
3. Always use JSDoc/TSDoc for function documentation
4. Never use `any` type
5. Use Bun builtins wherever possible
6. Files must never exceed 400 lines - break into modules
7. Tests must follow AAA pattern (Arrange-Act-Assert)
8. Maintain test coverage above 80%
9. All PRs require passing tests and lint checks

## Project Structure

```
.
├── src/                      # Source code directory
│   ├── core/                # Core application logic
│   │   └── types/          # TypeScript type definitions
│   ├── modules/            # Feature modules and utilities
│   │   ├── tools/         # Tool implementations
│   │   └── utils/         # Utility functions
│   ├── services/          # External service integrations
│   └── config/            # Configuration files
├── tests/                   # Test files
├── db/                      # Database-related files
│   ├── migrations/        # Database migrations
│   └── mock_data/        # Mock data for testing
├── public/                  # Public assets
└── scratchpad/             # Temporary file storage for assistant
```

### Key Files

- `main.py` - Application entry point
- `modules/logging.py` - Logging configuration and utilities
- `modules/memory_management.py` - Memory state management
- `modules/tools.py` - Tool definitions and implementations
- `personalization.json` - User-specific configuration
- `.env` - Environment variables
- `pyproject.toml` - Project dependencies and settings


## Bun-Specific Practices

### Testing with Bun
Use Bun's built-in test runner and assertions:

```typescript
import { expect, test, describe, beforeEach, spyOn, type Mock } from "bun:test";

describe("ModuleName", () => {
  // Test suite
});
```

### Shell Commands with Bun
Use Bun's `$` tagged template literal for shell commands:

```typescript
import { $ } from "bun";

test("should clean up temporary files", async () => {
  const fileCheck = await $`ls temp_script.py`.quiet().nothrow();
  expect(fileCheck.exitCode).not.toBe(0);
});
```

### Testing Examples

1. Spy Setup Example:
```typescript
let consoleSpies: {
  info: Mock<typeof console.info>;
  error: Mock<typeof console.error>;
  warn: Mock<typeof console.warn>;
  debug: Mock<typeof console.debug>;
};

beforeEach(() => {
  consoleSpies = {
    info: spyOn(console, "info").mockImplementation(() => {}),
    error: spyOn(console, "error").mockImplementation(() => {}),
    warn: spyOn(console, "warn").mockImplementation(() => {}),
    debug: spyOn(console, "debug").mockImplementation(() => {})
  };

  // Reset spy call counts
  for (const spy of Object.values(consoleSpies)) {
    spy.mockClear();
  }
});
```

2. AAA Pattern Example:
```typescript
it("should log outgoing events with cyan styling", () => {
  // Arrange
  const event = { type: "session.update" };
  const direction: EventDirection = "Outgoing";

  // Act
  logger.logWebSocketEvent(direction, event);

  // Assert
  expect(consoleSpies.info).toHaveBeenCalledTimes(1);
  const rawMessage = stripAnsi(consoleSpies.info.mock.calls[0][0]);
  expect(rawMessage).toContain("session.update");
});
```

## Code Style

### TypeScript/JavaScript

1. Use PascalCase for class names and interfaces
   ```typescript
   class MemoryManager {}
   interface LogStyle {}
   ```

2. Use camelCase for variables, functions, and methods
   ```typescript
   const consoleSpies = {};
   function logWebSocketEvent() {}
   ```

3. Use ALL_CAPS for constants
   ```typescript
   const EVENT_EMOJIS = {};
   ```

4. Prefer explicit type annotations
   ```typescript
   export type EventDirection = "Outgoing" | "Incoming";
   ```

## Documentation

1. Use JSDoc/TSDoc for public APIs:
   ```typescript
   /**
    * Logs a WebSocket event with appropriate styling and emojis
    * @param direction - Direction of the WebSocket event
    * @param event - The event object to log
    */
   public logWebSocketEvent(direction: EventDirection, event: { type: string }): void
   ```

2. Include examples in complex function documentation:
   ```typescript
   /**
    * Match a key against a pattern with wildcard support
    * @example
    * matchPattern("user_*", "user_name") // returns true
    * matchPattern("*_id", "user_id") // returns true
    */
   private matchPattern(pattern: string, key: string): boolean
   ```

## Error Handling

1. Use explicit error types:
   ```typescript
   try {
     // code
   } catch (error) {
     if (error instanceof ConnectionError) {
       // handle connection error
     } else {
       // handle other errors
     }
   }
   ```

## Async/Await

1. Use async/await over raw promises:
   ```typescript
   // Preferred
   async function getData() {
     const result = await fetchData();
     return result;
   }

   // Avoid
   function getData() {
     return fetchData().then(result => result);
   }
   ```

## Environment Variables

1. Document required environment variables in `.env.example`:
   ```env
   # Required for API access
   OPENAI_API_KEY=your_api_key
   
   # Optional configurations
   DEBUG_MODE=false
   ```

## Git Conventions

1. Use Conventional Commits:
   ```
   build: changes that affect the build system
   chore: updating grunt tasks etc; no production code change
   ci: changes to CI configuration files and scripts
   docs: documentation only changes
   feat: a new feature
   fix: a bug fix
   perf: code change that improves performance
   refactor: code change that neither fixes a bug nor adds a feature
   style: changes that do not affect the meaning of the code
   test: adding missing tests or correcting existing tests
   ```

2. Branch naming:
   ```
   feature/memory-management
   bugfix/websocket-timeout
   docs/update-readme
   ```

These conventions are designed to maintain code quality and consistency throughout the project. They should be followed for all new code and updates to existing code.