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

pub type Nullable[T] JsValue

pub impl [T] FromJsValue for Nullable[T] with from_js_value(value : JsValue) -> Nullable[T] {
  Nullable(value)
}
pub impl [T] ToJsValue for Nullable[T] with to_js_value(value : Nullable[T]) -> JsValue {
  value._
}

pub fn is_null[T](self : Nullable[T]) -> Bool {
  self._.is_null()
}

pub fn unwrap[T : FromJsValue](self : Nullable[T]) -> T {
  self._ |> from_js_value
}

pub fn to_option[T : FromJsValue](self : Nullable[T]) -> Option[T] {
  @option.unless(self.is_null(), fn() { self.unwrap() })
}
