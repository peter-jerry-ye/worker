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

///|
type JsArray[T] JsValue

///|
fn JsArray::new_ffi() -> JsValue = "peter-jerry-ye:worker/array" "new"

///|
fn JsArray::push_ffi(array : JsValue, value : JsValue) = "peter-jerry-ye:worker/array" "push"

///|
fn JsArray::length_ffi(self : JsValue) -> Int = "peter-jerry-ye:worker/array" "length"

///|
pub impl[T] FromJsValue for JsArray[T] with from_js_value(value : JsValue) -> JsArray[
  T,
] {
  JsArray(value)
}

///|
pub impl[T] ToJsValue for JsArray[T] with to_js_value(arr : JsArray[T]) -> JsValue {
  arr._
}

///|
pub fn[T] JsArray::new() -> JsArray[T] {
  JsArray(JsArray::new_ffi())
}

///|
pub fn[T : FromJsValue] get(self : JsArray[T], index : Int) -> T {
  self._.get_with_index(index)
}

///|
pub fn[T : ToJsValue] push(self : JsArray[T], value : T) -> Unit {
  self._ |> JsArray::push_ffi(to_js_value(value))
}

///|
pub fn[T] length(self : JsArray[T]) -> Int {
  JsArray::length_ffi(self._)
}

///|
pub fn[T : FromJsValue] JsArray::to_array(value : JsArray[T]) -> Array[T] {
  let array = Array::new(capacity=value.length())
  for i = 0; i < value.length(); i = i + 1 {
    array.push(value.get(i))
  }
  array
}

///|
pub fn[T : ToJsValue] JsArray::from_array(arr : Array[T]) -> JsArray[T] {
  let array = JsArray::new()
  arr.each(fn { v => array.push(v) })
  array
}

// pub fn ToJsValue::to_js_value[T](array : @vec.Vec[T]) -> JS_Value = "peter-jerry-ye:worker/js" "identity"

// pub fn FromJsValue::from_js_value[T](value : JS_Value) -> @vec.Vec[T] = "peter-jerry-ye:worker/js" "identity"
