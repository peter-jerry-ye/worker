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

type JS_Symbol JsValue

pub fn FromJsValue::from_js_value(value : JsValue) -> JS_Symbol {
  JS_Symbol(value)
}

pub fn ToJsValue::to_js_value(arr : JS_Symbol) -> JsValue {
  arr.0
}

fn JS_Symbol::make_ffi(value : JsValue) -> JsValue = "peter-jerry-ye:worker/js" "symbol"

pub fn JS_Symbol::make() -> JS_Symbol {
  JS_Symbol::make_ffi(JsValue::undefined()) |> from_js_value
}

pub fn JS_Symbol::make_with_string_js(value : JsString) -> JS_Symbol {
  JS_Symbol::make_ffi(value |> to_js_value) |> from_js_value
}

pub fn JS_Symbol::make_with_string(value : String) -> JS_Symbol {
  JS_Symbol::make_with_string_js(JsString::from_string(value))
}

pub fn JS_Symbol::make_with_number(value : Double) -> JS_Symbol {
  JS_Symbol::make_ffi(value |> to_js_value) |> from_js_value
}
