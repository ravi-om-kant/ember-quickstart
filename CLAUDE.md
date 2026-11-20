# CLAUDE.md - Production Level

**Use this when**: Building production-ready Ember.js code with strict quality standards.

---

## Code Quality Standards

### MUST Follow

✅ **Code Style**
- `.gjs` template-tag files (Octane)
- `@tracked` for state, `@action` for methods
- Arrow functions for `this` binding: `handleClick = () => { ... }`
- Const/let, never var
- Explicit return types in JSDoc
- Max 100 chars per line

✅ **Architecture**
- Routes: Only data loading + guards, nothing else
- Services: Singletons for shared state only
- Components: Pure, no side effects, accept @args only
- Separation of concerns: data/logic/ui

✅ **Error Handling**
- Let errors throw in `model()`
- Create `error.gjs` templates
- Proper error messages (not generic)
- Graceful fallbacks
- Never swallow errors silently

✅ **State Management**
- Session for auth state
- Services for shared data
- Components never mutate `@args`
- Always call `resetController()`
- Use `@tracked` only where necessary

✅ **Data Fetching**
- Use `store.request()` with handlers
- Proper cache configuration
- Query params with `refreshModel` config
- Retry logic for failures
- Clear error boundaries

✅ **Performance**
- No unnecessary `@tracked` properties
- Lazy-load routes/components
- Memoize expensive computations
- Monitor bundle size
- No memory leaks

✅ **Testing**
- Unit tests for services
- Integration tests for routes
- Component tests for UI logic
- E2E tests for critical flows
- 80%+ code coverage

✅ **Security**
- No hardcoded secrets
- Sanitize user input
- Validate on server + client
- Use HTTPS for all requests
- Secure token handling

---

## Code Review Checklist

Before committing, verify:

- [ ] No `@args` mutations
- [ ] Query params have `refreshModel` config
- [ ] Auth guards on protected routes
- [ ] Error handling in all `model()` hooks
- [ ] `resetController()` clears state
- [ ] No console.log() statements
- [ ] No TODO comments
- [ ] All imports used
- [ ] No unused variables
- [ ] File size < 300 lines
- [ ] All tests pass
- [ ] No linting errors
- [ ] No TypeScript errors
- [ ] Performance acceptable

---

## Expectations

🎯 **What I Will Do**
- Follow Ember best practices strictly
- Point out violations immediately
- Suggest refactoring for clarity
- Optimize for performance
- Write production-ready code
- Include proper error handling
- Add TypeScript types where needed
- Write clear commit messages

⚡ **What I Won't Do**
- Accept technical debt
- Skip error handling
- Write unclear code
- Leave commented code
- Create side effects in components
- Ignore performance issues
- Over-engineer simple features

---

## File References

Point to code as: `file.js:line-number`

Example: `app/services/session.js:42` means line 42 of that file.

---

## Response Style

- Concise and direct
- Code examples only when necessary
- Point to docs instead of re-explaining
- Focus on "why", not "what"
- No verbose explanations

---

## Git Commits

Message format:
```
Type: Brief summary

Longer explanation if needed.
- Bullet points for details
- Keep to 72 chars per line
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`

---

## When to Flag Issues

🚩 **I will stop and ask you to decide:**
- Breaking changes
- Architecture decisions
- Scope creep
- Performance tradeoffs
- Dependency additions

---

**Production Mode Active** ✅
Follow strict standards. No shortcuts.
