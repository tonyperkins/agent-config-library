## Security
- IMPORTANT: never commit secrets, API keys, or credentials — use env vars / `.env` (gitignored)
- Don't log full request/response bodies that may contain PII or tokens
- Validate and sanitize all external input at system boundaries; trust internal code
- Flag any new dependency that requests network or filesystem access beyond what the task needs
