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
export const [log, flush] = (() => {
    /** @type {number[]} buffer */
    let buffer = [];
    function flush() {
        if (buffer.length > 0) {
            console.log(new TextDecoder("utf-16").decode(new Uint16Array(buffer).valueOf()));
            buffer = [];
        }
    }
    /** @param {number} ch */
    function log(ch) {
        if (ch == '\n'.charCodeAt(0)) { flush(); }
        else if (ch == '\r'.charCodeAt(0)) { /* noop */ }
        else { buffer.push(ch); }
    }
    return [log, flush]
})();

/** WebAssembly.Imports */
export default {
    "peter-jerry-ye:worker/js": {
        is_null: (n) => Object.is(n, null),
        is_undefined: (n) => Object.is(n, undefined),
        is_bool: (n) => Object.is(typeof n, "boolean"),
        is_number: (n) => Object.is(typeof n, "number"),
        is_string: (n) => Object.is(typeof n, "string"),
        is_object: (n) => Object.is(typeof n, "object"),
        is_symbol: (n) => Object.is(typeof n, "symbol"),
        is_array: (n) => Array.isArray(n),
        identity: (n) => n,
        get: (object, key) => object[key],
        set: (object, key, value) => object[key] = value,
        apply: (func, thisArg, args) => func.apply(thisArg, args),
        /** @type {(descriptor: string | number | undefined) => Symbol} */
        symbol: (descriptor) => Symbol(descriptor),
        null: () => null,
        undefined: () => undefined,
        globalThis: () => globalThis,
    },
    "peter-jerry-ye:worker/array": {
        new: () => [],
        /** @type {(array: any[], value: any) => void} */
        push: (array, value) => { array.push(value) },
        /** @type {(array: any[], index: number) => any} */
        get: (array, index) => array[index],
        /** @type {(array: any[]) => number} */
        length: (array) => array.length,
    },
    spectest: {
        print_char: log
    },
    "peter-jerry-ye:worker/string": {
        length: (/** @type {string} */ str) => str.length,
        /** @type { (codePoint: number[]) => string} */
        fromCodePoint: (codePoint) => String.fromCodePoint(...codePoint),
        toCodePoint: (/** @type {string} */ str) => [...str].map(c => c.codePointAt(0)),
        empty: () => ""
    },
    "peter-jerry-ye:worker/promise": {
        /** @type {<T, T2>(p: Promise<T>, f: (v: T) => Promise<T2> | T2) => Promise<T2>} */
        then: (p, f) => p.then(f),
        resolve: (value) => Promise.resolve(value),
    },
    "peter-jerry-ye:worker/null": {
        /** @type {<T>(n: T | null) => Boolean} */
        is_null: (n) => Object.is(n, null),
        /** @type {<T>(n: T | null) => T} */
        get: (n) => n
    },
    "peter-jerry-ye:worker/iterator": {
        /** @type { <T>(result: IteratorResult<T>) => boolean | undefined} */
        done: (result) => result.done,
        /** @type { <T>(result: IteratorResult<T>) => any | undefined} */
        value: (result) => result.value,
    },
    "moonbit:ffi": {
        "make_closure": (funcref, closure) => funcref.bind(null, closure)
    }
}