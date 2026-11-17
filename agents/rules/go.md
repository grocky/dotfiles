---
description: Go conventions. Apply when a project has a go.mod or when editing Go files.
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go rules

These extend `~/AGENTS.md` (TDD, commits, naming all still apply). A project's own rules win where they differ.

## Standard library first

- Reach for the standard library before any dependency: `net/http` (with method/path patterns in `ServeMux`),
  `log/slog`, `encoding/json`, `database/sql`, `flag`, `testing`, `net/http/httptest`, `errors`, `slices`,
  `maps`, `iter`, `context`, `sync`.
- Add a third-party module only when the stdlib genuinely can't do the job reasonably, and say why in the
  commit message. Prefer `golang.org/x/...` over other third-party packages.
- No web frameworks, DI containers, assertion libraries or mocking frameworks unless the project already uses
  them.

## No global state

- No package-level mutable variables: no global DB handles, clients, loggers, config, registries or caches.
- No `init()` functions with side effects. Don't use `http.DefaultClient`, `http.DefaultServeMux`, the global
  `flag` set outside `main`, or `slog.SetDefault` in library code.
- Pass dependencies explicitly through constructors (`NewServer(store Store, logger *slog.Logger)`) and struct
  fields. `main` (or a `run(ctx, args, stdout, stderr) error` function it calls) is the only place that wires
  things together and reads flags and environment variables.
- Package-level values are fine only when immutable in practice: constants, sentinel errors
  (`var ErrNotFound = errors.New("not found")`), and compiled regexps.

## Context

- Every function that does I/O, blocks, or may be slow takes `ctx context.Context` as its **first** parameter,
  and passes it down to every call that accepts one.
- Use the `...Context` variants (`QueryContext`, `http.NewRequestWithContext`, `exec.CommandContext`).
- Honor cancellation in loops and goroutines (`select` on `ctx.Done()`); return `ctx.Err()` when cancelled.
- Never store a context in a struct. Never pass `nil`; use `context.TODO()` only as a temporary marker.
- Create the root context once in `main` with `signal.NotifyContext` for graceful shutdown.
- `context.Background()` belongs only in `main` and test setup. In tests use `t.Context()`.
- Don't use context values for optional parameters or dependencies; only for request-scoped data such as
  trace IDs, with unexported key types.
- "Within reason": pure, fast, in-memory functions (parsing, formatting, math) don't need a context.

## Tests

- **Table-driven by default.** A slice of named cases, each run with `t.Run(tc.name, ...)`:

  ```go
  func TestParseDuration(t *testing.T) {
      tests := []struct {
          name    string
          input   string
          want    time.Duration
          wantErr error
      }{
          {name: "minutes", input: "5m", want: 5 * time.Minute},
          {name: "empty", input: "", wantErr: ErrEmpty},
      }
      for _, tc := range tests {
          t.Run(tc.name, func(t *testing.T) {
              t.Parallel()
              got, err := ParseDuration(tc.input)
              if !errors.Is(err, tc.wantErr) {
                  t.Fatalf("ParseDuration(%q) error = %v, want %v", tc.input, err, tc.wantErr)
              }
              if got != tc.want {
                  t.Errorf("ParseDuration(%q) = %v, want %v", tc.input, got, tc.want)
              }
          })
      }
  }
  ```

- Failure messages read `Func(input) = got, want want`. Use `t.Fatalf` only when the test can't continue.
- Use the stdlib for comparisons (`==`, `reflect.DeepEqual`, `slices.Equal`, `maps.Equal`); use `go-cmp` only
  if the project already depends on it.
- Mark helpers with `t.Helper()`. Use `t.TempDir()`, `t.Setenv()`, `t.Cleanup()` and `t.Context()`.
- Use `t.Parallel()` where tests share no state (which is easy when there is no global state).
- Fakes over mocks: define a small interface where it is consumed and hand-write a fake in the test.
  Use `httptest.NewServer` / `httptest.NewRecorder` for HTTP.
- Fixtures go in `testdata/`. Golden files are updated behind an `-update` flag.
- Prefer black-box tests in `package foo_test`; drop to `package foo` only to test unexported logic that
  matters.
- Run `go test -race ./...` before committing.

## Errors

- Return errors; don't panic in library code. Handle each error once: either log it or return it, not both.
- Wrap with context using `fmt.Errorf("loading config %s: %w", path, err)`; check with `errors.Is` / `errors.As`.
- Error strings are lower case with no trailing punctuation.

## Design and layout

- Accept interfaces, return concrete types. Define interfaces in the consuming package and keep them small.
- Make the zero value useful where practical; otherwise provide a `New...` constructor.
- Layout: `cmd/<binary>/main.go` for entry points, `internal/` for non-public packages, packages named for
  what they provide (no `util`, `common`, `helpers`, `models`).
- Every goroutine has a clear owner and exit path; whoever starts it waits for it (`sync.WaitGroup`,
  `errgroup` from `golang.org/x/sync` when errors must propagate).
- Structured logging with `log/slog`, with the `*slog.Logger` injected.

## Tooling

- Code is `gofmt`/`goimports` clean and passes `go vet ./...`; run `staticcheck` or `golangci-lint` if the
  project configures them.
- Keep `go.mod` tidy (`go mod tidy`) in the same commit that changes imports.
- Build binaries into `bin/`: `go build -o bin/<name> ./cmd/<name>`.
