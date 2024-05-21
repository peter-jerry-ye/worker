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
import ffi, { flush as f } from '../js/import.mjs'

export const flush = f;
/** @type {WebAssembly.Imports} */
export default {
    ...ffi,
    "peter-jerry-ye:worker/array": {
        new: () => [],
        /** @type {(array: any[], value: any) => void} */
        push: (array, value) => { array.push(value) },
        /** @type {(array: any[], index: number) => any} */
        get: (array, index) => array[index],
        /** @type {(array: any[]) => number} */
        length: (array) => array.length,
    },
    "peter-jerry-ye:worker/url": {
        new: (/** @type {string | URL} */ url) => new URL(url),
        get_searchParams: (/** @type {URL} */ url) => url.searchParams,
        pathname: (/** @type {URL} */ url) => url.pathname,
    },
    "peter-jerry-ye:worker/url_search_params": {
        has: (/** @type {URLSearchParams} */ searchParams, /** @type {string} */ name) => searchParams.has(name),
        get: (/** @type {URLSearchParams} */ searchParams, /** @type {string} */ name) => searchParams.get(name),
    },
    "peter-jerry-ye:worker/request": {
        get_method: (/** @type {Request} */ request) => request.method,
        get_url: (/** @type {Request} */ request) => request.url,
        get_headers: (/** @type {Request} */ request) => request.headers,
        get_bodyUsed: (/** @type {Request} */ request) => request.bodyUsed,
        text: (/** @type {Request} */ request) => request.text(),
    },
    "peter-jerry-ye:worker/headers": {
        get: (/** @type {Headers} */ headers, /** @type {String} */ name) => headers.get(name),
        get_all: (/** @type {Headers} */ headers, /** @type {String} */ name) => headers.getAll(name),
        has: (/** @type {Headers} */ headers, /** @type {String} */ name) => headers.has(name),
    },
    "peter-jerry-ye:worker/response": {
        make: () => new Response(),
        make_with_string: (/** @type {String} */ string, /** @type {ResponseInit} */ init) => new Response(string, init),
    },
    "peter-jerry-ye:worker/response_init": {
        make: () => ({}),
        set_status: (/** @type {ResponseInit} */ init, /** @type {Number} */ status) => ({ ...init, status }),
        set_status_text: (/** @type {ResponseInit} */ init, /** @type {String} */ statusText) => ({ ...init, statusText }),
    }
}