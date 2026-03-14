---
name: fastapi-api-docs
description: Validate FastAPI routes, check OpenAPI schema, identify missing docs
allowed-tools: Bash(python *), Read, Grep
---

# FastAPI API Documentation Validator

Validate FastAPI route definitions, check OpenAPI schema completeness, and identify missing documentation.

## Steps

1. **Find FastAPI app**: Search for FastAPI app instances by grepping for `FastAPI(` and `APIRouter(` across the Python codebase. Identify the main app entry point and all routers.

2. **Catalog routes**: Read the router files and catalog all route definitions:
   - HTTP method and path
   - Function name
   - Request/response models
   - Dependencies
   - Tags and summary

3. **Check docstrings**: For each route handler function, verify it has:
   - A docstring (used as the OpenAPI operation description)
   - Pydantic model annotations for request body and response
   - Proper `response_model` parameter on the decorator

4. **Validate models**: Check Pydantic models used in routes for:
   - Field descriptions (`Field(description=...)`)
   - Examples (`model_config` with `json_schema_extra` or `Field(examples=[...])`)
   - Proper type annotations

5. **Generate OpenAPI schema** (if possible): Run `python -c "from <app_module> import app; import json; print(json.dumps(app.openapi(), indent=2))"` to extract the live schema and check for:
   - Routes missing descriptions
   - Parameters missing descriptions
   - Missing response codes (especially error responses)
   - Missing authentication/security scheme documentation

6. **Report**: Present a checklist of documentation completeness:
   - Routes with complete docs vs incomplete
   - Models missing field descriptions
   - Missing error response documentation
   - Suggested improvements with code snippets
