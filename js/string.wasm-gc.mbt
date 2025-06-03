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

type JsString JsValue

pub impl FromJsValue for JsString with from_js_value(self : JsValue) -> JsString {
  JsString(self)
}
pub impl ToJsValue for JsString with to_js_value(self : JsString) -> JsValue {
  self._
}

fn JsString::empty_ffi() -> JsValue = "peter-jerry-ye:worker/string" "empty"

pub fn JsString::empty() -> JsString {
  JsString(JsString::empty_ffi())
}

fn JsString::length_ffi(self : JsValue) -> Int = "peter-jerry-ye:worker/string" "length"

pub fn JsString::length(self : JsString) -> Int {
  self |> to_js_value |> JsString::length_ffi
}

fn JsString::from_code_point_ffi(value : JsValue) -> JsValue = "peter-jerry-ye:worker/string" "fromCodePoint"

fn JsString::to_code_point_ffi(value : JsValue) -> JsValue = "peter-jerry-ye:worker/string" "toCodePoint"

pub fn JsString::from_code_point_js(value : JsArray[Int]) -> JsString {
  JsString::from_code_point_ffi(value |> to_js_value) |> from_js_value
}

pub fn JsString::to_code_point_js(value : JsString) -> JsArray[Int] {
  JsString::to_code_point_ffi(value |> to_js_value) |> from_js_value
}

pub fn JsString::from_string(str : String) -> JsString {
  let array = JsArray::new()
  for ch in str {
    array.push(ch.to_int())
  }
  JsString::from_code_point_js(array)
}

pub fn JsString::to_string(str : JsString) -> String {
  let builder = StringBuilder::new(size_hint=str.length() * 2)
  for ch in str.to_code_point_js().to_array() {
    builder.write_char(ch.unsafe_to_char())
  }
  builder.to_string()
}
