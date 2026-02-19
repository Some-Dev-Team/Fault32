---
description: Object
icon: brackets-curly
---

# Response

## Dependencies

* Roblox's [HttpService](https://create.roblox.com/docs/reference/engine/classes/HttpService)

{% hint style="info" %}
Located inside the [.](./ "mention")Module.&#x20;
{% endhint %}

The `Response` object is returned by all [.](./ "mention")' functions.



### Properties

* `status_code` — HTTP status code (number).
* `body` — raw response body (string).
* `headers` — table of response headers.

### Methods

***

#### json

```luau
Response:json(): any
```

**Description:**\
Attempts to decode the response body as JSON.

**Returns:**\
Decoded Lua table.

**Example of usage:**

```luau
local response = HttpRequests.get("https://example.com/api/data") -- returns response object
local data = response:json()
print(data.name) -- or whatever keys inside the response that api provided
```

