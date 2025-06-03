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

type Request @js.JsValue

pub impl @js.FromJsValue for Request with
  from_js_value(value : @js.JsValue) -> Request {
    Request(value)
  }
pub impl @js.ToJsValue for Request with
  to_js_value(value : Request) -> @js.JsValue {
    value._
  }

fn Request::method_ffi(value : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/request" "get_method"

pub fn method_js(self : Request) -> @js.JsString {
  Request::method_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

pub fn method(self : Request) -> String {
  self.method_js().to_string()
}

fn Request::url_ffi(value : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/request" "get_url"

pub fn url_js(self : Request) -> @js.JsString {
  Request::url_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

pub fn url(self : Request) -> String {
  self.url_js().to_string()
}

fn Request::headers_ffi(value : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/request" "get_headers"

pub fn headers(self : Request) -> Headers {
  Headers(Request::headers_ffi(self |> @js.to_js_value))
}

fn Request::body_used_ffi(value : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/request" "get_bodyUsed"

pub fn body_used_js(self : Request) -> Bool {
  Request::body_used_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

pub fn body_used(self : Request) -> Bool {
  self.body_used_js()
}

fn Request::text_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/request" "text"

pub fn text_js(self : Request) -> @js.Promise[@js.JsString] {
  Request::text_ffi(self |> @js.to_js_value) |> @js.from_js_value
}

pub fn text(self : Request) -> @js.Promise[@js.JsString] {
  self.text_js()
}

type Headers @js.JsValue

pub impl @js.FromJsValue for Headers with
  from_js_value(value : @js.JsValue) -> Headers {
    Headers(value)
  }
pub impl @js.ToJsValue for Headers with
  to_js_value(value : Headers) -> @js.JsValue {
    value._
  }

fn Headers::get_ffi(self : @js.JsValue, name : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/headers" "get"

pub fn get_js(
  self : Headers,
  name : @js.JsString
) -> @js.Nullable[@js.JsString] {
  Headers::get_ffi(self |> @js.to_js_value, name |> @js.to_js_value)
  |> @js.from_js_value
}

pub fn get(self : Headers, name : String) -> Option[String] {
  self.get_js(@js.JsString::from_string(name)).to_option().map(@js.JsString::to_string)
}

fn Headers::has_ffi(self : @js.JsValue, name : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/headers" "has"

fn has_js(self : Headers, name : @js.JsString) -> Bool {
  Headers::has_ffi(self |> @js.to_js_value, name |> @js.to_js_value)
  |> @js.from_js_value
}

pub fn has(self : Headers, name : String) -> Bool {
  self.has_js(@js.JsString::from_string(name))
}
