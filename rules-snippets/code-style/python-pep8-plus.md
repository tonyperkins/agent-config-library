## Code style (Python)
- Follow PEP 8; run `ruff format` before considering anything done
- Type hints on all function signatures — no bare `def f(x):`
- No bare `except:` — catch specific exceptions
- f-strings over `.format()` or `%`
- Dataclasses or Pydantic models over loose dicts for structured data
