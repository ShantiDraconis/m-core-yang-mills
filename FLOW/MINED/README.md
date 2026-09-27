# MINED flow

Normalized schema:
`repo | sha | run_id | theorem | exact_type | state | error_class | error_signature | axioms | sorryAx | dependencies | hypothetical | terminal_effect`.

Deduplicate by `error_class + error_signature + exact_type`.
Only repeated REAL patterns can become production rules.
