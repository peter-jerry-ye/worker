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

pub type JsValue

pub trait ToJsValue {
  to_js_value(Self) -> JsValue
}

pub trait FromJsValue {
  from_js_value(JsValue) -> Self
}

pub fn to_js_value[T : ToJsValue](value : T) -> JsValue {
  value.to_js_value()
}

pub fn from_js_value[T : FromJsValue](value : JsValue) -> T {
  T::from_js_value(value)
}

pub fn ToJsValue::to_js_value(_unit : Unit) -> JsValue = "peter-jerry-ye:worker/js" "null"

pub fn FromJsValue::from_js_value(_unit : JsValue) -> Unit {
  ()
}

pub fn ToJsValue::to_js_value(value : Bool) -> JsValue = "peter-jerry-ye:worker/js" "identity"

pub fn FromJsValue::from_js_value(value : JsValue) -> Bool = "peter-jerry-ye:worker/js" "identity"

pub fn ToJsValue::to_js_value(value : Int) -> JsValue = "peter-jerry-ye:worker/js" "identity"

pub fn FromJsValue::from_js_value(value : JsValue) -> Int = "peter-jerry-ye:worker/js" "identity"

pub fn ToJsValue::to_js_value(value : Double) -> JsValue = "peter-jerry-ye:worker/js" "identity"

pub fn FromJsValue::from_js_value(value : JsValue) -> Double = "peter-jerry-ye:worker/js" "identity"

pub fn ToJsValue::to_js_value(value : JsValue) -> JsValue {
  value
}

pub fn FromJsValue::from_js_value(value : JsValue) -> JsValue {
  value
}

pub fn is_bool(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_bool"

pub fn is_null(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_null"

pub fn is_undefined(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_undefined"

pub fn is_number(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_number"

pub fn is_string(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_string"

pub fn is_object(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_object"

pub fn is_symbol(self : JsValue) -> Bool = "peter-jerry-ye:worker/js" "is_symbol"

fn get_globalThis() -> JsValue = "peter-jerry-ye:worker/js" "globalThis"

pub let globalThis : JsValue = get_globalThis()

/// https://tc39.es/ecma262/#sec-object-type
fn get_ffi(self : JsValue, key : JsValue) -> JsValue = "peter-jerry-ye:worker/js" "get"

pub fn get_with_string_js[T : FromJsValue](
  self : JsValue,
  key : JsString
) -> T {
  self.get_ffi(key |> to_js_value) |> from_js_value
}

pub fn get_with_string[T : FromJsValue](self : JsValue, key : String) -> T {
  self.get_with_string_js(JsString::from_string(key))
}

pub fn get_with_symbol[T : FromJsValue](self : JsValue, key : JS_Symbol) -> T {
  self.get_ffi(key |> to_js_value) |> from_js_value
}

pub fn get_with_index[T : FromJsValue](self : JsValue, index : Int) -> T {
  self.get_ffi(index |> to_js_value) |> from_js_value
}

/// https://tc39.es/ecma262/#sec-object-type
fn set_ffi(self : JsValue, key : JsValue, value : JsValue) = "peter-jerry-ye:worker/js" "set"

pub fn set_with_string[T : ToJsValue](
  self : JsValue,
  key : JsString,
  value : T
) -> Unit {
  self.set_ffi(key |> to_js_value, value |> to_js_value)
}

pub fn set_with_symbol[T : ToJsValue](
  self : JsValue,
  key : JS_Symbol,
  value : T
) -> Unit {
  self.set_ffi(key |> to_js_value, value |> to_js_value)
}

pub fn set_with_index[T : ToJsValue](
  self : JsValue,
  index : Int,
  value : T
) -> Unit {
  self.set_ffi(index |> to_js_value, value |> to_js_value)
}

pub fn JsValue::null() -> JsValue = "peter-jerry-ye:worker/js" "null"

pub fn JsValue::undefined() -> JsValue = "peter-jerry-ye:worker/js" "undefined"

fn JsValue::apply_ffi(
  self : JsValue,
  this : JsValue,
  args : JsValue
) -> JsValue = "peter-jerry-ye:worker/js" "apply"

pub fn JsValue::apply_js[This : ToJsValue, Arg : ToJsValue, Result : FromJsValue](
  self : JsValue,
  this : This,
  args : JsArray[Arg]
) -> Result {
  self.apply_ffi(this |> to_js_value, args |> to_js_value) |> from_js_value
}

pub fn JsValue::apply[This : ToJsValue, Arg : ToJsValue, Result : FromJsValue](
  self : JsValue,
  this : This,
  args : Array[Arg]
) -> Result {
  self.apply_js(this, JsArray::from_array(args))
}
