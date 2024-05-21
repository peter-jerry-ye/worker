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

pub fn ToJsValue::to_js_value(self : JsString) -> JsValue {
  self.0
}

pub fn FromJsValue::from_js_value(self : JsValue) -> JsString {
  JsString(self)
}

fn JsString::empty_ffi() -> JsValue = "peter-jerry-ye:worker/string" "empty"

pub fn JsString::empty() -> JsString {
  JsString(JsString::empty_ffi())
}

pub fn JsString::length(self : JsString) -> Int {
  self |> to_js_value |> length_ffi
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
  str.as_iter().map(Char::to_int).fold(
    fn(array : JsArray[Int], ch : Int) {
      array.push(ch)
      array
    },
    JsArray::new(),
  )
  |> JsString::from_code_point_js
}

pub fn JsString::to_string(str : JsString) -> String {
  str.to_code_point_js().to_array().as_iter().fold(
    fn(buffer : Buffer, ch : Int) {
      buffer.write_char(Char::from_int(ch))
      buffer
    },
    Buffer::make(100),
  ).to_string()
}
