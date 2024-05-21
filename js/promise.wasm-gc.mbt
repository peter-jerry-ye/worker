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

struct Promise[T] {
  val : JsValue
}

pub fn FromJsValue::from_js_value[T](value : JsValue) -> Promise[T] {
  { val: value }
}

pub fn ToJsValue::to_js_value[T](value : Promise[T]) -> JsValue {
  value.val
}

fn then_ffi(promise : JsValue, f : (JsValue) -> JsValue) -> JsValue = "peter-jerry-ye:worker/promise" "then"

pub fn map[A : FromJsValue, B : ToJsValue](
  self : Promise[A],
  f : (A) -> B
) -> Promise[B] {
  Promise::{
    val: self.val |> then_ffi(fn { a => f(a |> from_js_value) |> to_js_value }),
  }
}

pub fn bind[A : FromJsValue, B : ToJsValue](
  self : Promise[A],
  f : (A) -> Promise[B]
) -> Promise[B] {
  Promise::{
    val: self.val |> then_ffi(fn { a => (a |> from_js_value |> f).val }),
  }
}

fn Promise::resolve_ffi(value : JsValue) -> JsValue = "peter-jerry-ye:worker/promise" "resolve"

pub fn Promise::resolve[A : ToJsValue](value : A) -> Promise[A] {
  { val: resolve_ffi(value.to_js_value()) }
}
