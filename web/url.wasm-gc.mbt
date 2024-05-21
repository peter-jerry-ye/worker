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

type URL @js.JsValue

fn URL::make_ffi(url : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/url" "new"

pub fn URL::make_js(url : @js.JsString) -> URL {
  URL::make_ffi(url |> @js.to_js_value) |> @js.from_js_value
}

pub fn URL::make(url : String) -> URL {
  make_js(@js.JsString::from_string(url))
}

pub fn @js.FromJsValue::from_js_value(value : @js.JsValue) -> URL {
  URL(value)
}

pub fn @js.ToJsValue::to_js_value(value : URL) -> @js.JsValue {
  value.0
}

fn URL::searchParams_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/url" "get_searchParams"

pub fn searchParams(self : URL) -> URLSearchParams {
  self |> @js.to_js_value |> searchParams_ffi |> @js.from_js_value
}

fn URL::pathname_ffi(self : @js.JsValue) -> @js.JsValue = "peter-jerry-ye:worker/url" "pathname"

pub fn pathname_js(self : URL) -> @js.JsString {
  self |> @js.to_js_value |> pathname_ffi |> @js.from_js_value
}

pub fn pathname(self : URL) -> String {
  (self |> pathname_js).to_string()
}

type URLSearchParams @js.JsValue

pub fn @js.FromJsValue::from_js_value(
  value : @js.JsValue
) -> URLSearchParams {
  URLSearchParams(value)
}

pub fn @js.ToJsValue::to_js_value(value : URLSearchParams) -> @js.JsValue {
  value.0
}

fn URLSearchParams::has_ffi(
  self : @js.JsValue,
  name : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/url_search_params" "has"

pub fn has_js(self : URLSearchParams, name : @js.JsString) -> Bool {
  URLSearchParams::has_ffi(self |> @js.to_js_value, name |> @js.to_js_value)
  |> @js.from_js_value
}

pub fn has(self : URLSearchParams, name : String) -> Bool {
  self.has_js(@js.JsString::from_string(name))
}

fn URLSearchParams::get_ffi(
  self : @js.JsValue,
  name : @js.JsValue
) -> @js.JsValue = "peter-jerry-ye:worker/url_search_params" "get"

fn get_js(
  self : URLSearchParams,
  name : @js.JsString
) -> @js.Nullable[@js.JsString] {
  URLSearchParams::get_ffi(self |> @js.to_js_value, name |> @js.to_js_value)
  |> @js.from_js_value
}

pub fn get(self : URLSearchParams, name : String) -> Option[String] {
  self.get_js(@js.JsString::from_string(name)).to_option().map(@js.to_string)
}
