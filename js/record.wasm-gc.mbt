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

type Record JsValue

fn Record::get_ffi(self : JsValue, key : JsValue) -> JsValue = "peter-jerry-ye:worker/js" "get"

pub fn Record::get_js(self : Record, key : JsString) -> JsValue {
  Record::get_ffi(self |> to_js_value, key |> to_js_value) |> from_js_value
}

pub fn get(self : Record, key : String) -> JsValue {
  self.get_js(JsString::from_string(key))
}

pub fn FromJsValue::from_js_value(value : JsValue) -> Record {
  Record(value)
}

pub fn ToJsValue::to_js_value(value : Record) -> JsValue {
  value.0
}
