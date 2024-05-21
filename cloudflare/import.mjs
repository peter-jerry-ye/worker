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

// @ts-check

/** @type {WebAssembly.Imports} */
export default {
    "peter-jerry-ye:worker/cloudflare": {
        /** @type {(env: any, binding: String) => KVNamespace | D1Database} */
        "env_get": (env, binding) => env[binding],
        /** @type {(kv: KVNamespace, key: String) => Promise<string | null>} */
        "kvnamespace_get_string": (kv, key) => kv.get(key, "text"),
        /** @type {(kv: KVNamespace, key: String, value: String) => Promise<void>} */
        "kvnamespace_put_string": (kv, key, value) => kv.put(key, value),
        /** @type {(env: any, binding: String) => D1Database} */
        "env_d1": (env, binding) => env[binding],
        /** @type {(db: D1Database, query: String) => D1PreparedStatement} */
        "d1_prepare": (db, query) => db.prepare(query),
        /** @type {(stmt: D1PreparedStatement, values: unknown[]) => D1PreparedStatement} */
        "d1_prepared_statement_bind": (stmt, values) => stmt.bind(...values),
        /** @type {(stmt: D1PreparedStatement) => Promise<Record<string, unknown> | null>} */
        "d1_prepared_statement_first": (stmt) => stmt.first(),
        /** @type {<T>(stmt: D1PreparedStatement, colName: string) => Promise<T | null>} */
        "d1_prepared_statement_first_at": (stmt, colName) => stmt.first(colName),
        /** @type {(stmt: D1PreparedStatement) => Promise<D1Response>} */
        "d1_prepared_statement_run": (stmt) => stmt.run(),
        /** @type {(stmt: D1PreparedStatement) => Promise<D1Result<Record<string, unknown>>>} */
        "d1_prepared_statement_all": (stmt) => stmt.all(),
        /** @type {(stmt: D1Response) => Boolean} */
        "d1_response_success": (response) => response.success,
        /** @type {(stmt: D1Response) => D1Meta} */
        "d1_response_meta": (response) => response.meta,
        /** @type {(stmt: D1Response) => never | undefined} */
        "d1_response_error": (response) => response.error,
        /** @type {(result: D1Result) => unknown[]} */
        "d1_result_results": (result) => result.results,
    }
}