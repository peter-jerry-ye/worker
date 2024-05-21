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

type JsArray[T] JsValue

fn JsArray::new_ffi() -> JsValue = "peter-jerry-ye:worker/array" "new"

fn JsArray::push_ffi(array : JsValue, value : JsValue) = "peter-jerry-ye:worker/array" "push"

fn JsArray::length_ffi(self : JsValue) -> Int = "peter-jerry-ye:worker/array" "length"

pub fn FromJsValue::from_js_value[T](value : JsValue) -> JsArray[T] {
  JsArray(value)
}

pub fn ToJsValue::to_js_value[T](arr : JsArray[T]) -> JsValue {
  arr.0
}

pub fn JsArray::new[T]() -> JsArray[T] {
  JsArray(new_ffi())
}

pub fn get[T : FromJsValue](self : JsArray[T], index : Int) -> T {
  self.0.get_with_index(index)
}

pub fn push[T : ToJsValue](self : JsArray[T], value : T) -> Unit {
  self.0 |> push_ffi(to_js_value(value))
}

pub fn length[T](self : JsArray[T]) -> Int {
  length_ffi(self.0)
}

pub fn JsArray::to_array[T : FromJsValue](value : JsArray[T]) -> Array[T] {
  let array = Array::with_capacity(value.length())
  for i = 0; i < value.length(); i = i + 1 {
    array.push(value.get(i))
  }
  array
}

pub fn JsArray::from_array[T : ToJsValue](arr : Array[T]) -> JsArray[T] {
  let array = JsArray::new()
  arr.iter(fn { v => array.push(v) })
  array
}

// pub fn ToJsValue::to_js_value[T](array : @vec.Vec[T]) -> JS_Value = "peter-jerry-ye:worker/js" "identity"

// pub fn FromJsValue::from_js_value[T](value : JS_Value) -> @vec.Vec[T] = "peter-jerry-ye:worker/js" "identity"
