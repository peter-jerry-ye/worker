//  Copyright 2024 International Digital Economy Academy
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//      http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

// test/index.spec.ts
import { env, createExecutionContext, waitOnExecutionContext, SELF } from "cloudflare:test";
import { describe, it, expect, beforeEach } from "vitest";
import worker from "../src/index";

declare module "cloudflare:test" {
  interface ProvidedEnv {
    MY_KV_NAMESPACE: KVNamespace;
    MY_DB: D1Database
  }
}


// For now, you'll need to do something like this to get a correctly-typed
// `Request` to pass to `worker.fetch()`.
const IncomingRequest = Request<unknown, IncomingRequestCfProperties>;

describe("Unauthorized request", () => {
  it("responds with 401", async () => {
    const request = new IncomingRequest("http://example.com/api");
    const ctx = createExecutionContext();
    const response = await worker.fetch(request, env, ctx);
    await waitOnExecutionContext(ctx);
    expect(await response.text()).toMatchInlineSnapshot(`"Unauthorized"`);
    expect(response.status).toBe(401);
  })

  it("responds with 401", async () => {
    const response = await SELF.fetch("http://example.com/api");
    expect(await response.text()).toMatchInlineSnapshot(`"Unauthorized"`);
    expect(response.status).toBe(401);
  })
});

describe("Authorized request with nothing", () => {
  it("responds with hello world", async () => {
    const response = await SELF.fetch("http://example.com/api", { headers: { Authorization: "MoonBit" } });
    expect(await response.text()).toMatchInlineSnapshot(`"Hello, World!"`);
    expect(response.ok)
  })
})

describe("Authorized request with put and get", () => {
  it("responds with nothing", async () => {
    const response = await SELF.fetch("http://example.com/api/kv?key=hello", { headers: { Authorization: "MoonBit" } });
    expect(await response.text()).toMatchInlineSnapshot(`"hello -> null"`);
  })

  it("responds with something after put", async () => {
    let response = await SELF.fetch("http://example.com/api/kv", { headers: { Authorization: "MoonBit" }, method: "PUT", body: `{"key": "hello", "value": "world"}` });
    expect(response.ok);
    response = await SELF.fetch("http://example.com/api/kv?key=hello", { headers: { Authorization: "MoonBit" } })
    expect(await response.text()).toMatchInlineSnapshot(`"hello -> world"`);
  })

  it("responds 400 with something invalid", async () => {
    let response = await SELF.fetch("http://example.com/api/kv", { headers: { Authorization: "MoonBit" }, method: "PUT", body: `not valid` });
    expect(response.status).toBe(400);
  })
})

describe("Unprotected paths", () => {
  it("unknown path responds with 404", async () => {
    const response = await SELF.fetch("http://example.com/unknown");
    expect(response.status).toBe(404);
  })
  it("root responds with hello world", async () => {
    const response = await SELF.fetch("http://example.com/");
    expect(await response.text()).toMatchInlineSnapshot(`"Hello, World!"`);
  })
})

describe("REST API with D1 database", () => {
  beforeEach(() => {
    env.MY_DB.exec("CREATE TABLE IF NOT EXISTS users(id VARCHAR(50), password VARCHAR(50), role VARCHAR(50));")
  })

  it("fail to get someone unknown", async () => {
    const response = await SELF.fetch("http://example.com/api/d1/user/unknown");
    expect(response.status).toBe(404);
  })

  it("get someone's role after creation", async () => {
    let response = await SELF.fetch("http://example.com/api/d1/user", { method: "PUT", body: JSON.stringify({ username: "moonbit", password: "123456", role: "admin" }) });
    expect(response.ok);
    response = await SELF.fetch("http://example.com/api/d1/user/moonbit");
    expect(await response.text()).toMatchInlineSnapshot(`"admin"`);
  })
})