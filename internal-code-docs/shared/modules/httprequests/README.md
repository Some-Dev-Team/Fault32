---
description: Module
icon: file-code
---

# HTTPRequests

## Dependencies

* Roblox's [HttpService](https://create.roblox.com/docs/reference/engine/classes/HttpService)
* [response.md](response.md "mention") object (contained inside same modulescript)

## What is this module for?

Provides a simplified interface for making HTTP requests using `HttpService`.\
Wraps responses into a structured `Response` object and automatically handles JSON encoding and decoding.

## Functions

***

### get

```luau
HttpRequests.get(
    url: string,
    options: {
        headers: { [string]: string }?,
        body: any?
    }?
): Response
```

**Description:**\
Sends a GET request.

**Parameters:**

* `url` — the request URL.
* `options` — (optional) table containing request configuration.
  * `headers` — (optional) custom request headers.
  * `body` — (optional) request body. If not a string, it will be JSON-encoded automatically.

**Returns:**\
`Response` object representing the HTTP response.

**Example of usage:**

```luau
local response = HttpRequests.get("https://example.com/api/data")
print(response.status_code)
print(response.body)
```

***

### post

```luau
HttpRequests.post(url: string, options: table?): Response
```

**Description:**\
Sends a POST request.

**Parameters:**

* `url` — the request URL.
* `options` — (optional) table containing request configuration.
  * `headers` — (optional) custom request headers.
  * `body` — (optional) request body. If not a string, it will be JSON-encoded automatically.

**Returns:**\
`Response` object representing the HTTP response.

**Example of usage:**

```luau
local response = HttpRequests.post("https://example.com/api/users", {
    body = {
        username = "Goose",
        level = 99
    }
})

local data = response:json()
print(data.id)
```

***

### put

```luau
HttpRequests.put(url: string, options: table?): Response
```

**Description:**\
Sends a PUT request.

**Parameters:**

* `url` — the request URL.
* `options` — (optional) table containing request configuration.
  * `headers` — (optional) custom request headers.
  * `body` — (optional) request body. If not a string, it will be JSON-encoded automatically.

**Returns:**\
`Response` object representing the HTTP response.

**Example of usage:**

```luau
local response = HttpRequests.put("https://example.com/api/users/1", {
    body = { level = 100 }
})

print(response.status_code)
```

***

### delete

```luau
HttpRequests.delete(url: string, options: table?): Response
```

**Description:**\
Sends a DELETE request.

**Parameters:**

* `url` — the request URL.
* `options` — (optional) table containing request configuration.
  * `headers` — (optional) custom request headers.
  * `body` — (optional) request body. If not a string, it will be JSON-encoded automatically.

**Returns:**\
`Response` object representing the HTTP response.

**Example of usage:**

```luau
local response = HttpRequests.delete("https://example.com/api/users/1")
print(response.status_code)
```

### **Behaviour Notes (for all functions):**

* If `options.body` is provided and is not a string, it will be automatically JSON-encoded.
* `"Content-Type"` is set to `"application/json"` when body is JSON-encoded.
* Errors are thrown if the HTTP request fails or JSON decoding fails.
